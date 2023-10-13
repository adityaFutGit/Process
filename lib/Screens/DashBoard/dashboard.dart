// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print, non_constant_identifier_names, unused_field, unused_local_variable, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cron/cron.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'package:hrcosmoemployee/Constants/text_constant.dart';
import 'package:hrcosmoemployee/Navigation/locator.dart';
import 'package:hrcosmoemployee/Navigation/navigation_service.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/annoucements.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/attendance.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/companyPolicies.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/companyProfile.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/holidayList.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/leave.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/myProfile.dart';
//import 'package:hrcosmoemployee/Screens/DashBoard/payroll.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/request.dart';
import 'package:hrcosmoemployee/Screens/DashBoard/workProfile.dart';
import 'package:hrcosmoemployee/Screens/login/login_screen.dart';
import 'package:hrcosmoemployee/custom_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:vibration/vibration.dart';
import '../../Models/userdataModel.dart';
import 'dart:math' show cos, sqrt, asin;

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  //All Variables Declared
  bool show = false;
  bool showResume = false;
  String checkIn = "";
  String checkOut = "";
  String wrkHRS = "";
  var clockOutDate;
  var clockInDate;
  bool clockOut = false;
  bool isClockedIn = false;
  bool isBreak = false;
  var employeeId;
  var geoTagAction;
  var addressAction;
  String location = 'Null, Press Button';
  String Address = 'search';
  double distanceBetweenTwoPointInMeter = 0;
  var latitude, longitude;
  final NavigationService _navigationService = locator<NavigationService>();
  var In, Out;
  var cI;
  var empLatitude, empLongitude, locationId;
  String? geoTag;
  UserModel _userModel = UserModel();
  bool progress = false;
  bool geoLoc = true;
  var action;
  var imageUrl;
  var dio = Dio();
  final cron = Cron();
  Timer? timer;
  var duration = 5;
  var token;
  bool? attendanceWithMobile;
  bool? attendanceLocationLock;
  var headerText;

  Future<Position> _getGeoLocationPosition() async {
    checkLocationPermissionAccess();
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
  }

  Future<void> GetAddressFromLatLong(Position position) async {
    checkLocationPermissionAccess();
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemarks[0];
    Address =
        '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    latitude = position.latitude;
    longitude = position.longitude;
    print(Address);
    setState(() {});
  }

  List route = const [
    MyProfile(),
    Attendance(),
    CompanyProfile(),
    // Payroll(),
    HolidayList(),
    Leaves(),
    CompanyPolicies(),
    Annoucements(),
    WorkProfile(),
    Request()
  ];

  List<String> svg = [
    "assets/My Profile.png",
    "assets/Attendance.png",
    "assets/Company Profile.png",
    "assets/Payroll.png",
    "assets/Holidays.png",
    "assets/Leaves.png",
    "assets/Company Policies.png",
    "assets/Announcements.png",
    "assets/Work Profile.png",
    "assets/Leaves.png",
  ];

  List<String> gridTitle = [
    "My Profile",
    "Attendance",
    "Company\nProfile",
    "Payroll",
    "Holidays",
    "Leaves",
    "Company\nPolicies",
    "Announcements",
    "Work Profile",
    "Requests"
  ];
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
      //initPrefs();
    });
  }

  @override
  void initState() {
    startStreaming();
    WidgetsBinding.instance.addObserver(this);
    initPrefs();
    super.initState();
  }

  checkCameraPermissionAccess() async {
    cameraStatus = await Permission.camera.status;
    await Permission.camera.request();
  }

  checkLocationPermissionAccess() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showAlertDialogForLocationSetting(context);
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      showAlertDialogForLocationAccess(context);
      return Future.error('Location permissions are denied');
    }
    if (permission == LocationPermission.deniedForever) {
      showAlertDialogForLocationSetting(context);
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  bool visibleDO = false;
  var version;
  initPrefs() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    print(version);
    print("SHERDIL");
    // await Upgrader.clearSavedSettings();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var refresh_token = prefs.getString("refresh_token");
    http.Response res = await http.post(
        Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
        headers: {"refresh_token": refresh_token.toString()});
    var jsonResponse = jsonDecode(res.body);

    print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
    await prefs.setString("token", jsonResponse["token"]);

    var value = prefs.getInt('UserId');

    isClockedIn = prefs.getBool('isClockedIn') ?? false;
    // isBreak = prefs.getBool('isBreak') ?? false;
    checkIn = prefs.getString('clockInTime') ?? checkIn;
    checkOut = prefs.getString('clockOutTime') ?? checkOut;
    wrkHRS = prefs.getString('wrkHrs') ?? wrkHRS;
    clockOutDate = prefs.getString('clockOutDate');
    clockInDate = prefs.getString('clockInDate');
    String decodedMap = prefs.getString('Users') ?? "";
    _userModel = userModelFromMap(decodedMap);
    token = prefs.getString("token");
    attendanceWithMobile = prefs.getBool("attendanceWithMobile");
    attendanceLocationLock = prefs.getBool("attendanceLocationLock");
    setState(() {
      employeeId = value;
      print("EMPLOYEEID: $employeeId");
    });
    prefs.setInt("employeeId", employeeId);
    await checkCameraPermissionAccess();
    await _getDashboardAttendanceDetails();

    setState(() {
      geoTag = _userModel.userData?.employee?.employeeOffrollment == null
          ? _userModel.userData?.employee?.employeeOnrollment?.location?.geoTag
          : _userModel
              .userData?.employee?.employeeOffrollment?.location?.geoTag;
      print(geoTag);
      if (geoTag != null) {
        var arr = geoTag?.split(", ");
        locationId = _userModel
                    .userData?.employee?.employeeOffrollment?.location ==
                null
            ? _userModel.userData?.employee?.employeeOnrollment?.location?.id
            : _userModel.userData?.employee?.employeeOffrollment?.location?.id;
        empLatitude = arr?[0];
        empLongitude = arr?[1];
        // print(locationId);
        // print(empLatitude);
        // print(empLongitude);
      }
      print(attDetails["status"]);
      if (attDetails["status"] == "DO") {
        setState(() {
          visibleDO = true;
        });
      } else {
        setState(() {
          visibleDO = false;
        });
      }
      if (attDetails["status"] == "A") {
        prefs.setString("headerText",
            "Welcome ${_userModel.userData?.firstName},\nPlease clock in to start your workday!");
      } else if (attDetails["status"] == "DO") {
        prefs.setString("headerText",
            "Hi ${_userModel.userData?.firstName},\nToday is Day-Off !");
      } else if (attDetails["timeIn"] != null &&
          attDetails["timeOut"] != null) {
        prefs.setString("headerText",
            "Hi ${_userModel.userData?.firstName},\nYou have checked out for today!");
      } else if (attDetails["status"] == "P") {
        prefs.setString("headerText",
            "Hi ${_userModel.userData?.firstName},\nYour workday started at ${DateFormat('hh:mm a').format(DateTime.parse("0000-00-00T${attDetails["timeIn"]}Z"))}. You can clock out once you finish you workday.");
      }
      setState(() {});

      headerText = prefs.getString("headerText");
    });

    if (clockInDate != DateFormat('dd.MM.yy').format(DateTime.now())) {
      setState(() {
        prefs.setString("wrkHrs", "--:--");
        prefs.setString("clockInTime", "--:--");
        prefs.setString("clockOutTime", "--:--");
        prefs.setBool("isClockedIn", false);
      });
    }
  }

  showAlertDialogForLocationSetting(BuildContext context) {
    // Create button
    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget openSettingButton = TextButton(
      child: Text(
        "Open Setting",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () async {
        Geolocator.openLocationSettings()
            .then((value) => Navigator.of(context).pop());
        //  Navigator.of(context).pop();
        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Location is disable, Open setting to enable the location to mark attendance",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [openSettingButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogForLocationAccess(BuildContext context) {
    // Create button
    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget openSettingButton = TextButton(
      child: Text(
        "Open Setting",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () async {
        Geolocator.openAppSettings()
            .then((value) => Navigator.of(context).pop());

        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Location is Denied, Open setting to give access to the location to mark attendance",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [openSettingButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogForCameraAccess(BuildContext context) {
    // Create button
    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget openSettingButton = TextButton(
      child: Text(
        "Open Setting",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () async {
        Geolocator.openAppSettings()
            .then((value) => Navigator.of(context).pop());

        setState(() {});
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Camera is Denied, Open setting to give access to the camera to mark attendance",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [openSettingButton, noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    initPrefs();
    switch (state) {
      case AppLifecycleState.resumed:
        initPrefs();
        break;
      case AppLifecycleState.inactive:
        initPrefs();
        break;
      case AppLifecycleState.paused:
        initPrefs();
        break;
      case AppLifecycleState.detached:
        initPrefs();
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }

  var distanceBetweenTwoPointInKM;
  var helpTextForDistance;
  var currentLatLong;
  showAlertDialogDistanceError(BuildContext context) {
    // Create button
    Widget noButton = TextButton(
      child: Text(
        "Okay",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Sorry, you are currently not at your expected location. Please move towards your assigned location to mark the attendance.\n\nAssigned Lat-Long:\n$geoTag\n\nCurrent Lat-Long:\n$currentLatLong \n\nDistance: $distanceBetweenTwoPointInKM $helpTextForDistance",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [noButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  double calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.0174532925199432100;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showAlertDialogExit(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 350,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maincolor),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool('isLoggedIn', false);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ));
                  },
                  child: SizedBox(
                    width: 90,
                    child: Row(
                      children: [
                        Icon(Icons.power_settings_new),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Log Out"),
                      ],
                    ),
                  )),
              SizedBox(
                height: 350,
              ),
              Text(
                "Version: $version",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 185, 185, 185),
                    fontSize: 13),
              )
            ],
          ),
        ),
        appBar: CustomAppBar(),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: ((OverscrollIndicatorNotification? notification) {
            notification!.disallowIndicator();
            return true;
          }),
          child: UpgradeAlert(
            upgrader: Upgrader(
              shouldPopScope: () => true,
              showIgnore: false,
              durationUntilAlertAgain: Duration(days: 1),
              dialogStyle: Platform.isIOS
                  ? UpgradeDialogStyle.cupertino
                  : UpgradeDialogStyle.material,
              canDismissDialog: true,
            ),
            child: ModalProgressHUD(
              inAsyncCall: clockInLoading == true ? true : false,
              blur: 3,
              progressIndicator: clockInLoading == true
                  ? Lottie.asset("assets/timer.json", height: 70)
                  : Container(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(top: 20, left: 15),
                  child: responseBody == null
                      ? Align(
                          heightFactor: 6,
                          alignment: Alignment.center,
                          child:
                              Lottie.asset("assets/loading.json", height: 100))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(
                                    headerText,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: .3,
                                        color: Colors.black87),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            attendanceWithMobile == false
                                ? Center(
                                    child: Image.asset(
                                      "assets/appLogo.png",
                                      height: 60,
                                      width: 150,
                                    ),
                                  )
                                : SizedBox(
                                    child: Column(
                                    children: [
                                      Visibility(
                                          visible: visibleDO,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                child: Image.asset(
                                                  "assets/clockInDisable.png",
                                                  height: 100,
                                                ),
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        duration: Duration(
                                                            seconds: 4),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                182, 22, 10),
                                                        content: Text(
                                                          "Today is Day-Off",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        )),
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: 75,
                                              ),
                                              InkWell(
                                                child: Image.asset(
                                                  "assets/clockOutDisable.png",
                                                  height: 100,
                                                ),
                                                onTap: () {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        duration: Duration(
                                                            seconds: 4),
                                                        behavior:
                                                            SnackBarBehavior
                                                                .floating,
                                                        backgroundColor:
                                                            Color.fromARGB(255,
                                                                182, 22, 10),
                                                        content: Text(
                                                          "Today is Day-Off",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                          ),
                                                        )),
                                                  );
                                                },
                                              )
                                            ],
                                          )),
                                      Visibility(
                                        visible: !visibleDO,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Row(
                                                children: [
                                                  Center(
                                                    child: InkWell(
                                                        onTap: attDetails[
                                                                    "status"] ==
                                                                "P"
                                                            ? () {
                                                                if (attDetails[
                                                                            "timeIn"] !=
                                                                        null &&
                                                                    attDetails[
                                                                            "timeOut"] ==
                                                                        null) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                        duration: Duration(
                                                                            seconds:
                                                                                5),
                                                                        behavior:
                                                                            SnackBarBehavior
                                                                                .floating,
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            182,
                                                                            22,
                                                                            10),
                                                                        content:
                                                                            Text(
                                                                          "Your workday already started at ${DateFormat('hh:mm a').format(DateTime.parse("0000-00-00T${attDetails["timeIn"]}Z"))}. You can clock out once you finish your workday. ",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              const TextStyle(
                                                                            letterSpacing:
                                                                                .3,
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        )),
                                                                  );
                                                                }
                                                              }
                                                            : () async {
                                                                await checkLocationPermissionAccess();
                                                                Vibration.vibrate(
                                                                    duration:
                                                                        250,
                                                                    amplitude:
                                                                        1);
                                                                if (geoTag ==
                                                                    null) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                    SnackBar(
                                                                        duration: Duration(
                                                                            seconds:
                                                                                4),
                                                                        behavior:
                                                                            SnackBarBehavior
                                                                                .floating,
                                                                        backgroundColor: Color.fromARGB(
                                                                            255,
                                                                            182,
                                                                            22,
                                                                            10),
                                                                        content:
                                                                            Text(
                                                                          "Location is not assigned, Please contact the admin HR.",
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                          ),
                                                                        )),
                                                                  );
                                                                } else {
                                                                  setState(() {
                                                                    action =
                                                                        "checkIn";
                                                                  });
                                                                  Position
                                                                      position =
                                                                      await _getGeoLocationPosition();
                                                                  location =
                                                                      'Lat: ${position.latitude} , Long: ${position.longitude}';
                                                                  await GetAddressFromLatLong(
                                                                      position);
                                                                  setState(() {
                                                                    latitude =
                                                                        position
                                                                            .latitude;
                                                                    longitude =
                                                                        position
                                                                            .longitude;
                                                                    geoTagAction =
                                                                        "geoTagIn";
                                                                    addressAction =
                                                                        "addressIn";
                                                                    progress =
                                                                        false;
                                                                    currentLatLong =
                                                                        "${position.latitude}, ${position.longitude}";
                                                                  });
                                                                  print(
                                                                      currentLatLong);
                                                                  distanceBetweenTwoPointInMeter = Geolocator.distanceBetween(
                                                                          position
                                                                              .latitude,
                                                                          position
                                                                              .longitude,
                                                                          double.parse(
                                                                              empLatitude),
                                                                          double.parse(
                                                                              empLongitude))
                                                                      .floorToDouble();
                                                                  // var radius =
                                                                  //     calculateDistance(
                                                                  //         position.latitude,
                                                                  //         position.longitude,
                                                                  //         double.parse(
                                                                  //             empLatitude),
                                                                  //         double.parse(
                                                                  //             empLongitude));
                                                                  // print("RADIUS: $radius");
                                                                  print(
                                                                      "DISTANCE BETWEEN: $distanceBetweenTwoPointInKM");
                                                                  if (distanceBetweenTwoPointInMeter >
                                                                      1000.0) {
                                                                    distanceBetweenTwoPointInKM =
                                                                        distanceBetweenTwoPointInMeter /
                                                                            1000;
                                                                    helpTextForDistance =
                                                                        "Kilometers";
                                                                  } else {
                                                                    distanceBetweenTwoPointInKM =
                                                                        distanceBetweenTwoPointInMeter;
                                                                    helpTextForDistance =
                                                                        "Meters";
                                                                  }

                                                                  print(
                                                                      "DISTANCE BETWEEN: $distanceBetweenTwoPointInMeter");

                                                                  if (attendanceLocationLock ==
                                                                      true) {
                                                                    if (distanceBetweenTwoPointInMeter <
                                                                        50.00) {
                                                                      print(
                                                                          "INSIDE 50");
                                                                      uploadImage(
                                                                          ImageSource
                                                                              .camera);
                                                                    } else {
                                                                      print(
                                                                          "Outside 50");
                                                                      showAlertDialogDistanceError(
                                                                          context);
                                                                    }
                                                                  } else {
                                                                    uploadImage(
                                                                        ImageSource
                                                                            .camera);
                                                                  }
                                                                }
                                                              },
                                                        child: attDetails[
                                                                    "timeIn"] !=
                                                                null
                                                            ? Image.asset(
                                                                "assets/clockInDisable.png",
                                                                height: 100,
                                                              )
                                                            : Image.asset(
                                                                "assets/clockInEnable.png",
                                                                height: 100,
                                                              )),
                                                  ),
                                                  SizedBox(
                                                    width: 75,
                                                  ),
                                                  attDetails["status"] != "A"
                                                      ? Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              InkWell(
                                                                  onTap: attDetails["timeOut"] !=
                                                                              null &&
                                                                          attDetails["status"] ==
                                                                              "P"
                                                                      ? () {}
                                                                      : () async {
                                                                          SharedPreferences
                                                                              prefs =
                                                                              await SharedPreferences.getInstance();
                                                                          await checkLocationPermissionAccess();
                                                                          Vibration.vibrate(
                                                                              duration: 250,
                                                                              amplitude: 1);
                                                                          setState(
                                                                              () {
                                                                            action =
                                                                                "checkOut";
                                                                          });
                                                                          var cO =
                                                                              DateFormat('yyyy-MM-ddTHH:mm').format(DateTime.now());
                                                                          Out =
                                                                              DateFormat('hh:mm a').format(DateTime.now());
                                                                          checkOut =
                                                                              Out;
                                                                          clockOut =
                                                                              true;
                                                                          clockOutDate =
                                                                              DateFormat('dd.MM.yy').format(DateTime.now());
                                                                          DateTime
                                                                              dt1 =
                                                                              DateTime.parse(cO);
                                                                          DateTime
                                                                              dt2 =
                                                                              DateTime.parse(prefs.getString("cI").toString());
                                                                          Duration
                                                                              ddd =
                                                                              dt1.difference(dt2);
                                                                          wrkHRS =
                                                                              "${ddd.inHours % 24} hrs : ${ddd.inMinutes % 60} mins";
                                                                          Position
                                                                              position =
                                                                              await _getGeoLocationPosition();
                                                                          location =
                                                                              'Lat: ${position.latitude} , Long: ${position.longitude}';
                                                                          await GetAddressFromLatLong(
                                                                              position);
                                                                          setState(
                                                                              () {
                                                                            latitude =
                                                                                position.latitude;
                                                                            longitude =
                                                                                position.longitude;
                                                                            geoTagAction =
                                                                                "geoTagOut";
                                                                            addressAction =
                                                                                "addressOut";
                                                                            currentLatLong =
                                                                                "${position.latitude}, ${position.longitude}";
                                                                          });

                                                                          distanceBetweenTwoPointInMeter =
                                                                              Geolocator.distanceBetween(position.latitude, position.longitude, double.parse(empLatitude), double.parse(empLongitude)).floorToDouble();
                                                                          // var radius = calculateDistance(
                                                                          //     position.latitude,
                                                                          //     position.longitude,
                                                                          //     double.parse(empLatitude),
                                                                          //     double.parse(empLongitude));
                                                                          // print("RADIUS: ${radius * 1000}");

                                                                          if (distanceBetweenTwoPointInMeter >
                                                                              500.0) {
                                                                            setState(() {
                                                                              distanceBetweenTwoPointInKM = distanceBetweenTwoPointInMeter / 1000;
                                                                              helpTextForDistance = "kilometers";
                                                                            });
                                                                          } else {
                                                                            distanceBetweenTwoPointInKM =
                                                                                distanceBetweenTwoPointInMeter;
                                                                            helpTextForDistance =
                                                                                "meters";
                                                                          }
                                                                          print(
                                                                              "DISTANCE BETWEEN: $distanceBetweenTwoPointInMeter");
                                                                          print(
                                                                              "DISTANCE BETWEEN: $distanceBetweenTwoPointInKM");
                                                                          if (attendanceLocationLock ==
                                                                              true) {
                                                                            if (distanceBetweenTwoPointInMeter <
                                                                                50.00) {
                                                                              print("INSIDE 50");
                                                                              showAlertDialogClockOut(context);
                                                                            } else {
                                                                              print("Outside 50");
                                                                              showAlertDialogDistanceError(context);
                                                                            }
                                                                          } else {
                                                                            showAlertDialogClockOut(context);
                                                                          }
                                                                        },
                                                                  child: attDetails[
                                                                              "timeOut"] ==
                                                                          null
                                                                      ? Image
                                                                          .asset(
                                                                          "assets/clockOutEnable.png",
                                                                          height:
                                                                              100,
                                                                        )
                                                                      : Image
                                                                          .asset(
                                                                          "assets/clockOutDisable.png",
                                                                          height:
                                                                              100,
                                                                        ))
                                                            ],
                                                          ),
                                                        )
                                                      : GestureDetector(
                                                          onTap: () {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                              SnackBar(
                                                                  duration:
                                                                      Duration(
                                                                          seconds:
                                                                              4),
                                                                  behavior:
                                                                      SnackBarBehavior
                                                                          .floating,
                                                                  backgroundColor:
                                                                      Color.fromARGB(
                                                                          255,
                                                                          182,
                                                                          22,
                                                                          10),
                                                                  content: Text(
                                                                    "Please start your workday by clicking on Clock-in",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  )),
                                                            );
                                                          },
                                                          child: Image.asset(
                                                            "assets/clockOutDisable.png",
                                                            height: 100,
                                                          ),
                                                        )
                                                ],
                                              ),
                                            ),
                                            //  if (attDetails["timeIn"] != null &&
                                            //       attDetails["timeOut"] != null) ...[
                                            //     Center(
                                            //       child: Row(
                                            //         children: [
                                            //           Image.asset(
                                            //               "assets/clockInDisable.png"),
                                            //           Image.asset(
                                            //               "assets/clockOutDisable.png"),
                                            //         ],
                                            //       ),
                                            //     )
                                            //   ]
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 0.13.sw,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Clock In',
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(
                                                    Icons.watch_later_outlined,
                                                    size: 10,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                attCheckINloading == false
                                                    ? checkIn
                                                    : attDetails["timeIn"] ==
                                                            null
                                                        ? "--:--"
                                                        : DateFormat('hh:mm a')
                                                            .format(DateTime.parse(
                                                                "0000-00-00T${attDetails["timeIn"]}Z")),
                                                style: TextStyle(
                                                  fontSize: 12.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Clock Out',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(
                                                    Icons.watch_later_outlined,
                                                    size: 10,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                attCheckOUTloading == false
                                                    ? checkOut
                                                    : attDetails["timeOut"] ==
                                                            null
                                                        ? "--:--"
                                                        : DateFormat('hh:mm a')
                                                            .format(DateTime.parse(
                                                                "0000-00-00T${attDetails["timeOut"]}Z")),
                                                style:
                                                    TextStyle(fontSize: 12.5),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    'Working HRS',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  SizedBox(
                                                    width: 4,
                                                  ),
                                                  Icon(
                                                    Icons.timer_sharp,
                                                    size: 10,
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 3,
                                              ),
                                              Text(
                                                attDetails["workDuration"] ==
                                                        null
                                                    ? "--:--"
                                                    : "${DateFormat('HH').format(DateTime.parse("0000-00-00T${attDetails["workDuration"]}Z"))} hrs : ${DateFormat('mm').format(DateTime.parse("0000-00-00T${attDetails["workDuration"]}Z"))} mins ",
                                                style: TextStyle(
                                                    fontSize: 12.5.sp),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                            SizedBox(height: 0.05.sw),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 2,
                                          mainAxisSpacing: 14),
                                  itemCount: 10,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    route[index]));
                                      },
                                      child: Wrap(
                                        runSpacing: 8,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                svg[index],
                                                height: 83,
                                                width: 91,
                                              ),
                                              SizedBox(
                                                height: 7,
                                              ),
                                              Text(
                                                textAlign: TextAlign.center,
                                                gridTitle[index],
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    fontFamily: 'FontMain',
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  var attDetails;
  var responseBody;
  bool attCheckINloading = true;
  bool attCheckOUTloading = true;
  http.Response? res;

  _getDashboardAttendanceDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      res = await http.get(
          Uri.parse(
              '${TextConstant.baseURL}/api/attendance/employeeAttendance/today?employeeId=$employeeId'),
          headers: {
            'x-access-token': token,
          });

      if (res!.statusCode == 200) {
        setState(() {
          responseBody = res!.body;
        });

        attDetails = json.decode(responseBody);
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ));
      }
    } on Exception catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: AppColors.maincolor,
          content: Text(
            "Login after sometime",
            style: TextStyle(color: Colors.white, fontSize: 18),
          )));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ));
    }
  }

