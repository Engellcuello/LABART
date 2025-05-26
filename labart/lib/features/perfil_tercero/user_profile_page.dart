import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:labart/features/perfil_tercero/widgets/userProfilePost.dart';
import 'package:labart/features/settings/setting_screen.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/features/perfil_tercero/widgets/user_profile_header.dart';
import 'package:labart/features/perfil_tercero/widgets/user_profile_tabs.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({
    Key? key, 
    this.userId, 
    this.userName, 
    this.userImg
  }) : super(key: key);
  
  final int? userId;
  final String? userName;
  final String? userImg;

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isFollowing = false;
  late ScrollController _scrollController;
  double _appBarOpacity = 0.0;
  late double _headerHeight;
  late String _headerImageUrl;

  @override
  void didUpdateWidget(UserProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
      // Forzar recarga de datos cuando cambia el userId
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();

    
  _headerImageUrl = (widget.userImg != null && widget.userImg!.isNotEmpty)
      ? widget.userImg!
      : 'https://cdn.leonardo.ai/users/0ec727fb-b208-4674-8b2a-2a71a7c8ad3f/generations/a5f3ffee-6c93-4a2c-84ce-4e078a42fd7f/variations/UniversalUpscaler_a5f3ffee-6c93-4a2c-84ce-4e078a42fd7f.jpg?w=512';
    _headerHeight = (widget.userImg != null && widget.userImg!.isNotEmpty)
        ? THelperFunctions.screenHeight() * 0.88 
        : THelperFunctions.screenHeight() * 0.88;
    
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController()
      ..addListener(_handleScrollUpdate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Asegurarnos que el contexto está disponible
    if (_headerHeight <= 0) {
      _headerHeight = THelperFunctions.screenHeight() * 0.28;
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _handleScrollUpdate() {
    if (!_scrollController.hasClients) return;
    
    final offset = _scrollController.offset;
    const double fadeStart = 590;
    final double fadeEnd = 600;

    double opacity = 0.0;
    if (offset <= fadeStart) {
      opacity = 0.0;
    } else if (offset >= fadeEnd) {
      opacity = 1.0;
    } else {
      opacity = (offset - fadeStart) / (fadeEnd - fadeStart);
    }

    if (mounted) {
      setState(() {
        _appBarOpacity = opacity.clamp(0.0, 1.0);
      });
    }
  }

  void _showUnfollowDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Dejar de seguir'),
        content: const Text('¿Estás seguro de que quieres dejar de seguir a este usuario?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (mounted) {
                setState(() => _isFollowing = false);
              }
              Navigator.pop(context);
            },
            child: const Text('Dejar de seguir'),
          ),
        ],
      ),
    );
  }

  void _showMenuOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(TSizes.borderRadiusLg)),
          color: Colors.transparent,
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(TSizes.borderRadiusLg)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Compartir'),
                  onTap: () {
                    
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report),
                  title: const Text('Reportar'),
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: TSizes.sm),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                const SizedBox(height: TSizes.md),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final themeColor = Theme.of(context).scaffoldBackgroundColor;
    final String safeUserImg = (widget.userImg != null && widget.userImg!.isNotEmpty)
        ? widget.userImg!
        : _headerImageUrl;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: NestedScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            UserProfileHeader(
              appBarOpacity: _appBarOpacity,
              headerHeight: _headerHeight,
              headerImageUrl: safeUserImg,
              isFollowing: _isFollowing,
              onBackPressed: () => Navigator.pop(context),
              onMenuPressed: () => _showMenuOptions(context),
              onFollowPressed: () {
                if (mounted) {
                  setState(() => _isFollowing = true);
                }
              },
              showUnfollowDialog: _showUnfollowDialog,
              themeColor: themeColor,
              userName: widget.userName,
              userId: widget.userId,
            ),
            UserProfileTabs(tabController: _tabController),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            UserProfilePosts(userId: widget.userId ?? 0, tabType: 'creadas', isDark: dark,),
            UserProfilePosts(userId: widget.userId ?? 0, tabType: 'guardadas', isDark: dark,),
          ],
        ),
      ),
    );
  }
}