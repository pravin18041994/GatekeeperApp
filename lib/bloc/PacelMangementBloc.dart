import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:society_gatekeeper/provider/ApiProvider.dart';
import 'package:society_gatekeeper/repository/Repository.dart';

class ParcelManagementBloc {
  Repository repository = Repository();

  final flatNumber = BehaviorSubject<String>();
  final userName = BehaviorSubject<String>();
  final deliveryAgencyName = BehaviorSubject<String>();
  final deliveryAgentContact = BehaviorSubject<String>();
  final image = BehaviorSubject<File>();

  Function(String) get getFlatNumber => flatNumber.sink.add;
  Function(String) get getUserName => userName.sink.add;
  Function(File) get getImage => image.sink.add;
  Function(String) get getDeiveyAgencyName => deliveryAgencyName.sink.add;
  Function(String) get getDeliveyAgentContact => deliveryAgentContact.sink.add;

  addParcelDetails() {
    return repository.addParcelDetails(flatNumber.value, userName.value,
        image.value, deliveryAgencyName.value, deliveryAgentContact.value);
  }

  getParcelDetails() {
    return repository.getParcelDetails();
  }

  dispose() {
    flatNumber.close();
    userName.close();
    image.close();
    deliveryAgencyName.close();
    deliveryAgentContact.close();
  }

  Future<DateTime> showDateTimePicker(BuildContext context2) async {
    DateTime d = await showDatePicker(
      context: context2,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    return d;
    // if (d != null && d != selectedDate) {
    //   // openDialog();
    //   setState(() {
    //     print(d);
    //     var finalDate = d.toLocal().toString().split(' ');
    //     sdo = finalDate[0];
    //     dateController.text = finalDate[0];
    //     // getOrders(finalDate[0]);
    //     // Navigator.pop(context);
    //   });
    // }
  }

  getFlats() async {
    ApiProvider apiProvider = new ApiProvider();
    return await apiProvider.getFlats();
  }
}

final parcelManagementBloc = ParcelManagementBloc();
