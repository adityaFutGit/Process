import 'package:flutter/material.dart';

import '../Widgets/customColors.dart';

class MyWorkScreen extends StatefulWidget {
  const MyWorkScreen({super.key});

  @override
  State<MyWorkScreen> createState() => _MyWorkScreenState();
}

class _MyWorkScreenState extends State<MyWorkScreen> {
  bool hidePendingTask = false;
  bool hideTodayTask = false;
  bool hideUpcomingTask = false;
  int itemCount = 4;
  String helpText = "Load More...";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 239, 248),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((OverscrollIndicatorNotification? notification) {
          notification!.disallowIndicator();
          return true;
        }),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "Pending Tasks",
                      style: TextStyle(
                          color: Color.fromARGB(255, 64, 53, 114),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          if (hidePendingTask == false) {
                            hidePendingTask = true;
                          } else if (hidePendingTask == true) {
                            hidePendingTask = false;
                          }
                        });
                      },
                      icon: hidePendingTask == false
                          ? Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                            )
                          : Icon(
                              Icons.keyboard_arrow_up,
                              size: 20,
                            ),
                    ),
                    SizedBox(
                      width: 200,
                    ),
                    Icon(
                      Icons.filter_list_rounded,
                      size: 24,
                      color: Color.fromARGB(255, 157, 178, 206),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !hidePendingTask,
                child: Container(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) {
                        final Color background = Colors.red;
                        final Color fill = Colors.white;
                        final List<Color> gradient = [
                          background,
                          background,
                          fill,
                          fill,
                        ];
                        final double fillPercent = 97.55;
                        final double fillStop = (100 - fillPercent) / 100;
                        final List<double> stops = [
                          0.0,
                          fillStop,
                          fillStop,
                          1.0
                        ];

                        return Container(
                            height: 54,
                            width: 375,
                            margin:
                                EdgeInsets.only(bottom: 7, left: 3, right: 3),
                            padding: EdgeInsets.only(left: 20, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromARGB(255, 242, 240, 240)),
                              gradient: LinearGradient(
                                colors: gradient,
                                stops: stops,
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Task Title",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                          wordSpacing: 0.2),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      "Process Name",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                          wordSpacing: 0.2),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 20,
                                  width: 76,
                                  padding: EdgeInsets.only(left: 11, top: 4),
                                  child: Text(
                                    "In Progress",
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.iconColor),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 252, 227, 0),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                Text(
                                  "High",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Jun 1,2023",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ));
                      }),
                ),
              ),

              //Today's Task
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "Today Tasks",
                      style: TextStyle(
                          color: Color.fromARGB(255, 64, 53, 114),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          if (hideTodayTask == false) {
                            hideTodayTask = true;
                          } else if (hideTodayTask == true) {
                            hideTodayTask = false;
                          }
                        });
                      },
                      icon: hideTodayTask == false
                          ? Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                            )
                          : Icon(
                              Icons.keyboard_arrow_up,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !hideTodayTask,
                child: Container(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 2,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            height: 54,
                            width: 375,
                            margin:
                                EdgeInsets.only(bottom: 7, left: 3, right: 3),
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color: Color.fromARGB(255, 242, 240, 240)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Task Title",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                          wordSpacing: 0.2),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      "Process Name",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 0.2,
                                          wordSpacing: 0.2),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 20,
                                  width: 76,
                                  padding: EdgeInsets.only(left: 11, top: 4),
                                  child: Text(
                                    "In Progress",
                                    // textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: AppColors.iconColor),
                                  ),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 252, 227, 0),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                Text(
                                  "High",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500),
                                ),
                                Text(
                                  "Jun 1,2023",
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ));
                      }),
                ),
              ),
              //Upcoming Task
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: Row(
                  children: [
                    Text(
                      "Upcoming Tasks",
                      style: TextStyle(
                          color: Color.fromARGB(255, 64, 53, 114),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          if (hideUpcomingTask == false) {
                            hideUpcomingTask = true;
                          } else if (hideUpcomingTask == true) {
                            hideUpcomingTask = false;
                          }
                        });
                      },
                      icon: hideUpcomingTask == false
                          ? Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                            )
                          : Icon(
                              Icons.keyboard_arrow_up,
                              size: 20,
                            ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: !hideUpcomingTask,
                child: Column(
                  children: [
                    Container(
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: itemCount,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                height: 54,
                                width: 375,
                                margin: EdgeInsets.only(
                                    bottom: 7, left: 3, right: 3),
                                padding: EdgeInsets.only(left: 20, right: 10),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color:
                                            Color.fromARGB(255, 242, 240, 240)),
                                    color: Colors.white),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Task Title",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              wordSpacing: 0.2),
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Text(
                                          "Process Name",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 0.2,
                                              wordSpacing: 0.2),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 20,
                                      width: 76,
                                      padding:
                                          EdgeInsets.only(left: 11, top: 4),
                                      child: Text(
                                        "In Progress",
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: AppColors.iconColor),
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 252, 227, 0),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    Text(
                                      "High",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      "Jun 1,2023",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ));
                          }),
                    ),
                    TextButton(
                        onPressed: () {
                          if (itemCount == 4) {
                            setState(() {
                              itemCount = 10;
                              helpText = "See Less...";
                            });
                          } else if (itemCount != 4) {
                            setState(() {
                              itemCount = 4;
                              helpText = "Load More...";
                            });
                          }
                        },
                        child: Text(
                          helpText,
                          style: TextStyle(color: Colors.blue, fontSize: 12),
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
