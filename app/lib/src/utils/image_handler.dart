import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:path/path.dart' as p;

class MemoryImage {
  final String extension;
  final Uint8List bytes;

  MemoryImage({
    required this.extension,
    required this.bytes,
  });
}

Future<MemoryImage?> getImageFromDeviceGallery() async {
  ImagePicker picker = KiwiContainer().resolve();

  var xfile = await picker.pickImage(source: ImageSource.gallery);

  if (xfile != null) {
    return MemoryImage(
      extension: _getFileExtension(xfile.name),
      bytes: await xfile.readAsBytes(),
    );
  }

  return null;
}

Future<String> storeImageIntoAppFolder({
  required MemoryImage image,
  required bool isFront,
  required String deckId,
  required String cardId,
}) async {
  Directory dir = KiwiContainer().resolve();

  final deckDir = p.join(dir.path, deckId);

  var dirExists = await dir.list().any(
        (subDir) => subDir.path == deckDir,
      );

  if (!dirExists) {
    await Directory(deckDir).create();
  }

  var path = p.join(
    deckDir,
    _createFileName(
        isFront: isFront, cardId: cardId, extension: image.extension),
  );

  var file = File(path);

  await file.create();

  await file.writeAsBytes(image.bytes);

  return path;
}

String _createFileName({
  required bool isFront,
  required String cardId,
  required String extension,
}) =>
    "${isFront ? "Front_" : "Back_"}$cardId.$extension";

String _getFileExtension(String name) => name.split(".").last;
