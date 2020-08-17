import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Profile.dart';
import 'Settings.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SharedPreferences sharedPreferences;
  var _selectedIndex = 0;
  var selectedPage;
  var storage;
  var flatNo;
  var f;
  getInstance() async {
    storage = FlutterSecureStorage();
    flatNo = await storage.read(key: 'flat_no');
    setState(() {
      f = flatNo;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _selectedIndex = 0;
      selectedPage = HomePage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.blue[400],
        bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              if (index == 0) {
                setState(() {
                  selectedPage = HomePage();
                  _selectedIndex = 0;
                });
              } else if (index == 1) {
                setState(() {
                  selectedPage = Settings();
                  _selectedIndex = 1;
                });
              } else if (index == 2) {
                setState(() {
                  selectedPage = Profile();
                  _selectedIndex = 2;
                });
              }
            },
            currentIndex: _selectedIndex,
            elevation: 0.0,
            backgroundColor: Colors.blue[400],
            selectedItemColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                ),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.green,
                icon: Icon(Icons.home),
                title: Text('Profile'),
              ),
            ]),
        body: selectedPage,
      ),
    );
  }
}
