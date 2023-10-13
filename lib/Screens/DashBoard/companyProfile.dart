// ignore_for_file: non_constant_identifier_names, unused_field, prefer_typing_uninitialized_variables, prefer_const_constructors, prefer_if_null_operators, avoid_unnecessary_containers, file_names, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Models/userdataModel.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CompanyProfile extends StatefulWidget {
  const CompanyProfile({super.key});

  @override
  State<CompanyProfile> createState() => _CompanyProfileState();
}

class _CompanyProfileState extends State<CompanyProfile> {
  List<String> svg = [
    "assets/WorkProfilePNG/One.png",
    "assets/CompanyProfilePNG/2.png",
    "assets/CompanyProfilePNG/3.png",
    "assets/CompanyProfilePNG/4.png",
    "assets/WorkProfilePNG/Five.png",
    "assets/WorkProfilePNG/Seven.png",
    // "assets/WorkProfilePNG/Two.png",
  ];
  List<String> clientHeader = [
    "Company Name:",
    "Designation:",
    "Employee Code:",
    "Department:",
    "Location:",
    "Address:",
    //"Reporting Manager:",
    "Pincode:"
  ];
  List<String> companyHeader = [
    "Company Name:",
    "Designation:",
    // "Reporting Manager:",
    "Department:",
  ];
  List companySubHeader = [];

  UserModel _userModel = UserModel();
  static var compName, designation, empId, Dep, Loc, Add, RepMan, Pin;

  List clientSubHeader = [];
  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String decodedMap = prefs.getString('Users') ?? "";
    _userModel = userModelFromMap(decodedMap);

    setState(() {
      compName = _userModel.userData?.employee?.employeeOffrollment == null ||
              _userModel.userData?.employee?.employeeOffrollment?.offRollCompany
                      ?.name ==
                  null
          ? _userModel
              .userData?.employee?.employeeOnrollment?.onRollCompany?.name
          : _userModel
              .userData?.employee?.employeeOffrollment?.offRollCompany?.name;
      designation = _userModel.userData?.employee?.employeeOffrollment ==
                  null ||
              _userModel.userData?.employee?.employeeOffrollment?.designation ==
                  null
          ? _userModel.userData?.employee?.employeeOnrollment?.designation
          : _userModel.userData?.employee?.employeeOffrollment?.designation;
      // empId = _userModel.userData?.employee?.employeeCode == null ||
      //         _userModel.userData!.employee!.employeeCode!.isEmpty
      //     ? " "
      //     : _userModel.userData?.employee?.employeeCode;
      Dep = _userModel.userData?.employee?.employeeOffrollment == null ||
              _userModel.userData?.employee?.employeeOffrollment?.department ==
                  null
          ? _userModel.userData?.employee?.employeeOnrollment?.department
          : _userModel.userData?.employee?.employeeOffrollment?.department;
      // Loc = _userModel.userData?.employee?.employeeOffrollment?.location ==
      //             null ||
      //         _userModel.userData?.employee?.employeeOffrollment == null
      //     ? " "
      //     : _userModel.userData?.employee?.employeeOffrollment?.location?.name;
      // Add = _userModel.userData?.employee?.addresses == null ||
      //         _userModel.userData!.employee!.addresses!.isEmpty ||
      //         _userModel.userData?.employee?.addresses![0].addressLine1 == null
      //     ? " "
      //     : _userModel.userData?.employee?.addresses![0].addressLine1;
      clientSubHeader = [
        compName,
        designation,
        // empId.toString(),
        Dep,
        //Loc,
        //Add,
      ];
      companySubHeader = [
        compName,
        designation,
        Dep,
      ];
    });
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
              child: _userModel.userData == null
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
                                "Company Profile",
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
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text(
                                //   "CLIENT DETAILS",
                                //   style: TextStyle(
                                //       color: AppColors.maincolor,
                                //       fontSize: 16,
                                //       fontWeight: FontWeight.w600,
                                //       letterSpacing: 0.6),
                                // ),
                                // Container(
                                //   child: ListView.builder(
                                //       itemCount: 6,
                                //       shrinkWrap: true,
                                //       physics: NeverScrollableScrollPhysics(),
                                //       itemBuilder:
                                //           (BuildContext context, index) {
                                //         return Padding(
                                //           padding: EdgeInsets.symmetric(
                                //               vertical: 4, horizontal: 8),
                                //           child: Column(
                                //             children: [
                                //               Divider(
                                //                 color: Color.fromARGB(
                                //                     255, 216, 215, 215),
                                //                 thickness: 1,
                                //               ),
                                //               SizedBox(
                                //                 height: 10,
                                //               ),
                                //               Row(
                                //                 mainAxisAlignment:
                                //                     MainAxisAlignment
                                //                         .spaceBetween,
                                //                 children: [
                                //                   Row(
                                //                     children: [
                                //                       Image.asset(
                                //                         svg[index],
                                //                       ),
                                //                       SizedBox(
                                //                         width: 14,
                                //                       ),
                                //                       Text(
                                //                         clientHeader[index],
                                //                         style: TextStyle(
                                //                           fontSize: 15,
                                //                           fontWeight:
                                //                               FontWeight.w500,
                                //                           color: AppColors
                                //                               .darkgrey,
                                //                         ),
                                //                       ),
                                //                     ],
                                //                   ),
                                //                   SizedBox(
                                //                     width: 50,
                                //                   ),
                                //                   Flexible(
                                //                     child: Container(
                                //                       child: Text(
                                //                         clientSubHeader[index],
                                //                         style: TextStyle(
                                //                           fontSize: 15,
                                //                           fontWeight:
                                //                               FontWeight.w500,
                                //                           color: Color.fromARGB(
                                //                               255,
                                //                               128,
                                //                               128,
                                //                               128),
                                //                         ),
                                //                       ),
                                //                     ),
                                //                   ),
                                //                 ],
                                //               )
                                //             ],
                                //           ),
                                //         );
                                //       }),
                                // ),
                                // SizedBox(
                                //   height: 0.09.sw,
                                // ),
                                Text(
                                  "COMPANY DETAILS",
                                  style: TextStyle(
                                      color: AppColors.maincolor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.6),
                                ),
                                Container(
                                  height: 260,
                                  child: ListView.builder(
                                      itemCount: 3,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 8),
                                          child: Column(
                                            children: [
                                              Divider(
                                                color: Color.fromARGB(
                                                    255, 216, 215, 215),
                                                thickness: 1,
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        svg[index],
                                                      ),
                                                      SizedBox(
                                                        width: 14,
                                                      ),
                                                      Text(
                                                        companyHeader[index],
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: AppColors
                                                              .darkgrey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    width: 170,
                                                    child: Text(
                                                      companySubHeader[index],
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Color.fromARGB(
                                                            255, 128, 128, 128),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      }),
                                )
                              ],
                            ),
                          )
                        ])),
        ));
  }
}
