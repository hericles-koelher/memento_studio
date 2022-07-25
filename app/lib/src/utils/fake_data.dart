import 'package:memento_studio/src/entities.dart';

abstract class FakeData {
  static List<Deck> decks = [
    Deck(
      id: "abc",
      description: "xablaysadgargaerrrrraheagdf",
      name: "Teste1",
      lastModification: DateTime.now(),
      tags: ["adg", "yabada"],
    ),
    Deck(
        id: "bca",
        description: "Habilidades de um pássaro para uma guerra.",
        name: "War birb",
        lastModification: DateTime.now(),
        tags: ["matematica", "biologia", "guerra", "passaro"],
        cover: "assets/images/war-birb-wallpaper.jpeg",
        cards: [
          Card(
              id: "idcard1",
              frontText:
                  "Qual é a primeira pergunta relativamente longa do primeiro card?",
              frontImage: "assets/images/nhoque-charles.jpg",
              backText: "É essa mesmo que você acabou de fazer!"),
          Card(
            id: "idcard2",
            frontText: "Quem é você?",
            backImage: "assets/images/sushiraldo.jpg",
            backText: "Também não sei, to perdido",
          ),
          Card(
              id: "idcard3",
              frontText: "Nome do passarinho da mikaella",
              frontImage: "assets/images/geraldin.jpg",
              backText: "Geraldo",
              backImage: "assets/images/sushiraldo.jpg"),
          Card(
            id: "idcard4",
            frontText: "Quem nasceu primeiro, o ovo ou a galinha?",
            frontImage: "assets/images/nhoque-charles.jpg",
            backText: "Também não sei",
          )
        ]),
    Deck(
      id: "acb",
      description: "xablay",
      name: "Teste3",
      lastModification: DateTime.now(),
    ),
    Deck(
      id: "bca",
      description: "xablay",
      name: "Teste2",
      lastModification: DateTime.now(),
      tags: ["matematica", "biologia"],
    ),
    Deck(
      id: "bca",
      description: "xablay",
      name: "Teste2",
      lastModification: DateTime.now(),
      tags: ["matematica", "biologia"],
    ),
    Deck(
      id: "abc",
      description: "xablaysadgargaerrrrraheagdf",
      name: "Teste1",
      lastModification: DateTime.now(),
      tags: ["adg", "yabada"],
    ),
    Deck(
      id: "bca",
      description: "xablay",
      name: "Teste2",
      lastModification: DateTime.now(),
      tags: ["matematica", "biologia"],
    ),
    Deck(
      id: "abc",
      description: "xablaysadgargaerrrrraheagdf",
      name: "Teste1",
      lastModification: DateTime.now(),
      tags: ["adg", "yabada"],
    ),
    Deck(
      id: "bca",
      description: "xablay",
      name: "Teste2",
      lastModification: DateTime.now(),
      tags: ["matematica", "biologia"],
    ),
  ];
}
