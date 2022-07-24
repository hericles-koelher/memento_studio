import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/exceptions.dart';
import 'package:path/path.dart' as p;

final RegExp _msImageNameRegex = RegExp(
  r"^(?:(?:Front)|(?:Back)|(?:Cover))_.*\.(?:(?:bmp)|(?:gif)|(?:jpeg)|(?:jpg)|(?:png)|(?:webp)|(?:heif)|(?:heic))$",
);

String _createCardFileName({
  required bool isFront,
  required String cardId,
  required String extension,
}) =>
    "${isFront ? "Front_" : "Back_"}$cardId.$extension";

String _getFileExtension(String name) => name.split(".").last;

class MemoryImage {
  final String extension;
  final Uint8List bytes;

  MemoryImage({
    required this.extension,
    required this.bytes,
  });
}

Future<Uint8List> getImageBytes(String path) {
  if (_msImageNameRegex.hasMatch(path)) {
    return File(path).readAsBytes();
  } else {
    throw MSImageException(
      message: "Este caminho não está nos padrões de uso do MS",
    );
  }
}

Future<MemoryImage?> getImageFromDevice({required bool fromGallery}) async {
  ImagePicker picker = KiwiContainer().resolve();

  var xfile = await picker.pickImage(
    source: fromGallery ? ImageSource.gallery : ImageSource.camera,
  );

  if (xfile != null) {
    return MemoryImage(
      extension: _getFileExtension(xfile.name),
      bytes: await xfile.readAsBytes(),
    );
  }

  return null;
}

Future<String> storeCardImageIntoAppFolder({
  required MemoryImage image,
  required bool isFront,
  required String deckId,
  required String cardId,
}) async {
  Directory dir = KiwiContainer().resolve();

  final path = p.join(
    dir.path,
    deckId,
    _createCardFileName(
      isFront: isFront,
      cardId: cardId,
      extension: image.extension,
    ),
  );

  var file = File(path);

  await file.create(recursive: true);

  await file.writeAsBytes(
    image.bytes,
    mode: FileMode.writeOnly,
  );

  return path;
}

Future<String> storeDeckCoverImageIntoAppFolder({
  required MemoryImage image,
  required String deckId,
}) async {
  Directory dir = KiwiContainer().resolve();

  var path = p.join(
    dir.path,
    deckId,
    "Cover.${image.extension}",
  );

  var file = File(path);

  await file.create(recursive: true);

  await file.writeAsBytes(
    image.bytes,
    mode: FileMode.writeOnly,
  );

  return path;
}
