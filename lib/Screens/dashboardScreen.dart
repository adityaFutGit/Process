// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:process/Screens/homePage.dart';
import 'package:process/Screens/moreScreen.dart';
import 'package:process/Screens/myWorkScreen.dart';
import 'package:process/Widgets/customColors.dart';
import 'package:process/Widgets/customWidgets.dart';
import 'package:process/Screens/dataTable.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int pageIndex = 0;
  final pages = [
    const HomePage(),
    const MyWorkScreen(),
    const MoreScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 236, 239, 248),
        bottomNavigationBar: buildNavBar(context),
        appBar: CustomAppBar(),
        body: pages[pageIndex]);
  }

  Container buildNavBar(BuildContext context) {
    return Container(
        height: 73,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(255, 194, 194, 194), blurRadius: 10)
            ]),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Row(
                //   crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    height: 47,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageIndex == 0
                          ? Color.fromARGB(255, 225, 232, 253)
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                            enableFeedback: false,
                            onTap: () {
                              setState(() {
                                pageIndex = 0;
                              });
                            },
                            child: Icon(
                              Icons.home_outlined,
                              color: pageIndex == 0
                                  ? Color.fromARGB(255, 102, 143, 255)
                                  : AppColors.iconColor,
                              size: 26,
                            )),
                        Text(
                          "Home",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 70, 117, 247)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageIndex == 1
                          ? Color.fromARGB(255, 225, 232, 253)
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                            enableFeedback: false,
                            onTap: () {
                              setState(() {
                                pageIndex = 1;
                              });
                            },
                            child: Icon(
                              Icons.work_outline,
                              color: pageIndex == 1
                                  ? Color.fromARGB(255, 102, 143, 255)
                                  : AppColors.iconColor,
                              size: 26,
                            )),
                        Text(
                          "My Work",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 70, 117, 247)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 2),
                    height: 47,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: pageIndex == 2
                          ? Color.fromARGB(255, 225, 232, 253)
                          : Colors.white,
                    ),
                    child: Column(
                      children: [
                        InkWell(
                            enableFeedback: false,
                            onTap: () {
                              setState(() {
                                pageIndex = 2;
                              });
                            },
                            child: Icon(
                              Icons.pending_outlined,
                              color: pageIndex == 2
                                  ? Color.fromARGB(255, 70, 117, 247)
                                  : AppColors.iconColor,
                              size: 26,
                            )),
                        Text(
                          "More",
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w300,
                              color: Color.fromARGB(255, 70, 117, 247)),
                        )
                      ],
                    ),
                  ),
                ]),
          ],
        ));
  }
}
