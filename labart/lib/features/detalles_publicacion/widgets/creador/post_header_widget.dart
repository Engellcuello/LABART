import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/widgets/navigation_bar.dart';

class PostHeaderWidget extends StatelessWidget {
  final bool isDark;
  final Publicacion publicacion;

  const PostHeaderWidget({
    super.key,
    required this.isDark,
    required this.publicacion,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      child: Row(
        children: [
          GestureDetector(
              onTap: () {
                final usuario = publicacion.usuario;
                if (usuario != null) {
                  NavigationController.to.pushPage(
                    UserProfilePageWrapper(
                      userId: usuario.id,
                      userName: usuario.nombre,
                      userImg: usuario.imgUsuario,
                    ),
                  );
                }
              },
              child: _buildUserAvatar(),
            ),

          const SizedBox(width: TSizes.sm),
          Expanded(
            child: GestureDetector(
              onTap: () {
                final usuario = publicacion.usuario;
                if (usuario != null) {
                  NavigationController.to.pushPage(
                    UserProfilePageWrapper(
                      userId: usuario.id,
                      userName: usuario.nombre,
                      userImg: usuario.imgUsuario,
                    ),
                  );
                }
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserName(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar() {
    // Si no hay usuario o no tiene imagen
    if (publicacion.usuario == null || publicacion.usuario!.imgUsuario.isEmpty) {
      return CircleAvatar(
        radius: TSizes.iconMd,
        backgroundColor: isDark ? TColors.darkerGrey : TColors.lightGrey,
        child: Icon(Icons.person, color: isDark ? TColors.white : TColors.black),
      );
    }
    
    // Cargar imagen con CachedNetworkImage
    return CachedNetworkImage(
      imageUrl: publicacion.usuario!.imgUsuario,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        radius: TSizes.iconMd,
        backgroundImage: imageProvider,
      ),
      placeholder: (context, url) => CircleAvatar(
        radius: TSizes.iconMd,
        backgroundColor: isDark ? TColors.darkerGrey : TColors.lightGrey,
        child: const CircularProgressIndicator(strokeWidth: 2),
      ),
      errorWidget: (context, url, error) => CircleAvatar(
        radius: TSizes.iconMd,
        backgroundColor: isDark ? TColors.darkerGrey : TColors.lightGrey,
        child: Icon(Icons.error, color: isDark ? TColors.white : TColors.black),
      ),
    );
  }

  Widget _buildUserName(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final hasUserName = publicacion.usuario != null && 
                       publicacion.usuario!.nombre.isNotEmpty;
    
    return Text(
      hasUserName ? publicacion.usuario!.nombre : 'Cargando...',
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: dark ? TColors.textWhite : TColors.black,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

}