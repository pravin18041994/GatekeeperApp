import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:society_gatekeeper/bloc/PacelMangementBloc.dart';
import 'package:society_gatekeeper/models/FlatsModel.dart';
import 'package:society_gatekeeper/provider/ApiProvider.dart';

class ParcelManagement extends StatefulWidget {
  @override
  _ParcelManagementState createState() => _ParcelManagementState();
}

class _ParcelManagementState extends State<ParcelManagement> {
  final FocusNode dateFocusNode = FocusNode();
  final FocusNode nodeTodayButton = FocusNode();
  final FocusNode nodeflatDropdownValue = FocusNode();
  final FocusNode nodeSubmitButton = FocusNode();
  final FocusNode nodeUserName = FocusNode();

  final FocusNode nodeDeliveryAgencyNameController = FocusNode();

  final FocusNode nodeDeliveryAgencyContactNumber = FocusNode();
  var flatDropdownValue;
  List<String> flats;
  List parcelDetails, parcelDetails2;
  FlatsModel flatsModel;
  TextEditingController dateController = TextEditingController();
  TextEditingController deliveryAgencyNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  TextEditingController deliveryAgencyContactNumberController =
      TextEditingController();
  final _submitDetailsKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var resp;

  Future getImageFromCamera() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      img = image;
    });
  }

  // Future getImageFromGallery() async {
  //   ImagePicker imagePicker = ImagePicker();

  //   var image = await imagePicker.getImage(source: ImageSource.gallery);
  //   setState(() {
  //     img = image;
  //   });
  // }

  DateTime d;
  var isLoading;
  var img;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = true;
    getFlats();
    flats = [];
    parcelDetails = [];
    parcelDetails = [];
    getParcels();
  }

  getParcels() async {
    parcelDetails2 = await parcelManagementBloc.getParcelDetails();
    setState(() {
      parcelDetails = parcelDetails2;
    });
  }

  getFlats() async {
    flatsModel = await parcelManagementBloc.getFlats();
    setState(() {
      isLoading = false;
    });
    print(flatsModel.data.runtimeType);
    for (var i in flatsModel.data) {
      flats.add(i);
    }
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
    getParcels();
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
                text: "Enter  Parcel Details",
              ),
              Tab(
                icon: Icon(Icons.directions_transit),
                text: "Show Details",
              ),
            ],
          ),
          title: Text('Parcel Management', style: TextStyle(fontSize: 20.0)),
        ),
        body: TabBarView(
          children: [
            //Parcel Details
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
                                                Colors.black.withOpacity(1.0)),
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
                                                          parcelManagementBloc
                                                                  .userName
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
                                                  cursorColor: Colors.white,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  onChanged:
                                                      parcelManagementBloc
                                                          .getDeiveyAgencyName,
                                                  focusNode:
                                                      nodeDeliveryAgencyNameController,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Delivery Agency Name';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      deliveryAgencyNameController,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Delivery Agency Name",
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
                                                  cursorColor: Colors.white,
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                  keyboardType:
                                                      TextInputType.phone,
                                                  inputFormatters: [
                                                    WhitelistingTextInputFormatter
                                                        .digitsOnly,
                                                    LengthLimitingTextInputFormatter(
                                                        10)
                                                  ],
                                                  onChanged: parcelManagementBloc
                                                      .getDeliveyAgentContact,
                                                  validator: (value) {
                                                    if (value.isEmpty) {
                                                      return 'Please Enter Contact Number';
                                                    }
                                                    return null;
                                                  },
                                                  controller:
                                                      deliveryAgencyContactNumberController,
                                                  focusNode:
                                                      nodeDeliveryAgencyContactNumber,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Delivery Agent Contact",
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
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.15,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            borderOnForeground: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                side: BorderSide(
                                                    color: Colors.black)),
                                            child: img == null
                                                ? Center(
                                                    child: Text(
                                                      "Your image will appeare here",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  )
                                                : Image.file(
                                                    img,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                        ),
                                        Center(
                                          child: RaisedButton(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                                side: BorderSide(
                                                    color: Colors.black)),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                  context: context,
                                                  backgroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius
                                                        .only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    15.0),
                                                            topRight:
                                                                Radius.circular(
                                                                    15.0)),
                                                  ),
                                                  builder: (context) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        // ListTile(
                                                        //   leading: Icon(Icons
                                                        //       .collections),
                                                        //   title: Text(
                                                        //       'Choose From Gallery'),
                                                        //   onTap: () {
                                                        //     getImageFromGallery();
                                                        //     Navigator.pop(
                                                        //         context);
                                                        //   },
                                                        // ),
                                                        ListTile(
                                                          leading: Icon(
                                                              Icons.camera_alt),
                                                          title: Text(
                                                              'Take A Photo'),
                                                          onTap: () {
                                                            getImageFromCamera();
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              "Pick Image",
                                              style: TextStyle(fontSize: 20.0),
                                            ),
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
                                                  0.7,
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
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  if (_submitDetailsKey
                                                      .currentState
                                                      .validate()) {
                                                    dialogLoader(context);
                                                    parcelManagementBloc
                                                            .flatNumber.value =
                                                        flatDropdownValue;
                                                    parcelManagementBloc
                                                        .image.value = img;
                                                    resp =
                                                        await parcelManagementBloc
                                                            .addParcelDetails();
                                                    if (resp == 'success') {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              nodeSubmitButton);
                                                      Navigator.pop(context);
                                                      _scaffoldKey.currentState
                                                          .showSnackBar(new SnackBar(
                                                              content: new Text(
                                                                  "Added Successfully !",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Raleway'))));
                                                      deliveryAgencyNameController
                                                          .clear();
                                                      deliveryAgencyContactNumberController
                                                          .clear();
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              nodeSubmitButton);
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
                                                      deliveryAgencyNameController
                                                          .clear();
                                                      deliveryAgencyContactNumberController
                                                          .clear();
                                                    }
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            nodeSubmitButton);
                                                    // checkInternetConnection();
                                                    // if (_addFormKey.currentState.validate()) {
                                                    //   checkAddDetails();
                                                    // } else {}

                                                  }
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
                        //           d = await parcelManagementBloc
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
                                itemCount: parcelDetails.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.25,
                                      width: MediaQuery.of(context).size.width,
                                      child: Card(
                                        color: Colors.blue,
                                        semanticContainer: true,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Image.network(
                                                "https://picsum.photos/200/300"),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          "Name :",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Text(
                                                          parcelDetails[index]
                                                                      ['user']
                                                                  ['owner_name']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          "Delivery agency :",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Text(
                                                          parcelDetails[index][
                                                                  'delivery_agency']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          "Contact no :",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Text(
                                                          parcelDetails[index][
                                                                  'delivery_contact']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          "Date :",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Text(
                                                          parcelDetails[index]
                                                                  ['date']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            left: 5),
                                                        child: Text(
                                                          "Time :",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            right: 5),
                                                        child: Text(
                                                          parcelDetails[index]
                                                                  ['time']
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
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
          ],
        ),
      ),
    );
  }
}
