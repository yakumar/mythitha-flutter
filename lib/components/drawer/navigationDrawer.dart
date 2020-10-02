import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myhitha/components/homeCard.dart';
import 'package:myhitha/components/orders.dart';
import './drawerBody.dart';
import './drawerHeader.dart';
import '../auth/authservice.dart';
import 'package:get/get.dart';

class NavigationDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
            // Divider(),
            // createDrawerBody(
            //     icon: Icons.arrow_drop_down_circle,
            //     text: AuthService().checkAuth() == true ? 'Login' : 'Logout',
            //     onTap: () => null),
            Divider(),
            createDrawerBody(
                icon: Icons.shopping_basket,
                text: 'Orders',
                onTap: () => {
                      debugPrint(
                          'User:: ${FirebaseAuth.instance.currentUser.phoneNumber}'),
                      FirebaseAuth.instance.currentUser != null
                          ? Get.to(
                              Orders(
                                  phone: FirebaseAuth
                                      .instance.currentUser.phoneNumber),
                              arguments: '${FirebaseAuth.instance.currentUser}')
                          : null
                    }),
          ],
        ),
      ),
    );
  }
}
