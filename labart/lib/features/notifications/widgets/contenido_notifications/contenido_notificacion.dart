import 'package:flutter/material.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/helpers/helper_functions.dart';

class NotificationItem extends StatelessWidget {
  final Animation<double> animation;
  final String id;
  final int tabIndex;  // Cambiado de isComment a tabIndex
  final String userName;
  final String content;
  final String? imageUrl;  // Hacerlo nullable
  final Function(String, int) onDismissed;  // Cambiado el segundo parámetro
  final DateTime notificationTime;
  final String? userImageUrl;  // Nuevo parámetro
  final bool isRead;  // Nuevo parámetro

  const NotificationItem({
    super.key,
    required this.animation,
    required this.id,
    required this.tabIndex,
    required this.userName,
    required this.content,
    required this.imageUrl,
    required this.onDismissed,
    required this.notificationTime,
    this.userImageUrl,
    required this.isRead,
  });

  String _getTimeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Hace unos segundos';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 30) {
      return 'Hace ${difference.inDays} d';
    } else {
      final months = (difference.inDays / 30).floor();
      return 'Hace $months mes${months == 1 ? '' : 'es'}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      )),
      child: Dismissible(
        key: Key(id),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: TSizes.md),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          alignment: Alignment.centerRight,
          child: const Icon(Icons.delete, color: Colors.white, size: 32),
        ),
        onDismissed: (direction) {
          onDismissed(id, tabIndex);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: TSizes.md),
          child: Container(
            padding: const EdgeInsets.all(TSizes.sm),
            decoration: BoxDecoration(
              color: isDark 
                  ? const Color.fromARGB(255, 38, 46, 48) 
                  : Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: isDark 
                      ? const Color.fromARGB(255, 184, 184, 184).withOpacity(0.1) 
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    // Avatar con indicador de no leído
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: TColors.primary.withOpacity(0.2),
                          backgroundImage: userImageUrl != null 
                              ? NetworkImage(userImageUrl!) 
                              : null,
                          child: userImageUrl == null
                              ? const Icon(Icons.person, color: TColors.primary, size: 28)
                              : null,
                        ),
                        if (!isRead)
                          Positioned(
                            top: 0,
                            right: 2,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isDark ? const Color.fromARGB(255, 38, 46, 48) : Colors.white, // Cambia este color según tu diseño
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: TSizes.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            content,
                            style: TextStyle(
                              color: isDark ? Colors.grey[500] : Colors.grey[600],
                              fontSize: 14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getTimeAgo(notificationTime),
                            style: TextStyle(
                              color: isDark 
                                  ? Colors.white.withOpacity(0.8) 
                                  : Colors.black.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (imageUrl != null && imageUrl!.isNotEmpty) ...[
                      const SizedBox(width: TSizes.md),
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    color: Theme.of(context).scaffoldBackgroundColor, 
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 50,
                                  height: 50,
                                  color: Theme.of(context).scaffoldBackgroundColor,
                                  child: const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}