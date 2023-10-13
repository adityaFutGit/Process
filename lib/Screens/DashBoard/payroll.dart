// // ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, non_constant_identifier_names, unused_field, prefer_final_fields, avoid_print, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sort_child_properties_last, sized_box_for_whitespace

// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:hrcosmoemployee/Constants/color_constant.dart';
// import 'package:hrcosmoemployee/Constants/text_constant.dart';
// import 'package:hrcosmoemployee/Models/payslipModel.dart';
// import 'package:hrcosmoemployee/Models/userdataModel.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/hraScreen.dart';

// import 'package:hrcosmoemployee/Screens/DashBoard/investment.dart';
// import 'package:hrcosmoemployee/custom_widgets.dart';
// import 'package:http/http.dart' as http;
// import 'package:printing/printing.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// class Payroll extends StatefulWidget {
//   const Payroll({super.key});

//   @override
//   State<Payroll> createState() => _PayrollState();
// }

// class _PayrollState extends State<Payroll> {
//   PayslipModel _payslipModel = PayslipModel();
//   UserModel _userModel = UserModel();
//   var salarayId;
//   List empDetailsSubHeader = [];
//   List empBankDetailsSubHeader = [];
//   static var EmpName, id, des, dep, workdays, loc, lop;
//   static var bankName, panNo, AccntNo, pfNo;

//   @override
//   void initState() {
//     initPrefs();
//     super.initState();
//   }

//   void initPrefs() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var refresh_token = prefs.getString("refresh_token");
//     http.Response res = await http.post(
//         Uri.parse("${TextConstant.baseURL}/api/user/auth-refresh"),
//         headers: {"refresh_token": refresh_token.toString()});
//     var jsonResponse = jsonDecode(res.body);

//     print("NEW REFRESH TOKEN: ${jsonResponse["token"]}");
//     await prefs.setString("token", jsonResponse["token"]);
//     String decodedMap = prefs.getString('Users') ?? "";
//     _userModel = userModelFromMap(decodedMap);
//     setState(() {
//       salarayId = _userModel.userData?.employee?.employeeSalary == null ||
//               _userModel.userData?.employee?.employeeSalary?.id == null
//           ? " "
//           : _userModel.userData?.employee?.employeeSalary?.id;
//       EmpName = _userModel.userData?.fullName;
//       id = _userModel.userData?.employee?.employeeCode == null ||
//               _userModel.userData!.employee!.employeeCode!.isEmpty
//           ? " "
//           : _userModel.userData?.employee?.employeeCode;
//       des = _userModel.userData?.employee?.employeeOffrollment == null ||
//               _userModel.userData?.employee?.employeeOffrollment?.designation ==
//                   null
//           ? _userModel.userData?.employee?.employeeOnrollment?.designation
//           : _userModel.userData?.employee?.employeeOffrollment?.designation;
//       dep = _userModel.userData?.employee?.employeeOffrollment == null ||
//               _userModel.userData?.employee?.employeeOffrollment?.department ==
//                   null
//           ? _userModel.userData?.employee?.employeeOnrollment?.department
//           : _userModel.userData?.employee?.employeeOffrollment?.department;
//       workdays = " ";
//       loc = _userModel.userData?.employee?.employeeOffrollment == null ||
//               _userModel.userData?.employee?.employeeOffrollment?.location
//                       ?.name ==
//                   null
//           ? _userModel.userData?.employee?.employeeOnrollment?.location?.name
//           : "${_userModel.userData?.employee?.employeeOffrollment?.location?.name}";
//       lop = " ";
//       bankName = _userModel.userData?.employee?.finance?.bankName == null ||
//               _userModel.userData?.employee?.finance == null
//           ? " "
//           : "${_userModel.userData?.employee?.finance?.bankName}";
//       if (_userModel.userData!.employee!.documents!.isEmpty ||
//           _userModel.userData?.employee?.documents?[0].documentName ==
//               "Pan Number") {
//         panNo = _userModel.userData!.employee!.documents!.isEmpty ||
//                 _userModel.userData?.employee?.documents?[0].documentValue ==
//                     null
//             ? " "
//             : "${_userModel.userData?.employee?.documents?[0].documentValue}";
//       } else if (_userModel.userData!.employee!.documents!.isEmpty ||
//           _userModel.userData?.employee?.documents?[1].documentName ==
//               "Pan Number") {
//         panNo = _userModel.userData!.employee!.documents!.isEmpty ||
//                 _userModel.userData?.employee?.documents?[1].documentValue ==
//                     null
//             ? " "
//             : "${_userModel.userData?.employee?.documents?[1].documentValue}";
//       } else if (_userModel.userData!.employee!.documents!.isEmpty ||
//           _userModel.userData?.employee?.documents?[2].documentName ==
//               "Pan Number") {
//         panNo = _userModel.userData!.employee!.documents!.isEmpty ||
//                 _userModel.userData?.employee?.documents?[2].documentValue ==
//                     null
//             ? " "
//             : "${_userModel.userData?.employee?.documents?[2].documentValue}";
//       }
//       panNo = _userModel.userData!.employee!.documents!.isEmpty ||
//               _userModel.userData?.employee?.documents?[2].documentValue == null
//           ? " "
//           : "${_userModel.userData?.employee?.documents?[2].documentValue}";
//       AccntNo = _userModel.userData?.employee?.finance == null ||
//               _userModel.userData?.employee?.finance?.accountNumber == null
//           ? " "
//           : "${_userModel.userData?.employee?.finance?.accountNumber}";
//       pfNo = " ";
//       empDetailsSubHeader = [EmpName, id, des, dep, workdays, loc, lop];
//       empBankDetailsSubHeader = [bankName, panNo, AccntNo, pfNo];
//     });
//     token = prefs.getString("token");
//     print(salarayId);
//     //_getPayslipDetails1();
//   }

