import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:labart/features/chat_ai/art_assistant_screen.dart';
import 'package:labart/features/paint_drawing/example/fullstack_example/lib/main.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/helpers/helper_functions.dart';
import 'package:labart/widgets/subir_publicacion.dart';

class PublicacionModal extends StatelessWidget {
  const PublicacionModal({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {}, // Evita cerrar al tocar el modal
        child: FractionallySizedBox(
          heightFactor: 0.25,
          widthFactor: 1.0,
          child: Container(
            decoration: BoxDecoration(
              color: dark ? TColors.blakfondo : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            'Comienza ahora',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: dark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48), // para compensar el espacio del botón de cerrar
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Botón Izquierdo (Asistente)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Get.to(() => ArtAssistantScreen());
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.smart_toy_outlined, size: 50, color: dark ? Colors.white : Colors.black),
                            const SizedBox(height: 8),
                            Text(
                              'Asistente',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Botón Central (Publicar)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Get.to(() => NuevaPublicacionScreen());
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Iconsax.add, size: 50, color: dark ? Colors.white : Colors.black),
                            const SizedBox(height: 8),
                            Text(
                              'Publicar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Botón Derecho (Pintar)
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Get.to(() => FlutterPainterExample());
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.brush_outlined, size: 50, color: dark ? Colors.white : Colors.black),
                            const SizedBox(height: 8),
                            Text(
                              'Pintar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
