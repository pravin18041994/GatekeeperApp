import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bloc/ChangePasswordBloc.dart';
import 'ChangePasswordEnterOTP.dart';

class ChangePasswordEnterContact extends StatefulWidget {
  @override
  _ChangePasswordEnterContactState createState() => _ChangePasswordEnterContactState();
}

class _ChangePasswordEnterContactState extends State<ChangePasswordEnterContact> {
  var resp;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var contactController = TextEditingController();  
  var contactErrorText;
  var contactErrorTextVisible = false;
  onContactEntered()
  {
    setState(() {
      contactErrorTextVisible = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();    
  }
  @override
  Widget build(BuildContext context) {
    return 
    Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.blue[400],
      body: 
      AlertDialog(
      elevation: 0.0,
      
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Container(
          height: MediaQuery.of(context).size.height*0.70,          
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height*0.70, 
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,          
                  children: <Widget>[
                    Container( 
                      child: Icon(Icons.dashboard,size: 200.0,),
                    ),
                Container(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: contactController,
                    onChanged: (val){
                      onContactEntered();
                    },
                    autocorrect: true,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10),
                    ],
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                    decoration: InputDecoration(
                      hintText: 'Contact',
                      hintStyle:
                TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
              borderSide: BorderSide(color: Colors.blue[400], width: 3),
                      ),
                      focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              borderSide: BorderSide(color: Colors.black, width: 3),
                      ),
                    ),
                  ),
                ),
                Visibility( 
                  visible: contactErrorTextVisible,
                  child: Text(contactErrorText.toString(),style: TextStyle(color: Colors.red,fontSize: 14.0,fontFamily: 'Raleway',)),
                ),
                Container(
                  child: RaisedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    color: Colors.blue[400],
                    textColor: Colors.white,
                    onPressed: () async {
                      if(contactController.text.length == 0)
                      {
                          setState(() {
                            contactErrorTextVisible = true;
                            contactErrorText = "This field is required !";
                          });
                          return;
                      }
                        changePasswordBloc.contact.value = contactController.text;
                        changePasswordBloc.dialogLoader(context);
                        resp = await changePasswordBloc.changePasswordGetContact();
                        if(resp == "success")
                        {
                          Navigator.pop(context);
                           Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => ChangePasswordEnterOTP(contactController.text),
                                transitionsBuilder: (c, anim, a2, child) => FadeTransition(opacity: anim, child: child),
                                transitionDuration: Duration(milliseconds: 1200),
                              ),
                            );
                        }
                        else 
                        {
                          Navigator.pop(context);
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text('Contact not valid !'),
                              duration: Duration(seconds: 3),
                            ));
                         
                        }                                         
                    },
                  ),
                )
                  ],
                ),
            ),
          ],
        ),
      ),
    )
      
    );
  }
}