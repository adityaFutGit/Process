// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_typing_uninitialized_variables, sort_child_properties_last, await_only_futures, avoid_unnecessary_containers, unnecessary_cast, must_be_immutable, unused_local_variable, curly_braces_in_flow_control_structures

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Models/leaveModel.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../../Models/userdataModel.dart';

//Leaves
class Leaves extends StatefulWidget {
  const Leaves({super.key});

  @override
  State<Leaves> createState() => _LeavesState();
}

class _LeavesState extends State<Leaves> {
  var token;
  var companyId;
  var employeeId;

  UserModel _userModel = UserModel();
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
    _getcompOffLeaveDetails();
    _getAppliedLeaveDetails();
    await _getLeaveBalance();
    await _getCompOffBalance();
  }

  @override
  void initState() {
    initPrefs();

    super.initState();
  }

  @override
  void dispose() {
    _getAppliedLeaveDetails();
    _getLeaveBalance();
    super.dispose();
  }

  List<Color> dotColor = [AppColors.maincolor, Colors.green, Colors.red];

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
          child: (responseBodyCompOffDetails == null)
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
                            "Leaves",
                            style: TextStyle(
                                fontSize: 16.sp, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      // ElevatedButton(
                      //   onPressed: () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (BuildContext context) => LeaveRequest(),
                      //       ),
                      //     );
                      //   },
                      //   child: Text(
                      //     "Leave request",
                      //     style: TextStyle(fontSize: 13),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     fixedSize: Size(103, 20),
                      //     splashFactory: NoSplash.splashFactory,
                      //     elevation: 0,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(15)),
                      //     backgroundColor: AppColors.maincolor,
                      //   ),
                      // ),
                      ElevatedButton(
                        onPressed: () {
                          if (leaveBalance.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  duration: Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor:
                                      Color.fromARGB(255, 182, 22, 10),
                                  content: Text(
                                    "Leave Balance is Not Available",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 17,
                                    ),
                                  )),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ApplyLeaves(),
                              ),
                            );
                          }
                        },
                        child: Text(
                          "Apply Leave",
                          style: TextStyle(fontSize: 13),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(103, 20),
                          splashFactory: NoSplash.splashFactory,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          backgroundColor: AppColors.maincolor,
                        ),
                      ),
                      Align(
                        widthFactor: 2.88,
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Applied Leaves",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkgrey),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      appliedLeaveData == [] || showData == true
                          ? Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'No Applied Leaves',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 150, 150, 150),
                                        letterSpacing: 0.7,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Color.fromARGB(255, 233, 232, 232),
                                      width: 1.7)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    height: 0.6.sw,
                                    child: responseBody1 == null
                                        ? Text(
                                            'No Applied Leaves',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Color.fromARGB(
                                                    255, 150, 150, 150),
                                                letterSpacing: 0.7,
                                                fontWeight: FontWeight.w500),
                                          )
                                        : ListView.separated(
                                            separatorBuilder:
                                                (context, index) => SizedBox(
                                                      height: 20,
                                                    ),
                                            scrollDirection: Axis.vertical,
                                            itemCount:
                                                appliedLeaveData["count"],
                                            shrinkWrap: true,
                                            itemBuilder:
                                                ((BuildContext context, index) {
                                              var background;
                                              if (appliedLeaveData["rows"]
                                                      [index]["status"] ==
                                                  "approved") {
                                                background = Colors.green;
                                              }
                                              if (appliedLeaveData["rows"]
                                                      [index]["status"] ==
                                                  "rejected") {
                                                background = Colors.red;
                                              }
                                              if (appliedLeaveData["rows"]
                                                      [index]["status"] ==
                                                  "pending") {
                                                background = Color.fromARGB(
                                                    255, 231, 210, 16);
                                              }
                                              return Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        " • ${DateFormat.yMMMd().format(DateTime.parse(appliedLeaveData["rows"][index]["updatedAt"]))}",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: AppColors
                                                                .darkgrey),
                                                      ),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                                    MaterialPageRoute(
                                                              builder: (context) =>
                                                                  LeaveDetails(
                                                                id: appliedLeaveData[
                                                                        "rows"][
                                                                    index]["id"],
                                                              ),
                                                            ));
                                                          },
                                                          child: Text(
                                                            "View Details",
                                                            style: TextStyle(
                                                              fontSize: 14.5,
                                                              decoration:
                                                                  TextDecoration
                                                                      .underline,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      21,
                                                                      78,
                                                                      222),
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                  Divider(
                                                    thickness: 1.5,
                                                    height: 2,
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Status",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .darkgrey),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Text(
                                                            appliedLeaveData[
                                                                            "rows"]
                                                                        [index]
                                                                    ["status"]
                                                                .toString()
                                                                .capitalized(),
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color:
                                                                    background
                                                                //   AppColors.darkgrey
                                                                ),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Leave Type",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .darkgrey),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Text(
                                                            appliedLeaveData[
                                                                            "rows"]
                                                                        [index][
                                                                    "leaveType"]
                                                                ["name"],
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .darkgrey),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Start Date",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .darkgrey),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Text(
                                                            DateFormat(
                                                                    'dd.MM.yy')
                                                                .format(DateTime
                                                                    .parse(appliedLeaveData["rows"]
                                                                            [
                                                                            index]
                                                                        [
                                                                        "startDateTime"])),
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .darkgrey),
                                                          )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text(
                                                            "Days",
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: AppColors
                                                                    .darkgrey),
                                                          ),
                                                          SizedBox(
                                                            height: 6,
                                                          ),
                                                          Text(
                                                            "${appliedLeaveData["rows"][index]["totalLeavesToConsider"]} Days",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: AppColors
                                                                    .darkgrey),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              );
                                            })),
                                  ),
                                ],
                              ),
                            ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(
                        widthFactor: 2.88,
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Compensatory Leaves",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkgrey),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 14, vertical: 15),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: Color.fromARGB(255, 233, 232, 232),
                                  width: 1.7)),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 0.6.sw,
                                  child: ListView.separated(
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 20,
                                          ),
                                      scrollDirection: Axis.vertical,
                                      itemCount: compOffLeaveData["count"],
                                      shrinkWrap: true,
                                      itemBuilder:
                                          ((BuildContext context, index) {
                                        var background;
                                        if (compOffLeaveData["rows"][index]
                                                ["status"] ==
                                            "approved") {
                                          background = Colors.green;
                                        }
                                        if (compOffLeaveData["rows"][index]
                                                ["status"] ==
                                            "rejected") {
                                          background = Colors.red;
                                        }
                                        if (compOffLeaveData["rows"][index]
                                                ["status"] ==
                                            "pending") {
                                          background =
                                              Color.fromARGB(255, 231, 210, 16);
                                        }
                                        return Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  " • ${DateFormat.yMMMd().format(DateTime.parse(compOffLeaveData["rows"][index]["updatedAt"]))}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color:
                                                          AppColors.darkgrey),
                                                ),
                                                IconButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            CompOffEditLeaveRequest(
                                                          id: compOffLeaveData[
                                                                  "rows"][index]
                                                              ["id"],
                                                          startDate:
                                                              compOffLeaveData[
                                                                          "rows"]
                                                                      [index][
                                                                  "startDateTime"],
                                                          endDate:
                                                              compOffLeaveData[
                                                                          "rows"]
                                                                      [index][
                                                                  "endDateTime"],
                                                        ),
                                                      ));
                                                    },
                                                    icon: Icon(
                                                      Icons.edit,
                                                      color:
                                                          AppColors.maincolor,
                                                    ))
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1.5,
                                              height: 2,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Status",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .darkgrey),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      compOffLeaveData["rows"]
                                                              [index]["status"]
                                                          .toString()
                                                          .capitalized(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: background
                                                          //   AppColors.darkgrey
                                                          ),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Leave Type",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .darkgrey),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      "Comp Off",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .darkgrey),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Start Date",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .darkgrey),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      DateFormat('dd.MM.yy')
                                                          .format(DateTime.parse(
                                                              compOffLeaveData[
                                                                          "rows"]
                                                                      [index][
                                                                  "startDateTime"])),
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .darkgrey),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Text(
                                                      "Days",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: AppColors
                                                              .darkgrey),
                                                    ),
                                                    SizedBox(
                                                      height: 6,
                                                    ),
                                                    Text(
                                                      "${compOffLeaveData["rows"][index]["totalCompOffDays"]} Days",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .darkgrey),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      })),
                                )
                              ])),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              "Leave Balance",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.darkgrey),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            compOffBox(),
                            responseBody == null
                                ? Container()
                                : leaveBalance != null
                                    ? Container(
                                        child: ListView.builder(
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: leaveBalance.length,
                                            itemBuilder: (context, index) {
                                              final Color background = Color(
                                                      (math.Random()
                                                                  .nextDouble() *
                                                              0xFFFFFF)
                                                          .toInt())
                                                  .withOpacity(1.0);
                                              return Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          width: 1.8,
                                                          color: Color.fromARGB(
                                                              255,
                                                              227,
                                                              227,
                                                              227)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14)),
                                                  margin: EdgeInsets.only(
                                                    bottom: 10.0,
                                                  ),
                                                  child: ExpansionTile(
                                                    tilePadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    iconColor:
                                                        AppColors.maincolor,
                                                    collapsedIconColor:
                                                        AppColors.maincolor,
                                                    title: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.circle,
                                                          color: background,
                                                          size: 12,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${leaveBalance[index]["leaveType"]["name"]}",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .maincolor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            Text(
                                                              "(${leaveBalance[index]["leaveRemaining"].toStringAsFixed(2)} Remaining)",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .maincolor,
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    children: [
                                                      ListTile(
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                          title: Column(
                                                            children: [
                                                              Divider(
                                                                thickness: 1.5,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        218,
                                                                        218,
                                                                        218),
                                                                height: 0,
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              ),
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            13),
                                                                child: Column(
                                                                  children: [
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Credited Leaves- ",
                                                                              style: TextStyle(color: Color.fromRGBO(97, 97, 97, 1), fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 3.5,
                                                                            ),
                                                                            Text(
                                                                              "${leaveBalance[index]["leavesAccruedThisMonth"].toStringAsFixed(2)}",
                                                                              style: TextStyle(
                                                                                color: Colors.grey[600],
                                                                                fontSize: 13,
                                                                                height: 1.3,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Penalty- ",
                                                                              style: TextStyle(color: Color.fromRGBO(97, 97, 97, 1), fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 3.5,
                                                                            ),
                                                                            Text(
                                                                              "0",
                                                                              style: TextStyle(
                                                                                color: Colors.grey[600],
                                                                                fontSize: 13,
                                                                                height: 1.3,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          20,
                                                                    ),
                                                                    Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Applied Leaves- ",
                                                                              style: TextStyle(color: Color.fromRGBO(97, 97, 97, 1), fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 3.5,
                                                                            ),
                                                                            Text(
                                                                              "${leaveBalance[index]["leavesTakenThisMonth"]}",
                                                                              style: TextStyle(
                                                                                color: Colors.grey[600],
                                                                                fontSize: 13,
                                                                                height: 1.3,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        // SizedBox(
                                                                        //   width: 120,
                                                                        // ),
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Balance-  ",
                                                                              style: TextStyle(color: Color.fromRGBO(97, 97, 97, 1), fontSize: 14, fontWeight: FontWeight.bold),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 3.5,
                                                                            ),
                                                                            FittedBox(
                                                                              child: Text(
                                                                                "${leaveBalance[index]["leaveRemaining"].toStringAsFixed(2)}",
                                                                                style: TextStyle(
                                                                                  color: Colors.grey[600],
                                                                                  fontSize: 13,
                                                                                  height: 1.3,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )),
                                                    ],
                                                  ));
                                            }))
                                    : Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 60,
                                            ),
                                            Text(
                                              'No Leave Balance ',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.grey,
                                                  letterSpacing: 0.7,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      )
                          ]))
                    ]),
        ),
      ),
    );
  }

  var showBox;
  Widget compOffBox() {
    return responseBodyCompOff == null
        ? Container()
        : Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 1.8, color: Color.fromARGB(255, 227, 227, 227)),
                borderRadius: BorderRadius.circular(14)),
            margin: EdgeInsets.only(
              bottom: 10.0,
            ),
            child: ExpansionTile(
              tilePadding: EdgeInsets.symmetric(horizontal: 10),
              iconColor: AppColors.maincolor,
              collapsedIconColor: AppColors.maincolor,
              title: Row(
                children: [
                  Icon(
                    Icons.circle,
                    color: AppColors.maincolor,
                    size: 12,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Compensatory Off Leave",
                        style: TextStyle(
                            color: AppColors.maincolor,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        showBox == true
                            ? "0"
                            : "(${responseBodyCompOff["balance"].toStringAsFixed(2)} Remaining)",
                        style: TextStyle(
                            color: AppColors.maincolor,
                            fontSize: 11,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ],
              ),
              children: [
                ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                    title: Column(
                      children: [
                        Divider(
                          thickness: 1.5,
                          color: Color.fromARGB(255, 218, 218, 218),
                          height: 0,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 13),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Balance-  ",
                                style: TextStyle(
                                    color: Color.fromRGBO(97, 97, 97, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 3.5,
                              ),
                              FittedBox(
                                child: Text(
                                  showBox == true
                                      ? "0"
                                      : " ${responseBodyCompOff["balance"].toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ));
  }

  //COMP OOF LEAVE DETAILS
  var compOffLeaveData;
  var responseBodyCompOffDetails;

  void _getcompOffLeaveDetails() async {
    List<AppliedLeaveData> allData = List.empty(growable: true);

    try {
      String url =
          '${TextConstant.baseURL}/api/comp-off/leave-request/list?employeeId=$employeeId&companyId=$companyId';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      responseBodyCompOffDetails = res.body;
      compOffLeaveData = jsonDecode(res.body);
      print(compOffLeaveData);
    } on Exception catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.maincolor,
            content: Text(
              "${e.toString()} \nIt may take some time.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
      if (mounted)
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Leaves(),
        ));
    }
    if (!mounted) return;
    setState(() {});
  }

//NORMAL LEAVES DETAILS API

  var appliedLeaveData;
  var responseBody1;
  bool showData = false;
  void _getAppliedLeaveDetails() async {
    List<AppliedLeaveData> allData = List.empty(growable: true);

    try {
      String url =
          '${TextConstant.baseURL}/api/leave/leave-request/list?employeeId=$employeeId&status=pending&status=rejected&status=approved';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });

      responseBody1 = res.body;
      appliedLeaveData = jsonDecode(res.body);
      if (appliedLeaveData["message"] == "No data found" ||
          appliedLeaveData["count"] == 0) {
        setState(() {
          showData = true;
        });
      } else {
        setState(() {
          showData = false;
        });
      }

      // for (int i = 0; i < appliedLeaveData.length; i++) {
      //   allData.add(AppliedLeaveData(
      //     appliedLeaveData[i]["id"],
      //     appliedLeaveData[i]["status"],
      //     appliedLeaveData[i]["reasonForLeave"],
      //     appliedLeaveData[i]["employeeId"],
      //     appliedLeaveData[i]["leaveTypeId"],
      //     appliedLeaveData[i]["startDateTime"],
      //     appliedLeaveData[i]["endDateTime"],
      //     appliedLeaveData[i]["leaveType"]["name"],
      //     appliedLeaveData[i]["createdAt"],
      //   ));
      // }
    } on Exception catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.maincolor,
            content: Text(
              "${e.toString()} \nIt may take some time.",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
      if (mounted)
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Leaves(),
        ));
    }
    if (!mounted) return;
    setState(() {});
  }

  //Leave Balance Api
  var month = DateTime.now().month;
  var year = DateTime.now().year;

  dynamic leaveBalance;
  var responseBody;

  Future _getLeaveBalance() async {
    print(month);
    print(year);
    List<LeaveBalance> allData = List.empty(growable: true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = await prefs.getInt('UserId');
      if (!mounted) return;
      setState(() {
        employeeId = value;
      });
      print(employeeId);
      String url =
          '${TextConstant.baseURL}/api/leave/leave-available/employee-balance-list?employeeId=$employeeId&year=$year&month=$month';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      leaveBalance = jsonDecode(res.body);

      if (mounted)
        setState(() {
          responseBody = res.body;
        });
      // print(responseBody);
      for (int i = 0; i < leaveBalance.length; i++) {
        allData.add(LeaveBalance(
          leaveBalance[i]["id"],
          leaveBalance[i]["leavesAccruedThisMonth"],
          leaveBalance[i]["leavesTakenThisMonth"],
          leaveBalance[i]["leaveRemaining"],
          leaveBalance[i]["leavesMonthOpeningBalance"],
          leaveBalance[i]["month"],
          leaveBalance[i]["year"],
          leaveBalance[i]["leaveTypeId"],
          leaveBalance[i]["leaveType"]["name"],
        ));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nIt may take some time.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Leaves(),
      ));
    }
    if (!mounted) return;
    setState(() {});
  }

  //COMP OFF BALANCE API

  var responseBodyCompOff;

  Future _getCompOffBalance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String url =
          '${TextConstant.baseURL}/api/comp-off/employee/balance?entityId=$companyId&employeeId=$employeeId';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      if (res.statusCode == 200) {
        if (res.body.isNotEmpty) {
          responseBodyCompOff = jsonDecode(res.body);

          if (double.parse(responseBodyCompOff["balance"].toStringAsFixed(2)) >=
              1.0) {
            print("COMP OFF AVAILABLE");
            prefs.setBool("compOffBalance", true);
          } else {
            print("COMP OFF NOT AVAILABLE");
            prefs.setBool("compOffBalance", false);
          }
        } else if (res.body.isEmpty) {
          setState(() {
            showBox = true;
            responseBodyCompOff = "l";
          });
        }
      }
    } on Exception catch (e) {
      responseBodyCompOff == null;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()}",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Leaves(),
      ));
    }
    if (!mounted) return;
    setState(() {});
  }
}