//UPLOAD IMAGE FUNCTION -------->>>>>>>>>>>>

  File? _image;
  XFile? compressImage;
  var clockInLoading;
  var cameraStatus;
  String compressedImagePath = "/storage/emulated/0/Download/";
  Future uploadImage(ImageSource source) async {
    if (cameraStatus == PermissionStatus.denied) {
      showAlertDialogForCameraAccess(context);
    }
    if (cameraStatus == PermissionStatus.granted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        final image = await ImagePicker().pickImage(
          preferredCameraDevice: CameraDevice.front,
          source: source,
        );
        if (image == null) return;
        _image = File(image.path);
        if (!mounted) setState(() {});
        final compressedFile = await FlutterImageCompress.compressAndGetFile(
            _image!.path, "$compressedImagePath/${image.name}.jpg",
            quality: 18);
        compressImage = compressedFile;
        String filePath = compressedFile!.path;
        if (action == "checkIn") {
          clockInDetailsFunction();
          setState(() {
            clockInLoading = true;
            show = true;
          });
        } else if (action == "checkOut") {
          setState(() {
            clockInLoading = true;
            show = false;
          });
          clockOutDetailsFunction();
        }
        FormData data = FormData.fromMap(
            {'file': await MultipartFile.fromFile(filePath, filename: ".jpg")});
        Response response = await dio.post(
          '${TextConstant.baseURL}/api/common/common-routes/upload-single',
          data: data,
          options: Options(headers: {'x-access-token': token}),
        );

        if (response.statusCode == 200) {
          setState(() {
            imageUrl = response.data["url"];
          });
        }

        if (action == "checkIn") {
          clockInFunction();
        } else if (action == "checkOut") {
          clockOutFunction();
        }
      } on PlatformException catch (e) {
        print(e);
      }
    }
  }

