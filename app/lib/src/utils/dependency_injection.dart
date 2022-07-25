import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

import '../../firebase_options.dart';
import '../blocs.dart';
import '../datasource/api/api.dart';
import '../datasource/api/deck_api.dart';
import '../datasource/api/deck_reference_api.dart';
import '../repositories/deck_reference_repository.dart';
import '../repositories/deck_repository.dart';
import '../repositories/interfaces/deck_reference_repository_interface.dart';
import '../repositories/interfaces/deck_repository_interface.dart';
import '../state_managers.dart';
import '../utils.dart';

Future<void> injectDependencies() async {
  var kiwi = KiwiContainer();

  var fbApp = await Firebase.initializeApp(
    name: "Memento Studio",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  kiwi.registerInstance(AuthCubit(FirebaseAuth.instanceFor(app: fbApp)));
  kiwi.registerInstance(Logger());

  final chopperClient = Api.createInstance();
  kiwi.registerInstance<DeckReferenceRepositoryInterface>(
      DeckReferenceRepository(chopperClient.getService<DeckReferenceApi>()));
  kiwi.registerInstance<DeckRepositoryInterface>(
      DeckRepository(chopperClient.getService<DeckApi>()));

  kiwi.registerSingleton(
    (_) => GoogleSignIn(scopes: ["email", "profile"]),
  );

  kiwi.registerInstance(await ObjectBox.create());

  kiwi.registerInstance<Directory>(
    await getApplicationDocumentsDirectory(),
  );

  kiwi.registerSingleton((_) => ImagePicker());
}