//Apply Leaves
class ApplyLeaves extends StatefulWidget {
  const ApplyLeaves({super.key});

  @override
  State<ApplyLeaves> createState() => _ApplyLeavesState();
}

class _ApplyLeavesState extends State<ApplyLeaves> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController reason = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedFromHalf;
  String? selectedToHalf;
  var fromHalf = [
    'First Half',
    'Second Half',
  ];
  var toHalf = [
    'First Half',
    'Second Half',
  ];
  bool nextPage = false;
  String? selectedLeaveType;
  int? selectleaveId;
  var employeeId;
  var companyId;
  var from;
  var totalDays;
  @override
  void initState() {
    initPrefs();

    super.initState();
  }

  UserModel _userModel = UserModel();
  var compOffBalance;
  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refresh_token = prefs.getString("refresh_token");
    http.Response res = await http.post(
        Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
        headers: {"refresh_token": refresh_token.toString()});
    var jsonResponse = jsonDecode(res.body);

    print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
    await prefs.setString("token", jsonResponse["token"]);
    token = prefs.getString("token");
    setState(() {
      String decodedMap = prefs.getString('Users') ?? "";
      _userModel = userModelFromMap(decodedMap);
      companyId = _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.onRollCompany?.id
          : _userModel
              .userData?.employee?.employeeOffrollment?.offRollCompany?.id;
      compOffBalance = prefs.getBool("compOffBalance");
      print(compOffBalance);
    });

    _getLeaveList();
  }

  List<LeaveTypee> allLeave = List.empty(growable: true);
  dynamic leaveData;

  void _getLeaveList() async {
    String url =
        '${TextConstant.baseURL}/api/leave/leave-type/list?companyId=$companyId';
    try {
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = await prefs.getInt('UserId');
      setState(() {
        employeeId = value;
      });

      leaveData = jsonDecode(res.body);
      for (int i = 0; i < leaveData.length; i++) {
        allLeave.add(
          LeaveTypee(leaveData[i]["id"], leaveData[i]["name"]),
        );
      }
      if (compOffBalance == true) {
        allLeave.add(LeaveTypee(4, "Compensatory Off Leave"));
      }

      print(allLeave);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nLoading Again.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ApplyLeaves(),
      ));
    }
    setState(() {});
  }

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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: leaveData == null
                    ? Align(
                        heightFactor: 6,
                        alignment: Alignment.center,
                        child: Lottie.asset("assets/loading.json", height: 100))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "Leaves",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Apply Leaves",
                                    style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    "Leave Type*",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropdownButtonFormField<String>(
                                    validator: (value) {
                                      if (value == null) {
                                        return ("Select Leave Type");
                                      }
                                      return null;
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 17),
                                        hintText: "Select Leave",
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
                                    value: selectedLeaveType,
                                    items: allLeave
                                        .map((ite) => DropdownMenuItem<String>(
                                            value: ite.id.toString(),
                                            child: Text(
                                              ite.name,
                                            )))
                                        .toList(),
                                    onChanged: (item) {
                                      selectedLeaveType = item! as String?;
                                      setState(() {
                                        selectleaveId = int.parse(item);
                                      });
                                      toDate.text = "";
                                      print(selectedLeaveType);
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "From*",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomWidgets.textField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ("Select Date");
                                                }
                                                return null;
                                              },
                                              textController: fromDate,
                                              width: 140,
                                              height: 70,
                                              readOnly: true,
                                              hintText: "Select Date",
                                              lines: 1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8),
                                              onTap: () async {
                                                from = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2050));
                                                fromDate.text = from
                                                    .toString()
                                                    .substring(0, 10);
                                                print(fromDate.text);
                                              },
                                              suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black54,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Half",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 140,
                                            child:
                                                DropdownButtonFormField<String>(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 10),
                                                  hintText: "Select Half",
                                                  hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 136, 136, 136),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    227,
                                                                    227,
                                                                    227),
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true),
                                              isExpanded: false,
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              iconSize: 30,
                                              value: selectedFromHalf,
                                              items: fromHalf
                                                  .map((item) => DropdownMenuItem<
                                                          String>(
                                                      value: item,
                                                      child: Text(item,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))))
                                                  .toList(),
                                              onChanged: (item) {
                                                selectedFromHalf = item!;
                                              },
                                              onSaved: (newValue) {
                                                newValue = selectedFromHalf;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To*",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomWidgets.textField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ("Select Date");
                                                }
                                                return null;
                                              },
                                              textController: toDate,
                                              width: 140,
                                              height: 70,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              readOnly: true,
                                              hintText: "Select Date",
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8),
                                              onTap: () async {
                                                var to = await showDatePicker(
                                                    context: context,
                                                    initialDate:
                                                        selectedLeaveType == "4"
                                                            ? from
                                                            : DateTime.now(),
                                                    firstDate:
                                                        selectedLeaveType == "4"
                                                            ? from
                                                            : DateTime.now(),
                                                    lastDate:
                                                        selectedLeaveType == "4"
                                                            ? DateTime.parse(from
                                                                    .toString())
                                                                .add(Duration(
                                                                    days: 1))
                                                            : DateTime(2050));
                                                toDate.text = to
                                                    .toString()
                                                    .substring(0, 10);

                                                print(toDate.text);
                                                if (fromDate.text ==
                                                    toDate.text) {
                                                  totalDays = 1;
                                                  print("1");
                                                } else {
                                                  totalDays = 2;
                                                  print("2");
                                                }
                                              },
                                              suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black54,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Half",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 140,
                                            child:
                                                DropdownButtonFormField<String>(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 10),
                                                  hintText: "Select Half",
                                                  hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 136, 136, 136),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    227,
                                                                    227,
                                                                    227),
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true),
                                              isExpanded: false,
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              iconSize: 30,
                                              value: selectedToHalf,
                                              items: toHalf
                                                  .map((item) => DropdownMenuItem<
                                                          String>(
                                                      value: item,
                                                      child: Text(item,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))))
                                                  .toList(),
                                              onChanged: (item) {
                                                selectedToHalf = item!;
                                              },
                                              onSaved: (newValue) {
                                                newValue = selectedToHalf;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  selectedLeaveType == "4"
                                      ? Container()
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Reason for Leave*",
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            CustomWidgets.textField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ("Type Reason");
                                                }
                                                return null;
                                              },
                                              lines: 3,
                                              hintText: "Type here ...",
                                              textController: reason,
                                            ),
                                          ],
                                        ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 123, 123, 123),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,

                                            //maximumSize: Size(7, 3),
                                            minimumSize: const Size(100, 40),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 232, 232, 232),
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0))),
                                      ),
                                      nextPage == true
                                          ? const CircularProgressIndicator(
                                              color: AppColors.maincolor)
                                          : ElevatedButton(
                                              onPressed: () async {
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }
                                                setState(() {
                                                  nextPage = true;
                                                });
                                                if (selectedLeaveType == "4") {
                                                  postCompOffLeave();
                                                } else {
                                                  postApplyLeave();
                                                }
                                              },
                                              child: Text(
                                                "Apply",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 30, 67, 159),

                                                  //maximumSize: Size(7, 3),
                                                  minimumSize:
                                                      const Size(100, 40),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0))),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
              )),
        ));
  }

  var token;
  void postApplyLeave() async {
    try {
      final uri =
          Uri.parse("${TextConstant.baseURL}/api/leave/leave-request/add");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      };

      Map<String, dynamic> body = {
        "companyId": companyId,
        "leaveTypeId": selectleaveId,
        "employeeId": employeeId,
        "startDateTime": fromDate.text,
        "endDateTime": toDate.text,
        "status": "pending",
        "reasonForLeave": reason.text,
      };
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'x-access-token': token
        },
        body: jsonBody,
        encoding: encoding,
      );

      int statusCode = response.statusCode;
      print(statusCode);
      var responseBody = response.body;
      if (statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Leaves(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color.fromARGB(255, 10, 182, 53),
              content: Text(
                "Leave Applied",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                ),
              )),
        );
      } else if (statusCode != 200) {
        setState(() {
          nextPage = false;
        });
        if (response.body.isNotEmpty) {
          var errMsg = json.decode(responseBody);

          if (errMsg["message"] == "Must be greater than 10 words") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Reason for leave must be greater than 10 words")));
          } else if (errMsg["msg"] == "Leave Request created successfully") {
            setState(() {
              nextPage = true;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Leaves(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errMsg["message"].toString())));
          }

          setState(() {
            nextPage == false;
          });
        }
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nIt may take some time.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ApplyLeaves(),
      ));
    }
  }

  //POST COMP OFF LEAVE

  void postCompOffLeave() async {
    try {
      final uri =
          Uri.parse("${TextConstant.baseURL}/api/comp-off/leave-request/apply");
      final headers = {
        'Content-Type': 'application/json',
        'Accept': '*/*',
      };

      Map<String, dynamic> body = {
        "status": "pending",
        "startDateTime": fromDate.text,
        "endDateTime": toDate.text,
        "totalCompOffDays": totalDays,
        "companyId": companyId,
        "employeeId": employeeId
      };
      print(body);
      String jsonBody = json.encode(body);
      final encoding = Encoding.getByName('utf-8');

      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'x-access-token': token
        },
        body: jsonBody,
        encoding: encoding,
      );

      int statusCode = response.statusCode;
      print(statusCode);
      var responseBody = response.body;
      if (statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => Leaves(),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color.fromARGB(255, 10, 182, 53),
              content: Text(
                "Leave Applied",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                ),
              )),
        );
      } else if (statusCode != 200) {
        setState(() {
          nextPage = false;
        });
        if (response.body.isNotEmpty) {
          var errMsg = json.decode(responseBody);

          if (errMsg["message"] == "Must be greater than 10 words") {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("Reason for leave must be greater than 10 words")));
          } else if (errMsg["msg"] == "Leave Request created successfully") {
            setState(() {
              nextPage = true;
            });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => Leaves(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(errMsg["message"].toString())));
          }

          setState(() {
            nextPage == false;
          });
        }
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nIt may take some time.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ApplyLeaves(),
      ));
    }
  }
}