//Clock In Function
  clockInFunction() async {
    setState(() {
      progress = true;
    });
    markAttendance("checkIn");
  }

  clockInDetailsFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cI = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
      prefs.setString("cI", cI);
      In = DateFormat('hh:mm a').format(DateTime.now());
      checkIn = In;
      clockInDate = DateFormat('dd.MM.yy').format(DateTime.now());
    });
  }

  //Clock Out Function
  clockOutFunction() async {
    markAttendance("checkOut");
  }

  clockOutDetailsFunction() async {
    setState(() {});
    Navigator.of(context).pop();
  }

  markAttendance(String action) async {
    try {
      final uri = Uri.parse(
          "${TextConstant.baseURL}/api/attendance/employeeAttendance/update");

      Map<String, dynamic> body = {
        "action": action,
        "employeeId": employeeId,
        "date": DateTime(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .toString(),
        "locationId": distanceBetweenTwoPointInMeter < 100 ? locationId : null,
        "$geoTagAction": "$latitude, $longitude",
        "$addressAction": Address,
        "imgUrl": imageUrl
      };
      print(body);
      String jsonBody = json.encode(body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': '*/*',
          'x-access-token': token
        },
        body: jsonBody,
      );

      var responseBody = jsonDecode(response.body);
      print(responseBody);
      if (response.statusCode == 200) {
        initPrefs();

        print("COMPLETED");
        Future.delayed(Duration(seconds: 2), () async {
          setState(() {
            clockInLoading = false;
            attCheckINloading = true;
            attCheckOUTloading = true;
          });
        });
      }
    } on Exception catch (e) {
      print(e);
      setState(() {
        progress = false;
      });
      _getDashboardAttendanceDetails();
    }
  }

  //Alert Box for ClockOut
  showAlertDialogClockOut(BuildContext context) {
    // Create button
    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      child: Text(
        "Clock Out",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        uploadImage(ImageSource.camera);
        //  clockOutFunction();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Working hours: $wrkHRS",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      content: Text(
        "Are you sure want to Clock Out?",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      actions: [noButton, deleteButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Alert Box for Dashboard
  showAlertDialogExit(BuildContext context) {
    // Create button
    Widget noButton = TextButton(
      child: Text(
        "No",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      child: Text(
        "Exit",
        style: TextStyle(color: AppColors.maincolor),
      ),
      onPressed: () {
        SystemNavigator.pop();
      },
    );

    AlertDialog alert = AlertDialog(
      content: Text(
        "Are you sure want to Exit?",
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      actions: [noButton, deleteButton],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}




// import 'dart:async';
// import 'dart:convert';
// import 'package:cron/cron.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:hrcosmoemployee/Constants/color_constant.dart';
// import 'package:hrcosmoemployee/Constants/text_constant.dart';
// import 'package:hrcosmoemployee/Navigation/locator.dart';
// import 'package:hrcosmoemployee/Navigation/navigation_service.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/annoucements.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/attendance.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/companyPolicies.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/companyProfile.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/holidayList.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/leave.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/myProfile.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/payroll.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/workProfile.dart';
// import 'package:hrcosmoemployee/Screens/fileUpload.dart';
// import 'package:hrcosmoemployee/Screens/login/login_screen.dart';
// import 'package:hrcosmoemployee/custom_widgets.dart';
// import 'package:http/http.dart' as http;

// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';

// import '../../Models/userdataModel.dart';

// import '../medicalCard.dart';
// import 'dart:io' as io;
// import 'package:flutter_face_api_beta/face_api.dart' as Regula;

// class DashboardScreen extends StatefulWidget {
//   const DashboardScreen({super.key});

//   @override
//   State<DashboardScreen> createState() => _DashboardScreenState();
// }

// class _DashboardScreenState extends State<DashboardScreen>
//     with WidgetsBindingObserver {
//   //All Variables Declared
//   bool show = true;
//   bool showResume = false;
//   String checkIn = "";
//   String checkOut = "";
//   String wrkHRS = "";
//   var clockOutDate;
//   var clockInDate;
//   bool clockOut = false;
//   bool isClockedIn = false;
//   bool isBreak = false;
//   var employeeId;
//   var geoTagAction;
//   var addressAction;
//   String location = 'Null, Press Button';
//   var Address;
//   double distanceBetweenTwoPointInMeter = 0;
//   var latitude, longitude;
//   final NavigationService _navigationService = locator<NavigationService>();
//   var In, Out;
//   var cI;
//   var empLatitude, empLongitude, locationId;
//   String? geoTag;
//   UserModel _userModel = UserModel();
//   bool progress = false;
//   var token;
//   final cron = Cron();
//   Timer? timer;

//   var duration = 10;

//   List route = const [
//     MyProfile(),
//     Attendance(),
//     CompanyProfile(),
//     Payroll(),
//     HolidayList(),
//     Leaves(),
//     CompanyPolicies(),
//     Annoucements(),
//     WorkProfile()
//   ];

//   List<String> svg = [
//     "assets/My Profile.png",
//     "assets/Attendance.png",
//     "assets/Company Profile.png",
//     "assets/Payroll.png",
//     "assets/Holidays.png",
//     "assets/Leaves.png",
//     "assets/Company Policies.png",
//     "assets/Announcements.png",
//     "assets/Work Profile.png",
//   ];

//   List<String> gridTitle = [
//     "My Profile",
//     "Attendance",
//     "Company\nProfile",
//     "Payroll",
//     "Holidays",
//     "Leaves",
//     "Company\nPolicies",
//     "Announcements",
//     "Work Profile",
//   ];
// //Connection Checker
//   late ConnectivityResult result;
//   late StreamSubscription subscription;
//   var isConnected = false;
//   checkInternet() async {
//     result = await Connectivity().checkConnectivity();
//     if (result != ConnectivityResult.none) {
//       isConnected = true;
//     } else {
//       isConnected = false;
//       showDialogBox();
//     }
//     setState(() {});
//   }

//   showDialogBox() {
//     showDialog(
//         barrierDismissible: false,
//         context: context,
//         builder: (context) => CupertinoAlertDialog(
//               title: Text("No Internet"),
//               content: Text("Please check your internet connection"),
//               actions: [
//                 CupertinoButton.filled(
//                     child: Text("Retry"),
//                     onPressed: () {
//                       Navigator.pop(context);
//                       checkInternet();
//                     })
//               ],
//             ));
//   }

//   startStreaming() {
//     subscription = Connectivity().onConnectivityChanged.listen((event) async {
//       checkInternet();
//       // initPrefs();
//     });
//   }

//   var image1 = Regula.MatchFacesImage();
//   var image2 = Regula.MatchFacesImage();
//   var img1 = Image.asset('assets/profile.jpeg');
//   var img2 = Image.asset('assets/profile.jpeg');
//   var process = " ";
//   double similarity = 0.0;

//   @override
//   void initState() {
//     timer = Timer.periodic(Duration(minutes: duration), (Timer t) async {
//       print("SHERDIL");
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var refresh_token = prefs.getString("refresh_token");
//       http.Response res = await http.post(
//           Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
//           headers: {"refresh_token": refresh_token.toString()});
//       var jsonResponse = jsonDecode(res.body);

//       print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");

//       await prefs.setString("token", jsonResponse["token"]);

//       await initPrefs();
//     });

//     cron.schedule(Schedule.parse('30 2 * * *'), () async {
//       // getDuration();
//     });
//     startStreaming();
//     WidgetsBinding.instance.addObserver(this);
//     initPrefs();
//     super.initState();
//   }

//   initPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     print("MMMMMMMMMMMMKKKKKKKKKKKKK: ${prefs.getString(process)}");
//     if (prefs.getString(process) == "None") {
//       //  prefs.setString(process, "None");
//       print("HLLLLLLLLLLLLLLLLL");
//       Regula.FaceSDK.presentFaceCaptureActivity().then((result) => {
//             print('result present face capture $result'),
//             setImage(
//                 true,
//                 base64Decode(
//                     Regula.FaceCaptureResponse.fromJson(json.decode(result))!
//                         .image!
//                         .bitmap!
//                         .replaceAll("\n", "")),
//                 Regula.ImageType.LIVE),
//           });
//       await prefs.setString(process, "Done");
//     }
//     var value = prefs.getInt('UserId');

//     if (!mounted) {
//       setState(() {
//         isClockedIn = prefs.getBool('isClockedIn') ?? false;
//         // isBreak = prefs.getBool('isBreak') ?? false;
//         checkIn = prefs.getString('clockInTime') ?? checkIn;
//         checkOut = prefs.getString('clockOutTime') ?? checkOut;
//         wrkHRS = prefs.getString('wrkHrs') ?? wrkHRS;
//         clockOutDate = prefs.getString('clockOutDate');
//         clockInDate = prefs.getString('clockInDate');
//         String decodedMap = prefs.getString('Users') ?? "";
//         _userModel = userModelFromMap(decodedMap);
//       });
//     }
//     setState(() {
//       employeeId = value;
//     });
//     setState(() {
//       geoTag =
//           _userModel.userData?.employee?.employeeOffrollment?.location == null
//               ? "28.46177907305337, 77.0287459224417"
//               : _userModel
//                   .userData?.employee?.employeeOffrollment?.location?.geoTag;

//       var arr = geoTag?.split(", ");
// //       locationId =
//           _userModel.userData?.employee?.employeeOffrollment?.location == null
//               ? _userModel.userData?.employee?.employeeOnrollment?.location?.id
//               : _userModel
//                   .userData?.employee?.employeeOffrollment?.location?.id;
//       empLatitude = arr?[0];
//       empLongitude = arr?[1];
//     });
//     print(locationId);
//     print(empLatitude);
//     print(empLongitude);

//     if (clockInDate != DateFormat('dd.MM.yy').format(DateTime.now())) {
//       setState(() {
//         prefs.setString("wrkHrs", "--:--");
//         prefs.setString("clockInTime", "--:--");
//         prefs.setString("clockOutTime", "--:--");
//         prefs.setBool("isClockedIn", false);
//       });
//     }
//   }

//   Future<Position> _getGeoLocationPosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

//   Future<void> GetAddressFromLatLong(Position position) async {
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     Placemark place = placemarks[0];
//     setState(() {
//       Address =
//           '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
//     });
//     latitude = position.latitude;
//     longitude = position.longitude;
//     print(Address);
//     setState(() {});
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     initPrefs();
//     switch (state) {
//       case AppLifecycleState.resumed:
//         initPrefs();
//         print("app in resumed from background");
//         break;
//       case AppLifecycleState.inactive:
//         // initPrefs();
//         print("app is in inactive state");
//         break;
//       case AppLifecycleState.paused:
//         // initPrefs();
//         print("app is in paused state");
//         break;
//       case AppLifecycleState.detached:
//         print("app has been removed");
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () {
//         return showAlertDialogExit(context);
//       },
//       child: Scaffold(
//         //  bottomNavigationBar: CustomWidgets.navBar(onTap: () {}),
//         backgroundColor: Colors.white,
//         drawer: Drawer(
//           backgroundColor: Colors.white,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 85,
//               ),
//               Stack(
//                 children: [
//                   Container(
//                     width: 110,
//                     height: 110,
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                           width: 2.7, color: Color.fromARGB(255, 30, 67, 159)),
//                       boxShadow: [
//                         BoxShadow(
//                             spreadRadius: 2,
//                             blurRadius: 20,
//                             color: Colors.black.withOpacity(0.1),
//                             offset: Offset(0, 10))
//                       ],
//                       shape: BoxShape.circle,
//                       image:
//                           DecorationImage(fit: BoxFit.cover, image: img1.image
//                               // getDisplayImage(),
//                               ),
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(
//                 height: 500,
//               ),
//               ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.maincolor),
//                   onPressed: () async {
//                     final prefs = await SharedPreferences.getInstance();
//                     prefs.setBool('isLoggedIn', false);
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                       builder: (context) => const LoginScreen(),
//                     ));
//                     prefs.setBool("isClockedIn", false);
//                     prefs.setString("clockOutDate", "--:--");
//                     prefs.setString("clockInDate", "--:--");
//                     // prefs.setString(process, "None");
//                   },
//                   child: SizedBox(
//                     width: 90,
//                     child: Row(
//                       children: [
//                         Icon(Icons.power_settings_new),
//                         SizedBox(
//                           width: 8,
//                         ),
//                         Text("Log Out"),
//                       ],
//                     ),
//                   )),
//             ],
//           ),
//         ),
//         appBar: CustomAppBar(),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.only(top: 0.15.sw, left: 15),
//             child: Column(
//               children: [
//                 SizedBox(
//                     child: Column(
//                   children: [
//                     Center(
//                         //At first we have have initialized show as true so that clock in button is shown
//                         // if we click on clock in show will be false so if show is false clock out button will be shown.
//                         child: show == true && isClockedIn == false
//                             ? progress == true
//                                 ? Lottie.asset("assets/timer.json", height: 70)
//                                 : InkWell(
//                                     //In this logic if clock out date and current date is equal it will not clock in again
//                                     onTap: clockOutDate ==
//                                             DateFormat('dd.MM.yy')
//                                                 .format(DateTime.now())
//                                         ? () {}
//                                         : () {
//                                             //Here clock in function is called you can see the logic at the end below
//                                             clockInFunction();
//                                           },
//                                     child: Image.asset("assets/clockIn.png"))
//                             : Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   InkWell(
//                                       onTap: () async {
//                                         //Here Alert box will be open to ask for clock out or not you can see the logic at the end below
//                                         showAlertDialogClockOut(context);
//                                       },
//                                       child:
//                                           Image.asset("assets/clockOut.png")),
//                                 ],
//                               )),
//                     SizedBox(
//                       height: 0.13.sw,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   'Clock In',
//                                   style: TextStyle(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                                 Icon(
//                                   Icons.watch_later_outlined,
//                                   size: 10,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             Text(
//                               checkIn,
//                               style: TextStyle(
//                                 fontSize: 12.5,
//                               ),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   'Clock Out',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                                 Icon(
//                                   Icons.watch_later_outlined,
//                                   size: 10,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             Text(
//                               checkOut,
//                               style: TextStyle(fontSize: 12.5),
//                             ),
//                           ],
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(
//                                   'Working HRS',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                                 SizedBox(
//                                   width: 4,
//                                 ),
//                                 Icon(
//                                   Icons.timer_sharp,
//                                   size: 10,
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             Text(
//                               wrkHRS,
//                               style: TextStyle(fontSize: 12.5.sp),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ],
//                 )),
//                 SizedBox(height: 0.05.sw),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 10.0),
//                   child: GridView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               crossAxisSpacing: 2,
//                               mainAxisSpacing: 14),
//                       itemCount: 9,
//                       itemBuilder: (BuildContext ctx, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => route[index]));
//                           },
//                           child: Wrap(
//                             runSpacing: 8,
//                             children: [
//                               Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Image.asset(
//                                     svg[index],
//                                     height: 92,
//                                     width: 92,
//                                   ),
//                                   SizedBox(
//                                     height: 7,
//                                   ),
//                                   Text(
//                                     textAlign: TextAlign.center,
//                                     gridTitle[index],
//                                     style: const TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500),
//                                   )
//                                 ],
//                               ),
//                             ],
//                           ),
//                         );
//                       }),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

// //Clock In Function
//   clockInFunction() async {
//     setState(() {
//       progress = true;
//     });
//     await Regula.FaceSDK.presentFaceCaptureActivity().then((result) => {
//           print('result present face capture $result'),
//           setImage(
//               false,
//               base64Decode(
//                   Regula.FaceCaptureResponse.fromJson(json.decode(result))!
//                       .image!
//                       .bitmap!
//                       .replaceAll("\n", "")),
//               Regula.ImageType.LIVE)
//         });

//     await matchFaces("checkIn");
//   }

//   void clockInDetailsFunction() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Position position = await _getGeoLocationPosition();
//     location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
//     await GetAddressFromLatLong(position);
//     setState(() {
//       latitude = position.latitude;
//       longitude = position.longitude;
//       geoTagAction = "geoTagIn";
//       addressAction = "addressIn";
//       progress = false;
//     });
//     // await checkSimilarity("checkIn");
//     distanceBetweenTwoPointInMeter = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         double.parse(empLatitude),
//         double.parse(empLongitude));
//     print(distanceBetweenTwoPointInMeter);

//     await prefs.setBool("isClockedIn", true);
//     setState(() {
//       isClockedIn = true;
//     });

//     setState(() {
//       cI = DateFormat('yyyy-MM-ddTHH:mm:ss').format(DateTime.now());
//       prefs.setString("cI", cI);
//       In = DateFormat('hh:mm a').format(DateTime.now());
//       checkIn = In;
//       clockInDate = DateFormat('dd.MM.yy').format(DateTime.now());
//     });
//     await prefs.setString("clockInDate", clockInDate);
//     await prefs.setString("clockInTime", checkIn);
//     await _uploadDocuments(img2.image);
//     // setState(() async {
//     //   var bytesdata =
//     //       Base64Decoder().convert(img2.image.toString().split(",").last);
//     //   var selectedFile = bytesdata;

//     // });
//   }

//   //Clock Out Function
//   clockOutFunction() async {
//     await Regula.FaceSDK.presentFaceCaptureActivity().then((result) => {
//           print('result present face capture $result'),
//           setImage(
//               false,
//               base64Decode(
//                   Regula.FaceCaptureResponse.fromJson(json.decode(result))!
//                       .image!
//                       .bitmap!
//                       .replaceAll("\n", "")),
//               Regula.ImageType.LIVE)
//         });
//     Navigator.of(context).pop();
//     await matchFaces("checkOut");
//   }

//   clockOutDetailsFunction() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Position position = await _getGeoLocationPosition();
//     location = 'Lat: ${position.latitude} , Long: ${position.longitude}';
//     setState(() {
//       latitude = position.latitude;
//       longitude = position.longitude;
//       geoTagAction = "geoTagOut";
//       addressAction = "addressOut";
//     });
//     await GetAddressFromLatLong(position);
//     distanceBetweenTwoPointInMeter = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         double.parse(empLatitude),
//         double.parse(empLongitude));
//     print("distanceBetweenTwoPointInMeter: $distanceBetweenTwoPointInMeter");
//     setState(() {
//       show = true;
//     });
//     await prefs.setBool("isClockedIn", false);
//     setState(() {
//       isClockedIn = false;
//     });

//     setState(() {
//       var cO = DateFormat('yyyy-MM-ddTHH:mm').format(DateTime.now());
//       Out = DateFormat('hh:mm a').format(DateTime.now());
//       checkOut = Out;
//       clockOut = true;
//       clockOutDate = DateFormat('dd.MM.yy').format(DateTime.now());
//       DateTime dt1 = DateTime.parse(cO);
//       DateTime dt2 = DateTime.parse(prefs.getString("cI").toString());
//       Duration ddd = dt1.difference(dt2);
//       wrkHRS = "${ddd.inHours % 24} hrs : ${ddd.inMinutes % 60} mins";
//     });
//     await prefs.setString("wrkHrs", wrkHRS);
//     await prefs.setString("clockOutTime", checkOut);
//     await prefs.setString("clockOutDate", clockOutDate);
//     // setState(() async {
//     //   var bytesdata =
//     //       Base64Decoder().convert(img2.image.toString().split(",").last);
//     //   var selectedFile = bytesdata;

//     // });
//     await _uploadDocuments(img2.image);
//     //Navigator.of(context).pop();
//     // await markAttendance("checkOut");
//   }
// //Api Calling here---------

//   markAttendance(String action) async {
//     try {
//       final uri = Uri.parse(
//           "${TextConstant.baseURL}/api/attendance/employeeAttendance/update");
//       // final headers = {
//       //   'Content-Type': 'application/json',
//       //   'Accept': '*/*',
//       // };
//       Map<String, dynamic> body = {
//         "action": action,
//         "employeeId": employeeId,
//         "date": DateTime(
//                 DateTime.now().year, DateTime.now().month, DateTime.now().day)
//             .toString(),
//         "locationId": distanceBetweenTwoPointInMeter < 100 ? locationId : null,
//         "$geoTagAction": "$latitude, $longitude",
//         "$addressAction": Address,
//       };
//       String jsonBody = json.encode(body);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       var response = await post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': '*/*',
//           'x-access-token': token
//         },
//         body: jsonBody,
//       );

//       var responseBody = jsonDecode(response.body);
//       print(responseBody);
//       if (response.statusCode == 200) {
//         print("COMPLETED");
//         setState(() {
//           progress = false;
//         });
//       }
//     } on Exception catch (e) {
//       setState(() {
//         progress = false;
//       });
//       markAttendance(action);
//     }
//   }

//   //Alert Box for ClockOut
//   showAlertDialogClockOut(BuildContext context) {
//     // Create button
//     Widget noButton = TextButton(
//       child: Text(
//         "No",
//         style: TextStyle(color: AppColors.maincolor),
//       ),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );
//     Widget deleteButton = TextButton(
//       child: Text(
//         "Clock Out",
//         style: TextStyle(color: AppColors.maincolor),
//       ),
//       onPressed: () {
//         clockOutFunction();
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       content: Text(
//         "Are you sure want to Clock Out?",
//         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//       ),
//       actions: [noButton, deleteButton],
//     );

//     // show the dialog
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   //Alert Box for Dashboard
//   showAlertDialogExit(BuildContext context) {
//     // Create button
//     Widget noButton = TextButton(
//       child: Text(
//         "No",
//         style: TextStyle(color: AppColors.maincolor),
//       ),
//       onPressed: () {
//         Navigator.of(context).pop();
//       },
//     );
//     Widget deleteButton = TextButton(
//       child: Text(
//         "Exit",
//         style: TextStyle(color: AppColors.maincolor),
//       ),
//       onPressed: () {
//         SystemNavigator.pop();
//       },
//     );

//     AlertDialog alert = AlertDialog(
//       content: Text(
//         "Are you sure want to Exit?",
//         style: TextStyle(
//           fontSize: 16,
//         ),
//       ),
//       actions: [noButton, deleteButton],
//     );
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return alert;
//       },
//     );
//   }

//   Future matchFaces(action) async {
//     print(image1.bitmap);
//     print('image1.bitmap mathc');
//     print(image2.bitmap);
//     print('image2.bitmap mathc');
//     if (image1.bitmap == null ||
//         image1.bitmap == "" ||
//         image2.bitmap == null ||
//         image2.bitmap == "") return;
//     similarity = 0;
//     print("mathe face start");
//     //  update();
//     var request = Regula.MatchFacesRequest();
//     request.images = [image1, image2];

//     Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
//       var response = Regula.MatchFacesResponse.fromJson(json.decode(value));

//       Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//               jsonEncode(response!.results), 0.75)
//           .then((str) {
//         var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
//             json.decode(str));
//         setState(() {
//           similarity = split!.matchedFaces.isNotEmpty
//               ? double.parse(
//                   (split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2))
//               : 0;
//           image2.bitmap == null;
//           image2.bitmap == "";
//         });
//         print("SIMILARITYYYYYYY: $similarity");
//       });
//     });
//     Future.delayed(Duration(seconds: 10), () async {
//       await checkSimilarity(action);
//     });
//   }

//   Future<String> checkSimilarity(String action) async {
//     print("CHECKNGGGGGGG");
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     if (similarity > 85.00) {
//       action == "checkIn"
//           ? clockInDetailsFunction()
//           : clockOutDetailsFunction();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             duration: Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.green,
//             content: Text(
//               "Face matched",
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 20,
//               ),
//             )),
//       );
//       await markAttendance(action);
//     } else if (similarity < 85.00) {
//       setState(() {
//         progress = false;
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             duration: Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.red,
//             content: Text(
//               "Face does not match!!!",
//               textAlign: TextAlign.center,
//               style: const TextStyle(
//                 fontSize: 20,
//               ),
//             )),
//       );
//     }
//     return action;
//   }

//   setImage(bool first, Uint8List? imageFile, int type) {
//     if (imageFile == null) return;
//     similarity = 0;
//     setState(() {});

//     if (first) {
//       image1.bitmap = base64Encode(imageFile);
//       image1.imageType = type;
//       setState(() {
//         img1 = Image.memory(imageFile);

//         process = "Done";
//       });

//       print(image1.bitmap);
//       print('image1.bitmap');
//     } else {
//       image2.bitmap = base64Encode(imageFile);
//       image2.imageType = type;
//       img2 = Image.memory(imageFile);
//       print(image2.bitmap);
//       print('image2.bitmap');
//       setState(() {});
//     }
//   }

//   Future _uploadDocuments(ImageProvider file) async {
//     String url =
//         '${TextConstant.baseURL}/api/common/common-routes/upload-single';

//     var request = http.MultipartRequest('POST', Uri.parse(url));
//     request.files.add(http.MultipartFile.fromString(
//       'file',
//       file.toString(),
//     ));
//     var res = await request.send();
//     var responsed = await http.Response.fromStream(res);
//     final responseData = json.decode(responsed.body);
//     print("RESPONSE URL: $responseData");
//   }
//   // Future compressImage() async {
//   //   final compressedFile =
//   //       await FlutterImageCompress.compressAndGetFile(, targetPath);
//   // }
// }





//CLOCK IN CLOCK BUTTON OLD

 
                                // if (attDetails["timeIn"] == null) ...[
                                //   Center(
                                //     child: InkWell(
                                //         onTap: attDetails["status"] == "P"
                                //             ? () {}
                                //             : () async {
                                //                 await checkLocationPermissionAccess();
                                //                 if (geoTag == null) {
                                //                   ScaffoldMessenger.of(context)
                                //                       .showSnackBar(
                                //                     SnackBar(
                                //                         duration: Duration(
                                //                             seconds: 4),
                                //                         behavior:
                                //                             SnackBarBehavior
                                //                                 .floating,
                                //                         backgroundColor:
                                //                             Colors.red,
                                //                         content: Text(
                                //                           "Location is not assigned, Please contact the admin HR.",
                                //                           textAlign:
                                //                               TextAlign.center,
                                //                           style:
                                //                               const TextStyle(
                                //                             fontSize: 20,
                                //                           ),
                                //                         )),
                                //                   );
                                //                 } else {
                                //                   setState(() {
                                //                     action = "checkIn";
                                //                   });
                                //                   Position position =
                                //                       await _getGeoLocationPosition();
                                //                   location =
                                //                       'Lat: ${position.latitude} , Long: ${position.longitude}';
                                //                   await GetAddressFromLatLong(
                                //                       position);
                                //                   setState(() {
                                //                     latitude =
                                //                         position.latitude;
                                //                     longitude =
                                //                         position.longitude;
                                //                     geoTagAction = "geoTagIn";
                                //                     addressAction = "addressIn";
                                //                     progress = false;
                                //                     currentLatLong =
                                //                         "CURRENT LAT LONG: ${position.latitude}, ${position.longitude}";
                                //                   });
                                //                   print(currentLatLong);
                                //                   distanceBetweenTwoPointInMeter =
                                //                       Geolocator.distanceBetween(
                                //                               position.latitude,
                                //                               position
                                //                                   .longitude,
                                //                               double.parse(
                                //                                   empLatitude),
                                //                               double.parse(
                                //                                   empLongitude))
                                //                           .floorToDouble();
                                //                   // var radius =
                                //                   //     calculateDistance(
                                //                   //         position.latitude,
                                //                   //         position.longitude,
                                //                   //         double.parse(
                                //                   //             empLatitude),
                                //                   //         double.parse(
                                //                   //             empLongitude));
                                //                   // print("RADIUS: $radius");
                                //                   print(
                                //                       "DISTANCE BETWEEN: $distanceBetweenTwoPointInKM");
                                //                   if (distanceBetweenTwoPointInMeter >
                                //                       1000.0) {
                                //                     distanceBetweenTwoPointInKM =
                                //                         distanceBetweenTwoPointInMeter /
                                //                             1000;
                                //                     helpTextForDistance =
                                //                         "Kilometers";
                                //                   } else {
                                //                     distanceBetweenTwoPointInKM =
                                //                         distanceBetweenTwoPointInMeter;
                                //                     helpTextForDistance =
                                //                         "Meters";
                                //                   }

                                //                   print(
                                //                       "DISTANCE BETWEEN: $distanceBetweenTwoPointInMeter");

                                //                   if (attendanceLocationLock ==
                                //                       true) {
                                //                     if (distanceBetweenTwoPointInMeter <
                                //                         50.00) {
                                //                       print("INSIDE 50");
                                //                       uploadImage(
                                //                           ImageSource.camera);
                                //                     } else {
                                //                       print("Outside 50");
                                //                       showAlertDialogDistanceError(
                                //                           context);
                                //                     }
                                //                   } else {
                                //                     uploadImage(
                                //                         ImageSource.camera);
                                //                   }
                                //                 }
                                //               },
                                //         child: show == true
                                //             ? Image.asset("assets/clockOut.png")
                                //             : Image.asset(
                                //                 "assets/clockIn.png")),
                                //   )
                                // ] else if (attDetails["timeIn"] != null &&
                                //     attDetails["timeOut"] != null) ...[
                                //   Center(
                                //     child: Image.asset("assets/clockIn.png"),
                                //   )
                                // ] else if (attDetails["timeIn"] != null) ...[
                                //   Center(
                                //     child: Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.center,
                                //       crossAxisAlignment:
                                //           CrossAxisAlignment.center,
                                //       children: [
                                //         InkWell(
                                //             onTap: () async {
                                //               await checkLocationPermissionAccess();
                                //               setState(() {
                                //                 action = "checkOut";
                                //               });
                                //               Position position =
                                //                   await _getGeoLocationPosition();
                                //               location =
                                //                   'Lat: ${position.latitude} , Long: ${position.longitude}';
                                //               await GetAddressFromLatLong(
                                //                   position);
                                //               setState(() {
                                //                 latitude = position.latitude;
                                //                 longitude = position.longitude;
                                //                 geoTagAction = "geoTagOut";
                                //                 addressAction = "addressOut";
                                //                 currentLatLong =
                                //                     "${position.latitude}, ${position.longitude}";
                                //               });

                                //               distanceBetweenTwoPointInMeter =
                                //                   Geolocator.distanceBetween(
                                //                           position.latitude,
                                //                           position.longitude,
                                //                           double.parse(
                                //                               empLatitude),
                                //                           double.parse(
                                //                               empLongitude))
                                //                       .floorToDouble();
                                //               // var radius = calculateDistance(
                                //               //     position.latitude,
                                //               //     position.longitude,
                                //               //     double.parse(empLatitude),
                                //               //     double.parse(empLongitude));
                                //               // print("RADIUS: ${radius * 1000}");

                                //               if (distanceBetweenTwoPointInMeter >
                                //                   500.0) {
                                //                 setState(() {
                                //                   distanceBetweenTwoPointInKM =
                                //                       distanceBetweenTwoPointInMeter /
                                //                           1000;
                                //                   helpTextForDistance =
                                //                       "kilometers";
                                //                 });
                                //               } else {
                                //                 distanceBetweenTwoPointInKM =
                                //                     distanceBetweenTwoPointInMeter;
                                //                 helpTextForDistance = "meters";
                                //               }
                                //               print(
                                //                   "DISTANCE BETWEEN: $distanceBetweenTwoPointInMeter");
                                //               print(
                                //                   "DISTANCE BETWEEN: $distanceBetweenTwoPointInKM");
                                //               if (attendanceLocationLock ==
                                //                   true) {
                                //                 if (distanceBetweenTwoPointInMeter <
                                //                     50.00) {
                                //                   print("INSIDE 50");
                                //                   showAlertDialogClockOut(
                                //                       context);
                                //                 } else {
                                //                   print("Outside 50");
                                //                   showAlertDialogDistanceError(
                                //                       context);
                                //                 }
                                //               } else {
                                //                 showAlertDialogClockOut(
                                //                     context);
                                //               }
                                //             },
                                //             child: Image.asset(
                                //                 "assets/clockOut.png")),
                                //       ],
                                //     ),
                                //   )