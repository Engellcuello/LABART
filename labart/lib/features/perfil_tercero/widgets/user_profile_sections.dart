import 'package:flutter/material.dart';
import 'package:labart/features/perfil_tercero/widgets/userProfilePost.dart';
import 'package:labart/utils/helpers/helper_functions.dart';


class UserProfileSections extends StatelessWidget {
  final TabController tabController;
  final String headerImageUrl;
  final bool isFollowing;
  final int? userId;
  final VoidCallback onFollowPressed;
  final VoidCallback showUnfollowDialog;

  const UserProfileSections({
    super.key,
    required this.tabController,
    required this.headerImageUrl,
    required this.isFollowing,
    required this.userId,
    required this.onFollowPressed,
    required this.showUnfollowDialog,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return SliverFillRemaining(
      child: TabBarView(
        controller: tabController,
        children: [
          UserProfilePosts(userId: userId ?? 0, tabType: 'creadas', isDark: dark,),
          UserProfilePosts(userId: userId ?? 0, tabType: 'guardadas', isDark: dark,),
        ],
      ),
    );
  }
}

