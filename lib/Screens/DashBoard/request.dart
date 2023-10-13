// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/dashboard.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Models/userdataModel.dart';

class Request extends StatefulWidget {
  const Request({super.key});

  @override
  State<Request> createState() => _RequestState();
}

class _RequestState extends State<Request> {
  var token;
  var companyId;
  var employeeId;
  var reportingManagerId;

  UserModel _userModel = UserModel();
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
  initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refresh_token = prefs.getString("refresh_token");
    http.Response res = await http.post(
        Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
        headers: {"refresh_token": refresh_token.toString()});
    var jsonResponse = jsonDecode(res.body);

    print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
    await prefs.setString("token", jsonResponse["token"]);
    token = prefs.getString("token");
    var value = await prefs.getInt('UserId');
    if (!mounted) return;

    setState(() {
      employeeId = value;
    });
    String decodedMap = prefs.getString('Users') ?? "";
    _userModel = userModelFromMap(decodedMap);
    companyId = _userModel.userData?.employee?.employeeOffrollment == null
        ? _userModel.userData?.employee?.employeeOnrollment?.onRollCompany?.id
        : _userModel
            .userData?.employee?.employeeOffrollment?.offRollCompany?.id;

    reportingManagerId = _userModel.userData?.employee?.employeeOffrollment ==
            null
        ? _userModel.userData?.employee?.employeeOnrollment?.reportingManagerId
        : _userModel
            .userData?.employee?.employeeOffrollment?.reportingManagerId;
    if (reportingManagerId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.maincolor,
          content: Text(
            "Data Not Available",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const DashboardScreen(),
      ));
    } else {
      _getLeaveRequestDetails();
    }
  }

  @override
  void initState() {
    initPrefs();

    super.initState();
  }

  String? selectedRequest;

  var requests = ['All', 'Leaves', 'Attendance'];
  var height = 475.0;
  TextEditingController reasonForAction = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var approveORreject;
  bool showApprovedIcon = false;
  bool showRejectedIcon = false;
  bool showRejectButton = false;
  bool showreasonForActionBox = false;
  TextEditingController date = TextEditingController();
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
                child: leaveRequestDetails == null
                    ? Align(
                        heightFactor: 6,
                        alignment: Alignment.center,
                        child: Lottie.asset("assets/loading.json", height: 100))
                    : Column(
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
                                  "Requests",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWidgets.textField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ("Select Date");
                                      }
                                      return null;
                                    },
                                    textController: date,
                                    width: 140,
                                    height: 70,
                                    readOnly: true,
                                    hintText: "Select Date",
                                    lines: 1,
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 5.0, horizontal: 8),
                                    onTap: () async {
                                      var from = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(2050));
                                      date.text =
                                          from.toString().substring(0, 10);
                                    },
                                    suffixIcon: Icon(
                                      Icons.calendar_month,
                                      color: Colors.black54,
                                      size: 20,
                                    )),
                                Container(
                                  width: 140,
                                  child: DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(10),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 10),
                                        hintText: "Leaves",
                                        hintStyle: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color.fromARGB(
                                              255, 136, 136, 136),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Color.fromARGB(
                                                  255, 227, 227, 227),
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        fillColor: Colors.white,
                                        filled: true),
                                    isExpanded: false,
                                    icon: const Icon(
                                        Icons.arrow_drop_down_outlined),
                                    iconSize: 30,
                                    value: selectedRequest,
                                    items: requests
                                        .map((item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item,
                                                style: const TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w400))))
                                        .toList(),
                                    onChanged: (item) {
                                      selectedRequest = item!;
                                    },
                                    onSaved: (newValue) {
                                      newValue = selectedRequest;
                                    },
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {}, icon: Icon(Icons.sort))
                              ],
                            ),
                            showData == false
                                ? Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'No Leave Requests',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Color.fromARGB(
                                                  255, 150, 150, 150),
                                              letterSpacing: 0.7,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    //  height: 2000,
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: leaveRequestDetails.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                              height: 99,
                                              width: 475,
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 1.8,
                                                      color: Color.fromARGB(
                                                          255, 227, 227, 227)),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          14)),
                                              padding: EdgeInsets.all(10),
                                              margin: EdgeInsets.only(
                                                bottom: 10.0,
                                              ),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Stack(
                                                            children: [
                                                              Container(
                                                                width: 44.8,
                                                                height: 44.8,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border.all(
                                                                      width:
                                                                          1.5,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          30,
                                                                          67,
                                                                          159)),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        spreadRadius:
                                                                            2,
                                                                        blurRadius:
                                                                            20,
                                                                        color: Colors
                                                                            .black
                                                                            .withOpacity(
                                                                                0.1),
                                                                        offset: Offset(
                                                                            0,
                                                                            10))
                                                                  ],
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
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
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            width: 200,
                                                            child: Text(
                                                              leaveRequestDetails[
                                                                              index]
                                                                          [
                                                                          "employeeInfo"]
                                                                      [
                                                                      "employee"]
                                                                  ["fullName"],
                                                              style: TextStyle(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          44,
                                                                          44,
                                                                          44),
                                                                  fontSize: 17,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Leave",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        82,
                                                                        82,
                                                                        82),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            "${DateFormat.yMMMd().format(DateTime.parse(leaveRequestDetails[index]["updatedAt"]))}",
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        143,
                                                                        143,
                                                                        143),
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                        ],
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          showAlertDialog(
                                                              context,
                                                              approveORreject,
                                                              index);
                                                        },
                                                        child: Text(
                                                          "Action",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        ),
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                                backgroundColor:
                                                                    Color.fromARGB(
                                                                        255,
                                                                        30,
                                                                        67,
                                                                        159),

                                                                //maximumSize: Size(7, 3),
                                                                minimumSize:
                                                                    const Size(
                                                                        70, 25),
                                                                elevation: 0,
                                                                shape: RoundedRectangleBorder(
                                                                    side: BorderSide(
                                                                        color: Colors
                                                                            .transparent,
                                                                        width:
                                                                            1.5),
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

  showAlertDialog(BuildContext context, approveORreject, index) {
    Dialog alert = Dialog(
        backgroundColor: Colors.transparent,
        child: approveAndRejected(approveORreject, index));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget approveAndRejected(approveORreject, index) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
              width: 348,
              height: 592,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 17),
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
                              leaveRequestDetails[index]["employeeInfo"]
                                  ["employee"]["fullName"],
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            leaveRequestDetails[index]["employeeInfo"]
                                ["employee"]["email"],
                            style: TextStyle(
                                color: Color.fromARGB(255, 61, 61, 61),
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      IconButton(
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const Request()));
                            // Navigator.of(context).pop();
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
                        "Leave type: ",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 68, 68, 68)),
                      ),
                      Text(
                        leaveRequestDetails[index]["leaveType"]["name"],
                        style: TextStyle(
                            fontSize: 13,
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
                        "Status: ",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 68, 68, 68)),
                      ),
                      Text(
                        leaveRequestDetails[index]["status"]
                            .toString()
                            .capitalized(),
                        style: TextStyle(
                            fontSize: 13,
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
                        "Request raised on: ",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 68, 68, 68)),
                      ),
                      Text(
                        DateFormat.yMMMd().format(DateTime.parse(
                            leaveRequestDetails[index]["updatedAt"])),
                        style: TextStyle(
                            fontSize: 13,
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
                  Container(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Employee Code:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 36, 36, 36),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    leaveRequestDetails[index]["employeeInfo"]
                                        ["employeeCode"],
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkgrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Duration:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 36, 36, 36),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  // width: 200,
                                  child: Text(
                                    "${leaveRequestDetails[index]["totalLeavesToConsider"]} Days",
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkgrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Start date:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 36, 36, 36),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  width: 200,
                                  child: Text(
                                    DateFormat.yMMMd().format(DateTime.parse(
                                        leaveRequestDetails[index]
                                            ["startDateTime"])),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkgrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "End date:",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 36, 36, 36),
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Container(
                                  child: Text(
                                    DateFormat.yMMMd().format(DateTime.parse(
                                        leaveRequestDetails[index]
                                            ["endDateTime"])),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.darkgrey,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Reason:",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 36, 36, 36),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                child: Text(
                                  leaveRequestDetails[index]["reasonForLeave"],
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.darkgrey,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Reason for action:",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          ),
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
                          textController: reasonForAction,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Visibility(
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
                      )),
                  Visibility(
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
                  loading == true
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: AppColors.maincolor,
                            strokeWidth: 3,
                          ),
                        )
                      : showActionButton == true
                          ? Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        // setState(() {
                                        //   showreasonForActionBox = true;
                                        //   height = 555.0;
                                        //   // showRejectedIcon = true;
                                        // });
                                        leaveRequestAction(
                                            "rejected", index, setState);
                                      },
                                      child: Text(
                                        "Reject",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 168, 28, 28),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 253, 171, 175),
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
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }
                                        // setState(() {
                                        //   showreasonForActionBox = false;
                                        //   height = 475.0;
                                        //   showApprovedIcon = true;
                                        // });
                                        leaveRequestAction(
                                            "l1approved", index, setState);
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
                                              Color.fromARGB(255, 18, 206, 115),
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
                                ],
                              ),
                            )
                          : Container(),
                ],
              )),
        ),
      );
    });
  }

  bool loading = false;
  bool showActionButton = true;
  leaveRequestAction(String action, index, setState) async {
    setState(() {
      loading = true;
    });
    try {
      final uri =
          Uri.parse("${TextConstant.baseURL}/api/leave/leave-request/action");

      Map<String, dynamic> body = {
        "approvingAuthorityId": reportingManagerId,
        "id": leaveRequestDetails[index]["id"],
        "reasonLeaveToConsider": reasonForAction.text,
        "status": action
      };
      print(body);

      String jsonBody = json.encode(body);
      var response = await http.patch(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'x-access-token': token
        },
        body: jsonBody,
      );

      var responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        setState(() {
          loading = false;
          showActionButton = false;
          if (action == "l1approved") {
            showApprovedIcon = true;
          } else if (action == "rejected") {
            showRejectedIcon = true;
          }
        });
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  var leaveRequestDetails;
  bool showData = false;
  void _getLeaveRequestDetails() async {
    try {
      String url =
          '${TextConstant.baseURL}/api/leave/leave-request/list?companyId=$companyId&status=pending&offset=1&reportingManagerId=$reportingManagerId';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });

      leaveRequestDetails = jsonDecode(res.body);
      if (leaveRequestDetails == []) {
        setState(() {
          showData = false;
        });
      } else {
        setState(() {
          showData = true;
        });
      }
      print(leaveRequestDetails);
    } on Exception catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.maincolor,
            content: Text(
              "${e.toString()} \nIt may take some time.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
    }
    if (!mounted) return;
    setState(() {});
  }
}

extension StringExtension on String {
  String capitalized() {
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
