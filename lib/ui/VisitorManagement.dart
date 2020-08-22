import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:society_gatekeeper/bloc/VisitorManagementBloc.dart';
import 'package:society_gatekeeper/models/FlatsModel.dart';
import 'package:society_gatekeeper/provider/ApiProvider.dart';

class VisitorManagement extends StatefulWidget {
  @override
  _VisitorManagementState createState() => _VisitorManagementState();
}

class _VisitorManagementState extends State<VisitorManagement> {
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode nodeTodayButton = FocusNode();
  final FocusNode nodeflatDropdownValue = FocusNode();
  final FocusNode nodeUserName = FocusNode();
  final FocusNode nodeUserVehicleDetails = FocusNode();
  final FocusNode nodeSubmitButton = FocusNode();
  final FocusNode nodeNumberOfPersons = FocusNode();
  var resp;

  TextEditingController dateController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userVehicleDetails = TextEditingController();
  TextEditingController numberOfPersonsController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _submitDetailsKey = GlobalKey<FormState>();
  var flatDropdownValue;
  List<String> flats;
  List visitorsList = [];
  List visitorsList2 = [];
  DateTime d;
  FlatsModel flatsModel;
  var isLoading;
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    flats = [];
    isLoading = true;
    getFlats();
    getVisitor();
  }

  // addVisitor() async
  // {
  //   ApiProvider apiProvider = ApiProvider();
  //   visitors = await apiProvider.addVisitorDetails();
  // }

  getVisitor() async {
    ApiProvider apiProvider = ApiProvider();
    visitorsList2 = await apiProvider.getVisitorDetails();
    setState(() {
      visitorsList = visitorsList2;
    });
  }

  getFlats() async {
    flatsModel = await visitorManagementBloc.getFlats();
    setState(() {
      isLoading = false;
    });
    print(flatsModel.data.runtimeType);
    for (var i in flatsModel.data) {
      flats.add(i);
    }
  }

  void otpDialog(var id, var index) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black)),
          title: StatefulBuilder(
            builder: (ctx, setState) {
              return Column(
                children: <Widget>[
                  TextField(
                    onChanged: visitorManagementBloc.getOtp,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4)
                    ],
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Enter otp",
                        labelStyle: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(color: Colors.black)),
                          color: Colors.white,
                          elevation: 5.0,
                          child: Text(
                            "Check",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () async {
                            dialogLoader(context);
                            visitorManagementBloc.id.value = id;
                            resp = await visitorManagementBloc.verifyVisitor();
                            if (resp == 'success') {
                              Navigator.pop(context);
                              Navigator.pop(context);

                              setState(() {
                                visitorsList[index]['verified'] = true;
                              });
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                      content: new Text(
                                          "Verified successfully !",
                                          style: TextStyle(
                                              fontFamily: 'Raleway'))));
                            } else {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              _scaffoldKey.currentState.showSnackBar(
                                  new SnackBar(
                                      content: new Text("Incorrect otp !",
                                          style: TextStyle(
                                              fontFamily: 'Raleway'))));
                            }
                          }),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black)),
                        color: Colors.white,
                        elevation: 5.0,
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }

  dialogLoader(context) {
    AlertDialog alert = AlertDialog(
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            backgroundColor: Colors.blueAccent,
          )
        ],
      )),
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<Null> getRefresh() async {
    getVisitor();
    // getComplaints();
    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            backgroundColor: Colors.blue[400],
            centerTitle: true,
            elevation: 0.0,
            bottom: TabBar(
              indicatorColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(Icons.directions_car),
                  text: "Visitor Information",
                ),
                Tab(
                  icon: Icon(Icons.directions_transit),
                  text: "Details",
                ),
              ],
            ),
            title: Text('Visitor  Management',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
          ),
          body: TabBarView(children: [
            isLoading == true
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.blue[400],
                    ),
                  )
                : ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            children: <Widget>[
                              Form(
                                key: _submitDetailsKey,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.75,
                                  child: Card(
                                    color: Colors.blue,
                                    margin: EdgeInsets.fromLTRB(
                                        10.0, 15.0, 10.0, 10.0),
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color:
                                                Colors.blue.withOpacity(1.0)),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    child: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.60,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              ListTile(
                                                title: DropdownButton<String>(
                                                  dropdownColor: Colors.blue,
                                                  focusColor: Colors.white,
                                                  focusNode:
                                                      nodeflatDropdownValue,
                                                  value: flatDropdownValue,
                                                  icon: Icon(
                                                    Icons.arrow_downward,
                                                    color: Colors.green,
                                                  ),
                                                  iconSize: 0.0,
                                                  elevation: 16,
                                                  hint: Text(
                                                    "Flat Number",
                                                    style: TextStyle(
                                                        fontFamily: 'Raleway',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.white,
                                                  ),
                                                  onChanged:
                                                      (String newValue) async {
                                                    var users = json.decode(
                                                        await storage.read(
                                                            key: 'users'));
                                                    setState(() {
                                                      for (var i in users) {
                                                        print(i);
                                                        if (i['flat_no'] ==
                                                            newValue) {
                                                          print('object');
                                                          visitorManagementBloc
                                                                  .residentName
                                                                  .value =
                                                              i['_id']
                                                                  .toString();
                                                          print(i['_id']);
                                                        }
                                                      }
                                                      flatDropdownValue =
                                                          newValue;
                                                    });
                                                  },
                                                  items: flats.map<
                                                          DropdownMenuItem<
                                                              String>>(
                                                      (String value) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: value,
                                                      child: Text(
                                                        value,
                                                        style: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            color: Colors.white,
                                                            fontFamily:
                                                                'Raleway',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 15.0),
                                                      ),
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              ListTile(
                                                title: TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  cursorColor: Colors.white,
                                                  onChanged:
                                                      visitorManagementBloc
                                                          .getVehicleNumber,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Vehicle Details';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      userVehicleDetails,
                                                  focusNode:
                                                      nodeUserVehicleDetails,
                                                  decoration: InputDecoration(
                                                    labelText: "Vehicle Number",
                                                    labelStyle: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                    focusedBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                    enabledBorder:
                                                        UnderlineInputBorder(
                                                            borderSide:
                                                                BorderSide(
                                                                    color: Colors
                                                                        .white)),
                                                  ),
                                                ),
                                              ),
                                              ListTile(
                                                title: TextFormField(
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  cursorColor: Colors.white,
                                                  onChanged:
                                                      visitorManagementBloc
                                                          .getNoOfPersons,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please enter details';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      numberOfPersonsController,
                                                  focusNode:
                                                      nodeNumberOfPersons,
                                                  decoration: InputDecoration(
                                                      labelText:
                                                          "Number Of Persons",
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white),
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white)),
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                              borderSide: BorderSide(
                                                                  color: Colors
                                                                      .white))),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              margin: const EdgeInsets.only(
                                                  top: 10.0, bottom: 10.0),
                                              child: RaisedButton(
                                                focusNode: nodeSubmitButton,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(18.0),
                                                    side: BorderSide(
                                                        color: Colors.white,
                                                        width: 2.0)),
                                                color: Colors.white,
                                                child: Text(
                                                  "Submit",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blue,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (_submitDetailsKey
                                                      .currentState
                                                      .validate()) {
                                                    dialogLoader(context);
                                                    visitorManagementBloc
                                                            .flatNumber.value =
                                                        flatDropdownValue;
                                                    resp =
                                                        await visitorManagementBloc
                                                            .addVisitorDetails();
                                                    if (resp == 'success') {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              nodeSubmitButton);
                                                      Navigator.pop(context);
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(new SnackBar(
                                                              content: new Text(
                                                                  "Added successfully !",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Raleway'))));
                                                      userVehicleDetails
                                                          .clear();
                                                      numberOfPersonsController
                                                          .clear();
                                                    } else {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              nodeSubmitButton);
                                                      Navigator.pop(context);
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(new SnackBar(
                                                              content: new Text(
                                                                  "Cannot add now !",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Raleway'))));
                                                    }
                                                    // checkInternetConnection();
                                                    // if (_addFormKey.currentState.validate()) {
                                                    //   checkAddDetails();
                                                    // } else {}

                                                  } else {}
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),

            //Show Details
            ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: <Widget>[
                        //     SizedBox(
                        //       width: 125.0,
                        //       child: TextField(
                        //         focusNode: dateFocusNode,
                        //         controller: dateController,
                        //         onTap: () async {
                        //           d = await visitorManagementBloc
                        //               .showDateTimePicker(context);
                        //         },
                        //         decoration: InputDecoration(
                        //             hintText: "Select Date",
                        //             hintStyle: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               color: Colors.blue[400],
                        //             ),
                        //             focusedBorder: UnderlineInputBorder(
                        //                 borderSide: BorderSide(
                        //                     color: Colors.blue[400]))),
                        //       ),
                        //     ),
                        //     Container(
                        //       child: RaisedButton(
                        //         focusNode: nodeTodayButton,
                        //         color: Colors.blue[400],
                        //         child: Text(
                        //           "Today",
                        //           style: TextStyle(
                        //             color: Colors.white,
                        //           ),
                        //         ),
                        //         onPressed: () {
                        //           print(DateTime.now());
                        //           dateController.text =
                        //               DateTime.now().toString().split(' ')[0];
                        //           // getOrders(
                        //           //     DateTime.now().toString().split(' ')[0]);
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        // Divider(
                        //   color: Colors.blue,
                        //   thickness: 2.0,
                        // ),
                        RefreshIndicator(
                          onRefresh: getRefresh,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.77,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: visitorsList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (visitorsList[index]['flag'] ==
                                              'gatekeeper') {
                                            return null;
                                          }
                                          if (visitorsList[index]['verified'] ==
                                              false) {
                                            otpDialog(
                                                visitorsList[index]['_id'],
                                                index);
                                          } else {
                                            return null;
                                          }
                                        },
                                        child: Card(
                                          color: visitorsList[index]['flag'] ==
                                                  "gatekeeper"
                                              ? Colors.blue[400]
                                              : visitorsList[index]
                                                          ['verified'] ==
                                                      true
                                                  ? Colors.green
                                                  : Colors.red,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "Flat Number :",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      visitorsList[index]
                                                                  ['user']
                                                              ['flat_no']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "Name :",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      visitorsList[index]
                                                                  ['name'] ==
                                                              null
                                                          ? "-"
                                                          : visitorsList[index]
                                                                  ['name']
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "Contact no :",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      visitorsList[index]
                                                                  ['contact'] ==
                                                              null
                                                          ? "-"
                                                          : visitorsList[index]
                                                                  ['contact']
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "No of persons :",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      visitorsList[index]
                                                              ['no_of_persons']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "Date :",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      visitorsList[index]
                                                              ['date']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "Time : ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      visitorsList[index]
                                                              ['time']
                                                          .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 10),
                                                    child: Text(
                                                      "OTP : ",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Text(
                                                      visitorsList[index]
                                                                  ['otp'] ==
                                                              null
                                                          ? "-"
                                                          : visitorsList[index]
                                                                  ['otp']
                                                              .toString(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
