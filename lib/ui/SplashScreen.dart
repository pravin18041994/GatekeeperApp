import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:society_gatekeeper/provider/ApiProvider.dart';
import 'package:society_gatekeeper/ui/HomePage.dart';
import 'package:society_gatekeeper/ui/LoginPage.dart';
import 'package:society_gatekeeper/ui/MainPage.dart';

import 'Walkthrough.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var storage;
  var screenName;
  var token;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    storage = FlutterSecureStorage();
    getToken();
    
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        if (token != null) {
          getUsers();
          screenName = MainPage();
        } else {
          screenName = LoginPage();
        }
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (c, a1, a2) => screenName,
            transitionsBuilder: (c, anim, a2, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: Duration(milliseconds: 1200),
          ),
        );
      });
    });
  }

  getUsers() async {
    ApiProvider apiProvider = ApiProvider();
    List users2 = [];
    users2 = await apiProvider.getUsers();
    await storage.write(key: 'users', value: json.encode(users2));
  }

  getToken() async {
    token = await storage.read(key: "token");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x017),
      body: Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Image.asset(
            'assets/icons/internetofthings1.png',
            height: 200.0,
            width: 200.0,
            repeat: ImageRepeat.noRepeat,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Smart Society',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0),
              )
            ],
          )
        ],
      )),
    );
  }
}
