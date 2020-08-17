import '../provider/ApiProvider.dart';

class Repository {
  ApiProvider apiProvider = ApiProvider();

  //Login
  // Future<String> checkLogin(var contact,var password) => apiProvider.checkLogin(contact, password);
  //Change Password Get Contact
  Future<String> changePasswordGetContact(var contact) =>
      apiProvider.changePasswordGetContact(contact);
  //Change Password Verify OTP
  Future<String> changePasswordVerifyOTP(var contact, var otp) =>
      apiProvider.changePasswordVerifyOTP(contact, otp);
  //Change Password Confirmation
  Future<String> changePasswordConfirmation(var contact, var password) =>
      apiProvider.changePasswordConfirmation(contact, password);
  //Login
  Future<String> checkLogin(var contact, var password) =>
      apiProvider.checkLogin(contact, password);

  //visitor details

  Future<String> addVisitorDetail(var flatNumber, var residentName,
          var vehicleNumber, var noOfPersons) =>
      apiProvider.addVisitorDetails(
          flatNumber, residentName, vehicleNumber, noOfPersons);

  Future<List> getVisitorDetails() => apiProvider.getVisitorDetails();

  Future<String> addParcelDetails(var flatNumber, var userName, var image,
          var deliveryAgencyName, var deliveryAgentContact) =>
      apiProvider.addParcelDetails(flatNumber, userName, image,
          deliveryAgencyName, deliveryAgentContact);

  Future<List> getParcelDetails() => apiProvider.getParcelDetails();
  Future<String> verifyVisitor(var otp, var id) =>
      apiProvider.verifyVisitor(otp, id);
}
