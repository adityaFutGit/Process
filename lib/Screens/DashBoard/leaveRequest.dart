// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Models/userdataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_widgets.dart';

class LeaveRequest extends StatefulWidget {
  const LeaveRequest({super.key});

  @override
  State<LeaveRequest> createState() => _LeaveRequestState();
}

class _LeaveRequestState extends State<LeaveRequest> {
  var companyName = "macD";
  UserModel _userModel = UserModel();
  var token;
  var height = 475.0;
  TextEditingController reasonForRejection = TextEditingController();
  @override
  void initState() {
    initPrefs();

    super.initState();
  }

  initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      String decodedMap = prefs.getString('Users') ?? "";
      _userModel = userModelFromMap(decodedMap);

      token = prefs.getString("token");
    });

    // companyName =_userModel.userData?.;
  }

  List<KeyValueModel> _datas = [
    KeyValueModel(key: "Jan 2023", value: "1"),
    KeyValueModel(key: "Feb 2023", value: "2"),
    KeyValueModel(key: "Mar 2023", value: "3"),
    KeyValueModel(key: "Apr 2023", value: "4"),
    KeyValueModel(key: "May 2023", value: "5"),
    KeyValueModel(key: "Jun 2023", value: "6"),
    KeyValueModel(key: "Jul 2023", value: "7"),
    KeyValueModel(key: "Aug 2023", value: "8"),
    KeyValueModel(key: "Sep 2023", value: "9"),
    KeyValueModel(key: "Oct 2023", value: "10"),
    KeyValueModel(key: "Nov 2023", value: "11"),
    KeyValueModel(key: "Dec 2023", value: "12"),
  ];

  String _selectedMonthKey = "";
  String _selectedMonthValue = "";
  List empDetailsSubHeader = [
    "13456",
    "2 Days",
    "Apr 21, 2023",
    "Apr 30,2023",
    "Medical Emergency"
  ];
  List<String> empDetailsHeader = [
    "Employee ID:",
    "Duration:",
    "Start date:",
    "End Date:",
    "Reason:",
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var approveORreject;
  bool showApprovedIcon = false;
  bool showRejectedIcon = false;
  bool showRejectButton = false;
  bool showReasonForRejectionBox = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomWidgets.navBar(onTap: () {}),
        backgroundColor: Colors.white,
        drawer: const Drawer(backgroundColor: Colors.white),
        appBar: CustomAppBar(),
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: ((OverscrollIndicatorNotification? notification) {
              notification!.disallowIndicator();
              return true;
            }),
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                                size: 19,
                              )),
                          Text(
                            "Leaves Request",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 126,
                            height: 37,
                            child: DropdownButtonFormField<String>(
                              dropdownColor: Color.fromARGB(255, 216, 216, 216),
                              validator: (value) {
                                if (value == null) {
                                  return ("Select Month");
                                }
                                return null;
                              },
                              borderRadius: BorderRadius.circular(20),
                              decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 6.0, horizontal: 8),
                                  hintText: "Month",
                                  hintStyle: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 1.5),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  fillColor: AppColors.maincolor,
                                  filled: true),

                              icon: const Icon(
                                Icons.arrow_drop_down_outlined,
                                color: Colors.white,
                              ),
                              iconSize: 25,
                              //value: selectedMonth,
                              items: _datas
                                  .map((data) => DropdownMenuItem<String>(
                                        child: Text(
                                          data.key,
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                        value: data.value,
                                        onTap: () {
                                          _selectedMonthKey =
                                              data.key.toString();
                                        },
                                      ))
                                  .toList(),

                              onChanged: (String? value) {
                                _selectedMonthValue = value!;
                                print(_selectedMonthValue);
                                print(_selectedMonthKey);
                              },
                            ),
                          ),
                          FittedBox(
                            child: SizedBox(
                              width: 70,
                              child: Text(
                                companyName,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // approveAndRejected(),
                      Container(
                          //  height: 2000,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Container(
                                    height: 317,
                                    width: 348,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1.8,
                                            color: Color.fromARGB(
                                                255, 227, 227, 227)),
                                        borderRadius:
                                            BorderRadius.circular(14)),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.only(
                                      bottom: 15.0,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      width: 44.8,
                                                      height: 44.8,
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1.5,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    30,
                                                                    67,
                                                                    159)),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              spreadRadius: 2,
                                                              blurRadius: 20,
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.1),
                                                              offset:
                                                                  Offset(0, 10))
                                                        ],
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              "assets/profile.jpeg"),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 13,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: 200,
                                                  child: Text(
                                                    " Aditya Giri",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  "Software Engineer",
                                                  style: TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 61, 61, 61),
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 75,
                                              height: 26,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  color: Color.fromARGB(
                                                      255, 255, 210, 207)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.circle,
                                                    color: Color.fromARGB(
                                                        255, 245, 125, 117),
                                                    size: 10,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    "Pending",
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 245, 125, 117),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Divider(
                                          thickness: 1.5,
                                        ),
                                        GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    childAspectRatio: 6 / 2.5,
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 50,
                                                    mainAxisSpacing: 0),
                                            itemCount: 5,
                                            itemBuilder:
                                                (BuildContext ctx, index) {
                                              return Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      empDetailsHeader[index],
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                            255, 36, 36, 36),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Flexible(
                                                      flex: 1,
                                                      child: Container(
                                                        width: 200,
                                                        child: Text(
                                                          empDetailsSubHeader[
                                                              index],
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: AppColors
                                                                  .darkgrey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  approveORreject = "reject";
                                                });
                                                showAlertDialog(
                                                    context, approveORreject);
                                              },
                                              child: Text(
                                                "Reject",
                                                style: TextStyle(
                                                    color: AppColors.darkgrey,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,

                                                  //maximumSize: Size(7, 3),
                                                  minimumSize:
                                                      const Size(101, 35),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Color.fromARGB(
                                                              255,
                                                              231,
                                                              231,
                                                              231),
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0))),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  approveORreject = "approve";
                                                });
                                                showAlertDialog(
                                                    context, approveORreject);
                                              },
                                              child: Text(
                                                "Approve",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 30, 67, 159),

                                                  //maximumSize: Size(7, 3),
                                                  minimumSize:
                                                      const Size(101, 35),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0))),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ));
                              })),
                    ]))));
  }

  showAlertDialog(BuildContext context, approveORreject) {
    print(approveORreject);
    if (approveORreject == "reject") {
      setState(
        () {
          showRejectButton = true;
          height = 555.0;
          showReasonForRejectionBox = true;
        },
      );
    } else if (approveORreject == "approve") {
      setState(
        () {
          showRejectButton = false;
          height = 475.0;
          showReasonForRejectionBox = false;
        },
      );
    }
    Dialog alert = Dialog(
        backgroundColor: Colors.transparent,
        child: approveAndRejected(approveORreject));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget approveAndRejected(approveORreject) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
              width: 348,
              height: height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: 44.8,
                                height: 44.8,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color: Color.fromARGB(255, 30, 67, 159)),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 20,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 10))
                                  ],
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/profile.jpeg"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 180,
                            child: Text(
                              " Aditya Giri",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Software Engineer",
                            style: TextStyle(
                                color: Color.fromARGB(255, 61, 61, 61),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      IconButton(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.close,
                            size: 17,
                          )),
                    ],
                  ),
                  Divider(
                    thickness: 1.5,
                  ),
                  Row(
                    children: [
                      Text(
                        "Reporting Manager: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 68, 68, 68)),
                      ),
                      Text(
                        "Neha Sharma",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 68, 68, 68)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "Request Raised On: ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 68, 68, 68)),
                      ),
                      Text(
                        "Jan 15, 2023",
                        style: TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 68, 68, 68)),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  DottedLine(dashColor: Color.fromARGB(255, 170, 170, 170)),
                  SizedBox(
                    height: 14,
                  ),
                  GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 5.2 / 2.5,
                          crossAxisCount: 2,
                          crossAxisSpacing: 50,
                          mainAxisSpacing: 0),
                      itemCount: 5,
                      itemBuilder: (BuildContext ctx, index) {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                empDetailsHeader[index],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 36, 36, 36),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Flexible(
                                flex: 1,
                                child: Container(
                                  width: 200,
                                  child: Text(
                                    empDetailsSubHeader[index],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.darkgrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(
                    height: 10,
                  ),
                  Visibility(
                      visible: showReasonForRejectionBox,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Reason for rejection:",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomWidgets.textField(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Type Reason");
                              }
                              return null;
                            },
                            lines: 3,
                            hintText: "Type here ...",
                            textController: reasonForRejection,
                          ),
                        ],
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  showRejectButton == true
                      ? Visibility(
                          visible: showRejectedIcon,
                          child: Column(
                            children: [
                              Icon(
                                Icons.cancel,
                                size: 35,
                                color: Color.fromARGB(255, 219, 7, 7),
                              ),
                              Text(
                                "Rejected",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 177, 25, 5),
                                ),
                              )
                            ],
                          ))
                      : Visibility(
                          visible: showApprovedIcon,
                          child: Column(
                            children: [
                              // Image.asset("assets/tickMark.png"),
                              Icon(
                                Icons.check_circle_outline,
                                size: 35,
                                color: Color.fromARGB(255, 5, 177, 94),
                              ),
                              Text(
                                "Approved",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 5, 177, 94),
                                ),
                              )
                            ],
                          )),
                  showRejectButton == true
                      ? Visibility(
                          visible: !showRejectedIcon,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }
                                setState(() {
                                  showRejectedIcon = true;
                                });
                              },
                              child: Text(
                                "Reject",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 168, 28, 28),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 253, 171, 175),
                                  minimumSize: const Size(101, 35),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                            ),
                          ),
                        )
                      : Visibility(
                          visible: !showApprovedIcon,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  showApprovedIcon = true;
                                });
                              },
                              child: Text(
                                "Approve",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromARGB(255, 5, 177, 94),
                                  minimumSize: const Size(101, 35),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: Colors.transparent,
                                          width: 1.5),
                                      borderRadius:
                                          BorderRadius.circular(8.0))),
                            ),
                          ),
                        ),
                ],
              )),
        ),
      );
    });
  }
}

class KeyValueModel {
  String key;
  String value;

  KeyValueModel({required this.key, required this.value});
}
