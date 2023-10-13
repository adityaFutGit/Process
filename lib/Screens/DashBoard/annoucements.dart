// ignore_for_file: prefer_const_constructors, unused_field, prefer_final_fields, avoid_unnecessary_containers, sized_box_for_whitespace

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Models/announcementsModels.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/dashboard.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/userdataModel.dart';

class Annoucements extends StatefulWidget {
  const Annoucements({super.key});

  @override
  State<Annoucements> createState() => _AnnoucementsState();
}

class _AnnoucementsState extends State<Annoucements> {
  AnnouncementsModel _announcementsModel = AnnouncementsModel();
  var locationId;
  @override
  void initState() {
    initPrefs();
    // Future.delayed(const Duration(seconds: 3), () {
    //   setState(() {
    //     _getAnnouncementsDetails();
    //   });
    // });

    super.initState();
  }

  UserModel _userModel = UserModel();
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
    });
    token = prefs.getString("token");
    print(token);
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _getAnnouncementsDetails());
  }

  @override
  void dispose() {
    _getAnnouncementsDetails();

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
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: list.isEmpty
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
                                "Announcements",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          if (list[0].count == 0) ...[
                            Center(
                              child: Container(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 0.35.sw,
                                    ),
                                    Container(
                                      height: 140,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: Image.asset("assets/noAnnc.png",
                                          fit: BoxFit.fill),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "No Announcements",
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color.fromARGB(
                                              255, 150, 150, 150),
                                          letterSpacing: 0.7,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                          if (list.isNotEmpty) ...[
                            Container(
                                // height: 0.6.sw,
                                child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        SizedBox(
                                          height: 20,
                                        ),
                                    scrollDirection: Axis.vertical,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: list[0].count!,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        ((BuildContext context, index) {
                                      return Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 233, 233, 233),
                                                width: 2)),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    list[0]
                                                        .rows![index]
                                                        .subject
                                                        .toString(),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        letterSpacing: 0.4,
                                                        color: Color.fromARGB(
                                                            255, 47, 90, 197)),
                                                  ),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      showModalBottomSheet<
                                                          void>(
                                                        context: context,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                        ),
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      state) {
                                                            return Container(
                                                                height: 320,
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            27,
                                                                        vertical:
                                                                            10),
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                    border: Border.all(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            230,
                                                                            230,
                                                                            230),
                                                                        width:
                                                                            2)),
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Flexible(
                                                                            flex:
                                                                                1,
                                                                            child:
                                                                                Container(
                                                                              width: 270,
                                                                              child: Text(
                                                                                list[0].rows![index].subject.toString(),
                                                                                // maxLines:
                                                                                //       2,
                                                                                style: TextStyle(color: Colors.black87, fontSize: 18, letterSpacing: 0.4, fontWeight: FontWeight.w600),
                                                                              ),
                                                                            ),
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
                                                                      SizedBox(
                                                                        height:
                                                                            10,
                                                                      ),
                                                                      Row(
                                                                        children: [
                                                                          Icon(
                                                                            Icons.calendar_month,
                                                                            color:
                                                                                Colors.grey,
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                6,
                                                                          ),
                                                                          Text(
                                                                            " ${DateFormat.yMMMd().format(DateTime.parse(list[0].rows![index].publishDate.toString()))}",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.grey,
                                                                                fontWeight: FontWeight.w500),
                                                                          )
                                                                        ],
                                                                      ),
                                                                      Divider(
                                                                        color: Color.fromARGB(
                                                                            255,
                                                                            228,
                                                                            227,
                                                                            227),
                                                                        thickness:
                                                                            2,
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      SizedBox(
                                                                        height:
                                                                            20,
                                                                      ),
                                                                      Text(
                                                                        list[0]
                                                                            .rows![index]
                                                                            .description
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                155,
                                                                                155,
                                                                                155),
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            letterSpacing: 0.4),
                                                                      ),
                                                                    ]));
                                                          });
                                                        },
                                                      );
                                                    },
                                                    child: Text(
                                                      "View More",
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 39, 94, 233),
                                                      ),
                                                    ))
                                              ],
                                            ),
                                            Divider(
                                              thickness: 1.5,
                                              color: Color.fromARGB(
                                                  255, 224, 224, 224),
                                              height: 0,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              list[0]
                                                  .rows![index]
                                                  .description
                                                  .toString(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 165, 165, 165),
                                                  letterSpacing: 0.5,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_month,
                                                  color: Colors.grey,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  " ${DateFormat.yMMMd().format(DateTime.parse(list[0].rows![index].publishDate.toString()))}",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    }))),
                          ],
                          SizedBox(
                            height: 20,
                          )
                        ])),
        ));
  }

  List<AnnouncementsModel> list = [];
  dynamic announcementsData;
  var token;
  Future<List<AnnouncementsModel>> _getAnnouncementsDetails() async {
    try {
      String url =
          '${TextConstant.baseURL}/api/announcement/location?locationId=$locationId';
      http.Response res;
      res = await http.get(Uri.parse(url), headers: {
        'x-access-token': token,
      });
      announcementsData = jsonDecode(res.body);
      if (res.statusCode == 200) {
        for (int i = 0; i < announcementsData.length; i++) {
          list.add(AnnouncementsModel.fromJson(announcementsData));
        }
        if (mounted) setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: AppColors.maincolor,
            content: Text(
              "Location is not defined",
              style: TextStyle(color: Colors.white, fontSize: 18),
            )));
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardScreen(),
        ));
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "${e.toString()} \nLoading Again...",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Annoucements(),
      ));
    }
    return list;
  }
}
