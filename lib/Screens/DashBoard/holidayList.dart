// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_final_fields, prefer_typing_uninitialized_variables, unused_element, unused_local_variable, avoid_print

// import 'dart:collection';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Models/userdataModel.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:hrcosmoemployee/Models/holidayModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class HolidayList extends StatefulWidget {
  const HolidayList({super.key});

  @override
  State<HolidayList> createState() => _HolidayListState();
}

class _HolidayListState extends State<HolidayList> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay, focusedDay = DateTime.now();
  dynamic holidayData;
  DateTime? SelectedDay;
  List<Holiday> allData = List.empty(growable: true);
  List<Holiday> monthHolidays = List.empty(growable: true);
  UserModel _userModel = UserModel();
  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        focusedDay = focusedDay;
        _selectedDay = selectedDay;
      });
    }
  }

  @override
  void initState() {
    initPrefs();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {

    // });

    super.initState();
  }

  var companyId;
  var locationId;
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
      locationId =
          _userModel.userData?.employee?.employeeOffrollment?.location == null
              ? _userModel.userData?.employee?.employeeOnrollment?.location?.id
              : _userModel
                  .userData?.employee?.employeeOffrollment?.location?.id;
      companyId = _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.onRollCompany?.id
          : _userModel
              .userData?.employee?.employeeOffrollment?.offRollCompany?.id;
    });
    token = prefs.getString("token");
    print(locationId);
    print(companyId);
    allData = await _getHolidays();
    showHolidayList(DateTime.now());
  }

  @override
  void dispose() {
    _getHolidays();
    showHolidayList(DateTime.now());
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
              child: holidayData == null
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
                                "Holidays",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          TableCalendar(
                            rowHeight: 45,
                            focusedDay: focusedDay!,
                            firstDay: DateTime(2022),
                            lastDay: DateTime(2050),
                            calendarFormat: _calendarFormat,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            calendarBuilders: CalendarBuilders(
                              defaultBuilder: (
                                context,
                                day,
                                focusedDay,
                              ) {
                                for (Holiday d in list) {
                                  if (day.day == d.date.day &&
                                      day.month == d.date.month &&
                                      day.year == d.date.year) {
                                    return Container(
                                      height: 33,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.lightGreen,
                                          border: Border.all(
                                              color: Colors.transparent),
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                        child: Text(
                                          '${day.day}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    );
                                  }
                                }
                                return null;
                              },
                            ),
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
                            calendarStyle: CalendarStyle(
                                markerDecoration: BoxDecoration(
                                    color: Colors.green,
                                    border:
                                        Border.all(color: Colors.transparent),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10)),
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
                                    borderRadius: BorderRadius.circular(10)),
                                weekendTextStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                weekendDecoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.transparent),
                                    color: Color.fromARGB(255, 244, 199, 87),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10)),
                                selectedTextStyle:
                                    TextStyle(color: Colors.black),
                                selectedDecoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10))),
                            onDaySelected: ((selectedDay, changedDate) {
                              if (!isSameDay(_selectedDay, selectedDay)) {
                                setState(() {
                                  _selectedDay = selectedDay;
                                  SelectedDay = selectedDay;
                                  focusedDay = changedDate;
                                });
                              }
                            }),
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            onPageChanged: (changedDate) {
                              focusedDay = changedDate;
                              monthHolidays = showHolidayList(changedDate);
                              setState(() {});
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Divider(
                            thickness: 1.3,
                            height: 30,
                            color: Colors.grey[350],
                          ),
                          if (monthHolidays.isEmpty) ...[
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    height: 130,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Color.fromARGB(
                                                255, 224, 223, 223),
                                            width: 2)),
                                    child: Image.asset("assets/calendar.png"),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'No Holidays This Month',
                                    style: TextStyle(
                                        fontSize: 20,
                                        color:
                                            Color.fromARGB(255, 150, 150, 150),
                                        letterSpacing: 0.7,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (monthHolidays.isNotEmpty) ...[
                            SizedBox(
                              //height: 400,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: monthHolidays.length,
                                  itemBuilder: (BuildContext context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        height: 60,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 235, 234, 234),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Icon(
                                                Icons.calendar_month,
                                                color: AppColors.maincolor,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 12,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  monthHolidays[index].name,
                                                  style: TextStyle(
                                                      color:
                                                          AppColors.maincolor,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                Text(
                                                  DateFormat.EEEE().format(
                                                      monthHolidays[index]
                                                          .date),
                                                  style: TextStyle(
                                                      color: AppColors.darkgrey,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )
                                              ],
                                            ),
                                            Expanded(
                                              child: Text(
                                                DateFormat.yMMMMd().format(
                                                    monthHolidays[index].date),
                                                textAlign: TextAlign.right,
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 116, 116, 116),
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ])),
        ));
  }

  // Get Holiday information by API
  List<Holiday> list = [];
  var token;
  Future<List<Holiday>> _getHolidays() async {
    try {
      String url =
          '${TextConstant.baseURL}/api/holiday/list?companyId=$companyId&locationId=$locationId';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      holidayData = jsonDecode(res.body);
      for (int i = 0; i < holidayData["holidays"]["rows"].length; i++) {
        list.add(Holiday.fromJson(holidayData["holidays"]["rows"][i]));
      }
      if (mounted) setState(() {});
      print(list);
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nLoading Again...",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const HolidayList(),
      ));
    }
    return list;
  }

  List<Holiday> showHolidayList(DateTime focusedDay) {
    monthHolidays.clear();
    int i;
    String parsedDate;
    DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
    for (i = 0; i < allData.length; i++) {
      DateTime date = allData[i].date;
      parsedDate = dateFormat.format(date);

      if (date.month == focusedDay.month) {
        monthHolidays.add(allData[i]);
      }
    }

    return monthHolidays;
  }
}
