// ignore_for_file: prefer_const_constructors, file_names, avoid_unnecessary_containers, prefer_const_declarations, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Models/policyModel.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/dashboard.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../Models/userdataModel.dart';

class CompanyPolicies extends StatefulWidget {
  const CompanyPolicies({super.key});

  @override
  State<CompanyPolicies> createState() => _CompanyPoliciesState();
}

class _CompanyPoliciesState extends State<CompanyPolicies> {
  var companyId;
  var locationId;
  UserModel _userModel = UserModel();
  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  void initPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refresh_token = prefs.getString("refresh_token");
    http.Response res = await http.post(
        Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
        headers: {"refresh_token": refresh_token.toString()});
    var jsonResponse = jsonDecode(res.body);

    print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
    await prefs.setString("token", jsonResponse["token"]);
    setState(() {
      String decodedMap = prefs.getString('Users') ?? "";
      _userModel = userModelFromMap(decodedMap);

      companyId = _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.onRollCompany?.id
          : _userModel
              .userData?.employee?.employeeOffrollment?.offRollCompany?.id;
      token = prefs.getString("token");
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _getPolicyList());
    print(companyId);
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
          child: responseBody == null
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
                          "Company Policies",
                          style: TextStyle(
                              fontSize: 16.sp, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    if (_policyModel.totalCount == 0) ...[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 270,
                          ),
                          Text(
                            "No Company Policies",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 150, 150, 150),
                                letterSpacing: 0.7,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ] else
                      Container(
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _policyModel.totalCount,
                            itemBuilder: (BuildContext context, int index) {
                              final Color background = Color(
                                      (math.Random().nextDouble() * 0xFFFFFF)
                                          .toInt())
                                  .withOpacity(1.0);
                              final Color fill = Colors.white;
                              final List<Color> gradient = [
                                background,
                                background,
                                fill,
                                fill,
                              ];
                              final double fillPercent = 97.00;
                              final double fillStop = (100 - fillPercent) / 100;
                              final List<double> stops = [
                                0.0,
                                fillStop,
                                fillStop,
                                1.0
                              ];
                              return Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color:
                                          Color.fromARGB(255, 242, 240, 240)),
                                  gradient: LinearGradient(
                                    colors: gradient,
                                    stops: stops,
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ExpansionTile(
                                  tilePadding:
                                      EdgeInsets.symmetric(horizontal: 25),
                                  childrenPadding: EdgeInsets.only(bottom: 10),
                                  iconColor: AppColors.maincolor,
                                  collapsedIconColor: AppColors.maincolor,
                                  title: Text(
                                    "${_policyModel.policy?[index].name}",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: AppColors.maincolor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  children: [
                                    ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 30),
                                        title: Column(
                                          children: [
                                            Divider(
                                              thickness: 1.5,
                                              color: Color.fromARGB(
                                                  255, 218, 218, 218),
                                              height: 0,
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text(
                                              "${_policyModel.policy?[index].description}",
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.2,
                                                  wordSpacing: 0.2),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              );
                            }),
                      ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
        ),
      ),
    );
  }

  var responseBody;
  PolicyModel _policyModel = PolicyModel();
  var token;
  _getPolicyList() async {
    try {
      var url = Uri.parse(
          '${TextConstant.baseURL}/api/policy/company-policy?companyId=$companyId');

      http.Response res = await http.get(url, headers: {
        'x-access-token': token,
      });
      if (mounted) {
        setState(() {
          responseBody = res.body;
        });
      }
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            _policyModel = policyFromMap(responseBody);
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.maincolor,
            content: Text(
              "Company is not assigned",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
      }
    } on Exception catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.maincolor,
            content: Text(
              "${e.toString()} \nLoading Again...",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
      }
      _getPolicyList();
    }
    return;
  }
}
