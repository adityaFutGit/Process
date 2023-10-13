// ignore_for_file: prefer_const_constructors, sort_child_properties_last, avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously, prefer_final_fields, unused_element, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:day_night_time_picker/lib/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Models/attendanceModel.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

import '../../Models/userdataModel.dart';

class Attendance extends StatefulWidget {
  const Attendance({super.key});

  @override
  State<Attendance> createState() => _AttendanceState();
}

class _AttendanceState extends State<Attendance> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay, focusedDay = DateTime.now();
  var month;
  var year;
  dynamic attendanceData;
  DateTime? SelectedDay;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  int radioValue = -1;
  var employeeId;
  double boxHeight = 60;
  double bottomSheetHeight = 350;
  bool show = false;
  TimeOfDay _inTime = TimeOfDay.now();
  TimeOfDay _outTime = TimeOfDay.now();
  String inTime = "In Time";
  String outTime = "Out Time";
  String? selectedType;
  var companyId;
  bool showContainer = false;
  UserModel _userModel = UserModel();
  TextEditingController reason = TextEditingController();
  bool compOffButtonDisable = true;
  bool compOffResponse = false;
  var today = DateTime.now();
  var differnceOfTwoDate;
  var type = [
    'Full Day',
    'Half Day',
  ];
  void inTimeChanged(Time newTime) {
    setState(() {
      _inTime = newTime;
    });
  }

  void outTimeChanged(Time newTime) {
    setState(() {
      _outTime = newTime;
    });
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        focusedDay = focusedDay;
        _selectedDay = selectedDay;
        // _selectedEvents = _getEventsForDay(selectedDay);
      });
    }
  }

  void _expandBox() {
    setState(() {
      boxHeight = 120;
      bottomSheetHeight = 420;
    });
  }

  void _normalBox() {
    setState(() {
      boxHeight = 60;
      bottomSheetHeight = 350;
    });
  }

  initPrefs() async {
    print("SHERDIL");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refresh_token = prefs.getString("refresh_token");
    http.Response res = await http.post(
        Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
        headers: {"refresh_token": refresh_token.toString()});
    var jsonResponse = jsonDecode(res.body);

    print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
    await prefs.setString("token", jsonResponse["token"]);
  }

  @override
  void initState() {
    initPrefs();
    month = DateTime.now().month;
    year = DateTime.now().year;

    _showDetails();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var value = prefs.getInt('UserId');
      token = prefs.getString("token");
      String decodedMap = prefs.getString('Users') ?? "";
      _userModel = userModelFromMap(decodedMap);
      companyId = _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.onRollCompany?.id
          : _userModel
              .userData?.employee?.employeeOffrollment?.offRollCompany?.id;
      setState(() {
        employeeId = value;
      });
      _getAttendance();
    });

    super.initState();
  }

  void _showDetails() {}
  String date = "",
      intime = "--:--",
      outtime = "--:--",
      workinghrs = "--:--",
      brktime = "--:--",
      overtime = "--:--",
      status = "";

  var totalbrks = 0;
  var darkColor;
  var lightColor;
  var statuss;
  // @override
  // void dispose() {
  //   _getAttendance();
  //   _showDetails();
  //   super.dispose();
  // }

  bool nextPage = false;
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
              child: attendanceData == null
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
                                  "Attendance",
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Present",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 78, 200, 82),
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                    ),
                                    Container(
                                      height: 55,
                                      width: 60,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          Present.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )
                                  ],
                                ),

                                //Absent
                                Stack(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Absent",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 200, 78, 78),
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                    ),
                                    Container(
                                      height: 55,
                                      width: 60,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          Absent.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )
                                  ],
                                ),

                                //Half Day
                                Stack(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Half Day",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 235, 215, 33),
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                    ),
                                    Container(
                                      height: 55,
                                      width: 60,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          HalfDay.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )
                                  ],
                                ),

                                //Leaves
                                Stack(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Leaves",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 78, 129, 200),
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                    ),
                                    Container(
                                      height: 55,
                                      width: 60,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          Leaves.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )
                                  ],
                                ),

                                //Day Off
                                Stack(
                                  children: [
                                    Container(
                                      width: 60,
                                      child: Text(
                                        "Day Off",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 97, 89, 89),
                                          border: Border.all(
                                              color: Colors.transparent),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5))),
                                    ),
                                    Container(
                                      height: 55,
                                      width: 60,
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          DayOff.toString(),
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Color.fromARGB(
                                                  255, 190, 190, 190),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            TableCalendar(
                              rowHeight: 45,
                              focusedDay: focusedDay!,
                              firstDay: DateTime(2022),
                              lastDay: DateTime(2024),
                              calendarFormat: _calendarFormat,
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              headerStyle: HeaderStyle(
                                  headerPadding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 20),
                                  formatButtonVisible: false,
                                  titleCentered: true,
                                  leftChevronIcon: Icon(
                                    Icons.arrow_back,
                                    color: AppColors.maincolor,
                                  ),
                                  rightChevronIcon: Icon(
                                    Icons.arrow_forward,
                                    color: AppColors.maincolor,
                                  ),
                                  titleTextStyle: TextStyle(
                                      color: AppColors.maincolor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              daysOfWeekStyle: DaysOfWeekStyle(
                                  weekendStyle:
                                      TextStyle(fontWeight: FontWeight.w500),
                                  weekdayStyle:
                                      TextStyle(fontWeight: FontWeight.w500)),
                              calendarBuilders: CalendarBuilders(
                                defaultBuilder: (
                                  context,
                                  day,
                                  focusedDay,
                                ) {
                                  for (AttendanceData d in list) {
                                    if (day.day == d.date.day &&
                                        day.month == d.date.month &&
                                        day.year == d.date.year) {
                                      if (d.Pstatus("P")) {
                                        lightColor =
                                            Color.fromARGB(210, 189, 239, 192);
                                        darkColor = Colors.green;
                                        statuss = "Present";
                                      } else if (status == "HD") {
                                        lightColor =
                                            Color.fromARGB(255, 255, 252, 223);
                                        darkColor =
                                            Color.fromARGB(255, 255, 230, 3);
                                        statuss = "Half Day";
                                      } else if (status == "HL" ||
                                          status == "UL" ||
                                          status == "PL") {
                                        lightColor =
                                            Color.fromARGB(255, 167, 215, 255);
                                        darkColor = Colors.blue;
                                        statuss = "Leave";
                                      }
                                      //  else if (status == "DO") {
                                      //   lightColor =
                                      //       Color.fromARGB(255, 211, 198, 198);
                                      //   darkColor =
                                      //       Color.fromARGB(255, 97, 89, 89);
                                      //   statuss = "Day Off";
                                      // }
                                      return Container(
                                        height: 33,
                                        width: 40,
                                        decoration: BoxDecoration(
                                            color: d.Pstatus("P")
                                                ? Color.fromARGB(
                                                    255, 138, 203, 143)
                                                : d.Astatus("A")
                                                    ? Color.fromARGB(
                                                        220, 207, 90, 90)
                                                    : d.HDstatus("HD")
                                                        ? Color.fromARGB(
                                                            255, 235, 215, 33)
                                                        : d.Lstatus("HL UL PL")
                                                            ? Color.fromARGB(
                                                                255,
                                                                78,
                                                                129,
                                                                200)
                                                            : d.DOstatus("DO")
                                                                ? Color
                                                                    .fromARGB(
                                                                        255,
                                                                        156,
                                                                        155,
                                                                        155)
                                                                : Colors
                                                                    .transparent,
                                            border: Border.all(
                                                color: Colors.transparent),
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Center(
                                          child: Text(
                                            '${day.day}',
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return null;
                                },
                              ),
                              calendarStyle: CalendarStyle(
                                  outsideDaysVisible: false,
                                  defaultTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  defaultDecoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  todayDecoration: BoxDecoration(
                                      color: Colors.purple,
                                      border:
                                          Border.all(color: Colors.transparent),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5)),
                                  weekendTextStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  weekendDecoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.transparent),
                                      color: Color.fromARGB(255, 216, 244, 233),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(5)),
                                  selectedTextStyle:
                                      TextStyle(color: Colors.black),
                                  selectedDecoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 2),
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10))),
                              onDaySelected: ((selectedDay, changedDate) {
                                setState(() {
                                  changedDate = selectedDay;
                                  SelectedDay = selectedDay;
                                });
                                differnceOfTwoDate =
                                    today.difference(SelectedDay!).inDays;
                                print("DIFFERENCE: $differnceOfTwoDate");
                                _getCompOffResponse();
                                // print(SelectedDay);

                                for (AttendanceData d in list) {
                                  if (selectedDay.day == d.date.day &&
                                      selectedDay.month == d.date.month &&
                                      selectedDay.year == d.date.year) {
                                    if (d.DOstatus("DO")) {}
                                    if (!d.Astatus("A")) {
                                      setState(() {
                                        showContainer = true;
                                        date = d.date.toString();
                                        intime = d.timeIn ?? " ";
                                        outtime = d.timeOut ?? " ";
                                        workinghrs = d.workDuration ?? " ";
                                        brktime = d.breakTotalTime ?? " ";
                                        totalbrks = d.totalNoOfBreaks ?? " ";
                                        overtime = d.overTime ?? " ";
                                        status = d.status;
                                        if (intime == " ") {
                                          setState(() {
                                            intime = " ";
                                          });
                                        } else {
                                          DateTime IT = DateTime.parse(
                                              "0000-00-00T$intime");
                                          intime =
                                              DateFormat('hh:mm a').format(IT);
                                        }
                                        if (outtime == " ") {
                                          setState(() {
                                            outtime = " ";
                                          });
                                        } else {
                                          DateTime OT = DateTime.parse(
                                              "0000-00-00T$outtime");
                                          outtime =
                                              DateFormat('hh:mm a').format(OT);
                                        }

                                        if (outtime == " ") {
                                          setState(() {
                                            outtime = " ";
                                          });
                                        } else {
                                          DateTime WHRS = DateTime.parse(
                                              "0000-00-00T$workinghrs");
                                          workinghrs =
                                              "${DateFormat('HH').format(WHRS)} hrs : ${DateFormat('mm').format(WHRS)} mins";
                                        }
                                        if (overtime == " ") {
                                          setState(() {
                                            overtime = " ";
                                          });
                                        } else {
                                          DateTime OvT = DateTime.parse(
                                              "0000-00-00T$overtime");
                                          overtime =
                                              DateFormat('HH:mm').format(OvT);
                                        }

                                        if (brktime == " ") {
                                          setState(() {
                                            brktime = " ";
                                          });
                                        } else {
                                          DateTime BRT = DateTime.parse(
                                              "0000-00-00T$brktime");
                                          brktime = DateFormat('HH:mm:ss')
                                              .format(BRT);
                                        }

                                        date = DateFormat.yMMMd().format(
                                            DateTime.parse(d.date.toString()));
                                      });
                                    }
                                    if (d.Astatus("A")) {
                                      showContainer = false;
                                      if (d.attendanceRegularisation == null) {
                                        setState(() {
                                          disable = false;
                                        });
                                      } else {
                                        disable = true;
                                        if (disable == true) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                duration: Duration(seconds: 2),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                backgroundColor: Color.fromARGB(
                                                    255, 182, 22, 10),
                                                content: Text(
                                                  "Attendance Requested",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  ),
                                                )),
                                          );
                                        }
                                      }
                                      print(disable);
                                      disable == true
                                          ? Container()
                                          : showModalBottomSheet<void>(
                                              context: context,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter state) {
                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 20),
                                                    height: bottomSheetHeight,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            width: 1,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    226,
                                                                    226,
                                                                    226)),
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10))),
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              DateFormat.yMMMd()
                                                                  .format(DateTime
                                                                      .parse(d
                                                                          .date
                                                                          .toString())),
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  color: Colors
                                                                      .black87,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            IconButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                icon: Icon(Icons
                                                                    .close)),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Container(
                                                            height: 60,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216)),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        10)),
                                                            child:
                                                                RadioListTile(
                                                                    activeColor:
                                                                        Colors
                                                                            .black,
                                                                    title: Row(
                                                                      children: const [
                                                                        Icon(
                                                                          Icons
                                                                              .more_time,
                                                                          size:
                                                                              30,
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              15,
                                                                        ),
                                                                        Text(
                                                                          "Mark as Present",
                                                                          style: TextStyle(
                                                                              fontWeight: FontWeight.w500,
                                                                              fontSize: 17),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    value: 0,
                                                                    groupValue:
                                                                        radioValue,
                                                                    onChanged:
                                                                        (val) {
                                                                      state(() {
                                                                        // radioValue =
                                                                        //     val!;
                                                                        _normalBox();
                                                                        show =
                                                                            false;
                                                                      });

                                                                      print(
                                                                          radioValue);
                                                                    })),
                                                        SizedBox(
                                                          height: 25,
                                                        ),
                                                        AnimatedContainer(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 6),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    100),
                                                            height: boxHeight,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 2,
                                                                    color:
                                                                        Color.fromARGB(
                                                                            255,
                                                                            216,
                                                                            216,
                                                                            216)),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10)),
                                                            child:
                                                                RadioListTile(
                                                                    activeColor:
                                                                        Colors
                                                                            .black,
                                                                    title:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          children: const [
                                                                            Icon(
                                                                              Icons.access_time_filled,
                                                                              color: Colors.black,
                                                                              size: 30,
                                                                            ),
                                                                            SizedBox(
                                                                              width: 15,
                                                                            ),
                                                                            Text(
                                                                              "Mark Exact Time",
                                                                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                                                                            )
                                                                          ],
                                                                        ),
                                                                        show ==
                                                                                true
                                                                            ? StatefulBuilder(builder:
                                                                                (BuildContext context, StateSetter state) {
                                                                                return Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(fixedSize: Size(120, 0), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), side: BorderSide(color: Colors.black, width: 1), backgroundColor: Colors.white),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).push(
                                                                                            showPicker(
                                                                                              context: context,
                                                                                              value: _inTime as Time,
                                                                                              onChange: inTimeChanged,
                                                                                              minuteInterval: TimePickerInterval.ONE,
                                                                                              // Optional onChange to receive value as DateTime
                                                                                              onChangeDateTime: (DateTime dateTime) {
                                                                                                // print(dateTime);

                                                                                                state(() {
                                                                                                  inTime = DateFormat.jm().format(dateTime);
                                                                                                });
                                                                                                print(_inTime);
                                                                                                debugPrint("[debug datetime]:  ${DateFormat.jm().format(dateTime)}");
                                                                                              },
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              inTime,
                                                                                              style: TextStyle(color: Colors.black),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.timer_rounded,
                                                                                              color: Colors.black,
                                                                                            )
                                                                                          ],
                                                                                        )),
                                                                                    ElevatedButton(
                                                                                        style: ElevatedButton.styleFrom(fixedSize: Size(120, 0), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), side: BorderSide(color: Colors.black, width: 1), backgroundColor: Colors.white),
                                                                                        onPressed: () {
                                                                                          Navigator.of(context).push(
                                                                                            showPicker(
                                                                                              context: context,
                                                                                              value: _outTime as Time,
                                                                                              onChange: outTimeChanged,
                                                                                              minuteInterval: TimePickerInterval.ONE,
                                                                                              // Optional onChange to receive value as DateTime
                                                                                              onChangeDateTime: (DateTime dateTime) {
                                                                                                // print(dateTime);
                                                                                                state(() {
                                                                                                  outTime = DateFormat.jm().format(dateTime);
                                                                                                });
                                                                                                debugPrint("[debug datetime]:  ${DateFormat.jm().format(dateTime)} ");
                                                                                              },
                                                                                            ),
                                                                                          );
                                                                                        },
                                                                                        child: Row(
                                                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                          children: [
                                                                                            Text(
                                                                                              outTime,
                                                                                              style: TextStyle(color: Colors.black),
                                                                                            ),
                                                                                            Icon(
                                                                                              Icons.timer_rounded,
                                                                                              color: Colors.black,
                                                                                            )
                                                                                          ],
                                                                                        ))
                                                                                  ],
                                                                                );
                                                                              })
                                                                            : Container(),
                                                                      ],
                                                                    ),
                                                                    value: 1,
                                                                    groupValue:
                                                                        radioValue,
                                                                    onChanged:
                                                                        (val) {
                                                                      state(() {
                                                                        // radioValue =
                                                                        //     val!;
                                                                        _expandBox();
                                                                        show =
                                                                            true;
                                                                      });

                                                                      print(
                                                                          radioValue);
                                                                    })),
                                                        SizedBox(
                                                          height: 40,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            ElevatedButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                "Cancel",
                                                                style: TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            123,
                                                                            123,
                                                                            123),
                                                                    fontSize:
                                                                        17,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                              style: ElevatedButton
                                                                  .styleFrom(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,

                                                                      //maximumSize: Size(7, 3),
                                                                      minimumSize:
                                                                          const Size(100,
                                                                              40),
                                                                      elevation:
                                                                          0,
                                                                      shape: RoundedRectangleBorder(
                                                                          side: BorderSide(
                                                                              color: Color.fromARGB(255, 232, 232,
                                                                                  232),
                                                                              width:
                                                                                  1.5),
                                                                          borderRadius:
                                                                              BorderRadius.circular(8.0))),
                                                            ),
                                                            AbsorbPointer(
                                                              absorbing:
                                                                  disable,
                                                              child:
                                                                  ElevatedButton(
                                                                onPressed: () {
                                                                  _validateInputs();
                                                                },
                                                                child: Text(
                                                                  "Apply",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          17,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            30,
                                                                            67,
                                                                            159),

                                                                        //maximumSize: Size(7, 3),
                                                                        minimumSize: const Size(
                                                                            100,
                                                                            40),
                                                                        elevation:
                                                                            0,
                                                                        shape: RoundedRectangleBorder(
                                                                            side:
                                                                                BorderSide(color: Colors.transparent, width: 1.5),
                                                                            borderRadius: BorderRadius.circular(8.0))),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                });
                                              });
                                    }
                                  }

                                  if (!isSameDay(_selectedDay, selectedDay)) {
                                    setState(() {
                                      _selectedDay = selectedDay;
                                      focusedDay = changedDate;
                                    });
                                  }
                                }
                              }),
                              selectedDayPredicate: (day) {
                                return isSameDay(_selectedDay, day);
                              },
                              onPageChanged: (changedDate) async {
                                focusedDay = changedDate;
                                setState(() {
                                  month = changedDate.month;
                                  year = changedDate.year;
                                  _getAttendance();
                                });

                                print(year);
                                setState(() {});
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Divider(
                              thickness: 1.3,
                              height: 0,
                              color: Colors.grey[350],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            if (list.isNotEmpty) ...[
                              status == "DO"
                                  ? Container(
                                      padding: EdgeInsets.only(top: 40),
                                      child: Center(
                                        child: Text(
                                          "Day Off",
                                          style: TextStyle(
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black45),
                                        ),
                                      ),
                                    )
                                  : showContainer == false
                                      ? Container()
                                      : Column(
                                          children: [
                                            SelectedDay == null
                                                ? Container()
                                                : Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child:
                                                          compOffButtonLoading ==
                                                                  true
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      right: 20,
                                                                      top: 10,
                                                                      bottom:
                                                                          10),
                                                                  child: SizedBox(
                                                                      height: 18,
                                                                      width: 18,
                                                                      child: Center(
                                                                        child:
                                                                            CircularProgressIndicator(
                                                                          strokeWidth:
                                                                              2,
                                                                          color:
                                                                              AppColors.maincolor,
                                                                        ),
                                                                      )),
                                                                )
                                                              : ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    if (differnceOfTwoDate >
                                                                        60) {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                        SnackBar(
                                                                            duration:
                                                                                Duration(seconds: 3),
                                                                            behavior: SnackBarBehavior.floating,
                                                                            backgroundColor: Color.fromARGB(255, 182, 22, 10),
                                                                            content: Text(
                                                                              "Comp. Off can be apply within 60 days",
                                                                              textAlign: TextAlign.center,
                                                                              style: const TextStyle(
                                                                                fontSize: 17,
                                                                              ),
                                                                            )),
                                                                      );
                                                                    } else {
                                                                      print(
                                                                          compOffResponse);
                                                                      compOffResponse ==
                                                                              true
                                                                          ? ScaffoldMessenger.of(context)
                                                                              .showSnackBar(
                                                                              SnackBar(
                                                                                  duration: Duration(seconds: 2),
                                                                                  behavior: SnackBarBehavior.floating,
                                                                                  backgroundColor: Color.fromARGB(255, 182, 22, 10),
                                                                                  content: Text(
                                                                                    "Compensatory Off Requested",
                                                                                    textAlign: TextAlign.center,
                                                                                    style: const TextStyle(
                                                                                      fontSize: 17,
                                                                                    ),
                                                                                  )),
                                                                            )
                                                                          : showModalBottomSheet<void>(
                                                                              isScrollControlled: true,
                                                                              context: context,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(10.0),
                                                                              ),
                                                                              builder: (BuildContext context) {
                                                                                return showCompOff();
                                                                              });
                                                                    }
                                                                  },
                                                                  child: Text(
                                                                    "Comp. Off",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  style: ElevatedButton
                                                                      .styleFrom(
                                                                          backgroundColor: Color.fromARGB(
                                                                              255,
                                                                              30,
                                                                              67,
                                                                              159),

                                                                          //maximumSize: Size(7, 3),
                                                                          minimumSize: const Size(70,
                                                                              30),
                                                                          elevation:
                                                                              0,
                                                                          shape: RoundedRectangleBorder(
                                                                              side: BorderSide(color: Colors.transparent, width: 1.5),
                                                                              borderRadius: BorderRadius.circular(8.0))),
                                                                ),
                                                    ),
                                                  ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            SelectedDay == null
                                                ? Container()
                                                : Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 14,
                                                            vertical: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        border: Border.all(
                                                            width: 1.8,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    218,
                                                                    217,
                                                                    217))),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              date,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: 18),
                                                            ),
                                                            Container(
                                                              height: 26,
                                                              width: 100,
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          5),
                                                              decoration: BoxDecoration(
                                                                  color:
                                                                      lightColor,
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .transparent),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceEvenly,
                                                                children: [
                                                                  intime !=
                                                                          "--:--"
                                                                      ? Icon(
                                                                          Icons
                                                                              .circle,
                                                                          size:
                                                                              10,
                                                                          color:
                                                                              darkColor,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .circle,
                                                                          size:
                                                                              10,
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                  Text(
                                                                    statuss ??
                                                                        "",
                                                                    style: TextStyle(
                                                                        color:
                                                                            darkColor,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        Divider(
                                                          thickness: 1.5,
                                                          height: 30,
                                                          color: Color.fromARGB(
                                                              255,
                                                              230,
                                                              230,
                                                              230),
                                                        ),
                                                        IntrinsicHeight(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "In Time",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    intime,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                              VerticalDivider(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        230,
                                                                        230,
                                                                        230),
                                                                thickness: 1.6,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Out Time",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    outtime,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                              VerticalDivider(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        230,
                                                                        230,
                                                                        230),
                                                                thickness: 1.6,
                                                              ),
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "Working HRS",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 5,
                                                                  ),
                                                                  Text(
                                                                    workinghrs,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w400),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 30,
                                                        ),
                                                        IntrinsicHeight(
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Break Time",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      brktime,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                                VerticalDivider(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          230,
                                                                          230,
                                                                          230),
                                                                  thickness:
                                                                      1.6,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Total Breaks",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      "$totalbrks Break",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                                VerticalDivider(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          230,
                                                                          230,
                                                                          230),
                                                                  thickness:
                                                                      1.6,
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Text(
                                                                      "Overtime",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 5,
                                                                    ),
                                                                    Text(
                                                                      "$overtime HRS",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    )),
                                          ],
                                        ),
                            ] else if (list.isEmpty) ...[
                              Container()
                            ],
                            SizedBox(
                              height: 20,
                            ),
                          ]),
                    )),
        ));
  }

  Widget showCompOff() {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Form(
        key: formKey,
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 10),
              height: 400,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 1, color: Color.fromARGB(255, 226, 226, 226)),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Compensatory Off",
                        style: TextStyle(
                            color: AppColors.maincolor,
                            fontSize: 16,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            size: 20,
                          ))
                    ],
                  ),
                  Divider(
                    color: Color.fromARGB(255, 228, 227, 227),
                    thickness: 2,
                    height: 10,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      DateFormat('dd/MM/yyyy').format(SelectedDay!),
                      style: TextStyle(
                          color: Color.fromARGB(255, 15, 46, 124),
                          fontSize: 16,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Text(
                    "Select Day*",
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 140,
                    child: DropdownButtonFormField<String>(
                      validator: (value) {
                        if (value == null) {
                          return ("Select Type");
                        }
                        return null;
                      },
                      borderRadius: BorderRadius.circular(10),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 8),
                          hintText: "Select",
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 136, 136, 136),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 227, 227, 227),
                                width: 1.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          fillColor: Colors.white,
                          filled: true),
                      isExpanded: false,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      iconSize: 25,
                      value: selectedType,
                      items: type
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400))))
                          .toList(),
                      onChanged: (item) {
                        setState(() {
                          selectedType = item!;
                          print(selectedType);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Type Reason*",
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomWidgets.textField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ("Type Reason");
                      }
                      return null;
                    },
                    lines: 2,
                    hintText: "Type here ...",
                    textController: reason,
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  compOffLoading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.maincolor,
                          ),
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: ElevatedButton(
                            onPressed: () {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }
                              applyCompOff(setState);
                            },
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500),
                            ),
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 30, 67, 159),

                                //maximumSize: Size(7, 3),
                                minimumSize: const Size(100, 40),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.transparent, width: 1.5),
                                    borderRadius: BorderRadius.circular(8.0))),
                          ),
                        )
                ],
              )),
        ),
      );
    });
  }

  // Get Document information by API
  List<AttendanceData> list = [];
  var Present, Absent, HalfDay, Leaves, DayOff;
  var token;
  Future<List<AttendanceData>> _getAttendance() async {
    try {
      setState(() {
        Present = 0;
        Absent = 0;
        HalfDay = 0;
        Leaves = 0;
        DayOff = 0;
        list.clear();
      });
      String url =
          '${TextConstant.baseURL}/api/attendance/attendanceReport/month?employeeId=$employeeId&month=$month&year=$year';
      http.Response res;

      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      attendanceData = jsonDecode(res.body);

      for (int i = 0; i < attendanceData.length; i++) {
        list.add(AttendanceData.fromJson(attendanceData[i]));
      }

      setState(() {
        Present = list.where((element) => element.status == "P").length;
        Absent = list.where((element) => element.status == "A").length;
        HalfDay = list.where((element) => element.status == "HD").length;
        Leaves = list.where((element) => element.status == "HDL").length;
        DayOff = list.where((element) => element.status == "DO").length;
      });
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nLoading Again...",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      _getAttendance();
      // Navigator.of(context).pushReplacement(MaterialPageRoute(
      //   builder: (context) => const Attendance(),
      // ));
    }
    return list;
  }

  var disable;
  var responseBody;
  void markPresent() async {
    final uri = Uri.parse(
        "${TextConstant.baseURL}/api/attendance/attendanceRegularisation/add");

    Map<String, dynamic> body = {
      "date": SelectedDay.toString(),
      "requestedOverTime": "00:00:00.000",
      "requestedInTime": radioValue == 0 ? ":10:00 AM" : inTime,
      "requestedOutTime": radioValue == 0 ? "07:00 PM" : outTime,
      "reason": "forget",
      "employeeId": employeeId
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

    responseBody = json.decode(response.body);

    if (statusCode == 200) {
      setState(() {
        nextPage = true;
      });
      // Navigator.of(context).pop();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Attendance(),
      ));
    } else if (statusCode != 200) {
      setState(() {
        nextPage = false;
      });
      if (response.body.isNotEmpty) {
        var errMsg = json.decode(responseBody);
        print(errMsg);

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errMsg["message"].toString())));

        setState(() {
          nextPage == false;
        });
      }
    }
  }

  var responseBody2;
  bool compOffLoading = false;
  void applyCompOff(setState) async {
    setState(() {
      compOffLoading = true;
    });
    final uri =
        Uri.parse("${TextConstant.baseURL}/api/comp-off/credit-request/apply");

    Map<String, dynamic> body = {
      "employeeId": employeeId,
      "entityId": companyId,
      "date": DateFormat('yyyy/MM/dd').format(SelectedDay!),
      "attendanceDuration": selectedType,
      "message": reason.text
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

    responseBody = json.decode(response.body);
    print(responseBody);
    if (statusCode == 200) {
      setState(() {
        compOffLoading = false;
      });

      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Attendance(),
      ));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Color.fromARGB(255, 10, 182, 53),
            content: Text(
              "Compensatory Off Requested",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
              ),
            )),
      );
    } else if (statusCode != 200) {
      setState(() {
        compOffLoading = false;
      });
      if (response.body.isNotEmpty) {
        var errMsg = json.decode(responseBody);
        print(errMsg);

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errMsg["msg"].toString())));

        setState(() {
          nextPage == false;
        });
      }
    }
  }

  void _validateInputs() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (radioValue < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(bottom: 300),
              content: Text(
                "Select Any One",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              )),
        );
      } else if (radioValue == 1 &&
          inTime == "In Time" &&
          outTime == "Out Time") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              duration: Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              margin: EdgeInsets.only(bottom: 375),
              content: Text(
                "In and Out time is required",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                ),
              )),
        );
      } else if (radioValue > -1 && inTime.isNotEmpty && outTime.isNotEmpty) {
        markPresent();
      }
    }
  }

  bool compOffButtonLoading = false;
  _getCompOffResponse() async {
    setState(() {
      compOffButtonLoading = true;
    });
    try {
      var url = Uri.parse(
        '${TextConstant.baseURL}/api/comp-off/credit-request/isExist?entityId=$companyId&employeeId=$employeeId&date=${DateFormat('yyyy/MM/dd').format(SelectedDay!)}',
      );

      http.Response res = await http.get(url, headers: {
        'x-access-token': token,
      });

      if (res.statusCode == 200) {
        setState(() {
          compOffButtonLoading = false;
        });
        compOffResponse = jsonDecode(res.body);

        print(compOffResponse);
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
    }
    return;
  }
}
