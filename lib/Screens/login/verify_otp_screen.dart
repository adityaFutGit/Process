// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Screens/login/update_password_screen.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({super.key});

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  TextEditingController Email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          // iconTheme: IconThemeData(color: Color.fromARGB(255, 30, 67, 159)),
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              statusBarColor: Colors.transparent),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          title: Image.asset(
            "assets/mTrack.png",
            height: 100,
            width: 190,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            top: true,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 55, horizontal: 40),
              child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset("assets/verifyOTP.png"),
                          SizedBox(
                            height: 70,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Verify OTP",
                              style: TextStyle(
                                  color: AppColors.maincolor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "OTP has been sent to your registered email/phone",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 104, 104, 104),
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          CustomWidgets.textField(
                            hintText: "Email/Phone",
                            textController: Email,
                            prefixIcon: Icon(
                              Icons.person_outline_outlined,
                              color: Colors.black54,
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return ("Email is Required");
                              }
                              if (!RegExp(
                                      r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                  .hasMatch(value)) {
                                return ("Enter a valid Email");
                              }
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
                              CustomWidgets.button(
                                  text: "CONTINUE",
                                  onPressed: () {
                                    // if (_formKey.currentState!.validate()) {
                                    //   return;
                                    // }
                                    Get.to(UpdatePassword());
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }
}
