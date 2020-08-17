import 'package:flutter/material.dart';

class WalkthroughPage1 extends StatefulWidget {
  @override
  _WalkthroughPage1State createState() => _WalkthroughPage1State();
}

class _WalkthroughPage1State extends State<WalkthroughPage1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Center( 
        child: Container(
          child: Text('Page 1',style: TextStyle(color: Colors.white,fontSize: 24.0),),
        ),
      ),
      
    );
  }
}