//   List<KeyValueModel> _datas = [
//     KeyValueModel(key: "Jan", value: "1"),
//     KeyValueModel(key: "Feb", value: "2"),
//     KeyValueModel(key: "Mar", value: "3"),
//     KeyValueModel(key: "Apr", value: "4"),
//     KeyValueModel(key: "May", value: "5"),
//     KeyValueModel(key: "Jun", value: "6"),
//     KeyValueModel(key: "Jul", value: "7"),
//     KeyValueModel(key: "Aug", value: "8"),
//     KeyValueModel(key: "Sep", value: "9"),
//     KeyValueModel(key: "Oct", value: "10"),
//     KeyValueModel(key: "Nov", value: "11"),
//     KeyValueModel(key: "Dec", value: "12"),
//   ];

//   String _selectedMonthKey = "";
//   String _selectedMonthValue = "";

//   String? selectedYear;
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   var year = [
//     '2018',
//     '2019',
//     '2020',
//     '2021',
//     '2022',
//     '2023',
//     '2024',
//     '2025',
//     '2026',
//     '2027',
//     '2028',
//     '2029',
//   ];

//   List<String> svg = [
//     "assets/Payroll/1.png",
//     "assets/CompanyProfilePNG/3.png",
//     "assets/CompanyProfilePNG/2.png",
//     "assets/CompanyProfilePNG/4.png",
//     "assets/Payroll/3.png",
//     "assets/WorkProfilePNG/Five.png",
//     "assets/Payroll/2.png",
//   ];
//   List<String> empDetailsHeader = [
//     "Employee Name:",
//     "Employee Code:",
//     "Designation:",
//     "Department:",
//     "Work Days:",
//     "Location:",
//     "LOP:",
//   ];

//   List<String> svg2 = [
//     "assets/Payroll/4.png",
//     "assets/Payroll/5.png",
//     "assets/Payroll/6.png",
//     "assets/Payroll/7.png",
//   ];
//   List<String> empBankDetailsHeader = [
//     "Bank Name:",
//     "PAN No.:",
//     "Bank Account No.:",
//     "PF No.:",
//   ];
//   PdfColor appColor = PdfColor.fromInt(0x1E429F);
//   Future<void> downloadPaySlip() async {
//     final pdf = pw.Document();
//     pdf.addPage(pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (pw.Context context) {
//           return PayslipDetails();
//         }));

//     await Printing.layoutPdf(
//         onLayout: (PdfPageFormat format) async => pdf.save());
//   }

//   bool disable = false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: CustomWidgets.navBar(onTap: () {}),
//         backgroundColor: Colors.white,
//         drawer: const Drawer(backgroundColor: Colors.white),
//         appBar: CustomAppBar(),
//         body: NotificationListener<OverscrollIndicatorNotification>(
//           onNotification: ((OverscrollIndicatorNotification? notification) {
//             notification!.disallowIndicator();
//             return true;
//           }),
//           child: SingleChildScrollView(
//               padding: EdgeInsets.symmetric(horizontal: 10),
//               child: _userModel.userData == null
//                   ? Align(
//                       heightFactor: 6,
//                       alignment: Alignment.center,
//                       child: Lottie.asset("assets/loading.json", height: 100))
//                   : Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                           Row(
//                             children: [
//                               IconButton(
//                                   onPressed: () {
//                                     Navigator.pop(context);
//                                   },
//                                   icon: Icon(
//                                     Icons.arrow_back_ios,
//                                     color: Colors.black,
//                                     size: 19,
//                                   )),
//                               Text(
//                                 "Payroll",
//                                 style: TextStyle(
//                                     fontSize: 16.sp,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                             ],
//                           ),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                     builder: (context) => const Investment(),
//                                   ));
//                                 },
//                                 child: Text(
//                                   "Investment",
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   fixedSize: Size(106, 20),
//                                   splashFactory: NoSplash.splashFactory,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   backgroundColor: AppColors.maincolor,
//                                 ),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.of(context).push(MaterialPageRoute(
//                                       builder: (context) => HRAScreen()));
//                                 },
//                                 child: Text(
//                                   "HRA",
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   fixedSize: Size(106, 20),
//                                   splashFactory: NoSplash.splashFactory,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   backgroundColor: AppColors.maincolor,
//                                 ),
//                               ),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   showModalBottomSheet<void>(
//                                     context: context,
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10.0),
//                                     ),
//                                     builder: (BuildContext context) {
//                                       return _showPayslipEntries();
//                                     },
//                                   );
//                                 },
//                                 child: Text(
//                                   "View Payslip",
//                                   style: TextStyle(fontSize: 13),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   fixedSize: Size(106, 20),
//                                   splashFactory: NoSplash.splashFactory,
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(10)),
//                                   backgroundColor: AppColors.maincolor,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(
//                             height: 30,
//                           ),
//                           Container(
//                               width: 0.9.sw,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 15),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                       color: Color.fromARGB(255, 230, 230, 230),
//                                       width: 2)),
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "EMPLOYEE DETAILS",
//                                       style: TextStyle(
//                                           color: AppColors.maincolor,
//                                           fontSize: 16,
//                                           letterSpacing: 0.4,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     Divider(
//                                       color: Color.fromARGB(255, 228, 227, 227),
//                                       thickness: 2,
//                                       height: 24,
//                                     ),
//                                     GridView.builder(
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         gridDelegate:
//                                             SliverGridDelegateWithFixedCrossAxisCount(
//                                                 childAspectRatio: 4 / 2,
//                                                 crossAxisCount: 2,
//                                                 crossAxisSpacing: 50,
//                                                 mainAxisSpacing: 0),
//                                         itemCount: 7,
//                                         itemBuilder: (BuildContext ctx, index) {
//                                           return Container(
//                                             child: Row(
//                                               children: [
//                                                 Image.asset(
//                                                   svg[index],
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       empDetailsHeader[index],
//                                                       style: TextStyle(
//                                                         fontSize: 13,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color:
//                                                             AppColors.darkgrey,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 3,
//                                                     ),
//                                                     Flexible(
//                                                       flex: 1,
//                                                       child: Container(
//                                                         width: 90,
//                                                         child: Text(
//                                                           empDetailsSubHeader[
//                                                               index],
//                                                           style: TextStyle(
//                                                               fontSize: 14,
//                                                               color: AppColors
//                                                                   .darkgrey,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w400),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         }),
//                                   ])),
//                           SizedBox(
//                             height: 20,
//                           ),
//                           Container(
//                               width: 0.9.sw,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 20, vertical: 15),
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                       color: Color.fromARGB(255, 230, 230, 230),
//                                       width: 2)),
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "EMPLOYEE BANK DETAILS",
//                                       style: TextStyle(
//                                           color: AppColors.maincolor,
//                                           fontSize: 16,
//                                           letterSpacing: 0.4,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     Divider(
//                                       color: Color.fromARGB(255, 228, 227, 227),
//                                       thickness: 2,
//                                       height: 24,
//                                     ),
//                                     GridView.builder(
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         shrinkWrap: true,
//                                         gridDelegate:
//                                             SliverGridDelegateWithFixedCrossAxisCount(
//                                                 childAspectRatio: 4 / 2,
//                                                 crossAxisCount: 2,
//                                                 crossAxisSpacing: 35,
//                                                 mainAxisSpacing: 0),
//                                         itemCount: 4,
//                                         itemBuilder: (BuildContext ctx, index) {
//                                           return Container(
//                                             child: Row(
//                                               children: [
//                                                 Image.asset(
//                                                   svg2[index],
//                                                 ),
//                                                 SizedBox(
//                                                   width: 8,
//                                                 ),
//                                                 Column(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment.center,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.start,
//                                                   children: [
//                                                     Text(
//                                                       empBankDetailsHeader[
//                                                           index],
//                                                       style: TextStyle(
//                                                         fontSize: 13,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color:
//                                                             AppColors.darkgrey,
//                                                       ),
//                                                     ),
//                                                     SizedBox(
//                                                       height: 3,
//                                                     ),
//                                                     Text(
//                                                       empBankDetailsSubHeader[
//                                                           index],
//                                                       style: TextStyle(
//                                                           fontSize: 14,
//                                                           color: AppColors
//                                                               .darkgrey,
//                                                           fontWeight:
//                                                               FontWeight.w400),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           );
//                                         }),
//                                   ])),
//                           SizedBox(
//                             height: 30,
//                           )
//                         ])),
//         ));
//   }

