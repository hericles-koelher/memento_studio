import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:memento_studio/src/utils.dart';

/// {@category Widgets}
/// Imagem de card que é exibido na página de estudos.
class CardImage extends StatelessWidget {
  final String? imagePath;

  static const _defaultDecorationImage = DecorationImage(
    image: AssetImage("assets/images/placeholder.png"),
    fit: BoxFit.cover,
  );

  const CardImage({
    Key? key,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => ConstrainedBox(
            constraints: constraints.copyWith(
              maxHeight: constraints.maxWidth,
            ),
            child: Builder(
              builder: (_) {
                if (imagePath != null && imagePath!.contains("http")) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black54,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: "$baseUrl/$imagePath",
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(AssetManager.noImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54,
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    image: imagePath != null
                        ? DecorationImage(
                            alignment: Alignment.center,
                            image: FileImage(File(imagePath!)),
                            fit: BoxFit.cover,
                          )
                        : _defaultDecorationImage,
                  ),
                );
              },
            ),
          )),
    );
  }
}
