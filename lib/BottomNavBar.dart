import 'package:collegeproject/Screens/AddSmartDevice.dart';
import 'package:collegeproject/Screens/HomePage.dart';
import 'package:collegeproject/Screens/SettingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class MyNavBar extends StatefulWidget {
  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar> {
  //
  final user = FirebaseAuth.instance.currentUser;

  int _currentIndex = 0;
  final List<Widget> _children = [
    HomePage(),
    AddSmartDevice(),
    SettingsPage(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: SizedBox(
          height: 100.0,
          child: BottomNavigationBar(
            elevation: 0.0,
            selectedItemColor: Colors.redAccent,
            unselectedItemColor: Colors.grey,
            onTap: onTappedBar,
            currentIndex: _currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(left: 60.0),
                  child: Icon(Feather.home),
                ),
                title: Text(
                  "",
                  style: TextStyle(height: 0.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.purple[900],
                  ),
                  child: Center(
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
                title: Text(
                  "",
                  style: TextStyle(height: 0.0),
                ),
              ),
              BottomNavigationBarItem(
                icon: Padding(
                    padding: const EdgeInsets.only(right: 60.0),
                    child: Icon(FontAwesome.user_o)),
                title: Text(
                  "",
                  style: TextStyle(height: 0.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
