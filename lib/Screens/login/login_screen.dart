// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Models/userdataModel.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/dashboard.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController inputController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserModel _userModel = UserModel();
  bool _passwordVisible = false;
  var id;
  bool next = false;
  //Connection Checker
  late ConnectivityResult result;
  late StreamSubscription subscription;
  var isConnected = false;
  checkInternet() async {
    result = await Connectivity().checkConnectivity();
    if (result != ConnectivityResult.none) {
      isConnected = true;
    } else {
      isConnected = false;
      showDialogBox();
    }
    setState(() {});
  }

  showDialogBox() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("No Internet"),
              content: Text("Please check your internet connection"),
              actions: [
                CupertinoButton.filled(
                    child: Text("Retry"),
                    onPressed: () {
                      Navigator.pop(context);
                      checkInternet();
                    })
              ],
            ));
  }

  startStreaming() {
    subscription = Connectivity().onConnectivityChanged.listen((event) async {
      checkInternet();
    });
  }

  @override
  void initState() {
    startStreaming();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        throw SystemNavigator.pop();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.dark,
                systemNavigationBarColor: Colors.transparent,
                statusBarColor: Colors.transparent),
            elevation: 0,
            backgroundColor: const Color.fromARGB(255, 245, 245, 245),
            title: Image.asset(
              "assets/appLogo.png",
              height: 60,
              width: 150,
            ),
            centerTitle: true,
          ),
          body: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsets.only(top: 100, left: 30, right: 30),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome\nBack.",
                                  style: TextStyle(
                                      color: AppColors.maincolor,
                                      fontSize: 50,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Employee Login",
                                  style: TextStyle(
                                      color: AppColors.maincolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          CustomWidgets.textField(
                            hintText: "Email/Phone",
                            textController: inputController,
                            prefixIcon: Icon(
                              Icons.person_outline_outlined,
                              color: Colors.black54,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Email/Phone is required");
                              }
                              // if (field == "email") {
                              //   if (!RegExp(
                              //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-z]+\.[a-z]")
                              //       .hasMatch(value)) {
                              //     return ("Enter a valid Email");
                              //   }
                              // } else {
                              //   return ("Enter a valid Number");
                              // }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CustomWidgets.textField(
                            textController: passwordController,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.maincolor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            hintText: "Password",
                            lines: 1,
                            isPassword: !_passwordVisible,
                            prefixIcon: Icon(
                              Icons.lock_outline,
                              color: Colors.black54,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Password is required");
                              }
                              // if (value.length <= 6
                              //     // !RegExp( r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(value)
                              //     ) {
                              //   return ("Enter a valid Password");
                              // }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              next == true
                                  ? Lottie.asset("assets/loginLoading.json",
                                      height: 100)
                                  : CustomWidgets.button(
                                      text: "SIGN IN",
                                      onPressed: () async {
                                        if (RegExp(
                                                r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
                                            .hasMatch(inputController.text)) {
                                          field = "mobile";
                                        } else {
                                          field = "email";
                                        }
                                        print(field);
                                        if (!_formKey.currentState!
                                            .validate()) {
                                          return;
                                        }

                                        login(inputController.text,
                                            passwordController.text);
                                      }),
                              SizedBox(
                                height: 15,
                              ),
                              TextButton(
                                onPressed: () {
                                  //Get.to(ForgotPassword());
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      color: AppColors.maincolor,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          )),
    );
  }

  var field;
  var process = " ";
  login(String input, password) async {
    setState(() {
      next = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('${TextConstant.baseURL}/api/user/login');

      Map body = {
        "$field": input.toString(),
        "password": password,
      };
      http.Response res =
          await http.post(url, body: jsonEncode(body), headers: headers);
      var responseBody = res.body;
      print(responseBody);
      if (res.statusCode == 200) {
        prefs.setBool('isLoggedIn', true);
        setState(() {
          _userModel = userModelFromMap(responseBody);
          id = _userModel.userData!.employee!.id;
          prefs.setString("token", _userModel.token!);
          prefs.setString("refresh_token", _userModel.refreshToken!);
          prefs.setInt("UserId", id);
          // prefs.setInt(
          //     "salaryId", _userModel.userData!.employee!.employeeSalary!.id!);
          next = true;
          prefs.setBool("attendanceWithMobile",
              _userModel.userData!.employee!.attendanceWithMobile!);
          prefs.setBool("attendanceLocationLock",
              _userModel.userData!.employee!.attendanceLocationLock!);
        });
        print("TOKEN: ${prefs.getString("token")}");
        await prefs.setString('Users', userModelToMap(_userModel));

        Get.to(DashboardScreen());

        bool serviceEnabled;
        LocationPermission permission;
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        await Future.delayed(Duration.zero, () async {
          await QuickAlert.show(
              context: context,
              barrierDismissible: false,
              type: QuickAlertType.success,
              title: "Logged In",
              showCancelBtn: false,
              confirmBtnColor: Color.fromARGB(255, 116, 202, 120),
              onConfirmBtnTap: () async {
                Navigator.of(context).pop();
                if (!serviceEnabled) {
                  permission = await Geolocator.checkPermission();
                  // await Geolocator.openLocationSettings();
                  return Future.error('Location services are disabled.');
                }
                permission = await Geolocator.checkPermission();
                if (permission == LocationPermission.denied) {
                  permission = await Geolocator.requestPermission();
                  if (permission == LocationPermission.denied) {
                    return Future.error('Location permissions are denied');
                  }
                }
                if (permission == LocationPermission.deniedForever) {
                  return Future.error(
                      'Location permissions are permanently denied, we cannot request permissions.');
                }
              });
        });
        setState(() {
          next = false;
        });
      } else {
        setState(() {
          next = false;
        });
        print('failed');
        if (res.body.isNotEmpty) {
          var errMsg = json.decode(responseBody);
          print(errMsg);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Color.fromARGB(255, 182, 22, 10),
              content: Text(
                errMsg["message"].toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  letterSpacing: .3,
                  fontSize: 16,
                ),
              )));
        }
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "Login after sometime",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      setState(() {
        next = false;
      });
      print(e.toString());
    }
    return;
  }
}
