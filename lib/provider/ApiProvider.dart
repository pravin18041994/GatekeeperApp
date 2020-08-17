import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:society_gatekeeper/models/FlatsModel.dart';
import 'dart:convert';
import '../utilities/Constants.dart';

class ApiProvider {
  //Login Api
  Future<String> checkLogin(contact, password) async {
    var storage = FlutterSecureStorage();
    http.Response response = await http.post(
        Constants.BASE_URL + 'gatekeepers/login',
        body: {'contact': contact, 'password': password});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        await storage.write(key: "token", value: decodedResponse['token']);
        return 'success';
      } else {
        return decodedResponse['msg'];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  //Change Password ( Get Contact ) API
  Future<String> changePasswordGetContact(var contact) async {
    print(contact);
    http.Response response = await http.post(
        Constants.BASE_URL + 'gatekeepers/get_contact_update_password',
        body: {
          'contact': contact,
        });
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return 'success';
      } else {
        return decodedResponse['msg'];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  //Change Password ( Verify OTP ) API
  Future<String> changePasswordVerifyOTP(var contact, var otp) async {
    print(contact);
    print(otp);
    http.Response response = await http.post(
        Constants.BASE_URL + 'gatekeepers/verify_otp_update_password',
        body: {'contact': contact, 'otp': otp});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return 'success';
      } else {
        return decodedResponse['msg'];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  //Confirm Password API
  Future<String> changePasswordConfirmation(var contact, var password) async {
    print(contact);
    http.Response response = await http.post(
        Constants.BASE_URL + 'gatekeepers/update_password',
        body: {'contact': contact, 'password': password});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return 'success';
      } else {
        return decodedResponse['msg'];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  Future<FlatsModel> getFlats() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    http.Response response = await http.get(
        Constants.BASE_URL + 'societies/get_flats',
        headers: {'Authorization': 'Bearer ' + token});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      var flatsModelData = FlatsModel.fromJSON(decodedResponse);
      print(flatsModelData.data);
      if (decodedResponse['state'] == 'success') {
        return flatsModelData;
      } else {
        // return decodedResponse['msg'];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  Future<String> addVisitorDetails(
      var flatNumber, var resName, var vehNumber, var noOfPersons) async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    http.Response response =
        await http.post(Constants.BASE_URL + 'gatekeepers/add_visitor', body: {
      'flatNumber': flatNumber,
      'user_name': resName,
      'flag': 'gatekeeper',
      'vehicle_no': vehNumber,
      'no_of_persons': noOfPersons
    }, headers: {
      'Authorization': 'Bearer ' + token
    });
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return 'success';
      } else {
        return 'fail';
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  Future<List> getVisitorDetails() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    http.Response response = await http.get(
        Constants.BASE_URL + 'visitors/get_visitors',
        headers: {'Authorization': 'Bearer ' + token});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return decodedResponse['data'];
      } else {
        return [];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  // Future<String> addParcelDetails(
  //     user, delivery_agency, delivery_contact) async {
  //   var storage = FlutterSecureStorage();
  //   var token = await storage.read(key: 'token');
  //   http.Response response = await http.post(Constants.BASE_URL + '', body: {
  //     'user': user,
  //     'delivery_agency': delivery_agency,
  //     'delivery_contact': delivery_contact
  //   }, headers: {
  //     'Authorization': 'Bearer ' + token
  //   });
  //   print(response.body);
  //   if (response.statusCode == 200) {
  //     var decodedResponse = json.decode(response.body);
  //     if (decodedResponse['state'] == 'success') {
  //       return 'success';
  //     } else {
  //       return decodedResponse['msg'];
  //     }
  //   } else {
  //     throw Exception('Cannot perform the operation !');
  //   }
  // }

  Future<String> addParcelDetails(flatNumber, userName, image,
      deliveryAgencyName, deliveryAgentContact) async {
    print(flatNumber.toString() +
        userName.toString() +
        image.toString() +
        deliveryAgencyName.toString() +
        deliveryAgentContact.toString());
    var request = http.MultipartRequest(
        "POST", Uri.parse(Constants.BASE_URL + 'parcels/add_parcel'));
    //add text fields
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    request.fields["flat_number"] = flatNumber;
    request.fields["user_name"] = userName;
    request.fields["delivery_agency"] = deliveryAgencyName;
    request.fields["delivery_contact"] = deliveryAgentContact;
    request.headers['Authorization'] = 'Bearer ' + token;

    //create multipart using filepath, string or bytes
    var pic = await http.MultipartFile.fromPath("image", image.path);
    //add multipart to request
    request.files.add(pic);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print(responseString);
    if (json.decode(responseString)['state'] == 'success') {
      return 'success';
    } else {
      return 'fail';
    }
  }

  Future<List> getParcelDetails() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    http.Response response = await http.get(
        Constants.BASE_URL + 'parcels/get_parcels',
        headers: {'Authorization': 'Bearer ' + token});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return decodedResponse['data'];
      } else {
        return [];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  Future<List> getUsers() async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    http.Response response = await http.get(
        Constants.BASE_URL + 'gatekeepers/get_users',
        headers: {'Authorization': 'Bearer ' + token});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return decodedResponse['data'];
      } else {
        return [];
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }

  Future<String> verifyVisitor(var otp, var id) async {
    var storage = FlutterSecureStorage();
    var token = await storage.read(key: 'token');
    http.Response response = await http.post(
        Constants.BASE_URL + 'gatekeepers/verify_visitor',
        body: {'otp': otp, 'id': id},
        headers: {'Authorization': 'Bearer ' + token});
    print(response.body);
    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      if (decodedResponse['state'] == 'success') {
        return 'success';
      } else {
        return 'fail';
      }
    } else {
      throw Exception('Cannot perform the operation !');
    }
  }
}
