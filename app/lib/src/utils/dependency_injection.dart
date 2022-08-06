import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';
import 'package:memento_studio/src/apis.dart';
import 'package:memento_studio/src/repositories.dart';
import 'package:memento_studio/src/repositories/api/adapters/api_deck_adapter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../firebase_options.dart';
import '../state_managers.dart';
import '../utils.dart';

Future<void> injectDependencies() async {
  var kiwi = KiwiContainer();

  var fbApp = await Firebase.initializeApp(
    name: "Memento Studio",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  kiwi.registerInstance(ApiDeckAdapter());

  final chopperClient = Api.createInstance();
  kiwi.registerInstance<DeckReferenceRepositoryInterface>(
      DeckReferenceRepository(chopperClient.getService<DeckReferenceApi>()));
  kiwi.registerInstance<DeckRepositoryInterface>(
      DeckRepository(chopperClient.getService<DeckApi>()));
  kiwi.registerInstance<UserRepositoryInterface>(
      UserRepository(chopperClient.getService<UserApi>()));

  kiwi.registerInstance(AuthCubit(FirebaseAuth.instanceFor(app: fbApp)));

  kiwi.registerInstance(Logger());

  kiwi.registerSingleton(
    (_) => GoogleSignIn(scopes: ["email", "profile"]),
  );

  kiwi.registerInstance(await ObjectBox.create());

  kiwi.registerInstance<Directory>(
    await getApplicationDocumentsDirectory(),
  );

  kiwi.registerSingleton((_) => ImagePicker());

  kiwi.registerSingleton((_) => const Uuid());

  kiwi.registerInstance<LocalDeckRepository>(
    ObjectBoxLocalDeckRepository(
      kiwi.resolve(),
    ),
  );

  kiwi.registerInstance<DeckAdapter>(
    ObjectBoxDeckAdapter(),
  );

  kiwi.registerInstance(
    DeckCollectionCubit(
      kiwi.resolve(),
      kiwi.resolve(),
      kiwi.resolve(),
      kiwi.resolve(),
      kiwi.resolve(),
    ),
  );

  kiwi.registerInstance(DeckReferencesCubit(
    kiwi.resolve(),
    kiwi.resolve(),
  ));

  kiwi.registerSingleton<DeletedDeckListRepository>(
    (_) => ObjectBoxDeletedDeckList(kiwi.resolve()),
  );
}
