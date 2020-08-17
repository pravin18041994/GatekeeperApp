
import 'package:flutter/material.dart';
import 'package:society_gatekeeper/ui/LoginPage.dart';

import 'MainPage.dart';

class WalkthroughPage3 extends StatefulWidget {
  @override
  _WalkthroughPage3State createState() => _WalkthroughPage3State();
}

class _WalkthroughPage3State extends State<WalkthroughPage3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Center( 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              child: Text('Page 3',style: TextStyle(color: Colors.white,fontSize: 24.0),),
            ),
            Container( 
              child: RaisedButton( 
                onPressed: (){
                    Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          LoginPage(),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 1200),
                                    ),
                                  );
                },
                color: Colors.white,
                child: Text('Get Started !',style: TextStyle(color: Colors.blue[400],fontSize: 18.0,fontWeight: FontWeight.bold),),
              ),
            )
          ],
        ),
      ),
      
    );
  }
}