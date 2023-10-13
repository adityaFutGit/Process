// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/dashboard.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
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
                          Image.asset("assets/forgot.png"),
                          SizedBox(
                            height: 45,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Update Password",
                              style: TextStyle(
                                  color: AppColors.maincolor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          CustomWidgets.textField(
                            hintText: "Enter New Password",
                            textController: Email,
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
                            height: 15,
                          ),
                          CustomWidgets.textField(
                            hintText: "Confirm Password",
                            textController: Email,
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
                                    Get.to(DashboardScreen());
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
