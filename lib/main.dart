import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './utilities/sizes.dart';
import './components/homeCard.dart';
import './components/cart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './cubit/counter_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './components/auth/login.dart';
import 'package:get/get.dart';
import './components/thanks.dart';
import './components/orders.dart';
import './components/auth/signin.dart';
import './bloc/cart_bloc.dart';
import './bloc/simple_observer.dart';
import './bloc/cart_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = SimpleObserver();

  await Firebase.initializeApp();

  runApp(EasyLocalization(
      child: MyApp(),
      saveLocale: true,
      supportedLocales: [
        Locale('en', 'EN'),
        Locale('te', 'IN'),
      ],
      path: "assets/lang"));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  // final FirebaseOptions firebaseOptions = const FirebaseOptions(
  //   appId: '1:886958340235:ios:6d1bc232f9df637391fc8e',
  //   apiKey: 'AIzaSyCMo1WW_n4ZwLVjlrQ8-Smq7kAEaqHUcu4',
  //   projectId: 'myhitha-e99e0',
  //   messagingSenderId: '448618578101',
  // );

  //  Future<void> initializeDefault() async {
  //   FirebaseApp app = await Firebase.initializeApp();
  //   assert(app != null);
  //   print('Initialized default app $app');
  // }

  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // auth.authStateChanges().listen((User user) {
    // if (user == null) {
    //   print('No user');
    // } else {
    //   print('user signed up');
    // }
    // });

    return MultiBlocProvider(
        providers: [
          // BlocProvider<CounterCubit>(
          //   create: (context) => CounterCubit(),
          // ),
          BlocProvider<CartBloc>(
              create: (_) => CartBloc(SubmitCartRepository())),
        ],
        child: GetMaterialApp(
          title: 'MyHitha Home',
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            buttonTheme: ButtonThemeData(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0)),
                buttonColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 4.0)),
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to,
            // ) "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => HomeCard(),
            '/cart': (context) => Cart(),
            '/login': (context) => Login(),
            '/signin': (context) => SignIn(),
            '/thanks': (context) => Thanks(),
            '/orders': (context) => Orders(
                  email: FirebaseAuth.instance.currentUser.email,
                ),
          },
        ));
  }

  // Otherwise, show something whilst waiting for initialization to complete

}