//   Widget _showPayslipEntries() {
//     return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
//       return Form(
//         key: _formKey,
//         child: Container(
//           height: 320,
//           padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                   color: Color.fromARGB(255, 230, 230, 230), width: 2)),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     "PAYSLIP",
//                     style: TextStyle(
//                         color: AppColors.maincolor,
//                         fontSize: 16,
//                         letterSpacing: 0.4,
//                         fontWeight: FontWeight.w600),
//                   ),
//                   IconButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(
//                         Icons.close,
//                         size: 20,
//                       ))
//                 ],
//               ),
//               Divider(
//                 color: Color.fromARGB(255, 228, 227, 227),
//                 thickness: 2,
//                 height: 10,
//               ),
//               SizedBox(
//                 height: 25,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_month,
//                             color: Color.fromARGB(255, 120, 120, 120),
//                             size: 20,
//                           ),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "Month",
//                             style: TextStyle(
//                                 fontSize: 14, fontWeight: FontWeight.w500),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       SizedBox(
//                         width: 120,
//                         height: 55,
//                         child: DropdownButtonFormField<String>(
//                           validator: (value) {
//                             if (value == null) {
//                               return ("Select Month");
//                             }
//                             return null;
//                           },
//                           borderRadius: BorderRadius.circular(10),
//                           decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 0.0, horizontal: 8),
//                               hintText: "Month",
//                               hintStyle: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color.fromARGB(255, 136, 136, 136),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Color.fromARGB(255, 227, 227, 227),
//                                     width: 1.5),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Color.fromARGB(255, 215, 215, 215),
//                                     width: 1.5),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               fillColor: Colors.white,
//                               filled: true),

