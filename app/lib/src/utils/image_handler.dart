import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:memento_studio/src/exceptions.dart';
import 'package:path/path.dart' as p;

/// {@category Utils}
/// Regex do nome das imagens possíveis
final RegExp _msImageNameRegex = RegExp(
  r"^.*(?:(?:Front)|(?:Back)|(?:Cover))_.*\.(?:(?:bmp)|(?:gif)|(?:jpeg)|(?:jpg)|(?:png)|(?:webp)|(?:heif)|(?:heic))$",
);

/// {@category Utils}
/// Cria o nome da imagem de um card
String _createCardFileName({
  required bool isFront,
  required String cardId,
  required String extension,
}) =>
    "${isFront ? "Front_" : "Back_"}$cardId.$extension";

/// {@category Utils}
/// Pega o nome da extensão de um arquivo
String getFileExtension(String name) => name.split(".").last;

/// {@category Utils}
/// Imagem que é armazenada no banco local
class MemoryImage {
  final String extension;
  final Uint8List bytes;

  MemoryImage({
    required this.extension,
    required this.bytes,
  });
}

/// {@category Utils}
/// Pega bytes de imagem dado um caminho local
Future<Uint8List> getImageBytes(String path) {
  if (_msImageNameRegex.hasMatch(path)) {
    return File(path).readAsBytes();
  } else {
    throw MSImageException(
      message: "Este caminho não está nos padrões de uso do MS",
    );
  }
}

/// {@category Utils}
/// Pega imagem do dispositivo do usuário
Future<MemoryImage?> getImageFromDevice({required bool fromGallery}) async {
  ImagePicker picker = KiwiContainer().resolve();

  var xfile = await picker.pickImage(
    source: fromGallery ? ImageSource.gallery : ImageSource.camera,
  );

  if (xfile != null) {
    return MemoryImage(
      extension: getFileExtension(xfile.name),
      bytes: await xfile.readAsBytes(),
    );
  }

  return null;
}

/// {@category Utils}
/// Armazena imagem de card localmente
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

/// {@category Utils}
/// Armazena imagem de capa de baralho localmente
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

/// {@category Utils}
/// Deleta imagem localmente, dado um caminho
Future<void> deleteLocalImage(String? path) async {
  if (path == null) return;
  try {
    File file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    print("Erro ao deletar imagem: ${e.toString()}");
    // Error in getting access to the file.
  }
}
