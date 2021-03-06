import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myhitha/components/homeCard.dart';
import 'package:myhitha/components/orders.dart';
import './drawerBody.dart';
import './drawerHeader.dart';
import '../auth/authservice.dart';
import 'package:get/get.dart';
import '../auth/login.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: Container(
        color: Colors.blue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            createDrawerHeader(),
            createDrawerBody(
                icon: Icons.home,
                text: 'Home',
                onTap: () => Get.to(HomeCard())),
            Divider(),
            createDrawerBody(
                icon: Icons.arrow_drop_down_circle,
                text: FirebaseAuth.instance.currentUser.isNull
                    ? 'Login'
                    : 'Logout',
                onTap: () => FirebaseAuth.instance.currentUser.isNull
                    ? Get.to(Login())
                    : AuthService().signOut()),
            Divider(),
            createDrawerBody(
                icon: Icons.account_circle,
                text: 'Orders',
                onTap: () => {
                      debugPrint(
                          'User:: ${FirebaseAuth.instance.currentUser.email}'),
                      FirebaseAuth.instance.currentUser != null
                          ? Get.to(
                              Orders(
                                  email:
                                      FirebaseAuth.instance.currentUser.email),
                              arguments: '${FirebaseAuth.instance.currentUser}')
                          : null
                    }),
          ],
        ),
      ),
    );
  }
}