//                           icon: const Icon(Icons.arrow_drop_down_outlined),
//                           iconSize: 25,
//                           //value: selectedMonth,
//                           items: _datas
//                               .map((data) => DropdownMenuItem<String>(
//                                     child: Text(data.key),
//                                     value: data.value,
//                                     onTap: () {
//                                       _selectedMonthKey = data.key.toString();
//                                     },
//                                   ))
//                               .toList(),

//                           onChanged: (String? value) {
//                             state(() => _selectedMonthValue = value!);
//                             print(_selectedMonthValue);
//                             print(_selectedMonthKey);
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_month,
//                             color: Color.fromARGB(255, 120, 120, 120),
//                             size: 20,
//                           ),
//                           SizedBox(
//                             width: 5,
//                           ),
//                           Text(
//                             "Year",
//                             style: TextStyle(
//                                 fontSize: 14, fontWeight: FontWeight.w500),
//                           )
//                         ],
//                       ),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       Container(
//                         width: 120,
//                         height: 55,
//                         child: DropdownButtonFormField<String>(
//                           validator: (value) {
//                             if (value == null) {
//                               return ("Select Year");
//                             }
//                             return null;
//                           },
//                           borderRadius: BorderRadius.circular(10),
//                           decoration: InputDecoration(
//                               contentPadding: const EdgeInsets.symmetric(
//                                   vertical: 0.0, horizontal: 8),
//                               hintText: "Year",
//                               hintStyle: const TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w500,
//                                 color: Color.fromARGB(255, 136, 136, 136),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Color.fromARGB(255, 227, 227, 227),
//                                     width: 1.5),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: const BorderSide(
//                                     color: Color.fromARGB(255, 215, 215, 215),
//                                     width: 1.5),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               fillColor: Colors.white,
//                               filled: true),
//                           isExpanded: true,
//                           icon: const Icon(Icons.arrow_drop_down_outlined),
//                           iconSize: 25,
//                           value: selectedYear,
//                           items: year
//                               .map((item) => DropdownMenuItem<String>(
//                                   value: item,
//                                   child: Text(item,
//                                       style: const TextStyle(
//                                           color: Colors.black87,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w400))))
//                               .toList(),
//                           onChanged: (item) async {
//                             selectedYear = item!;
//                             print(selectedYear);
//                             await _getPayslipDetails();
//                           },
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () {
//                       if (!_formKey.currentState!.validate()) {
//                         return;
//                       }
//                       showModalBottomSheet<dynamic>(
//                         isScrollControlled: true,
//                         context: context,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.0),
//                         ),
//                         builder: (BuildContext context) {
//                           return _viewPayslip();
//                         },
//                       );
//                     },
//                     child: Text(
//                       "View",
//                       style: TextStyle(
//                           color: Color.fromARGB(255, 123, 123, 123),
//                           fontSize: 14,
//                           fontWeight: FontWeight.w500),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         minimumSize: const Size(101, 35),
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                                 color: Color.fromARGB(255, 232, 232, 232),
//                                 width: 1.5),
//                             borderRadius: BorderRadius.circular(8.0))),
//                   ),
//                   AbsorbPointer(
//                     absorbing: disable,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         if (!_formKey.currentState!.validate()) {
//                           return;
//                         }
//                         downloadPaySlip();
//                       },
//                       child: Text(
//                         "Download",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Color.fromARGB(255, 30, 67, 159),

//                           //maximumSize: Size(7, 3),
//                           minimumSize: const Size(101, 35),
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                               side: BorderSide(
//                                   color: Colors.transparent, width: 1.5),
//                               borderRadius: BorderRadius.circular(8.0))),
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   //Widget for view pay slip
//   static var basic,
//       HRA,
//       Conveyence,
//       MedAllowance,
//       SpecialAllowance,
//       Pf,
//       IncomeTax,
//       ProfTax;
//   List earningsSubHeader = [];
//   List deductionSubHeader = [];

//   void loadData() {
//     setState(() {
//       basic = list[0].earningComponent?[8].value;
//       HRA = list[0].earningComponent?[7].value;
//       Conveyence = list[0].earningComponent?[7].value;
//       MedAllowance = list[0].earningComponent?[7].value;
//       SpecialAllowance = list[0].earningComponent?[6].value;
//       Pf = list[0].earningComponent?[5].value;
//       IncomeTax = list[0].earningComponent?[7].value;
//       ProfTax = list[0].earningComponent?[7].value;
//       earningsSubHeader = [
//         basic,
//         HRA,
//         basic,
//         basic,
//         SpecialAllowance,
//       ];
//       deductionSubHeader = [Pf, IncomeTax, ProfTax];
//     });
//     setState(() {});
//   }

//   List<String> earningsHeader = [
//     "Basic:",
//     "HRA:",
//     "Conveyence:",
//     "Medical Allowance:",
//     "Special Allowance:",
//   ];

//   List<String> deductionHeader = [
//     "PF:",
//     "Income Tax:",
//     "Prof. Tax:",
//   ];

//   _viewPayslip() {
//     return StatefulBuilder(builder: (BuildContext context, StateSetter state) {
//       return paySlipData == null
//           ? Align(
//               heightFactor: 6,
//               alignment: Alignment.center,
//               child: Lottie.asset("assets/loading.json", height: 100))
//           : paySlipData.isEmpty
//               ? Container(
//                   height: 320,
//                   child: Center(
//                     child: Text(
//                       "No Data",
//                       style:
//                           TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                 )
//               : Container(
//                   height: 750,
//                   padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
//                   decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                           color: Color.fromARGB(255, 230, 230, 230), width: 2)),
//                   child: Column(
//                     children: [
//                       _payslipDetails(),
//                       // PayslipDetails(),
//                       Align(
//                         alignment: Alignment.center,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             downloadPaySlip();
//                           },
//                           child: Text(
//                             "Download",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w500),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                               backgroundColor: Color.fromARGB(255, 30, 67, 159),

//                               //maximumSize: Size(7, 3),
//                               minimumSize: const Size(101, 35),
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   side: BorderSide(
//                                       color: Colors.transparent, width: 1.5),
//                                   borderRadius: BorderRadius.circular(8.0))),
//                         ),
//                       )
//                     ],
//                   ),
//                 );
//     });
//   }

//   Widget _payslipDetails() {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//       Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             "Payslip for the Month of $_selectedMonthKey $selectedYear",
//             style: TextStyle(
//                 color: AppColors.maincolor,
//                 fontSize: 16,
//                 letterSpacing: 0.4,
//                 fontWeight: FontWeight.w600),
//           ),
//           IconButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               icon: Icon(
//                 Icons.close,
//                 size: 20,
//               ))
//         ],
//       ),
//       Divider(
//         color: Color.fromARGB(255, 228, 227, 227),
//         thickness: 2,
//         height: 1,
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       Text(
//         "EARNINGS",
//         style: TextStyle(
//             color: Color.fromARGB(255, 96, 96, 96),
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.6,
//             fontSize: 16),
//       ),
//       Container(
//         child: ListView.builder(
//             itemCount: 5,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (BuildContext context, index) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 child: Column(
//                   children: [
//                     Divider(
//                       color: Color.fromARGB(255, 216, 215, 215),
//                       thickness: 1,
//                     ),
//                     SizedBox(
//                       height: 3,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               earningsHeader[index],
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color.fromARGB(255, 112, 111, 111),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           " ${earningsSubHeader[index]}",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Color.fromARGB(255, 128, 128, 128),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }),
//       ),
//       Divider(
//         color: Color.fromARGB(255, 228, 227, 227),
//         thickness: 2,
//         height: 20,
//       ),
//       SizedBox(
//         height: 5,
//       ),
//       Container(
//         width: 340,
//         height: 36,
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(color: AppColors.maincolor)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Total Earnings:",
//               style: TextStyle(
//                   color: AppColors.maincolor,
//                   fontSize: 14,
//                   letterSpacing: 0.3,
//                   fontWeight: FontWeight.w600),
//             ),
//             Text(
//               " ",
//               style: TextStyle(
//                   color: AppColors.maincolor,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600),
//             )
//           ],
//         ),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       Text(
//         "DEDUCTION",
//         style: TextStyle(
//             color: Color.fromARGB(255, 96, 96, 96),
//             fontWeight: FontWeight.w600,
//             letterSpacing: 0.6,
//             fontSize: 16),
//       ),
//       Container(
//         child: ListView.builder(
//             itemCount: 3,
//             shrinkWrap: true,
//             physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (BuildContext context, index) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 child: Column(
//                   children: [
//                     Divider(
//                       color: Color.fromARGB(255, 216, 215, 215),
//                       thickness: 1,
//                     ),
//                     SizedBox(
//                       height: 3,
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               deductionHeader[index],
//                               style: TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color.fromARGB(255, 112, 111, 111),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Text(
//                           " ${deductionSubHeader[index]}",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: Color.fromARGB(255, 128, 128, 128),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }),
//       ),
//       Divider(
//         color: Color.fromARGB(255, 228, 227, 227),
//         thickness: 2,
//         height: 20,
//       ),
//       SizedBox(
//         height: 5,
//       ),
//       Container(
//         width: 340,
//         height: 36,
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(color: AppColors.maincolor)),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Total Deduction:",
//               style: TextStyle(
//                   color: AppColors.maincolor,
//                   fontSize: 14,
//                   letterSpacing: 0.3,
//                   fontWeight: FontWeight.w600),
//             ),
//             Text(
//               " ",
//               style: TextStyle(
//                   color: AppColors.maincolor,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w600),
//             )
//           ],
//         ),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//       Container(
//         width: 350,
//         height: 40,
//         padding: EdgeInsets.symmetric(horizontal: 15),
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(5),
//             border: Border.all(color: Color.fromARGB(255, 205, 205, 205))),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               "Net Pay for the Month:",
//               style: TextStyle(
//                   color: Colors.black87,
//                   fontSize: 14,
//                   letterSpacing: 0.3,
//                   fontWeight: FontWeight.w700),
//             ),
//             Text(
//               "",
//               style: TextStyle(
//                   color: Color.fromARGB(221, 31, 31, 31),
//                   fontSize: 13,
//                   fontWeight: FontWeight.w700),
//             )
//           ],
//         ),
//       ),
//       SizedBox(
//         height: 20,
//       ),
//     ]);
//   }

//   PayslipDetails() {
//     return pw
//         .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
//       pw.Row(
//         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//         children: [
//           pw.Text(
//             "Payslip for the Month of $_selectedMonthKey $selectedYear",
//             style: pw.TextStyle(
//                 color: appColor,
//                 fontSize: 16,
//                 letterSpacing: 0.4,
//                 fontWeight: pw.FontWeight.bold),
//           ),
//         ],
//       ),
//       pw.SizedBox(
//         height: 10,
//       ),
//       pw.Divider(
//         // color: Color.fromARGB(255, 228, 227, 227),
//         thickness: 2,
//         height: 1,
//       ),
//       pw.SizedBox(
//         height: 20,
//       ),
//       pw.Text(
//         "EARNINGS",
//         style: pw.TextStyle(
//             // color: pw.Colors.fromARGB(255, 96, 96, 96),
//             fontWeight: pw.FontWeight.bold,
//             letterSpacing: 0.6,
//             fontSize: 16),
//       ),
//       pw.Container(
//         child: pw.ListView.builder(
//             itemCount: 5,
//             // shrinkWrap: true,
//             // physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return pw.Padding(
//                 padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 child: pw.Column(
//                   children: [
//                     pw.Divider(
//                       //  color: Color.fromARGB(255, 216, 215, 215),
//                       thickness: 1,
//                     ),
//                     pw.SizedBox(
//                       height: 3,
//                     ),
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Row(
//                           children: [
//                             pw.Text(
//                               earningsHeader[index],
//                               style: pw.TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: pw.FontWeight.bold,
//                                 // color: Color.fromARGB(255, 112, 111, 111),
//                               ),
//                             ),
//                           ],
//                         ),
//                         pw.Text(
//                           " ${earningsSubHeader[index]}",
//                           style: pw.TextStyle(
//                             fontSize: 14,
//                             // fontWeight: FontWeight.w500,
//                             // color: Color.fromARGB(255, 128, 128, 128),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }),
//       ),
//       pw.Divider(
//         // color: Color.fromARGB(255, 228, 227, 227),
//         thickness: 2,
//         height: 20,
//       ),
//       pw.SizedBox(
//         height: 5,
//       ),
//       pw.Container(
//         width: 340,
//         height: 36,
//         padding: pw.EdgeInsets.symmetric(horizontal: 15),
//         decoration: pw.BoxDecoration(
//             borderRadius: pw.BorderRadius.circular(5),
//             border: pw.Border.all(color: appColor)),
//         child: pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text(
//               "Total Earnings:",
//               style: pw.TextStyle(
//                   color: appColor,
//                   fontSize: 14,
//                   letterSpacing: 0.3,
//                   fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Text(
//               " ",
//               style: pw.TextStyle(
//                   color: appColor,
//                   fontSize: 13,
//                   fontWeight: pw.FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//       pw.SizedBox(
//         height: 20,
//       ),
//       pw.Text(
//         "DEDUCTION",
//         style: pw.TextStyle(
//             //color: Color.fromARGB(255, 96, 96, 96),
//             fontWeight: pw.FontWeight.bold,
//             letterSpacing: 0.6,
//             fontSize: 16),
//       ),
//       pw.Container(
//         child: pw.ListView.builder(
//             itemCount: 3,
//             // shrinkWrap: true,
//             // physics: NeverScrollableScrollPhysics(),
//             itemBuilder: (context, index) {
//               return pw.Padding(
//                 padding: pw.EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 child: pw.Column(
//                   children: [
//                     pw.Divider(
//                       //color: Color.fromARGB(255, 216, 215, 215),
//                       thickness: 1,
//                     ),
//                     pw.SizedBox(
//                       height: 3,
//                     ),
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Row(
//                           children: [
//                             pw.Text(
//                               deductionHeader[index],
//                               style: pw.TextStyle(
//                                 fontSize: 14,
//                                 fontWeight: pw.FontWeight.bold,
//                                 // color: Color.fromARGB(255, 112, 111, 111),
//                               ),
//                             ),
//                           ],
//                         ),
//                         pw.Text(
//                           " ${deductionSubHeader[index]}",
//                           style: pw.TextStyle(
//                             fontSize: 14,
//                             //  fontWeight: FontWeight.w500,
//                             //  color: Color.fromARGB(255, 128, 128, 128),
//                           ),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }),
//       ),
//       pw.Divider(
//         //color: Color.fromARGB(255, 228, 227, 227),
//         thickness: 2,
//         height: 20,
//       ),
//       pw.SizedBox(
//         height: 5,
//       ),
//       pw.Container(
//         width: 340,
//         height: 36,
//         padding: pw.EdgeInsets.symmetric(horizontal: 15),
//         decoration: pw.BoxDecoration(
//             borderRadius: pw.BorderRadius.circular(5),
//             border: pw.Border.all(
//                 //color: AppColors.maincolor
//                 )),
//         child: pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text(
//               "Total Deduction:",
//               style: pw.TextStyle(
//                   color: appColor,
//                   fontSize: 14,
//                   letterSpacing: 0.3,
//                   fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Text(
//               " ",
//               style: pw.TextStyle(
//                   color: appColor,
//                   fontSize: 13,
//                   fontWeight: pw.FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//       pw.SizedBox(
//         height: 20,
//       ),
//       pw.Container(
//         width: 350,
//         height: 40,
//         padding: pw.EdgeInsets.symmetric(horizontal: 15),
//         decoration: pw.BoxDecoration(
//             borderRadius: pw.BorderRadius.circular(5),
//             border: pw.Border.all(
//                 //color:  Color.fromARGB(255, 205, 205, 205)
//                 )),
//         child: pw.Row(
//           mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//           children: [
//             pw.Text(
//               "Net Pay for the Month:",
//               style: pw.TextStyle(
//                   //  color: Colors.black87,
//                   fontSize: 15,
//                   letterSpacing: 0.3,
//                   fontWeight: pw.FontWeight.bold),
//             ),
//             pw.Text(
//               " ",
//               style: pw.TextStyle(
//                   // color: Color.fromARGB(221, 31, 31, 31),
//                   fontSize: 15,
//                   fontWeight: pw.FontWeight.bold),
//             )
//           ],
//         ),
//       ),
//       pw.SizedBox(
//         height: 20,
//       ),
//     ]);
//   }

// //API calling for Payslip
//   List<PayslipModel> list = [];
//   dynamic paySlipData;
//   var token;
//   Future<List<PayslipModel>> _getPayslipDetails() async {
//     print("FFFFFF");
//     try {
//       String url =
//           '${TextConstant.baseURL}/api/payroll/employee-salary/list-earning?year=$selectedYear&month=$_selectedMonthValue&employeeSalaryId=$salarayId';
//       http.Response res;

//       res = await http.get(Uri.parse(url), headers: {
//         'x-access-token': token,
//       });
//       paySlipData = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         for (int i = 0; i < paySlipData.length; i++) {
//           list.add(PayslipModel.fromJson(paySlipData[i]));
//         }

//         setState(() {
//           loadData();
//         });
//         if (paySlipData.isEmpty) {
//           setState(() {
//             disable = false;
//           });
//         } else {
//           setState(() {
//             disable = true;
//           });
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: AppColors.maincolor,
//             content: Text(
//               "Salary is not defined",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             )));
//         setState(() {
//           disable = true;
//         });
//         Navigator.pop(context);
//       }

//       print(disable);
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: AppColors.maincolor,
//           content: Text(
//             "${e.toString()} \nLoading Again...",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           )));
//       setState(() {
//         loadData();
//       });
//     }
//     return list;
//   }
// }

// class KeyValueModel {
//   String key;
//   String value;

//   KeyValueModel({required this.key, required this.value});
// }
