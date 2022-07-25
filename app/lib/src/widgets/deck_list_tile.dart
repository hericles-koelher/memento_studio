import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../entities/local/deck/deck_reference.dart';

class DeckListTile extends StatelessWidget {
  final DeckReference deck;
  const DeckListTile({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tags = deck.tags.isNotEmpty ? deck.tags : ["Sem Tags"];

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
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: CachedNetworkImage(
                        imageUrl: deck.cover ?? "",
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image:
                                  AssetImage("assets/images/placeholder.png"),
                              fit: BoxFit.cover,
                            ),
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
                        Text(deck.name),
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
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: tags.length,
              itemBuilder: (_, index) => Chip(
                label: Text(tags[index]),
              ),
              separatorBuilder: (_, __) => const SizedBox(width: 5),
            ),
          ),
        ],
      ),
    );
  }
}
