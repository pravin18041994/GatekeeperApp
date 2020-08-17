import 'package:flutter/material.dart';

class WalkthroughPage2 extends StatefulWidget {
  @override
  _WalkthroughPage2State createState() => _WalkthroughPage2State();
}

class _WalkthroughPage2State extends State<WalkthroughPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[400],
      body: Center( 
        child: Container(
          child: Text('Page 2',style: TextStyle(color: Colors.white,fontSize: 24.0),),
        ),
      ),
      
    );
  }
}