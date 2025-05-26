import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';

class TCartCounterIcon extends StatelessWidget {
  const TCartCounterIcon({
    super.key, 
    required this.onPressed, 
    required this.iconColor,
    this.showBadge = true, // Opcional: para controlar visibilidad
  });

  final VoidCallback onPressed;
  final Color iconColor;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Stack(
      children: [
        // Icono con fondo circular
        Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: dark ? const Color.fromARGB(41, 35, 35, 35) : const Color.fromARGB(25, 194, 194, 194), // Fondo sutil
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: onPressed,
            icon: Icon(Iconsax.notification, color: iconColor),
            padding: const EdgeInsets.all(4),
          ),
        ),
        
        // Punto rojo de notificación
        if (showBadge)
          Positioned(
            top: 18,
            right: 22,
            child: Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: Colors.red, // Punto rojo
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: dark ? const Color.fromARGB(255, 246, 246, 246) : TColors.black,
                  width: 1,
                ),
              ),
            ),
          )
      ],
    );
  }
}