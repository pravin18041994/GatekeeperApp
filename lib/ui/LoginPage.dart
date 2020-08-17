import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../bloc/LoginBloc.dart';
import 'ChangePasswordEnterContact.dart';
import 'MainPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var contactController = TextEditingController();
  var passwordController = TextEditingController();
  var contactErrorTextVisible = false;
  var passwordErrorTextVisible = false;
  var contactErrorText;
  var passwordErrorText;
  onContactEntered() {
    setState(() {
      contactErrorTextVisible = false;
    });
  }

  onPasswordEntered() {
    setState(() {
      passwordErrorTextVisible = false;
    });
  }

  var resp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return null;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.blue[400],
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.95,
            width: MediaQuery.of(context).size.width * 0.9,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0)),
                  color: Colors.white,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.90,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Icon(
                                Icons.dashboard,
                                size: 200.0,
                              ),
                              // child: Text(
                              //   'Login',
                              //   style: TextStyle(
                              //       color: Colors.black,
                              //       fontSize: 25.0,
                              //       fontWeight: FontWeight.bold),
                              // ),
                            )
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: TextField(
                            onChanged: (val) {
                              onContactEntered();
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            cursorColor: Colors.black,
                            autocorrect: true,
                            controller: contactController,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Contact',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(
                                    color: Colors.blue[400], width: 3),
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
                          visible: contactErrorTextVisible,
                          child: Text(contactErrorText.toString(),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                                fontFamily: 'Raleway',
                              )),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15.0, right: 15.0),
                          child: TextField(
                            cursorColor: Colors.black,
                            autocorrect: true,
                            controller: passwordController,
                            obscureText: true,
                            onChanged: (val) {
                              onPasswordEntered();
                            },
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              fillColor: Colors.white70,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12.0)),
                                borderSide: BorderSide(
                                    color: Colors.blue[400], width: 3),
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
                          visible: passwordErrorTextVisible,
                          child: Text(passwordErrorText.toString(),
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0,
                                fontFamily: 'Raleway',
                              )),
                        ),
                        RaisedButton(
                          child: Text(
                            'Login',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          color: Colors.blue[400],
                          textColor: Colors.white,
                          onPressed: () async {
                            if (contactController.text.length == 0) {
                              setState(() {
                                contactErrorTextVisible = true;
                                contactErrorText = "This field is required !";
                              });
                              return;
                            }
                            if (passwordController.text.length == 0) {
                              setState(() {
                                passwordErrorTextVisible = true;
                                passwordErrorText = "This field is required !";
                              });
                              return;
                            }
                            loginBloc.dialogLoader(context);
                            loginBloc.contact.value = contactController.text;
                            loginBloc.password.value = passwordController.text;
                            resp = await loginBloc.checkLogin();
                            if (resp == "success") {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (c, a1, a2) => MainPage(),
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
                                content: Text(resp.toString(),
                                    style: TextStyle(fontFamily: 'Raleway')),
                                duration: Duration(seconds: 3),
                              ));
                            }
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (c, a1, a2) =>
                                          ChangePasswordEnterContact(),
                                      transitionsBuilder:
                                          (c, anim, a2, child) =>
                                              FadeTransition(
                                                  opacity: anim, child: child),
                                      transitionDuration:
                                          Duration(milliseconds: 1200),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: InkWell(
                                onTap: () {},
                                child: Text(
                                  'Powered By   => ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