//Leave Details

class LeaveDetails extends StatefulWidget {
  int id;
  LeaveDetails({super.key, required this.id});

  @override
  State<LeaveDetails> createState() => _LeaveDetailsState();
}

class _LeaveDetailsState extends State<LeaveDetails> {
  var color;
  var token;
  @override
  void initState() {
    initPrefs();
    super.initState();
  }

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

    _storeleaveId();
    _getLeaveDetails();
  }

  var leaveId;
  void _storeleaveId() {
    int id = widget.id;
    setState(() {
      leaveId = id;
    });
  }

  @override
  void dispose() {
    _getLeaveDetails();
    super.dispose();
  }

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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: leaveData == null
                  ? Align(
                      heightFactor: 6,
                      alignment: Alignment.center,
                      child: Lottie.asset("assets/loading.json", height: 100))
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                "Leaves",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            //  height: 600,
                            width: 400,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 227, 227, 227),
                                      blurRadius: 2,
                                      spreadRadius: 1)
                                ]),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Leave Details",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.darkgrey),
                                    ),
                                    Text(
                                      leaveData["status"]
                                          .toString()
                                          .capitalized(),
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400,
                                          color: color),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black12,
                                  height: 35,
                                  thickness: 2,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: AppColors.maincolor,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "From",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.maincolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  "(First Half)",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          AppColors.maincolor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              DateFormat('dd.MM.yy').format(
                                                  DateTime.parse(leaveData[
                                                      "startDateTime"])),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.maincolor,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.calendar_month,
                                          color: AppColors.maincolor,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "To",
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color:
                                                          AppColors.maincolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Text(
                                                  "(First Half)",
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color:
                                                          AppColors.maincolor,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 6,
                                            ),
                                            Text(
                                              DateFormat('dd.MM.yy').format(
                                                  DateTime.parse(leaveData[
                                                      "endDateTime"])),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: AppColors.maincolor,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 227, 227, 227),
                                            blurRadius: 1,
                                            spreadRadius: 0.5)
                                      ]),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Total Days:",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkgrey),
                                      ),
                                      SizedBox(
                                        width: 0.2.sw,
                                      ),
                                      VerticalDivider(
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                        width: 0.20.sw,
                                      ),
                                      Text(
                                        "${leaveData["totalLeavesToConsider"]} Days",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.darkgrey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 227, 227, 227),
                                            blurRadius: 1,
                                            spreadRadius: 0.5)
                                      ]),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Date Requested:",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkgrey),
                                      ),
                                      SizedBox(
                                        width: 0.12.sw,
                                      ),
                                      VerticalDivider(
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                        width: 0.20.sw,
                                      ),
                                      Text(
                                        DateFormat('dd.MM.yy').format(
                                            DateTime.parse(
                                                leaveData["createdAt"])),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.darkgrey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 227, 227, 227),
                                            blurRadius: 1,
                                            spreadRadius: 0.5)
                                      ]),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Leave Type:",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkgrey),
                                      ),
                                      SizedBox(
                                        width: 0.2.sw,
                                      ),
                                      VerticalDivider(
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                        width: 0.13.sw,
                                      ),
                                      Container(
                                        width: 89,
                                        child: Text(
                                          leaveData["leaveType"]["name"],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.darkgrey),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 227, 227, 227),
                                            blurRadius: 1,
                                            spreadRadius: 0.5)
                                      ]),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Remaining Balance:",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkgrey),
                                      ),
                                      SizedBox(
                                        width: 0.07.sw,
                                      ),
                                      VerticalDivider(
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                        width: 0.25.sw,
                                      ),
                                      Text(
                                        leaveData["leaveAvailable"] == null
                                            ? ""
                                            : "${leaveData["leaveAvailable"]["leaveRemaining"].toStringAsFixed(2)}",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.darkgrey),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Color.fromARGB(
                                                255, 227, 227, 227),
                                            blurRadius: 1,
                                            spreadRadius: 0.5)
                                      ]),
                                  child: Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Reason for Leave:",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.darkgrey),
                                      ),
                                      SizedBox(
                                        width: 0.1.sw,
                                      ),
                                      VerticalDivider(
                                        thickness: 1.5,
                                      ),
                                      SizedBox(
                                        width: 0.10.sw,
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Container(
                                          width: 200,
                                          child: Text(
                                            leaveData["reasonForLeave"],
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.darkgrey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Visibility(
                                  visible: visible,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    height: 50,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.transparent),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Color.fromARGB(
                                                  255, 227, 227, 227),
                                              blurRadius: 1,
                                              spreadRadius: 0.5)
                                        ]),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Approved By:",
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppColors.darkgrey),
                                        ),
                                        Align(
                                          child: VerticalDivider(
                                            thickness: 1.5,
                                          ),
                                        ),
                                        Text(
                                          leaveData["approvingAuth"] == null
                                              ? ""
                                              : leaveData["approvingAuth"]
                                                  ["fullName"],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.darkgrey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // ElevatedButton(
                              //   onPressed: () {},
                              //   child: Text(
                              //     "Cancel Request",
                              //     style: TextStyle(
                              //         color: Color.fromARGB(255, 123, 123, 123),
                              //         fontSize: 17,
                              //         fontWeight: FontWeight.w500),
                              //   ),
                              //   style: ElevatedButton.styleFrom(
                              //       backgroundColor: Colors.white,

                              //       //maximumSize: Size(7, 3),
                              //       minimumSize: const Size(100, 40),
                              //       elevation: 0,
                              //       shape: RoundedRectangleBorder(
                              //           side: BorderSide(
                              //               color: Color.fromARGB(
                              //                   255, 232, 232, 232),
                              //               width: 1.5),
                              //           borderRadius:
                              //               BorderRadius.circular(8.0))),
                              // ),
                              ElevatedButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          EditLeaveRequest(id: leaveData["id"]),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Edit Request",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 30, 67, 159),

                                    //maximumSize: Size(7, 3),
                                    minimumSize: const Size(160, 40),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            color: Colors.transparent,
                                            width: 1.5),
                                        borderRadius:
                                            BorderRadius.circular(8.0))),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ])),
        ));
  }

  dynamic leaveData;
  var visible;
  void _getLeaveDetails() async {
    print(leaveId);
    try {
      List<LeaveDetailsData> allData = List.empty(growable: true);
      String url = '${TextConstant.baseURL}/api/leave/leave-detail/$leaveId';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      leaveData = jsonDecode(res.body);

      if (leaveData["status"] == "rejected") {
        color = Colors.red;
        visible = true;
      }
      if (leaveData["status"] == "approved") {
        color = Colors.green;
        visible = true;
      }
      if (leaveData["status"] == "pending") {
        color = Color.fromARGB(255, 230, 209, 27);
        visible = false;
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nIt may take some time.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      _getLeaveDetails();
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
//Edit Leave Request

class EditLeaveRequest extends StatefulWidget {
  int id;
  EditLeaveRequest({super.key, required this.id});

  @override
  State<EditLeaveRequest> createState() => _EditLeaveRequestState();
}

class _EditLeaveRequestState extends State<EditLeaveRequest> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
//  TextEditingController reason = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedFromHalf;
  String? selectedToHalf;
  var fromHalf = [
    'First Half',
    'Second Half',
  ];
  var toHalf = [
    'First Half',
    'Second Half',
  ];
  bool nextPage = false;
  String? selectedLeaveType;
  int? selectleaveId;
  var employeeId;
  var companyId;
  UserModel _userModel = UserModel();

  var leaveId;

  _storeleaveId() {
    int id = widget.id;
    setState(() {
      leaveId = id;
    });
    _getLeaveList();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  bool loaded = true;
  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refresh_token = prefs.getString("refresh_token");
    http.Response res = await http.post(
        Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
        headers: {"refresh_token": refresh_token.toString()});
    var jsonResponse = jsonDecode(res.body);

    print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
    await prefs.setString("token", jsonResponse["token"]);
    token = prefs.getString("token");

    setState(() {
      String decodedMap = prefs.getString('Users') ?? "";
      _userModel = userModelFromMap(decodedMap);
      companyId = _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.onRollCompany?.id
          : _userModel
              .userData?.employee?.employeeOffrollment?.offRollCompany?.id;
    });
    _storeleaveId();

    print(leaveId);
  }

  List<LeaveTypee> allLeave = List.empty(growable: true);

  var helpTextStartDate1 = "";
  var helpTextStartDate2 = "";
  var helpTextEndDate1 = "";
  var helpTextEndDate2 = "";

  var helpTextReason2 = "";
  var leaveType;
  var leaveTypeIdDefault;
  var leaveTypeIdChange;
  bool leaveTypeChange = false;
  bool reasonChange = false;
  bool startDateChange = false;
  bool endDateChange = false;
  TextEditingController? editFromDate;
  TextEditingController? editToDate;
  TextEditingController? editReason;
  @override
  Widget build(BuildContext context) {
    if (loaded == false) {
      leaveTypeIdDefault = leaveData["leaveType"]["id"];
      leaveType = leaveData["leaveType"]["name"];
      editFromDate = TextEditingController(
          text: DateFormat('dd.MM.yy')
              .format(DateTime.parse(leaveData["startDateTime"])));
      editToDate = TextEditingController(
          text: DateFormat('dd.MM.yy')
              .format(DateTime.parse(leaveData["endDateTime"])));
      editReason = TextEditingController(text: leaveData["reasonForLeave"]);
    }

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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: loaded == true
                    ? Align(
                        heightFactor: 6,
                        alignment: Alignment.center,
                        child: Lottie.asset("assets/loading.json", height: 100))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "Edit Leaves",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                //  mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Leave Type*",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(10),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 17),
                                        hintText: leaveType,
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
                                    value: selectedLeaveType,
                                    items: allLeave
                                        .map((ite) => DropdownMenuItem<String>(
                                            value: ite.id.toString(),
                                            child: Text(
                                              ite.name,
                                            )))
                                        .toList(),
                                    onChanged: (item) {
                                      selectedLeaveType = item! as String?;
                                      setState(() {
                                        leaveTypeChange = true;
                                        selectleaveId = int.parse(item);
                                        leaveTypeIdChange = selectleaveId;
                                      });
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "From*",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomWidgets.textField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ("Select Date");
                                                }
                                                return null;
                                              },
                                              textController: editFromDate,
                                              width: 140,
                                              height: 70,
                                              readOnly: true,
                                              hintText: "Select Date",
                                              lines: 1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8),
                                              onTap: () async {
                                                var from = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2050));
                                                fromDate.text = from
                                                    .toString()
                                                    .substring(0, 10);
                                                setState(() {
                                                  leaveData["startDateTime"] =
                                                      from.toString();

                                                  helpTextStartDate2 =
                                                      from.toString();
                                                });
                                              },
                                              suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black54,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Half",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 140,
                                            child:
                                                DropdownButtonFormField<String>(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 10),
                                                  hintText: "Select Half",
                                                  hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 136, 136, 136),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    227,
                                                                    227,
                                                                    227),
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true),
                                              isExpanded: false,
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              iconSize: 30,
                                              value: selectedFromHalf,
                                              items: fromHalf
                                                  .map((item) => DropdownMenuItem<
                                                          String>(
                                                      value: item,
                                                      child: Text(item,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))))
                                                  .toList(),
                                              onChanged: (item) {
                                                selectedFromHalf = item!;
                                              },
                                              onSaved: (newValue) {
                                                newValue = selectedFromHalf;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To*",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomWidgets.textField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ("Select Date");
                                                }
                                                return null;
                                              },
                                              textController: editToDate,
                                              width: 140,
                                              height: 70,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              readOnly: true,
                                              hintText: "Select Date",
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8),
                                              onTap: () async {
                                                var to = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime.now(),
                                                    lastDate: DateTime(2050));
                                                toDate.text = to
                                                    .toString()
                                                    .substring(0, 10);
                                                setState(() {
                                                  leaveData["endDateTime"] =
                                                      to.toString();

                                                  helpTextEndDate2 =
                                                      to.toString();
                                                });
                                              },
                                              suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black54,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Half",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 140,
                                            child:
                                                DropdownButtonFormField<String>(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 10),
                                                  hintText: "Select Half",
                                                  hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 136, 136, 136),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    227,
                                                                    227,
                                                                    227),
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true),
                                              isExpanded: false,
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              iconSize: 30,
                                              value: selectedToHalf,
                                              items: toHalf
                                                  .map((item) => DropdownMenuItem<
                                                          String>(
                                                      value: item,
                                                      child: Text(item,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))))
                                                  .toList(),
                                              onChanged: (item) {
                                                selectedToHalf = item!;
                                              },
                                              onSaved: (newValue) {
                                                newValue = selectedToHalf;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    "Reason for Leave*",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  CustomWidgets.textField(
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return ("Type Reason");
                                      }
                                      return null;
                                    },
                                    lines: 3,
                                    onChange: (text) {
                                      reasonChange = true;
                                      leaveData["reasonForLeave"] = text;
                                      helpTextReason2 = text;
                                    },
                                    textController: editReason,
                                  ),
                                  SizedBox(
                                    height: 70,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 123, 123, 123),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,

                                            //maximumSize: Size(7, 3),
                                            minimumSize: const Size(100, 40),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 232, 232, 232),
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0))),
                                      ),
                                      nextPage == true
                                          ? const CircularProgressIndicator(
                                              color: AppColors.maincolor)
                                          : ElevatedButton(
                                              onPressed: () async {
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }
                                                setState(() {
                                                  nextPage = true;
                                                });

                                                try {
                                                  final uri = Uri.parse(
                                                      "${TextConstant.baseURL}/api/leave/leave-request/edit");

                                                  Map<String, dynamic> body = {
                                                    "employeeId": employeeId,
                                                    "companyId": companyId,
                                                    "leaveId": leaveId,
                                                    "leaveTypeId":
                                                        leaveTypeChange == true
                                                            ? leaveTypeIdChange
                                                            : leaveTypeIdDefault,
                                                    "startDateTime":
                                                        startDateChange == true
                                                            ? helpTextStartDate2
                                                            : leaveData[
                                                                "startDateTime"],
                                                    "endDateTime":
                                                        endDateChange == true
                                                            ? helpTextEndDate2
                                                            : leaveData[
                                                                "endDateTime"],
                                                    "reasonForLeave":
                                                        reasonChange == true
                                                            ? helpTextReason2
                                                            : leaveData[
                                                                "reasonForLeave"],
                                                  };
                                                  print(body);
                                                  String jsonBody =
                                                      json.encode(body);
                                                  final encoding =
                                                      Encoding.getByName(
                                                          'utf-8');

                                                  var response =
                                                      await http.post(
                                                    uri,
                                                    headers: {
                                                      'Content-Type':
                                                          'application/json',
                                                      'Accept': '*/*',
                                                      'x-access-token': token
                                                    },
                                                    body: jsonBody,
                                                    encoding: encoding,
                                                  );

                                                  int statusCode =
                                                      response.statusCode;
                                                  print(statusCode);
                                                  var responseBody =
                                                      response.body;
                                                  if (statusCode == 200) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Leaves(),
                                                      ),
                                                    );
                                                  } else if (statusCode !=
                                                      200) {
                                                    setState(() {
                                                      nextPage = false;
                                                    });
                                                    if (response
                                                        .body.isNotEmpty) {
                                                      var errMsg = json
                                                          .decode(responseBody);

                                                      if (errMsg["message"] ==
                                                          "Must be greater than 10 words") {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Reason for leave must be greater than 10 words")));
                                                      } else if (errMsg[
                                                              "msg"] ==
                                                          "Leave Request created successfully") {
                                                        setState(() {
                                                          nextPage = true;
                                                        });
                                                        Navigator
                                                            .pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (BuildContext
                                                                    context) =>
                                                                Leaves(),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(errMsg[
                                                                        "message"]
                                                                    .toString())));
                                                      }

                                                      setState(() {
                                                        nextPage == false;
                                                      });
                                                    }
                                                  }
                                                } on Exception catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              AppColors
                                                                  .maincolor,
                                                          content: Text(
                                                            "${e.toString()} \nIt may take some time.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          )));
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ApplyLeaves(),
                                                  ));
                                                }
                                              },
                                              child: Text(
                                                "Apply",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 30, 67, 159),

                                                  //maximumSize: Size(7, 3),
                                                  minimumSize:
                                                      const Size(100, 40),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0))),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
              )),
        ));
  }

  _getLeaveList() async {
    String url =
        '${TextConstant.baseURL}/api/leave/leave-type/list?companyId=$companyId';
    try {
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = await prefs.getInt('UserId');
      setState(() {
        employeeId = value;
      });

      leaveData = jsonDecode(res.body);
      for (int i = 0; i < leaveData.length; i++) {
        allLeave.add(LeaveTypee(leaveData[i]["id"], leaveData[i]["name"]));
      }
      _getLeaveDetails();
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nLoading Again.",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const ApplyLeaves(),
      ));
    }
    setState(() {});
  }

  var token;
  dynamic leaveData;
  _getLeaveDetails() async {
    try {
      String url = '${TextConstant.baseURL}/api/leave/leave-detail/$leaveId';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      if (res.statusCode == 200) {
        leaveData = jsonDecode(res.body);
        loaded = false;
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()}",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      _getLeaveDetails();
    }
    if (!mounted) return;
    setState(() {});
  }
}

