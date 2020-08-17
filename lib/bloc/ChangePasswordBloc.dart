import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import '../repository/Repository.dart';

class ChangePasswordBloc 
{
  Repository repository = Repository();
  final contact = BehaviorSubject<String>();
  final otp = BehaviorSubject<String>();
  final password = BehaviorSubject<String>();
  Function(String) get getContact => contact.sink.add;
  Function(String) get getPassword => password.sink.add;
  Function(String) get getOTP => otp.sink.add;
  
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
  changePasswordGetContact()
  {
    Future<String> resp;
    resp = repository.changePasswordGetContact(contact.value);
    return resp;
  }
  changePasswordVerifyOTP()
  {
    Future<String> resp;
    resp = repository.changePasswordVerifyOTP(contact.value, otp.value);
    return resp;
  }
  changePasswordConfirmation()
  {
    Future<String> resp;
    resp = repository.changePasswordConfirmation(contact.value, password.value);
    return resp;
  }
  dispose() 
  {
    contact.close();
    otp.close();
    password.close();
  }
  
}
final changePasswordBloc = ChangePasswordBloc();