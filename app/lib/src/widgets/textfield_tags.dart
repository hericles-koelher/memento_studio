import 'package:flutter/material.dart';

class TextFieldTags extends StatelessWidget {
  final List<String> tags;
  void Function(String, List<String>) onSearchAction;
  void Function(String)? onAddTag;
  void Function(String)? onDeleteTag;

  final textFieldController = TextEditingController();

  TextFieldTags(
      {Key? key,
      this.tags = const <String>[],
      required this.onSearchAction,
      this.onDeleteTag,
      this.onAddTag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: textFieldController,
          decoration: InputDecoration(
            labelText: "Pesquisar",
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            suffixIcon: IconButton(
              onPressed: () {
                onSearchAction(textFieldController.text, tags);
              },
              icon: const Icon(Icons.search),
            ),
            border: const OutlineInputBorder(),
          ),
        ),
        TextButton(
          onPressed: () {
            if (onAddTag != null) onAddTag!(textFieldController.text);
          },
          child: const Text("Add tag"),
        ),
        tags.isEmpty
            ? Container()
            : SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: tags.length,
                  itemBuilder: (_, index) => Chip(
                    label: Text(tags[index]),
                    onDeleted: () {
                      if (onDeleteTag != null) onDeleteTag!(tags[index]);
                    },
                  ),
                  separatorBuilder: (_, __) => const SizedBox(width: 5),
                ),
              ),
      ],
    );
  }
}
