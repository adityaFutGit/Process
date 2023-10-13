// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:http/http.dart' as http;
// import 'package:hrcosmoemployee/Screens/DashBoard/investment.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../Constants/color_constant.dart';
// import '../../Constants/text_constant.dart';
// import '../../custom_widgets.dart';

// class Regime extends StatefulWidget {
//   const Regime({super.key});

//   @override
//   State<Regime> createState() => _RegimeState();
// }

// class _RegimeState extends State<Regime> {
//   var salaryId;
//   var token;
//   int radioValue = -1;
//   @override
//   void initState() {
//     initPrefs();
//     super.initState();
//   }

//   initPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var refresh_token = prefs.getString("refresh_token");
//     http.Response res = await http.post(
//         Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
//         headers: {"refresh_token": refresh_token.toString()});
//     var jsonResponse = jsonDecode(res.body);

//     print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
//     await prefs.setString("token", jsonResponse["token"]);
//     salaryId = prefs.getInt("salaryId");
//     token = prefs.getString("token");
//     _getAnnouncementsDetails();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: CustomWidgets.navBar(onTap: () {}),
//         backgroundColor: Colors.white,
//         drawer: const Drawer(backgroundColor: Colors.white),
//         appBar: CustomAppBar(),
//         body: NotificationListener<OverscrollIndicatorNotification>(
//             onNotification: ((OverscrollIndicatorNotification? notification) {
//               notification!.disallowIndicator();
//               return true;
//             }),
//             child: SingleChildScrollView(
//                 padding: EdgeInsets.symmetric(horizontal: 10),
//                 child: regimeData == null
//                     ? Align(
//                         heightFactor: 6,
//                         alignment: Alignment.center,
//                         child: Lottie.asset("assets/loading.json", height: 100))
//                     : Column(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                             Row(
//                               children: [
//                                 IconButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     icon: Icon(
//                                       Icons.arrow_back_ios,
//                                       color: Colors.black,
//                                       size: 19,
//                                     )),
//                                 Text(
//                                   "Regime",
//                                   style: TextStyle(
//                                       fontSize: 16.sp,
//                                       fontWeight: FontWeight.w500),
//                                 ),
//                               ],
//                             ),
//                             SizedBox(
//                               height: 15,
//                             ),
//                             Row(
//                               children: [
//                                 SizedBox(
//                                   width: 5,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       radioValue = 0;
//                                     });
//                                   },
//                                   child: Container(
//                                       width: MediaQuery.of(context).size.width /
//                                           2.2,
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                           color: Color.fromARGB(
//                                               255, 224, 224, 224),
//                                           border: Border.all(),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Align(
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                               "Old Regime",
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                           Divider(
//                                             color: Colors.black,
//                                             thickness: 1.5,
//                                           ),
//                                           Text(
//                                               "Gross Yearly Salary:${regimeData["salaryStructureByOldRegime"]["grossYearlySalary"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Gross Monthly Salary:${regimeData["salaryStructureByOldRegime"]["grossMonthlySalary"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Yearly Tax Before Cess And Surcharge:${regimeData["salaryStructureByOldRegime"]["yearlyTaxBeforeCessAndSurcharge"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Monthly Tax Before Cess And Surcharge:${regimeData["salaryStructureByOldRegime"]["monthlyTaxBeforeCessAndSurcharge"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Health And Education Cess Yearly:${regimeData["salaryStructureByOldRegime"]["healthAndEducationCessYearly"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Health And Education Cess Monthly:${regimeData["salaryStructureByOldRegime"]["healthAndEducationCessMonthly"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Yearly Tax:${regimeData["salaryStructureByOldRegime"]["yearlyTax"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Monthly Tax:${regimeData["salaryStructureByOldRegime"]["monthlyTax"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Yearly Salary After Tax:${regimeData["salaryStructureByOldRegime"]["yearlySalaryAfterTax"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Monthly Salary After Tax:${regimeData["salaryStructureByOldRegime"]["monthlySalaryAfterTax"]}"),
//                                           sizedBox(),
//                                         ],
//                                       )),
//                                 ),
//                                 SizedBox(
//                                   width: 10,
//                                 ),
//                                 GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       radioValue = 1;
//                                     });
//                                   },
//                                   child: Container(
//                                       width: MediaQuery.of(context).size.width /
//                                           2.2,
//                                       padding: EdgeInsets.all(10),
//                                       decoration: BoxDecoration(
//                                           color: Color.fromARGB(
//                                               255, 224, 224, 224),
//                                           border: Border.all(),
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.start,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Align(
//                                             alignment: Alignment.center,
//                                             child: Text(
//                                               "New Regime",
//                                               style: TextStyle(
//                                                   fontSize: 18,
//                                                   fontWeight: FontWeight.w500),
//                                             ),
//                                           ),
//                                           Divider(
//                                             color: Colors.black,
//                                             thickness: 1.5,
//                                           ),
//                                           Text(
//                                               "Gross Yearly Salary:${regimeData["salaryStructureByNewRegime"]["grossYearlySalary"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Gross Monthly Salary:${regimeData["salaryStructureByNewRegime"]["grossMonthlySalary"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Yearly Tax Before Cess And Surcharge:${regimeData["salaryStructureByNewRegime"]["yearlyTaxBeforeCessAndSurcharge"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Monthly Tax Before Cess And Surcharge:${regimeData["salaryStructureByNewRegime"]["monthlyTaxBeforeCessAndSurcharge"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Health And Education Cess Yearly:${regimeData["salaryStructureByNewRegime"]["healthAndEducationCessYearly"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Health And Education Cess Monthly:${regimeData["salaryStructureByNewRegime"]["healthAndEducationCessMonthly"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Yearly Tax:${regimeData["salaryStructureByNewRegime"]["yearlyTax"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Monthly Tax:${regimeData["salaryStructureByNewRegime"]["monthlyTax"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Yearly Salary After Tax:${regimeData["salaryStructureByNewRegime"]["yearlySalaryAfterTax"]}"),
//                                           sizedBox(),
//                                           Text(
//                                               "Monthly Salary After Tax:${regimeData["salaryStructureByNewRegime"]["monthlySalaryAfterTax"]}"),
//                                           sizedBox(),
//                                         ],
//                                       )),
//                                 )
//                               ],
//                             ),
//                             Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   Container(
//                                       height: 100,
//                                       width: 100,
//                                       child: RadioListTile(
//                                           activeColor: Colors.black,
//                                           value: 0,
//                                           groupValue: radioValue,
//                                           onChanged: (val) {

//                                             setState(() {
//                                               radioValue = val!;
//                                             });
//                                           })),
//                                   SizedBox(
//                                     width: 40,
//                                   ),
//                                   Container(
//                                       height: 100,
//                                       width: 100,
//                                       child: RadioListTile(
//                                           activeColor: Colors.black,
//                                           value: 1,
//                                           groupValue: radioValue,
//                                           onChanged: (val) {
//                                             setState(() {
//                                               radioValue = val!;
//                                             });
//                                           }))
//                                 ]),
//                             ElevatedButton(
//                               onPressed: () {},
//                               child: Text(
//                                 "Save",
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                 fixedSize: Size(110, 25),
//                                 splashFactory: NoSplash.splashFactory,
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                                 backgroundColor: AppColors.maincolor,
//                               ),
//                             ),
//                           ]))));
//   }

//   Widget sizedBox() {
//     return SizedBox(
//       height: 8,
//     );
//   }

//   dynamic regimeData;

//   _getAnnouncementsDetails() async {
//     try {
//       String url =
//           '${TextConstant.baseURL}/api/payroll/annual-taxation/employee/get-annnual-tax?employeeSalaryId=$salaryId';
//       http.Response res;
//       res = await http.get(Uri.parse(url), headers: {
//         'x-access-token': token,
//       });
//       regimeData = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         if (regimeData["salaryStructureByOldRegime"]["grossYearlySalary"] <
//             regimeData["salaryStructureByNewRegime"]["grossYearlySalary"]) {
//           setState(() {
//             radioValue = 0;
//           });
//         } else {
//           setState(() {
//             radioValue = 1;
//           });
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: AppColors.maincolor,
//             content: Text(
//               "Data Not Available",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             )));
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const Investment(),
//         ));
//       }

//       if (mounted) setState(() {});
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: AppColors.maincolor,
//           content: Text(
//             "${e.toString()} \nLoading Again...",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           )));
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const Regime(),
//       ));
//     }
//   }
// }
