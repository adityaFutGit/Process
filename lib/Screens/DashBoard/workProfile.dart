// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Models/userdataModel.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WorkProfile extends StatefulWidget {
  const WorkProfile({super.key});

  @override
  State<WorkProfile> createState() => _WorkProfileState();
}

class _WorkProfileState extends State<WorkProfile> {
  List<String> svg = [
    "assets/WorkProfilePNG/One.png",
    //"assets/WorkProfilePNG/Two.png",
    "assets/WorkProfilePNG/Three.png",
    //"assets/WorkProfilePNG/Four.png",
    "assets/WorkProfilePNG/Five.png",
    "assets/WorkProfilePNG/Six.png",
    "assets/WorkProfilePNG/Seven.png",
    "assets/WorkProfilePNG/Eigth.png",
  ];
  List<String> gridHeader = [
    "Company Name:",
    //"Field Officer:",
    "Phone Number:",
    // "Client Name:",
    "Location:",
    "City:",
    "Address:",
    "Pincode:"
  ];
  List gridSubHeader = [];
  UserModel _userModel = UserModel();
  static var companyName,
      //  fieldOfficer,
      num,
      //  clientName,
      loc,
      city,
      address,
      pincode,
      department;
  @override
  void initState() {
    initPrefs();

    super.initState();
  }

  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String decodedMap = prefs.getString('Users') ?? "";
    _userModel = userModelFromMap(decodedMap);
    setState(() {
      companyName =
          _userModel.userData?.employee?.employeeOffrollment == null ||
                  _userModel.userData?.employee?.employeeOffrollment
                          ?.offRollCompany?.name ==
                      null
              ? _userModel
                  .userData?.employee?.employeeOnrollment?.onRollCompany?.name
              : _userModel.userData?.employee?.employeeOffrollment
                  ?.offRollCompany?.name;
      // fieldOfficer = " ";
      department = _userModel.userData?.employee?.employeeOffrollment == null ||
              _userModel.userData?.employee?.employeeOffrollment?.department ==
                  null
          ? _userModel.userData?.employee?.employeeOnrollment?.department
          : _userModel.userData?.employee?.employeeOffrollment?.department;
      if (_userModel
                  .userData?.employee?.employeeOnrollment?.location?.contacts ==
              null &&
          _userModel.userData?.employee?.employeeOffrollment?.location
                  ?.contacts ==
              null) {
        num = "";
      } else {
        num = _userModel.userData?.employee?.employeeOffrollment?.location
                        ?.contacts ==
                    null ||
                _userModel.userData?.employee?.employeeOffrollment == null
            ? ""
            : "${_userModel.userData?.employee?.employeeOffrollment?.location?.contacts["mobile"]}";
      }

      // clientName = " ";
      loc = _userModel.userData?.employee?.employeeOffrollment == null ||
              _userModel.userData?.employee?.employeeOffrollment?.location
                      ?.name ==
                  null
          ? _userModel.userData?.employee?.employeeOnrollment?.location?.name
          : "${_userModel.userData?.employee?.employeeOffrollment?.location?.name}";
      if (_userModel.userData?.employee?.employeeOnrollment?.location?.city ==
              null &&
          _userModel.userData?.employee?.employeeOffrollment?.location?.city ==
              null) {
        city = "";
      } else {
        city = _userModel.userData?.employee?.employeeOffrollment == null ||
                _userModel.userData?.employee?.employeeOffrollment?.location
                        ?.city ==
                    null
            ? _userModel
                .userData?.employee?.employeeOnrollment?.location?.city?.name
            : "${_userModel.userData?.employee?.employeeOffrollment?.location?.city?.name}";
      }

      address = _userModel.userData?.employee?.employeeOffrollment?.location
                      ?.addressLine1 ==
                  null ||
              _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel
              .userData?.employee?.employeeOnrollment?.location?.addressLine1
          : "${_userModel.userData?.employee?.employeeOffrollment?.location?.addressLine1}";
      pincode = _userModel.userData?.employee?.employeeOffrollment?.location
                      ?.pincode ==
                  null ||
              _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.location?.pincode
          : "${_userModel.userData?.employee?.employeeOffrollment?.location?.pincode}";
      gridSubHeader = [
        companyName,
        // fieldOfficer,
        num,
        //  companyName,
        loc,
        city,
        address,
        pincode
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
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: _userModel.userData == null
                ? Align(
                    heightFactor: 6,
                    alignment: Alignment.center,
                    child: Lottie.asset("assets/loading.json", height: 100))
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                              "Work Profile",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                width: 104,
                                height: 104,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 2.5,
                                      color: Color.fromARGB(255, 30, 67, 159)),
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage("assets/profile.jpeg"),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          department,
                          style: TextStyle(
                              color: AppColors.maincolor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Employee Code: ${_userModel.userData?.employee?.employeeCode ?? " "}",
                          style: TextStyle(
                              color: Color.fromARGB(255, 136, 136, 136),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 7 / 5,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 26,
                                      mainAxisSpacing: 18),
                              itemCount: 6,
                              itemBuilder: (BuildContext ctx, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 224, 224, 224),
                                          width: 2),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          svg[index],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          gridHeader[index],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.darkgrey,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          gridSubHeader[index],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.darkgrey,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ])),
      ),
    );
  }
}
