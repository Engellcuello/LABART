import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:labart/utils/http/http_client.dart';
import 'package:labart/widgets/navigation_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileHeader extends StatefulWidget {
  final double appBarOpacity;
  final double headerHeight;
  final String headerImageUrl;
  final bool isFollowing;
  final VoidCallback onBackPressed;
  final VoidCallback onMenuPressed;
  final VoidCallback onFollowPressed;
  final VoidCallback showUnfollowDialog;
  final Color themeColor;
  final int? userId;
  final String? userName;

  const UserProfileHeader({
    required this.appBarOpacity,
    required this.headerHeight,
    required this.headerImageUrl,
    required this.isFollowing,
    required this.onBackPressed,
    required this.onMenuPressed,
    required this.onFollowPressed,
    required this.showUnfollowDialog,
    required this.themeColor,
    this.userId,
    this.userName,
    Key? key,
  }) : super(key: key);

  @override
  _UserProfileHeaderState createState() => _UserProfileHeaderState();
}

class _UserProfileHeaderState extends State<UserProfileHeader> {
  late Future<Map<String, dynamic>> _statsFuture;
  int publicaciones = 0;
  int reacciones = 0;

  @override
  void initState() {
    super.initState();
    if (widget.userId != null) {
      _statsFuture = _fetchUserStats(widget.userId!);
      _statsFuture.then((stats) {
        if (mounted) {
          setState(() {
            publicaciones = stats['total_publicaciones'] ?? 0;
            reacciones = stats['total_reacciones'] ?? 0;
          });
        }
      });
    }
  }

  Future<Map<String, dynamic>> _fetchUserStats(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final uri = Uri.parse('${THttpHelper.baseUrl}/estadisticas_usuario/$userId');

    try {
      final response = await http.get(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load user stats');
      }
    } catch (e) {
      throw Exception('Failed to connect to the server: $e');
    }
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: TSizes.statsSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: TSizes.statsSize - 2,
                color: Colors.white.withOpacity(0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildAppBarIconButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: dark
            ? TColors.blakfondo.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
      ),
      child: IconButton(
        icon: Icon(icon, size: 24, color: dark ? Colors.white : Colors.black),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildFollowButton(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: TSizes.followButtonWidth,
      height: TSizes.followButtonHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: dark
            ? TColors.blakfondo.withOpacity(0.5)
            : Colors.white.withOpacity(0.5),
      ),
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: IconButton(
            icon: Icon(
              widget.isFollowing ? Icons.favorite : Icons.favorite_border,
              color: widget.isFollowing ? TColors.heartActive : Colors.white,
              size: TSizes.iconMd,
            ),
            onPressed: () {
              if (widget.isFollowing) {
                widget.showUnfollowDialog();
              } else {
                widget.onFollowPressed();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final showNameInAppBar = widget.appBarOpacity > 0.7;

    final parts = (widget.userName ?? '').split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return SliverAppBar(
      expandedHeight: widget.headerHeight,
      pinned: true,
      floating: false,
      snap: false,
      stretch: false,
      backgroundColor: Color.lerp(
        Colors.transparent,
        widget.themeColor,
        widget.appBarOpacity < 0.5
            ? 0.0
            : ((widget.appBarOpacity - 0.5) / 0.5).clamp(0.0, 1.0),
      ),
      elevation: 0,
      toolbarHeight: kToolbarHeight,
      leadingWidth: 56,
      leading: _buildAppBarIconButton(
        context, 
        Iconsax.arrow_left_2_copy, 
        () => NavigationController.to.popPage() // Cambiar onBackPressed por popPage
      ),
      title: showNameInAppBar
          ? AutoSizeText(
              widget.userName ?? '',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.black,
                    height: 1.0,
                  ),
              maxLines: 2,
              minFontSize: 20,
              maxFontSize: 36,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      centerTitle: true,
      actions: [
        _buildAppBarIconButton(context, Icons.more_vert, widget.onMenuPressed),
      ],
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              InteractiveViewer(
                panEnabled: true,
                minScale: 1,
                maxScale: 3,
                child: Image.network(
                  widget.headerImageUrl,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: 300,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.6),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                left: TSizes.md,
                bottom: TSizes.md * 2,
                right: TSizes.md,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: TSizes.imageThumbSize - 10,
                      height: TSizes.imageThumbSize - 10,
                      margin: const EdgeInsets.only(bottom: TSizes.md),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(widget.headerImageUrl),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: TSizes.firstNameSize + 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 0.9,
                              ),
                        ),
                        if (lastName.isNotEmpty)
                          Text(
                            lastName,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: TSizes.lastNameSize + 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 0.9,
                                ),
                          ),
                      ],
                    ),
                    const SizedBox(height: TSizes.md),
                    FutureBuilder<Map<String, dynamic>>(
                      future: _statsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Row(
                            children: [
                              _buildStatItem(context, '', 'Publicaciones'),
                              const SizedBox(width: TSizes.md),
                              _buildStatItem(context, '', 'Reacciones'),
                            ],
                          );
                        } else if (snapshot.hasError) {
                          return Row(
                            children: [
                              _buildStatItem(context, '0', 'Publicaciones'),
                              const SizedBox(width: TSizes.md),
                              _buildStatItem(context, '0', 'Reacciones'),
                            ],
                          );
                        } else {
                          final stats = snapshot.data ?? {
                            'total_publicaciones': 0,
                            'total_reacciones': 0
                          };
                          return Row(
                            children: [
                              _buildStatItem(
                                  context,
                                  stats['total_publicaciones'].toString(),
                                  'Publicaciones'),
                              const SizedBox(width: TSizes.md),
                              _buildStatItem(
                                  context,
                                  stats['total_reacciones'].toString(),
                                  'Reacciones'),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                right: TSizes.md,
                bottom: TSizes.md * 2 +
                    TSizes.imageThumbSize -
                    (TSizes.followButtonHeight / 2),
                child: _buildFollowButton(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}