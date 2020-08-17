import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../repository/Repository.dart';

class LoginBloc 
{
  Repository repository = Repository();
  final contact = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();
  Function(String) get getContact => contact.sink.add;
  Function(String) get getPassword => password.sink.add;
  
   checkLogin()
  {
    Future<String> resp;  
    resp = repository.checkLogin(contact.value, password.value);
    return resp;
    
  }

  dispose() 
  {
    contact.close();
    password.close();
  }
  dialogLoader(context)
  {
                 
          AlertDialog alert = AlertDialog(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            content: Container(child: Row(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[CircularProgressIndicator(backgroundColor: Colors.blueAccent,)],)),
            
          );

          // show the dialog
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(onWillPop: (){
                return null;
              },child: alert,);
            },
          );        
  }
}
final loginBloc = LoginBloc();