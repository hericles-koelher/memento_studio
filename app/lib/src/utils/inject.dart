import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kiwi/kiwi.dart';
import 'package:logger/logger.dart';

import '../../firebase_options.dart';
import '../blocs.dart';
import '../datasource/api/api.dart';
import '../datasource/api/deck_api.dart';
import '../datasource/api/deck_reference_api.dart';
import '../repositories/deck_reference_repository.dart';
import '../repositories/deck_repository.dart';
import '../repositories/interfaces/deck_reference_repository_interface.dart';
import '../repositories/interfaces/deck_repository_interface.dart';

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
    (container) => GoogleSignIn(scopes: ["email", "profile"]),
  );
}
