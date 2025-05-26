import 'package:flutter/material.dart';
import 'package:labart/common/models/publicacion_model.dart';
import 'package:labart/utils/constants/colors.dart';
import 'package:labart/utils/constants/sizes.dart';
import 'package:labart/utils/constants/text_strings.dart';

class PostContentWidget extends StatefulWidget {
  final bool isDark;
  final Publicacion publicacion;

  const PostContentWidget({
    super.key,
    required this.isDark,
    required this.publicacion,
  });

  @override
  State<PostContentWidget> createState() => _PostContentWidgetState();
}

class _PostContentWidgetState extends State<PostContentWidget> {
  bool _showFullDescription = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.md,
        vertical: TSizes.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.publicacion.titulo,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: TSizes.xs),
          LayoutBuilder(
            builder: (context, constraints) {
              final text = widget.publicacion.descripcion;
              final textSpan = TextSpan(
                text: text,
                style: Theme.of(context).textTheme.bodyMedium,
              );
              final textPainter = TextPainter(
                text: textSpan,
                maxLines: 3,
                textDirection: TextDirection.ltr,
              )..layout(maxWidth: constraints.maxWidth);

              if (textPainter.didExceedMaxLines) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _showFullDescription
                          ? text
                          : '${text.substring(0, 100)}...',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _showFullDescription = !_showFullDescription;
                        });
                      },
                      child: Text(
                        _showFullDescription
                            ? TTexts.verMenos
                            : TTexts.verMas,
                        style: TextStyle(
                          color: TColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Text(text, style: Theme.of(context).textTheme.bodyMedium);
            },
          ),
        ],
      ),
    );
  }
}