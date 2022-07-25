import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:memento_studio/src/entities.dart' as ms_entities;

class CardView extends StatelessWidget {
  final String text;
  final String? imagePath;
  final Color color;
  final double height;

  const CardView(
      {Key? key,
      required this.text,
      this.imagePath,
      required this.color,
      required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TextTheme textTheme = Theme.of(context).textTheme;

    bool shouldShowImage = imagePath != null && imagePath!.isNotEmpty;

    return Container(
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Card(
        color: color,
        child: Column(children: [
          shouldShowImage
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: cardImage(),
                )
              : const Spacer(),
          shouldShowImage ? const Spacer() : Container(),
          SizedBox(
            width: double.infinity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: AutoSizeText(
                  text,
                  style: const TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
              ),
            ),
          ),
          const Spacer(),
        ]),
      ),
    );
  }

  Widget cardImage() {
    var placeholderImage = const BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/placeholder.png"),
        fit: BoxFit.cover,
      ),
    );

    if (!imagePath!.contains('http')) {
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.center,
            image: AssetImage(imagePath!),
            fit: BoxFit.cover,
          ),
        ),
        height: height / 2,
      );
    }

    return CachedNetworkImage(
      // width: MediaQuery.of(context).size.width,
      height: height / 2,
      width: double.infinity,
      imageUrl: imagePath!,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Container(
        decoration: placeholderImage,
      ),
    );
  }
}
