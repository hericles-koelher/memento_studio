import 'package:flutter/material.dart';
import 'package:memento_studio/src/entities.dart';

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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
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