//Comp Off Edit Leave Request

class CompOffEditLeaveRequest extends StatefulWidget {
  int id;
  var startDate;
  var endDate;
  CompOffEditLeaveRequest(
      {super.key,
      required this.id,
      required this.startDate,
      required this.endDate});

  @override
  State<CompOffEditLeaveRequest> createState() =>
      _CompOffEditLeaveRequestState();
}

class _CompOffEditLeaveRequestState extends State<CompOffEditLeaveRequest> {
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedFromHalf;
  String? selectedToHalf;
  var fromHalf = [
    'First Half',
    'Second Half',
  ];
  var toHalf = [
    'First Half',
    'Second Half',
  ];
  bool nextPage = false;
  String? selectedLeaveType;
  int? selectleaveId;
  var employeeId;
  var companyId;
  UserModel _userModel = UserModel();
  var startDate;
  var endDate;
  var leaveId;
  var token;
  var totalDays;
  _storeleaveId() {
    int id = widget.id;
    startDate = widget.startDate;
    endDate = widget.endDate;
    setState(() {
      leaveId = id;
    });
    print(startDate);
    print(endDate);
    setState(() {
      loaded = false;
    });
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  bool loaded = true;
  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refresh_token = prefs.getString("refresh_token");
    http.Response res = await http.post(
        Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
        headers: {"refresh_token": refresh_token.toString()});
    var jsonResponse = jsonDecode(res.body);

    print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
    await prefs.setString("token", jsonResponse["token"]);
    token = prefs.getString("token");

    _storeleaveId();
    setState(() {
      String decodedMap = prefs.getString('Users') ?? "";
      _userModel = userModelFromMap(decodedMap);
      companyId = _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.onRollCompany?.id
          : _userModel
              .userData?.employee?.employeeOffrollment?.offRollCompany?.id;
    });
  }

