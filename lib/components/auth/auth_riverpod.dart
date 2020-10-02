// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// class RiverAuthService {
//   static final provider = StreamProvider.autoDispose((ref) {
//     final sub = FirebaseAuth.instance
//         .authStateChanges()
//         .listen((User user) => ref.read(uidProvider).state = user?.uid);

//     ref.onDispose(() => sub.cancel());

//     return FirebaseAuth.instance.authStateChanges();
//   });
//   static final uidProvider = StateProvider<String>((_) => null);
// }
