import 'package:flutter/material.dart';
import 'package:labart/features/notifications/widgets/tabbar/tab_bar_with_indicator.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/features/notifications/widgets/contenido_notifications/contenido_notificacion.dart';
import 'package:http/http.dart' as http;
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> 
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  Animation<double> _animation = AlwaysStoppedAnimation(0.0);

  bool _hasProcessedUnread = false;
  
  List<dynamic> _comments = [];
  List<dynamic> _reactions = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _token = '';
  int _userId = 0;

  @override
  void initState() {
    super.initState();
    
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabChange);
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _animationController.forward();
        NavigationController.to.hasUnreadNotifications.value = false;
        _loadUserDataAndFetchNotifications().catchError((error) {
          if (mounted) {
            setState(() {
              _isLoading = false;
              _errorMessage = 'Error al cargar notificaciones';
            });
          }
        });
      }
    });
  }

  void _handleTabChange() {
    if (!_hasProcessedUnread) {
      _processUnreadNotificationsInBackground();
      _hasProcessedUnread = true;
    }
  }

  Future<void> _loadUserDataAndFetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userId = prefs.getInt('id_usuario') ?? 0;
    final lastVisit = prefs.getString('last_notification_visit');

    if (token.isEmpty || userId == 0) {
      if (mounted) {
        setState(() {
          _errorMessage = 'No se pudo obtener la información del usuario';
          _isLoading = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _token = token;
        _userId = userId;
      });
    }

    await _fetchNotifications();
    
    // Guardar el momento actual como última visita
    final now = DateTime.now();
    await prefs.setString('last_notification_visit', now.toIso8601String());
    
    if (mounted) {
      setState(() {
      });
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/notificaciones_usuario/$_userId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _comments = data['comentarios'] ?? [];
          _reactions = data['reacciones'] ?? [];
          _isLoading = false;
        });
        _processUnreadNotificationsInBackground();
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error al cargar notificaciones';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error de conexión';
        });
      }
      debugPrint('Error fetching notifications: $e');
    }
  }


  Future<void> _processUnreadNotificationsInBackground() async {
    if (!mounted) return;
    
    List<String> notificationsToMarkAsRead = [];
    
    notificationsToMarkAsRead.addAll(
      _comments.where((n) => n['leida'] == false).map((n) => n['id'].toString())
    );
    notificationsToMarkAsRead.addAll(
      _reactions.where((n) => n['leida'] == false).map((n) => n['id'].toString())
    );

    if (notificationsToMarkAsRead.isNotEmpty) {
      await _markNotificationsAsRead(notificationsToMarkAsRead);
      
      if (mounted) {
        NavigationController.to.hasUnreadNotifications.value = false;
      }
    }
  }

  Future<void> _markNotificationsAsRead(List<String> notificationIds) async {
    if (notificationIds.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('${THttpHelper.baseUrl}/notificaciones/marcar_como_leidas/$_userId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'notificaciones': notificationIds.map(int.parse).toList(),
        }),
      );

      if (response.statusCode != 200) {
        debugPrint('Error al marcar notificaciones: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error de conexión: $e');
    }
  }

  Future<void> _showDeleteAllDialog(BuildContext context) async {
    final currentTab = _tabController.index;
    final tipoNotificacion = currentTab == 0 ? 'comentarios' : 'reacciones';
    final dark = THelperFunctions.isDarkMode(context);  
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Center(
          child: Text(
            'Eliminar notificaciones',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: TColors.primary,
            ),
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar todas las notificaciones de $tipoNotificacion?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: dark ? Colors.white : Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              side: BorderSide(color: dark ? Colors.white : Colors.black),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancelar',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: dark ? Colors.white : Colors.black),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(157, 100, 180, 246), 
                  Color.fromARGB(255, 219, 77, 255), 
                  Color.fromARGB(159, 211, 170, 212)
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Eliminar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _deleteAllNotifications(currentTab);
    }
  }

  Future<void> _deleteAllNotifications(int tabIndex) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    try {
      final tipos = tabIndex == 0 ? [6] : [2, 3, 4, 5];
      
      final response = await http.delete(
        Uri.parse('${THttpHelper.baseUrl}/notificaciones/eliminar/$_userId'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({'tipos': tipos}),
      );

      final responseBody = json.decode(response.body);
      
      if (response.statusCode == 200) {
        setState(() {
          if (tabIndex == 0) {
            _comments.clear();
          } else {
            _reactions.clear();
          }
        });
        
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(responseBody['message'] ?? 'Notificaciones eliminadas correctamente'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text(responseBody['message'] ?? 'Error al eliminar notificaciones'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Error de conexión: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _removeNotification(String id, int tabIndex) async {
    try {
      final response = await http.delete(
        Uri.parse('${THttpHelper.baseUrl}/notificaciones/$id'),
        headers: {
          'Authorization': 'Bearer $_token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          if (tabIndex == 0) {
            _comments.removeWhere((item) => item['id'].toString() == id);
          } else {
            _reactions.removeWhere((item) => item['id'].toString() == id);
          }
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notificación eliminada')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión: $e')),
      );
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _animationController.dispose();
    // Cancelar cualquier operación pendiente aquí si es necesario
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'Notificaciones', 
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteAllDialog(context),
          ),
        ],
        bottom: TabBarWithIndicator(
          isDark: isDark,
          tabController: _tabController, 
          tabs: [],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : FadeTransition(
                  opacity: _animation,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildNotificationsList(_comments, 0),
                      _buildNotificationsList(_reactions, 1),
                    ],
                  ),
                ),
    );
  }

  Widget _buildNotificationsList(List<dynamic> notifications, int tabIndex) {
    return notifications.isEmpty
        ? Center(
            child: Text(
              'No hay notificaciones',
              style: TextStyle(
                color: THelperFunctions.isDarkMode(context) 
                    ? Colors.white70 
                    : Colors.black54,
              ),
            ),
          )
        : AnimatedList(
            key: Key('notifications_${tabIndex}_${notifications.length}'),
            padding: const EdgeInsets.all(TSizes.md),
            initialItemCount: notifications.length,
            itemBuilder: (context, index, animation) {
              final item = notifications[index];
              return NotificationItem(
                animation: animation,
                id: item['id'].toString(),
                tabIndex: tabIndex,
                userName: item['usuario_accion']['nombre'] ?? 'Usuario',
                content: item['mensaje'] ?? '',
                imageUrl: item['imagen_publicacion'],
                notificationTime: DateTime.parse(item['fecha']),
                onDismissed: _removeNotification,
                userImageUrl: item['usuario_accion']['imagen'],
                isRead: item['leida'] ?? false,
              );
            },
          );
  }
}