  List<String> allLeave = ["Comp Off"];

  var helpTextStartDate1 = "";
  var helpTextStartDate2 = "";
  var helpTextEndDate1 = "";
  var helpTextEndDate2 = "";
  var helpTextDaysDate1 = "";
  var helpTextDaysDate2;
  var from;
  TextEditingController? editFromDate;
  TextEditingController? editToDate;
  @override
  Widget build(BuildContext context) {
    if (loaded == false) {
      editFromDate = TextEditingController(
          text: DateFormat('dd.MM.yy').format(DateTime.parse(startDate)));
      editToDate = TextEditingController(
          text: DateFormat('dd.MM.yy').format(DateTime.parse(endDate)));
    }

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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: (loaded == true)
                  ? Align(
                      heightFactor: 6,
                      alignment: Alignment.center,
                      child: Lottie.asset("assets/loading.json", height: 100))
                  : Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  "Edit Leaves",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Leave Type*",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  DropdownButtonFormField<String>(
                                    borderRadius: BorderRadius.circular(10),
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0.0, horizontal: 17),
                                        hintText: "Compensatory Leave",
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
                                    value: selectedLeaveType,
                                    items: allLeave
                                        .map((ite) => DropdownMenuItem<String>(
                                            value: "a",
                                            child: Text("Compensatory Leave")))
                                        .toList(),
                                    onChanged: (item) {
                                      // selectedLeaveType = item! as String?;
                                      // setState(() {
                                      //   helpLeavetype1 = "leaveType";
                                      //   helpLeavetype2 = selectedLeaveType!;
                                      //   selectleaveId = int.parse(item);
                                      // });
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "From*",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomWidgets.textField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ("Select Date");
                                                }
                                                return null;
                                              },
                                              textController: editFromDate,
                                              width: 140,
                                              height: 70,
                                              readOnly: true,
                                              hintText: "Select Date",
                                              lines: 1,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8),
                                              onTap: () async {
                                                from = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.parse(
                                                        startDate),
                                                    firstDate: DateTime.parse(
                                                        startDate),
                                                    lastDate: DateTime(2050));
                                                fromDate.text = from
                                                    .toString()
                                                    .substring(0, 10);
                                                setState(() {
                                                  startDate = from.toString();
                                                  helpTextStartDate1 =
                                                      "startDateTime";
                                                  helpTextStartDate2 =
                                                      // DateFormat('dd.MM.yy')
                                                      //     .format(from);
                                                      from.toString();
                                                });
                                              },
                                              suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black54,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Half",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 140,
                                            child:
                                                DropdownButtonFormField<String>(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 10),
                                                  hintText: "Select Half",
                                                  hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 136, 136, 136),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    227,
                                                                    227,
                                                                    227),
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true),
                                              isExpanded: false,
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              iconSize: 30,
                                              value: selectedFromHalf,
                                              items: fromHalf
                                                  .map((item) => DropdownMenuItem<
                                                          String>(
                                                      value: item,
                                                      child: Text(item,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))))
                                                  .toList(),
                                              onChanged: (item) {
                                                selectedFromHalf = item!;
                                              },
                                              onSaved: (newValue) {
                                                newValue = selectedFromHalf;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "To*",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          CustomWidgets.textField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return ("Select Date");
                                                }
                                                return null;
                                              },
                                              textController: editToDate,
                                              width: 140,
                                              height: 70,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                              readOnly: true,
                                              hintText: "Select Date",
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 8),
                                              onTap: () async {
                                                var to = await showDatePicker(
                                                    context: context,
                                                    initialDate: DateTime.parse(
                                                        startDate),
                                                    firstDate: DateTime.parse(
                                                        startDate),
                                                    lastDate: DateTime.parse(
                                                            from.toString())
                                                        .add(
                                                            Duration(days: 1)));
                                                toDate.text = to
                                                    .toString()
                                                    .substring(0, 10);
                                                setState(() {
                                                  endDate = to.toString();
                                                  helpTextEndDate1 =
                                                      "endDateTime";
                                                  helpTextEndDate2 =
                                                      // DateFormat('dd.MM.yy')
                                                      //     .format(to!);
                                                      to.toString();
                                                  if (fromDate.text ==
                                                      toDate.text) {
                                                    totalDays = 1;
                                                    print("1");
                                                  } else {
                                                    totalDays = 2;
                                                    print("2");
                                                  }
                                                  helpTextDaysDate1 =
                                                      "totalCompOffDays";
                                                  helpTextDaysDate2 = totalDays;
                                                });
                                              },
                                              suffixIcon: Icon(
                                                Icons.calendar_month,
                                                color: Colors.black54,
                                                size: 20,
                                              )),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Select Half",
                                            style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: 140,
                                            child:
                                                DropdownButtonFormField<String>(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              decoration: InputDecoration(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 0.0,
                                                          horizontal: 10),
                                                  hintText: "Select Half",
                                                  hintStyle: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromARGB(
                                                        255, 136, 136, 136),
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    227,
                                                                    227,
                                                                    227),
                                                            width: 1.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide:
                                                        const BorderSide(
                                                            color: Colors.grey),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  fillColor: Colors.white,
                                                  filled: true),
                                              isExpanded: false,
                                              icon: const Icon(Icons
                                                  .arrow_drop_down_outlined),
                                              iconSize: 30,
                                              value: selectedToHalf,
                                              items: toHalf
                                                  .map((item) => DropdownMenuItem<
                                                          String>(
                                                      value: item,
                                                      child: Text(item,
                                                          style: const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400))))
                                                  .toList(),
                                              onChanged: (item) {
                                                selectedToHalf = item!;
                                              },
                                              onSaved: (newValue) {
                                                newValue = selectedToHalf;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 180,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 123, 123, 123),
                                              fontSize: 17,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,

                                            //maximumSize: Size(7, 3),
                                            minimumSize: const Size(100, 40),
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                                side: BorderSide(
                                                    color: Color.fromARGB(
                                                        255, 232, 232, 232),
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        8.0))),
                                      ),
                                      nextPage == true
                                          ? const CircularProgressIndicator(
                                              color: AppColors.maincolor)
                                          : ElevatedButton(
                                              onPressed: () async {
                                                if (!_formKey.currentState!
                                                    .validate()) {
                                                  return;
                                                }
                                                setState(() {
                                                  nextPage = true;
                                                });

                                                try {
                                                  final uri = Uri.parse(
                                                      "${TextConstant.baseURL}/api/comp-off/leave-request/edit");
                                                  Map<String, dynamic> body = {
                                                    helpTextStartDate1:
                                                        "${helpTextStartDate2}Z",
                                                    helpTextEndDate1:
                                                        "${helpTextEndDate2}Z",
                                                    helpTextDaysDate1:
                                                        helpTextDaysDate2,
                                                    "compOffLeaveId": leaveId
                                                  };
                                                  String jsonBody =
                                                      json.encode(body);
                                                  final encoding =
                                                      Encoding.getByName(
                                                          'utf-8');

                                                  var response =
                                                      await http.patch(
                                                    uri,
                                                    headers: {
                                                      'Content-Type':
                                                          'application/json',
                                                      'Accept': '*/*',
                                                      'x-access-token': token
                                                    },
                                                    body: jsonBody,
                                                    encoding: encoding,
                                                  );
                                                  print(body);
                                                  int statusCode =
                                                      response.statusCode;
                                                  print(statusCode);
                                                  var responseBody =
                                                      response.body;
                                                  if (statusCode == 200) {
                                                    print(responseBody);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            Leaves(),
                                                      ),
                                                    );
                                                  }
                                                } on Exception catch (e) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          backgroundColor:
                                                              AppColors
                                                                  .maincolor,
                                                          content: Text(
                                                            "${e.toString()} \nIt may take some time.",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18),
                                                          )));
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ApplyLeaves(),
                                                  ));
                                                }
                                              },
                                              child: Text(
                                                "Apply",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 30, 67, 159),

                                                  //maximumSize: Size(7, 3),
                                                  minimumSize:
                                                      const Size(100, 40),
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      side: BorderSide(
                                                          color: Colors
                                                              .transparent,
                                                          width: 1.5),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0))),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                    )),
        ));
  }
}
