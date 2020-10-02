import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/login.dart';
import '../homeCard.dart';
import '../cart.dart';
import '../checkout.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// abstract class AuthServiceBase {
//   handleAuth();
//   signOut();
//   signIn(AuthCredential authCreds, BuildContext context);
//   signInWithOTP(String smsCode, String verId, BuildContext context);
// }

// final myNotifierProvider = ChangeNotifierProvider((_) {
//   return AuthService();
// });

class AuthService {
  checkAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user != null) {
        return true;
      } else {
        return false;
      }
    });
  }

  // @override
  handleAuth() {
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        Get.off(Login());
      } else {
        Get.to(Checkout());
      }
    });

    // if (user == null) {
    //   print('No user');
    // } else {
    //   print('user signed up');
    // }
    // StreamBuilder(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (BuildContext context, snapshot) {
    //       debugPrint('snapshot, ${snapshot.data}');
    //       if (snapshot.hasData) {
    //         Get.to(Checkout());

    //         // Navigator.push(
    //         //     context, MaterialPageRoute(builder: (context) => Checkout()));

    //         // return Checkout();
    //       } else {
    //         Get.offAll(Login());
    //         // Navigator.push(
    //         //     context, MaterialPageRoute(builder: (context) => Login()));
    //         // return Login();
    //       }
    //     });

    // notifyListeners();
  }

  //Sign out
  // @override
  signOut() {
    FirebaseAuth.instance.signOut();
    Get.offAll(HomeCard());
  }

  //SignIn
  // @override
  signIn(AuthCredential authCreds, BuildContext context) async {
    UserCredential response =
        await FirebaseAuth.instance.signInWithCredential(authCreds);
    debugPrint('Firebase credential, ${response.user}');
    Get.off(HomeCard());

    // Navigator.pushNamedAndRemoveUntil(
    //     context, "/cart", (Route<dynamic> route) => false);

    // Navigator.pushNamedAndRemoveUntil('/cart', (Route<dynamic> route) => false);
    // await Navigator.of(context).pushReplacementNamed('/cart');
    // Navigator.of(context).pop(); // to pop the dialog box
  }

  // @override
  signInWithOTP(smsCode, verId, context) {
    AuthCredential authCreds =
        PhoneAuthProvider.credential(verificationId: verId, smsCode: smsCode);
    signIn(authCreds, context);
  }
}
