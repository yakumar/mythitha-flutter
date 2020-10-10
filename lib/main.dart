import 'package:flutter/material.dart';
// import 'package:myhitha/components/homeCard.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
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
          BlocProvider<CounterCubit>(
            create: (context) => CounterCubit(),
          ),
        ],
        child: GetMaterialApp(
          title: 'MyHitha Home',
          theme: ThemeData(
            buttonTheme: ButtonThemeData(
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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return HomeCard();
  }
}
