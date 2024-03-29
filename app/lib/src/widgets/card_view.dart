import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:memento_studio/src/utils.dart';
import 'package:memento_studio/src/widgets.dart';

/// {@category Widgets}
/// Carta que aparece na tela de estudos.
class CardView extends StatelessWidget {
  final String? text;
  final String? imagePath;
  final bool isFront;

  final double height;

  const CardView({
    Key? key,
    this.text,
    this.imagePath,
    required this.height,
    required this.isFront,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    var textStyle = textTheme.bodyLarge;

    var defaultText = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "Sem texto de ${isFront ? 'pergunta' : 'resposta'}",
          overflow: TextOverflow.ellipsis,
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 2,
        ),
        Text(
          "¯\\_(ツ)_/¯",
          style: textStyle,
          textAlign: TextAlign.center,
        )
      ],
    );

    return LayoutBuilder(
      builder: (_, constraints) => Center(
        child: SizedBox(
          height: constraints.maxHeight * 0.85,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(
                borderRadius,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: -2,
                  offset: Offset(4, 3),
                )
              ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                side: const BorderSide(
                  color: Colors.black,
                  width: borderWidth,
                ),
                borderRadius: BorderRadius.circular(
                  borderRadius,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    if (imagePath != null && imagePath!.isNotEmpty) ...[
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: CardImage(imagePath: imagePath),
                        ),
                      ),
                      const SizedBox(height: 15)
                    ],
                    Flexible(
                      flex: 2,
                      child: Container(
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.black54,
                              width: 2.0,
                            )),
                        child: Column(
                          children: [
                            if (text != null && text!.isNotEmpty) ...[
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  isFront ? 'Pergunta:' : 'Resposta:',
                                  style: textTheme.caption?.copyWith(
                                    color: MSTheme.darkPurple,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            Expanded(
                              child: Center(
                                child: text != null
                                    ? AutoSizeText(
                                        text!,
                                        style: textStyle,
                                      )
                                    : defaultText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
