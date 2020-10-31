import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utilities/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './authservice.dart';
import 'package:get/get.dart';
import '../homeCard.dart';
import './login.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  String email, password;

  bool codeSent = false;
  // TextEditingController _emailController = TextEditingController();
  // TextEditingController _passController = TextEditingController();
  bool checkBoxValue = false;

  // @override
  // void dispose() {
  //   //profileBloc.dispose() cannot call as ProfileBloc class doesn't have dispose method
  //   super.dispose();
  // }

  // void autoLogin() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   //  var autoLogin = prefs.getInt('autoLogin') ??
  //   // still don't know what this is, a boolean?
  //   if (prefs.getString('email') != null &&
  //       prefs.getString('password') != null) {
  //     setState(() {
  //       _emailController.text = prefs.getString('email');
  //       _passController.text = prefs.getString('password');
  //     });
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   // autoLogin();
  // }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _emailController.dispose();
  //   _passController.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[700],
      resizeToAvoidBottomPadding: false,
      body: Container(
        // width: displayWidth(context) / 2,
        margin: EdgeInsets.symmetric(
            horizontal: displayWidth(context) / 18,
            vertical: displayHeight(context) / 4),
        height: displayHeight(context) / 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange[700],
        ),

        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "MyHitha Register",
                  style: TextStyle(fontSize: 25.0, color: Colors.black87),
                ),
                Container(
                  height: displayHeight(context) / 40,
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: displayWidth(context) / 9),
                  child: TextFormField(
                    // controller: _emailController,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 16.0),
                      prefixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 12.0),
                        child:
                            Icon(Icons.email), // myIcon is a 48px-wide widget.
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                    textAlignVertical: TextAlignVertical.bottom,

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter Email';
                      } else if (!value.contains('@')) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  height: displayHeight(context) / 50,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: displayWidth(context) / 9),
                  child: TextFormField(
                    // controller: _passController,

                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 10.0),
                      prefixIcon: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 12.0),
                        child:
                            Icon(Icons.lock), // myIcon is a 48px-wide widget.
                      ),
                      border: OutlineInputBorder(),
                      labelText: 'password',
                    ),
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    onSaved: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                    textAlignVertical: TextAlignVertical.bottom,

                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter password';
                      } else if (value.length < 6) {
                        return 'Please enter more than 6 characters';
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        _signIn(email, password);

                        // codeSent
                        //     ? AuthService()
                        //         .signInWithOTP(smsCode, verificationId, context)
                        //     : verifyPhone(phoneNo, context);
                      }
                    },
                    child: Text('Register'),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Spacer(),
                      Expanded(child: Text('already registered..')),
                      Expanded(
                        child: FlatButton(
                            color: Colors.white38,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0)),
                            onPressed: () => Get.off(Login()),
                            child: Text('Login')),
                      ),
                      Container()
                    ],
                  ),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: CheckboxListTile(
                            controlAffinity: ListTileControlAffinity
                                .leading, //  <-- leading Checkbox

                            title: Text(
                              "Remember me",
                              style: TextStyle(color: Colors.black),
                            ),
                            value: checkBoxValue,
                            onChanged: (bool val) {
                              print('bool val:, $checkBoxValue');
                              setState(() {
                                checkBoxValue = val;
                              });
                            }),
                      ),
                      // Flexible(child: Text('Remember'))
                    ],
                  ),
                )
                // codeSent
                //     ? Padding(
                //         padding: EdgeInsets.symmetric(vertical: 6.0),
                //         child: FlatButton(
                //           onPressed: () => verifyPhone(phoneNo, context),
                //           child: Text('resend OTP'),
                //         ),
                //       )
                //     : Container()
              ],
            ),
          ),
        ),
      ),
    );
  }

  _signIn(String emaily, String passwordy) async {
    final _auth = FirebaseAuth.instance;
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
          email: emaily, password: passwordy);
      if (newUser != null) {
        print('new User: ${newUser}');
        if (checkBoxValue) {
          SharedPreferences loginPrefs = await SharedPreferences.getInstance();
          if (loginPrefs.getString('email') != null &&
              loginPrefs.getString('password') != null) {
            loginPrefs.clear();
            loginPrefs.setString('email', '${emaily}');
            loginPrefs.setString('password', '$passwordy');
          } else {
            loginPrefs.setString('email', emaily);
            loginPrefs.setString('password', passwordy);
          }
        }
        // print('new User: ${newUser.user.updatePhoneNumber(PhoneAuthCredential)}');
        // const snapshot = await _auth.verifyPhoneNumber().on('state_changed', phoneAuthSnapshot => {
        // console.log('Snapshot state: ', phoneAuthSnapshot.state);
        //   FirebaseAuth.instance.verifyPhoneNumber(
        // phoneNumber: phoneNumber,
        // timeout: const Duration(minutes: 2),
        // verificationCompleted: (credential) async {
        //   await (await FirebaseAuth.instance.currentUser.).updatePhoneNumberCredential(credential);
        //   // either this occurs or the user needs to manually enter the SMS code
        // },
        // verificationFailed: null,
        // codeSent: (verificationId, [forceResendingToken]) async {
        //   String smsCode;
        //   // get the SMS code from the user somehow (probably using a text field)
        //   final AuthCredential credential =
        //     PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
        //  await FirebaseAuth.instance.currentUser.updatePhoneNumber(credential);
        // },
        // codeAutoRetrievalTimeout: null);

        Get.off(HomeCard());
      } else {}
    } catch (e) {}
  }

  // Future<void> verifyPhone(phoneNo, BuildContext context) async {
  //   final PhoneVerificationCompleted verified = (AuthCredential authResult) {
  //     AuthService().signIn(authResult, context);
  //   };

  //   final PhoneVerificationFailed verificationfailed =
  //       (FirebaseAuthException authException) {
  //     print('${authException.message}');
  //   };

  //   final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
  //     this.verificationId = verId;
  //     setState(() {
  //       this.codeSent = true;
  //     });
  //   };

  //   final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
  //     this.verificationId = verId;
  //   };

  //   await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: phoneNo,
  //       timeout: const Duration(seconds: 0),
  //       verificationCompleted: verified,
  //       verificationFailed: verificationfailed,
  //       codeSent: smsSent,
  //       codeAutoRetrievalTimeout: autoTimeout);
  // }
}
