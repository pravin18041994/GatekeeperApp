import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/ChangePasswordBloc.dart';
import 'ChangePasswordConfirmation.dart';

class ChangePasswordEnterOTP extends StatefulWidget {
  final contact;
  ChangePasswordEnterOTP(this.contact);
  @override
  _ChangePasswordEnterOTPState createState() => _ChangePasswordEnterOTPState();
}

class _ChangePasswordEnterOTPState extends State<ChangePasswordEnterOTP> {
  var resp;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var otpController = TextEditingController();
  var otpErrorText;
  var otpErrorTextVisible = false;
  onOTPEntered()
  {
    setState(() {
      otpErrorTextVisible = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
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
                    autocorrect: true,
                    onChanged: (val){
                      onOTPEntered();
                    },
                    controller: otpController,
                    inputFormatters: [                      
                      LengthLimitingTextInputFormatter(4),
                    ],
                    style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold
                            ),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'OTP',
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
                  visible: otpErrorTextVisible,
                  child: Text(otpErrorText.toString(),style: TextStyle(color: Colors.red,fontSize: 14.0,fontFamily: 'Raleway',)),
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
                      if(otpController.text.length == 0)
                      {
                        setState(() {
                          otpErrorTextVisible = true;
                          otpErrorText = "This field is required !";
                        });
                        return;
                      }
                      changePasswordBloc.otp.value = otpController.text;
                      changePasswordBloc.dialogLoader(context);
                      resp = await changePasswordBloc.changePasswordVerifyOTP();
                      if(resp == "success")
                      {
                        Navigator.pop(context);
                        Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => ChangePasswordConfirmation(widget.contact),
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
                              content: Text('Incorrect OTP !'),
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
  
         ));
  }
}