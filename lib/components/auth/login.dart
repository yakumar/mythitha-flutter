import 'package:flutter/material.dart';
import '../../utilities/sizes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './authservice.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  // @override
  // void dispose() {
  //   //profileBloc.dispose() cannot call as ProfileBloc class doesn't have dispose method
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  "MyHitha Login",
                  style: TextStyle(fontSize: 25.0, color: Colors.lime),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                        child: Text(
                      '+91',
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    )),
                    Flexible(
                      child: Container(
                        width: 1.0,
                        margin: EdgeInsets.symmetric(horizontal: 3.0),
                      ),
                    ),
                    Flexible(
                      child: TextFormField(
                        decoration: InputDecoration(
                          // contentPadding: EdgeInsets.only(top: 0.01),
                          helperText: 'Enter Mobile',
                        ),
                        textAlignVertical: TextAlignVertical.bottom,
                        keyboardType: TextInputType.phone,
                        onSaved: (val) => phoneNo = '+91${val}',

                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter Phone';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                codeSent
                    ? Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: displayWidth(context) / 6),
                        child: TextFormField(
                          decoration: InputDecoration(
                            helperText: 'Enter OTP',
                          ),
                          keyboardType: TextInputType.phone,
                          onSaved: (val) => smsCode = val,

                          // The validator receives the text that the user has entered.
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter OTP';
                            }
                            return null;
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();

                        codeSent
                            ? AuthService()
                                .signInWithOTP(smsCode, verificationId, context)
                            : verifyPhone(phoneNo, context);
                      }
                    },
                    child: codeSent ? Text('Login') : Text('Generate OTP'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> verifyPhone(phoneNo, BuildContext context) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult, context);
    };

    final PhoneVerificationFailed verificationfailed =
        (FirebaseAuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 0),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
