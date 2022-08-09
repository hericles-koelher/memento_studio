import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:memento_studio/src/entities.dart';
import 'package:memento_studio/src/utils/constants.dart';

class DeckListTile extends StatelessWidget {
  final DeckReference deck;
  const DeckListTile({Key? key, required this.deck}) : super(key: key);

  static const _withoutTagChip = Chip(
    label: Text("Sem Tags"),
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Flexible(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: deck.cover ?? "",
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      imageBuilder: (context, image) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.black,
                            width: borderWidth,
                          ),
                          image: DecorationImage(
                            image: image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(
                            color: Colors.black,
                            width: borderWidth,
                          ),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/placeholder.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          deck.name,
                          maxLines: 2,
                        ),
                        if (deck.description != null)
                          Text(
                            deck.description!,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const Spacer(),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Por ${deck.author} de tal"),
                              Text("${deck.numberOfCards} cards")
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
          Flexible(
            child: deck.tags.isEmpty
                ? Row(children: const [_withoutTagChip])
                : ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: deck.tags.length,
                    itemBuilder: (_, index) => Chip(
                      label: Text(deck.tags[index]),
                      backgroundColor: Colors
                          .accents[index % Colors.accents.length].shade100,
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 5),
                  ),
          ),
        ],
      ),
    );
  }
}
