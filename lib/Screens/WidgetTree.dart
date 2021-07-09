import 'package:collegeproject/BottomNavBar.dart';
import 'package:collegeproject/Screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WidgetTree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    if (user == null) {
      return LoginScreen();
    }
    return MyNavBar();
  }
}
