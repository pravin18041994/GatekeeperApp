import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../bloc/ChangePasswordBloc.dart';
import 'LoginPage.dart';

class ChangePasswordConfirmation extends StatefulWidget {
  final contact;
  ChangePasswordConfirmation(this.contact);
  @override
  _ChangePasswordConfirmationState createState() =>
      _ChangePasswordConfirmationState();
}

class _ChangePasswordConfirmationState
    extends State<ChangePasswordConfirmation> {
  var resp;
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var confirmPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var newPasswordErrorText = '';
  var confirmPasswordErrorText = '';
  var newPasswordErrorTextVisible = false;
  var confirmPasswordErrorTextVisible = false;
  onNewPasswordEntered() {
    setState(() {
      newPasswordErrorTextVisible = false;
    });
  }

  onConfirmPasswordEntered() {
    setState(() {
      confirmPasswordErrorTextVisible = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue[400],
        body: AlertDialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.80,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: Icon(
                          Icons.dashboard,
                          size: 200.0,
                        ),
                      ),
                      Container(
                        child: TextField(
                          cursorColor: Colors.black,
                          autocorrect: true,
                          obscureText: true,
                          onChanged: (val) {
                            onNewPasswordEntered();
                          },
                          controller: newPasswordController,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                          decoration: InputDecoration(
                            hintText: 'New Password',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.blue[400], width: 3),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: newPasswordErrorTextVisible,
                        child: Text(newPasswordErrorText,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              fontFamily: 'Raleway',
                            )),
                      ),
                      Container(
                        child: TextField(
                          cursorColor: Colors.black,
                          autocorrect: true,
                          obscureText: true,
                          onChanged: (val) {
                            onConfirmPasswordEntered();
                          },
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                            hintText: 'Confirm Password',
                            hintStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            filled: true,
                            fillColor: Colors.white70,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12.0)),
                              borderSide:
                                  BorderSide(color: Colors.blue[400], width: 3),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                                  BorderSide(color: Colors.black, width: 3),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: confirmPasswordErrorTextVisible,
                        child: Text(confirmPasswordErrorText,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14.0,
                              fontFamily: 'Raleway',
                            )),
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
                            if (newPasswordController.text.length == 0) {
                              setState(() {
                                newPasswordErrorTextVisible = true;
                                newPasswordErrorText =
                                    "This field is required !";
                              });
                              return;
                            }
                            if (confirmPasswordController.text.length == 0) {
                              setState(() {
                                confirmPasswordErrorTextVisible = true;
                                confirmPasswordErrorText =
                                    "This field is required !";
                              });
                              return;
                            }
                            if (newPasswordController.text ==
                                confirmPasswordController.text) {
                              changePasswordBloc.dialogLoader(context);
                              changePasswordBloc.contact.value = widget.contact;
                              changePasswordBloc.password.value =
                                  newPasswordController.text;
                              resp = await changePasswordBloc
                                  .changePasswordConfirmation();
                              if (resp == "success") {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (c, a1, a2) => LoginPage(),
                                    transitionsBuilder: (c, anim, a2, child) =>
                                        FadeTransition(
                                            opacity: anim, child: child),
                                    transitionDuration:
                                        Duration(milliseconds: 1200),
                                  ),
                                );
                              } else {
                                Navigator.pop(context);
                                _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text('Please try again later !'),
                                  duration: Duration(seconds: 3),
                                ));
                                return;
                              }
                            } else {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                content: Text('Passwords doesn\'t match !',style: TextStyle(
                                  fontFamily: 'Raleway',
                                ),),
                                duration: Duration(seconds: 3),
                              ));
                              return;
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
