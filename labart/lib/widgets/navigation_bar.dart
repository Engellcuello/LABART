import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:get/get.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/features/autentication/screens/login_singup/login_singup.dart';
import 'package:labart/features/explore_more/route_bar.dart';
import 'package:labart/features/explore_more/screens/explorar/categorias/screen_publi_categoria/publi_categoria.dart';
import 'package:labart/home.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/features/detalles_publicacion/publicacion_detalle_widget.dart';
import 'package:labart/features/notifications/notifications_screen.dart';
import 'package:labart/features/perfil_tercero/user_profile_page.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/_PublicacionModal.dart';
import 'package:labart/widgets/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Obx(() {
      final currentScreen = controller.pageStack.isNotEmpty
          ? controller.pageStack.last
          : controller.screens[controller.selectedIndex.value];

      return Scaffold(
        bottomNavigationBar: NavigationBar(
          height: 60,
          elevation: 0,
          selectedIndex: controller.safeSelectedIndex,
          onDestinationSelected: controller.changePage,
          backgroundColor: darkMode ? TColors.black : TColors.white,
          indicatorColor: darkMode
              ? const Color.fromARGB(25, 255, 255, 255)
              : const Color.fromARGB(25, 35, 35, 35),
          destinations: [
            const NavigationDestination(icon: Icon(Iconsax.home), label: ''),
            const NavigationDestination(icon: Icon(Iconsax.search_normal), label: ''),
            const NavigationDestination(icon: Icon(Iconsax.add), label: ''),
            NavigationDestination(
              icon: Obx(() => Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Iconsax.notification),
                  if (controller.hasUnreadNotifications.value)
                    Positioned(
                      right: 2,
                      top: 1,
                      child: Container(
                        width: 10,  // Tamaño fijo
                        height: 10, // Tamaño fijo
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                ],
              )),
              label: '',
            ),
            const NavigationDestination(icon: Icon(Iconsax.user), label: ''),
          ],
        ),
        body: currentScreen,
      );
    });
  }
}

class SlideTransitionAnimation extends StatefulWidget {
  final Widget child;
  const SlideTransitionAnimation({super.key, required this.child});

  @override
  State<SlideTransitionAnimation> createState() => _SlideTransitionAnimationState();
}

class _SlideTransitionAnimationState extends State<SlideTransitionAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class NavigationController extends GetxController {
  static NavigationController get to => Get.find();

  final Rx<int> selectedIndex = 0.obs;
  final RxList<Widget> pageStack = <Widget>[].obs;
  final RxList<Publicacion> cachedPublicaciones = <Publicacion>[].obs;
  final RxBool hasUnreadNotifications = false.obs; 
  Timer? _notificationCheckTimer;

  // Lista de pantallas precargadas
  final List<Widget> screens = [
    const DiscoverPage(),
    const ExploreScreenWithTabs(),
    Container(), // Modal Placeholder
    const NotificationsScreen(),
    const ProfilePage(),
  ];

  // Cargar las pantallas de manera anticipada (en el onInit)
  @override
  Future<void> onInit() async {
    super.onInit();
    await _loadScreens();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('id_usuario');

    if (userId == null) {
      Get.offAll(() => const AuthScreen());
    } else {
      // Verificar notificaciones al iniciar
      await _checkUnreadNotifications(userId);
      
      // Configurar verificación periódica cada 10 minutos
      _notificationCheckTimer = Timer.periodic(
        const Duration(minutes: 10), 
        (_) => _checkUnreadNotifications(userId)
      );
    }
  }

  @override
  void onClose() {
    _notificationCheckTimer?.cancel();
    super.onClose();
  }

  Future<void> _checkUnreadNotifications(int userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      
      final response = await http.get(
        Uri.parse('${THttpHelper.baseUrl}/notificaciones/tiene_no_leidas/$userId'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        hasUnreadNotifications.value = data['tiene_no_leidas'] ?? false;
      }
    } catch (e) {
      hasUnreadNotifications.value = false;
    }
  }


  Future<void> _loadScreens() async {
    // Aquí puedes cargar las pantallas de manera anticipada si es necesario
    // Por ejemplo, si las pantallas tienen datos que cargar, puedes hacerlo aquí.
    // Este ejemplo es solo una carga simple de las pantallas.
    for (var screen in screens) {
      // Aquí podrías agregar algún tipo de precarga si las pantallas requieren
      // datos asíncronos como imágenes, recursos, etc.
      await Future.delayed(const Duration(milliseconds: 50));  // Simula un pequeño retraso si es necesario
    }
  }

  int get safeSelectedIndex => selectedIndex.value;

  void changePage(int index) {
    if (index == 2) {
      showModalBottomSheet(
        context: Get.context!,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        enableDrag: false,
        builder: (_) => const PublicacionModal(),
      );
      return;
    }

    pageStack.clear();
    selectedIndex.value = index;
  }

  void pushPage(Widget page) {
    pageStack.add(page);
  }

  void popPage() {
    if (pageStack.isNotEmpty) {
      pageStack.removeLast();
    }
  }

  void clearStack() {
    pageStack.clear();
  }

  void openCategoriaScreen(int categoriaId, String nombreCategoria) {
    pushPage(CategoriaScreenWrapper(
      categoriaId: categoriaId,
      nombreCategoria: nombreCategoria,
    ));
  }

  void openDetail(Publicacion publicacion, bool isDark, List<Publicacion> currentPublicaciones) {
    cachedPublicaciones.assignAll(currentPublicaciones);
    pushPage(PublicacionDetalleWrapper(
      publicacion: publicacion,
      isDark: isDark,
    ));
  }

  void openUserProfile({int? userId, String? userName, String? userImg}) {
    pushPage(UserProfilePageWrapper(
      userId: userId,
      userName: userName,
      userImg: userImg,
    ));
  }
}


class CategoriaScreenWrapper extends StatelessWidget {
  final int categoriaId;
  final String nombreCategoria;

  const CategoriaScreenWrapper({
    super.key,
    required this.categoriaId,
    required this.nombreCategoria,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationController.to.popPage();
        return false;
      },
      child: PublicacionesCategoriaScreen(
        categoriaId: categoriaId,
        nombreCategoria: nombreCategoria,
      ),
    );
  }
}

class PublicacionDetalleWrapper extends StatelessWidget {
  final Publicacion publicacion;
  final bool isDark;

  const PublicacionDetalleWrapper({
    super.key,
    required this.publicacion,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationController.to.popPage();
        return false;
      },
      child: PublicacionDetalleWidget(
        publicacion: publicacion,
        isDark: isDark,
      ),
    );
  }
}

class UserProfilePageWrapper extends StatelessWidget {
  final int? userId;
  final String? userName;
  final String? userImg;

  const UserProfilePageWrapper({
    Key? key,
    this.userId,
    this.userName,
    this.userImg,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationController.to.popPage();
        return false;
      },
      child: UserProfilePage(
        userId: userId,
        userName: userName,
        userImg: userImg,
      ),
    );
  }
}
