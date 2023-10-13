// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Models/userdataModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../custom_widgets.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  UserModel _userModel = UserModel();
  var designation;
  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      String decodedMap = prefs.getString('Users') ?? "";
      _userModel = userModelFromMap(decodedMap);
    });

    setState(() {
      if (_userModel.userData?.employee?.employeeOffrollment?.designation ==
              null &&
          _userModel.userData?.employee?.employeeOnrollment?.designation ==
              null) {
        designation = "";
      } else {
        designation = _userModel.userData?.employee?.employeeOffrollment ==
                    null ||
                _userModel
                        .userData?.employee?.employeeOffrollment?.designation ==
                    null
            ? _userModel.userData?.employee?.employeeOnrollment?.designation
            : _userModel.userData?.employee?.employeeOffrollment?.designation;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomWidgets.navBar(onTap: () {}),
      backgroundColor: Colors.white,
      drawer: const Drawer(backgroundColor: Colors.white),
      appBar: CustomAppBar(),
      body: SafeArea(
        right: true,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: ((OverscrollIndicatorNotification? notification) {
            notification!.disallowIndicator();
            return true;
          }),
          child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: _userModel.userData?.employee == null
                  ? Align(
                      heightFactor: 6,
                      alignment: Alignment.center,
                      child: Lottie.asset("assets/loading.json", height: 100))
                  : Column(
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
                              "View Employee",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 70,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, right: 10),
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.maincolor),
                                  onPressed: () {
                                    //Get.to(MedicalCard());
                                  },
                                  child: Text("Medical Card")),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 88,
                                  height: 90,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.7,
                                        color:
                                            Color.fromARGB(255, 30, 67, 159)),
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
                                      // getDisplayImage(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_userModel.userData?.fullName ?? " "}",
                                  style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 30, 67, 159)),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  "Employee Code: ${_userModel.userData?.employee?.employeeCode ?? " "}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Image.asset("assets/radio.png"),
                                    Container(
                                        width: 1.5,
                                        height: 0.3.sw,
                                        color:
                                            Color.fromARGB(255, 30, 67, 159)),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "BASIC DETAILS",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 30, 67, 159)),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "Email:",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 84, 84, 84),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Container(
                                          width: 120,
                                          child: Text(
                                            "${_userModel.userData?.email ?? " "}",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 120, 120, 120),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 17,
                                        ),
                                        Text(
                                          "Designation:",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 84, 84, 84),
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          designation ?? "",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 120, 120, 120),
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 0.2.sw,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      "Phone No.:",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${_userModel.userData?.mobile ?? " "}",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                      "Education:",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${_userModel.userData?.employee?.education ?? " "}",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.grey,
                          indent: 34,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Image.asset("assets/radio.png"),
                                    Container(
                                        width: 1.5,
                                        height: 0.3.sw,
                                        color:
                                            Color.fromARGB(255, 30, 67, 159)),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "ADDRESS",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 30, 67, 159)),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Permanent Address",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      width: 270,
                                      child: Text(
                                        _userModel.userData?.employee
                                                        ?.addresses ==
                                                    null ||
                                                _userModel.userData!.employee!
                                                    .addresses!.isEmpty
                                            ? " "
                                            : "${_userModel.userData?.employee?.addresses![0].addressLine1}",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 120, 120, 120),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                      "Temporary Address",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Container(
                                      width: 270,
                                      child: Text(
                                        _userModel.userData?.employee
                                                        ?.addresses ==
                                                    null ||
                                                _userModel.userData!.employee!
                                                    .addresses!.isEmpty
                                            ? " "
                                            : "${_userModel.userData?.employee?.addresses![0].addressLine1}",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 120, 120, 120),
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: Colors.grey,
                          indent: 34,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Image.asset("assets/radio.png"),
                                    Container(
                                        width: 1.5,
                                        height: 0.3.sw,
                                        color:
                                            Color.fromARGB(255, 30, 67, 159)),
                                  ],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "JOB HISTORY",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 30, 67, 159)),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Location",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${_userModel.userData?.employee?.employeeOffrollment?.location == null || _userModel.userData?.employee?.employeeOffrollment == null ? " " : _userModel.userData?.employee?.employeeOffrollment?.location?.name}",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                      "Start Date",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${_userModel.userData?.employee?.employeeOffrollment?.thisRoleStartDate ?? " "}",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    // Text(
                                    //   "Location",
                                    //   style: TextStyle(
                                    //       color:
                                    //           Color.fromARGB(255, 84, 84, 84),
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // SizedBox(
                                    //   height: 3,
                                    // ),
                                    // Text(
                                    //   " ",
                                    //   style: TextStyle(
                                    //       color: Color.fromARGB(
                                    //           255, 120, 120, 120),
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    // SizedBox(
                                    //   height: 17,
                                    // ),
                                    // Text(
                                    //   "Start Date",
                                    //   style: TextStyle(
                                    //       color:
                                    //           Color.fromARGB(255, 84, 84, 84),
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // SizedBox(
                                    //   height: 3,
                                    // ),
                                    // Text(
                                    //   " ",
                                    //   style: TextStyle(
                                    //       color: Color.fromARGB(
                                    //           255, 120, 120, 120),
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                  ],
                                ),
                                SizedBox(
                                  width: 0.36.sw,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      height: 35,
                                    ),
                                    Text(
                                      "Designation",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${_userModel.userData?.employee?.employeeOffrollment?.designation ?? " "}",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    Text(
                                      "End Date",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 84, 84, 84),
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      "${_userModel.userData?.employee?.employeeOffrollment?.lastWorkingDate ?? " "}",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 120, 120, 120),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 17,
                                    ),
                                    // Text(
                                    //   "Designation",
                                    //   style: TextStyle(
                                    //       color:
                                    //           Color.fromARGB(255, 84, 84, 84),
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // SizedBox(
                                    //   height: 3,
                                    // ),
                                    // Text(
                                    //   " ",
                                    //   style: TextStyle(
                                    //       color: Color.fromARGB(
                                    //           255, 120, 120, 120),
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                    // SizedBox(
                                    //   height: 17,
                                    // ),
                                    // Text(
                                    //   "End Date",
                                    //   style: TextStyle(
                                    //       color:
                                    //           Color.fromARGB(255, 84, 84, 84),
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // SizedBox(
                                    //   height: 3,
                                    // ),
                                    // Text(
                                    //   " ",
                                    //   style: TextStyle(
                                    //       color: Color.fromARGB(
                                    //           255, 120, 120, 120),
                                    //       fontWeight: FontWeight.w500),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            )
                          ],
                        ),
                      ],
                    )),
        ),
      ),
    );
  }
}
