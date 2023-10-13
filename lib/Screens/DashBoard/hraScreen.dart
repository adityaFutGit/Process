// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:external_path/external_path.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
// import 'package:hrcosmoemployee/custom_widgets.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../../Constants/color_constant.dart';
// import '../../Constants/text_constant.dart';
// import '../../Models/hraModel.dart';
// import '../../Models/stateCityModel.dart';

// class HRAScreen extends StatefulWidget {
//   const HRAScreen({super.key});

//   @override
//   State<HRAScreen> createState() => _HRAScreenState();
// }

// class _HRAScreenState extends State<HRAScreen> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String? selectedTempState;
//   String? selectedTempCity;

//   int? selectTempStateId;
//   int? selectTempCityId;

//   bool loadingHRA = false;
//   @override
//   void initState() {
//     initPrefs();

//     super.initState();
//   }

//   var salaryId;
//   var token;
//   TextEditingController amount = TextEditingController();
//   TextEditingController startDate = TextEditingController();
//   TextEditingController endDate = TextEditingController();
//   TextEditingController address = TextEditingController();
//   TextEditingController landlordPan = TextEditingController();

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
//     print(salaryId);
//     _getListHRA();
//     _getStateList();
//   }

//   bool downloading = false;
//   double progress = 0.0;
//   String progressString = '';
//   String downloadedExcelPath = '';
//   var progressText = "Downloading...";
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
//             child: allStatesT.isEmpty && responseBody == null
//                 ? Align(
//                     heightFactor: 6,
//                     alignment: Alignment.center,
//                     child: Lottie.asset("assets/loading.json", height: 100))
//                 : SingleChildScrollView(
//                     padding: EdgeInsets.symmetric(horizontal: 10),
//                     child: Column(children: [
//                       Row(
//                         children: [
//                           IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               icon: Icon(
//                                 Icons.arrow_back_ios,
//                                 color: Colors.black,
//                                 size: 19,
//                               )),
//                           Text(
//                             "HRA",
//                             style: TextStyle(
//                                 fontSize: 18.sp, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       Align(
//                         widthFactor: 3.2,
//                         alignment: Alignment.centerRight,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             showModalBottomSheet<void>(
//                               isScrollControlled: true,
//                               context: context,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10.0),
//                               ),
//                               builder: (BuildContext context) {
//                                 return _showAddHraModal();
//                               },
//                             );
//                           },
//                           child: Text(
//                             "Add",
//                             style: TextStyle(fontSize: 16),
//                           ),
//                           style: ElevatedButton.styleFrom(
//                             fixedSize: Size(110, 25),
//                             splashFactory: NoSplash.splashFactory,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10)),
//                             backgroundColor: AppColors.maincolor,
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                       Container(
//                         padding:
//                             EdgeInsets.symmetric(horizontal: 14, vertical: 15),
//                         decoration: BoxDecoration(
//                             borderRadius: BorderRadius.circular(12),
//                             border: Border.all(
//                                 color: Color.fromARGB(255, 233, 232, 232),
//                                 width: 1.7)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Container(
//                               //height: 1.sh,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     // mainAxisAlignment:
//                                     //     MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         "Landlord PAN",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColors.darkgrey),
//                                       ),
//                                       SizedBox(
//                                         width: 20,
//                                       ),
//                                       Text(
//                                         "Address",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColors.darkgrey),
//                                       ),
//                                       SizedBox(
//                                         width: 40,
//                                       ),
//                                       Text(
//                                         "Amount",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColors.darkgrey),
//                                       ),
//                                       SizedBox(
//                                         width: 25,
//                                       ),
//                                       Text(
//                                         "Action",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColors.darkgrey),
//                                       ),
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 8,
//                                   ),
//                                   Divider(
//                                     thickness: 1.5,
//                                   ),
//                                   SizedBox(
//                                     height: 10,
//                                   ),
//                                   ListView.separated(
//                                       separatorBuilder: (context, index) =>
//                                           SizedBox(
//                                             height: 20,
//                                           ),
//                                       scrollDirection: Axis.vertical,
//                                       itemCount: allData.length,
//                                       physics: NeverScrollableScrollPhysics(),
//                                       shrinkWrap: true,
//                                       itemBuilder:
//                                           ((BuildContext context, index) {
//                                         return Column(
//                                           children: [
//                                             Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment
//                                                       .spaceBetween,
//                                               children: [
//                                                 Container(
//                                                   width: 100,
//                                                   child: Text(
//                                                     hraDeduction[index]
//                                                             ["landloardPAN"] ??
//                                                         "",
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color: Color.fromARGB(
//                                                             255, 94, 94, 94)),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   width: 110,
//                                                   child: Text(
//                                                     "${hraDeduction[index]["address"]}",
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color: Color.fromARGB(
//                                                             255, 94, 94, 94)),
//                                                   ),
//                                                 ),
//                                                 Container(
//                                                   width: 50,
//                                                   child: Text(
//                                                     "${hraDeduction[index]["amount"]}",
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color: Color.fromARGB(
//                                                             255, 94, 94, 94)),
//                                                   ),
//                                                 ),
//                                                 Row(
//                                                   children: [
//                                                     IconButton(
//                                                       padding: EdgeInsets.zero,
//                                                       constraints:
//                                                           BoxConstraints(),
//                                                       onPressed: () {
//                                                         doDownloadFile(index);
//                                                       },
//                                                       icon:
//                                                           Icon(Icons.download),
//                                                     ),
//                                                     IconButton(
//                                                       padding: EdgeInsets.zero,
//                                                       constraints:
//                                                           BoxConstraints(),
//                                                       onPressed: () {
//                                                         showModalBottomSheet<
//                                                             void>(
//                                                           isScrollControlled:
//                                                               true,
//                                                           context: context,
//                                                           shape:
//                                                               RoundedRectangleBorder(
//                                                             borderRadius:
//                                                                 BorderRadius
//                                                                     .circular(
//                                                                         10.0),
//                                                           ),
//                                                           builder: (BuildContext
//                                                               context) {
//                                                             return _showEditHraModal(
//                                                                 index);
//                                                           },
//                                                         );
//                                                       },
//                                                       icon: Icon(Icons.edit),
//                                                     ),
//                                                     IconButton(
//                                                       padding: EdgeInsets.zero,
//                                                       constraints:
//                                                           BoxConstraints(),
//                                                       onPressed: () {},
//                                                       icon: Icon(Icons.delete),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                             SizedBox(
//                                               height: 10,
//                                             ),
//                                             Divider(
//                                               thickness: 1.5,
//                                               height: 20,
//                                             ),
//                                           ],
//                                         );
//                                       })),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(
//                         height: 20,
//                       )
//                     ]))));
//   }

//   Future<bool> getStoragePremission() async {
//     return await Permission.storage.request().isGranted;
//   }

//   Future<String> getDownloadFolderPath() async {
//     return await ExternalPath.getExternalStoragePublicDirectory(
//         ExternalPath.DIRECTORY_DOWNLOADS);
//   }

//   Future downloadFile(String downloadDirectory, index) async {
//     var url = "${hraDeduction[index]["documentUrl"]}";
//     print(url);
//     Dio dio = Dio();
//     var downloadedExcelPath =
//         '$downloadDirectory/${hraDeduction[index]["documentUrl"].toString().substring(101)}';
//     print(downloadedExcelPath);
//     try {
//       await dio.download(url, downloadedExcelPath,
//           deleteOnError: true,
//           options: Options(headers: {
//             'x-access-token': token,
//           }), onReceiveProgress: (rec, total) {
//         setState(() {
//           progress = rec / total;
//         });
//         setState(() {
//           // progressText = "Downloading...";
//           downloading = true;
//           progressString = "${((rec / total) * 100).toStringAsFixed(0)}%";
//         });
//         print(progressString);
//       }).then((value) {
//         // Navigator.of(context).pop();
//         Future.delayed(Duration.zero, () {
//           QuickAlert.show(
//               context: context,
//               barrierDismissible: false,
//               type: QuickAlertType.success,
//               title: "Downloaded",
//               showCancelBtn: false,
//               confirmBtnColor: Color.fromARGB(255, 116, 202, 120),
//               onConfirmBtnTap: () {
//                 Navigator.of(context).pop();
//               });
//         });
//       });
//     } catch (e) {}
//     await Future.delayed(const Duration(seconds: 3));
//     return downloadedExcelPath;
//   }

//   /// Do download by user's click
//   Future<void> doDownloadFile(index) async {
//     if (await getStoragePremission()) {
//       String downloadDirectory = await getDownloadFolderPath();
//       setState(() {
//         downloading = false;
//         progressString = "COMPLETED";
//         downloadedExcelPath = downloadDirectory;
//       });
//       await downloadFile(downloadDirectory, index);
//     }
//   }

//   bool saveDisable = true;
//   Widget _showAddHraModal() {
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//       return Padding(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Form(
//             key: _formKey,
//             child: Container(
//                 height: 600,
//                 padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: Color.fromARGB(255, 230, 230, 230), width: 2)),
//                 child: SingleChildScrollView(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Add HRA",
//                               style: TextStyle(
//                                   color: AppColors.maincolor,
//                                   fontSize: 16,
//                                   letterSpacing: 0.4,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             IconButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 icon: Icon(
//                                   Icons.close,
//                                   size: 20,
//                                 ))
//                           ],
//                         ),
//                         Divider(
//                           color: Color.fromARGB(255, 228, 227, 227),
//                           thickness: 2,
//                           height: 10,
//                         ),
//                         SizedBox(
//                           height: 25,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                                 width: 294,
//                                 child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       const Text(
//                                         "State*",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 15,
//                                             color:
//                                                 Color.fromARGB(178, 0, 0, 0)),
//                                       ),
//                                       const SizedBox(
//                                         height: 12,
//                                       ),
//                                       DropdownButtonFormField(
//                                         validator: (value) {
//                                           if (value == null) {
//                                             return ("Select State");
//                                           }
//                                           return null;
//                                         },
//                                         borderRadius: BorderRadius.circular(10),
//                                         decoration: InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 0.0,
//                                                     horizontal: 13),
//                                             hintText: "Select State",
//                                             hintStyle: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500,
//                                               color: Color.fromARGB(
//                                                   255, 136, 136, 136),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Color.fromARGB(
//                                                       255, 227, 227, 227),
//                                                   width: 1.5),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Colors.grey),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             fillColor: Colors.white,
//                                             filled: true),
//                                         isExpanded: false,
//                                         icon: const Icon(
//                                             Icons.arrow_drop_down_outlined),
//                                         iconSize: 30,
//                                         value: selectedTempState,
//                                         items: allStatesT.map((ite) {
//                                           return DropdownMenuItem(
//                                             child: Text(
//                                               ite.name,
//                                             ),
//                                             value: ite.id.toString(),
//                                           );
//                                         }).toList(),
//                                         onChanged: (item) {
//                                           setState(() {
//                                             selectedTempState = item!;
//                                             selectTempStateId = int.parse(item);
//                                             _getCitiesListT(
//                                                 selectTempStateId!, setState);
//                                           });
//                                         },
//                                       ),
//                                     ])),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             Container(
//                                 width: 294,
//                                 child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         "City*",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 15,
//                                             color:
//                                                 Color.fromARGB(178, 0, 0, 0)),
//                                       ),
//                                       const SizedBox(
//                                         height: 12,
//                                       ),
//                                       cityLoading == true
//                                           ? Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 20),
//                                               child: SizedBox(
//                                                 height: 20,
//                                                 width: 20,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   strokeWidth: 2,
//                                                   color: AppColors.maincolor,
//                                                 ),
//                                               ),
//                                             )
//                                           : DropdownButtonFormField(
//                                               validator: (value) {
//                                                 if (value == null) {
//                                                   return ("Select City");
//                                                 }
//                                                 return null;
//                                               },
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               decoration: InputDecoration(
//                                                   contentPadding:
//                                                       const EdgeInsets
//                                                               .symmetric(
//                                                           vertical: 0.0,
//                                                           horizontal: 13),
//                                                   hintText: "Select City",
//                                                   hintStyle: const TextStyle(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: Color.fromARGB(
//                                                         255, 136, 136, 136),
//                                                   ),
//                                                   enabledBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide:
//                                                         const BorderSide(
//                                                             color:
//                                                                 Color.fromARGB(
//                                                                     255,
//                                                                     227,
//                                                                     227,
//                                                                     227),
//                                                             width: 1.5),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide:
//                                                         const BorderSide(
//                                                             color: Colors.grey),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                   fillColor: Colors.white,
//                                                   filled: true),
//                                               isExpanded: false,
//                                               icon: const Icon(Icons
//                                                   .arrow_drop_down_outlined),
//                                               iconSize: 30,
//                                               value: selectedTempCity,
//                                               items: allCitiesT.map((ite) {
//                                                 return DropdownMenuItem(
//                                                   child: SizedBox(
//                                                     width: 230,
//                                                     child: Text(
//                                                       ite.name,
//                                                     ),
//                                                   ),
//                                                   value: ite.id.toString(),
//                                                 );
//                                               }).toList(),
//                                               onChanged: (item) {
//                                                 setState(() {
//                                                   selectedTempCity = item!;
//                                                   selectTempCityId =
//                                                       int.parse(item);
//                                                 });
//                                               },
//                                             ),
//                                     ])),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Start Date",
//                               hintText: "YYYY-MM-DD",
//                               textController: startDate,
//                               keyboardType: TextInputType.number,
//                               inputFormatters: [
//                                 MaskTextInputFormatter(
//                                   mask: "####-##-##",
//                                 )
//                               ],
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Date");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "End Date",
//                               hintText: "YYYY-MM-DD",
//                               textController: endDate,
//                               keyboardType: TextInputType.number,
//                               inputFormatters: [
//                                 MaskTextInputFormatter(
//                                   mask: "####-##-##",
//                                 )
//                               ],
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Date");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Amount",
//                               textController: amount,
//                               keyboardType: TextInputType.number,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Amount");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Address",
//                               textController: address,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Address");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Landlord PAN",
//                               inputFormatters: [
//                                 LengthLimitingTextInputFormatter(10),
//                                 UpperCaseTextFormatter(),
//                               ],
//                               textController: landlordPan,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Pan No.");
//                                 }
//                                 if (value.isNotEmpty) {
//                                   if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}')
//                                       .hasMatch(value)) {
//                                     return ("Enter a valid Pan No.");
//                                   }
//                                 }

//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField("Document upload",
//                                 validator: (fileName) {
//                                   if (fileName == null) {
//                                     return ("Upload Document");
//                                   } else
//                                     return null;
//                                 },
//                                 hintText: fileName == null
//                                     ? "*No file chosen"
//                                     : fileName,
//                                 onTap: () {
//                                   pickDocument(setState);
//                                   setState(() {});
//                                 },
//                                 readOnly: true,
//                                 suffixIcon: Icon(
//                                   Icons.upload,
//                                   color: Colors.black54,
//                                 )),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                     color: Color.fromARGB(255, 123, 123, 123),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   minimumSize: const Size(101, 35),
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       side: BorderSide(
//                                           color: Color.fromARGB(
//                                               255, 232, 232, 232),
//                                           width: 1.5),
//                                       borderRadius:
//                                           BorderRadius.circular(8.0))),
//                             ),
//                             addLoading == true
//                                 ? CircularProgressIndicator(
//                                     color: AppColors.maincolor,
//                                   )
//                                 : AbsorbPointer(
//                                     absorbing: saveDisable,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         if (!_formKey.currentState!
//                                             .validate()) {
//                                           return;
//                                         }
//                                         addHRA(setState);
//                                       },
//                                       child: Text(
//                                         "Save",
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500),
//                                       ),
//                                       style: ElevatedButton.styleFrom(
//                                           backgroundColor:
//                                               Color.fromARGB(255, 30, 67, 159),

//                                           //maximumSize: Size(7, 3),
//                                           minimumSize: const Size(101, 35),
//                                           elevation: 0,
//                                           shape: RoundedRectangleBorder(
//                                               side: BorderSide(
//                                                   color: Colors.transparent,
//                                                   width: 1.5),
//                                               borderRadius:
//                                                   BorderRadius.circular(8.0))),
//                                     ),
//                                   )
//                           ],
//                         ),
//                       ]),
//                 ))),
//       );
//     });
//   }

//   var editDocumentUrlMain;
//   var editAmountMain;
//   var helpTextStartDate1 = "";
//   var helpTextStartDate2 = "";
//   var helpTextEndDate1 = "";
//   var helpTextEndDate2 = "";
//   var helpTextamount1 = "";
//   var helpTextamount2 = "";
//   var helpTextaddress1 = "";
//   var helpTextaddress2 = "";
//   var helpTextPan1 = "";
//   var helpTextPan2 = "";
//   var helpDocument1 = "";
//   var helpDocument2 = "";
//   // var helpCategoryText1 = "";
//   // var helpCategoryText2 = "";
//   // var helpInvestmentText1 = "";
//   // var helpInvestmentText2 = "";

//   Widget _showEditHraModal(index) {
//     var hraDeductionId = hraDeduction[index]["id"];
//     TextEditingController editStartDate = TextEditingController(
//         text: hraDeduction[index]["dateStart"].toString());
//     TextEditingController editEndDate =
//         TextEditingController(text: hraDeduction[index]["dateEnd"].toString());
//     TextEditingController editAmount =
//         TextEditingController(text: hraDeduction[index]["amount"].toString());
//     TextEditingController editAddress =
//         TextEditingController(text: hraDeduction[index]["address"].toString());
//     TextEditingController editLandlordPan = TextEditingController(
//         text: hraDeduction[index]["landloardPAN"].toString());
//     var editDocumentUrl = hraDeduction[index]["documents"]["rentAgreement"];

//     int documentUrlLength =
//         hraDeduction[index]["documents"]["rentAgreement"].toString().length;
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//       return Padding(
//         padding:
//             EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: Form(
//             key: _formKey,
//             child: Container(
//                 height: 600,
//                 padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(
//                         color: Color.fromARGB(255, 230, 230, 230), width: 2)),
//                 child: SingleChildScrollView(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Edit HRA",
//                               style: TextStyle(
//                                   color: AppColors.maincolor,
//                                   fontSize: 16,
//                                   letterSpacing: 0.4,
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             IconButton(
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 icon: Icon(
//                                   Icons.close,
//                                   size: 20,
//                                 ))
//                           ],
//                         ),
//                         Divider(
//                           color: Color.fromARGB(255, 228, 227, 227),
//                           thickness: 2,
//                           height: 10,
//                         ),
//                         SizedBox(
//                           height: 25,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Container(
//                                 width: 294,
//                                 child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       const Text(
//                                         "State*",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 15,
//                                             color:
//                                                 Color.fromARGB(178, 0, 0, 0)),
//                                       ),
//                                       const SizedBox(
//                                         height: 12,
//                                       ),
//                                       DropdownButtonFormField(
//                                         validator: (value) {
//                                           if (value == null) {
//                                             return ("Select State");
//                                           }
//                                           return null;
//                                         },
//                                         borderRadius: BorderRadius.circular(10),
//                                         decoration: InputDecoration(
//                                             contentPadding:
//                                                 const EdgeInsets.symmetric(
//                                                     vertical: 0.0,
//                                                     horizontal: 13),
//                                             hintText: "Select State",
//                                             hintStyle: const TextStyle(
//                                               fontSize: 14,
//                                               fontWeight: FontWeight.w500,
//                                               color: Color.fromARGB(
//                                                   255, 136, 136, 136),
//                                             ),
//                                             enabledBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Color.fromARGB(
//                                                       255, 227, 227, 227),
//                                                   width: 1.5),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             focusedBorder: OutlineInputBorder(
//                                               borderSide: const BorderSide(
//                                                   color: Colors.grey),
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                             ),
//                                             fillColor: Colors.white,
//                                             filled: true),
//                                         isExpanded: false,
//                                         icon: const Icon(
//                                             Icons.arrow_drop_down_outlined),
//                                         iconSize: 30,
//                                         value: selectedTempState,
//                                         items: allStatesT.map((ite) {
//                                           return DropdownMenuItem(
//                                             child: Text(
//                                               ite.name,
//                                             ),
//                                             value: ite.id.toString(),
//                                           );
//                                         }).toList(),
//                                         onChanged: (item) {
//                                           setState(() {
//                                             selectedTempState = item!;
//                                             selectTempStateId = int.parse(item);
//                                             _getCitiesListT(
//                                                 selectTempStateId!, setState);
//                                           });
//                                         },
//                                       ),
//                                     ])),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             Container(
//                                 width: 294,
//                                 child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: <Widget>[
//                                       Text(
//                                         "City*",
//                                         style: const TextStyle(
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: 15,
//                                             color:
//                                                 Color.fromARGB(178, 0, 0, 0)),
//                                       ),
//                                       const SizedBox(
//                                         height: 12,
//                                       ),
//                                       cityLoading == true
//                                           ? Padding(
//                                               padding: const EdgeInsets.only(
//                                                   left: 20),
//                                               child: SizedBox(
//                                                 height: 20,
//                                                 width: 20,
//                                                 child:
//                                                     CircularProgressIndicator(
//                                                   strokeWidth: 2,
//                                                   color: AppColors.maincolor,
//                                                 ),
//                                               ),
//                                             )
//                                           : DropdownButtonFormField(
//                                               validator: (value) {
//                                                 if (value == null) {
//                                                   return ("Select City");
//                                                 }
//                                                 return null;
//                                               },
//                                               borderRadius:
//                                                   BorderRadius.circular(10),
//                                               decoration: InputDecoration(
//                                                   contentPadding:
//                                                       const EdgeInsets
//                                                               .symmetric(
//                                                           vertical: 0.0,
//                                                           horizontal: 13),
//                                                   hintText: "Select City",
//                                                   hintStyle: const TextStyle(
//                                                     fontSize: 14,
//                                                     fontWeight: FontWeight.w500,
//                                                     color: Color.fromARGB(
//                                                         255, 136, 136, 136),
//                                                   ),
//                                                   enabledBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide:
//                                                         const BorderSide(
//                                                             color:
//                                                                 Color.fromARGB(
//                                                                     255,
//                                                                     227,
//                                                                     227,
//                                                                     227),
//                                                             width: 1.5),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                   focusedBorder:
//                                                       OutlineInputBorder(
//                                                     borderSide:
//                                                         const BorderSide(
//                                                             color: Colors.grey),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             10),
//                                                   ),
//                                                   fillColor: Colors.white,
//                                                   filled: true),
//                                               isExpanded: false,
//                                               icon: const Icon(Icons
//                                                   .arrow_drop_down_outlined),
//                                               iconSize: 30,
//                                               value: selectedTempCity,
//                                               items: allCitiesT.map((ite) {
//                                                 return DropdownMenuItem(
//                                                   child: SizedBox(
//                                                     width: 230,
//                                                     child: Text(
//                                                       ite.name,
//                                                     ),
//                                                   ),
//                                                   value: ite.id.toString(),
//                                                 );
//                                               }).toList(),
//                                               onChanged: (item) {
//                                                 setState(() {
//                                                   selectedTempCity = item!;
//                                                   selectTempCityId =
//                                                       int.parse(item);
//                                                 });
//                                               },
//                                             ),
//                                     ])),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Start Date",
//                               hintText: "YYYY-MM-DD",
//                               textController: editStartDate,
//                               keyboardType: TextInputType.number,
//                               onChange: (text) {
//                                 hraDeduction[index]["dateStart"] = text;
//                                 helpTextStartDate1 = "dateStart";
//                                 helpTextStartDate2 = editStartDate.text;
//                               },
//                               inputFormatters: [
//                                 MaskTextInputFormatter(
//                                   mask: "####-##-##",
//                                 )
//                               ],
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Date");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "End Date",
//                               hintText: "YYYY-MM-DD",
//                               textController: editEndDate,
//                               keyboardType: TextInputType.number,
//                               onChange: (text) {
//                                 hraDeduction[index]["dateEnd"] = text;
//                                 helpTextEndDate1 = "dateEnd";
//                                 helpTextEndDate2 = editEndDate.text;
//                               },
//                               inputFormatters: [
//                                 MaskTextInputFormatter(
//                                   mask: "####-##-##",
//                                 )
//                               ],
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Date");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Amount",
//                               textController: editAmount,
//                               keyboardType: TextInputType.number,
//                               onChange: (text) {
//                                 // setState(() {
//                                 hraDeduction[index]["amount"] = text;
//                                 helpTextamount1 = "amount";
//                                 helpTextamount2 = editAmount.text;
//                                 // });
//                               },
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Amount");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Address",
//                               textController: editAddress,
//                               onChange: (text) {
//                                 // setState(() {
//                                 hraDeduction[index]["address"] = text;
//                                 helpTextaddress1 = "address";
//                                 helpTextaddress2 = editAddress.text;
//                                 // });
//                               },
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Address");
//                                 }
//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField(
//                               "Landlord PAN",
//                               inputFormatters: [
//                                 LengthLimitingTextInputFormatter(10),
//                                 UpperCaseTextFormatter(),
//                               ],
//                               textController: editLandlordPan,
//                               onChange: (text) {
//                                 // setState(() {
//                                 hraDeduction[index]["landloardPAN"] = text;
//                                 helpTextPan1 = "landloardPAN";
//                                 helpTextPan2 = editLandlordPan.text;
//                                 // });
//                               },
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return ("Enter Pan No.");
//                                 }
//                                 if (value.isNotEmpty) {
//                                   if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}')
//                                       .hasMatch(value)) {
//                                     return ("Enter a valid Pan No.");
//                                   }
//                                 }

//                                 return null;
//                               },
//                             ),
//                             SizedBox(
//                               height: 17,
//                             ),
//                             CustomWidgets.textFormField("Document upload",
//                                 validator: (fileName) {
//                                   if (fileName == null) {
//                                     return ("Upload Document");
//                                   } else
//                                     return null;
//                                 },
//                                 hintText: fileName == ""
//                                     ? documentUrlLength < 30
//                                         ? editDocumentUrl
//                                             .toString()
//                                             .substring(10)
//                                         : editDocumentUrl
//                                             .toString()
//                                             .substring(90)
//                                     : fileName,
//                                 onTap: () {
//                                   pickDocument(setState);
//                                   setState(() {});
//                                 },
//                                 readOnly: true,
//                                 suffixIcon: Icon(
//                                   Icons.upload,
//                                   color: Colors.black54,
//                                 )),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               child: Text(
//                                 "Cancel",
//                                 style: TextStyle(
//                                     color: Color.fromARGB(255, 123, 123, 123),
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w500),
//                               ),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.white,
//                                   minimumSize: const Size(101, 35),
//                                   elevation: 0,
//                                   shape: RoundedRectangleBorder(
//                                       side: BorderSide(
//                                           color: Color.fromARGB(
//                                               255, 232, 232, 232),
//                                           width: 1.5),
//                                       borderRadius:
//                                           BorderRadius.circular(8.0))),
//                             ),
//                             addLoading == true
//                                 ? CircularProgressIndicator(
//                                     color: AppColors.maincolor,
//                                   )
//                                 : ElevatedButton(
//                                     onPressed: () async {
//                                       if (!_formKey.currentState!.validate()) {
//                                         return;
//                                       }
//                                       setState(() {
//                                         editLoading = true;
//                                       });
//                                       try {
//                                         final uri = Uri.parse(
//                                             "${TextConstant.baseURL}/api/payroll/annual-taxation/employee/edit-hra");

//                                         Map<String, dynamic> body = {
//                                           helpTextStartDate1:
//                                               helpTextStartDate2,
//                                           helpTextEndDate1: helpTextEndDate2,
//                                           helpTextamount1: helpTextamount2,
//                                           helpTextaddress1: helpTextaddress2,
//                                           helpTextPan1: helpTextPan2,
//                                           helpDocument1: helpDocument2,
//                                           "hraDeductionId": hraDeductionId
//                                         };
//                                         String jsonBody = json.encode(body);
//                                         final encoding =
//                                             Encoding.getByName('utf-8');
//                                         print(body);
//                                         var response = await http.patch(
//                                           uri,
//                                           headers: {
//                                             'Content-Type': 'application/json',
//                                             'Accept': '*/*',
//                                             'x-access-token': token
//                                           },
//                                           body: jsonBody,
//                                           encoding: encoding,
//                                         );

//                                         var responseBody = response.body;
//                                         print(responseBody);
//                                         if (response.statusCode == 200) {
//                                           setState(() {
//                                             editLoading = false;
//                                           });
//                                           Navigator.of(context).pushReplacement(
//                                               MaterialPageRoute(
//                                             builder: (context) =>
//                                                 const HRAScreen(),
//                                           ));
//                                         }
//                                       } on Exception catch (e) {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(SnackBar(
//                                                 backgroundColor:
//                                                     AppColors.maincolor,
//                                                 content: Text(
//                                                   "${e.toString()} ",
//                                                   style: TextStyle(
//                                                       color: Colors.white,
//                                                       fontSize: 18),
//                                                 )));
//                                         Navigator.of(context)
//                                             .pushReplacement(MaterialPageRoute(
//                                           builder: (context) =>
//                                               const HRAScreen(),
//                                         ));
//                                       }
//                                     },
//                                     child: Text(
//                                       "Save",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500),
//                                     ),
//                                     style: ElevatedButton.styleFrom(
//                                         backgroundColor:
//                                             Color.fromARGB(255, 30, 67, 159),

//                                         //maximumSize: Size(7, 3),
//                                         minimumSize: const Size(101, 35),
//                                         elevation: 0,
//                                         shape: RoundedRectangleBorder(
//                                             side: BorderSide(
//                                                 color: Colors.transparent,
//                                                 width: 1.5),
//                                             borderRadius:
//                                                 BorderRadius.circular(8.0))),
//                                   )
//                           ],
//                         ),
//                       ]),
//                 ))),
//       );
//     });
//   }

// //List Deduction
//   dynamic hraDeduction;
//   var responseBody;
//   List<HraListDeduction> allData = List.empty(growable: true);
//   _getListHRA() async {
//     try {
//       var url = Uri.parse(
//           '${TextConstant.baseURL}/api/payroll/annual-taxation/employee/list-hra?employeeSalaryId=$salaryId');

//       http.Response res = await http.get(url, headers: {
//         'x-access-token': token,
//       });
//       if (mounted) {
//         setState(() {
//           responseBody = res.body;
//         });
//       }
//       if (res.statusCode == 200) {
//         hraDeduction = jsonDecode(res.body);
//         for (int i = 0; i < hraDeduction.length; i++) {
//           allData.add(HraListDeduction(
//             hraDeduction[i]["id"],
//             hraDeduction[i]["amount"],
//             hraDeduction[i]["address"],
//             hraDeduction[i]["dateStart"],
//             hraDeduction[i]["dateEnd"],
//             hraDeduction[i]["financialYear"],
//             hraDeduction[i]["description"],
//             hraDeduction[i]["landloardPAN"],
//             hraDeduction[i]["categoryId"],
//             hraDeduction[i]["stateId"],
//             hraDeduction[i]["cityId"],
//             hraDeduction[i]["status"],
//             hraDeduction[i]["documents"]["rentAgreement"],
//             hraDeduction[i]["employeeSalaryId"],
//           ));
//         }
//       }
//     } on Exception catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             backgroundColor: AppColors.maincolor,
//             content: Text(
//               "${e.toString()} \nLoading Again...",
//               style: TextStyle(color: Colors.white, fontSize: 18),
//             )));
//       }
//       _getListHRA();
//     }
//     return;
//   }

// //Post Add investment details
//   var addLoading = false;
//   void addHRA(setState) async {
//     setState(() {
//       addLoading = true;
//     });
//     try {
//       final uri = Uri.parse(
//           "${TextConstant.baseURL}/api/payroll/annual-taxation/employee/add-hra");

//       Map<String, dynamic> body = {
//         "stateId": selectTempStateId,
//         "cityId": selectTempCityId,
//         "address": address.text,
//         "dateStart": startDate.text,
//         "dateEnd": endDate.text,
//         "amount": amount.text,
//         "landloardPAN": landlordPan.text,
//         "financialYear": "2022-2023",
//         "status": "Submited",
//         "documents": {"rentAgreement": documentUrl},
//         "employeeSalaryId": salaryId
//       };
//       String jsonBody = json.encode(body);
//       final encoding = Encoding.getByName('utf-8');

//       var response = await http.post(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': '*/*',
//           'x-access-token': token
//         },
//         body: jsonBody,
//         encoding: encoding,
//       );

//       var responseBody = response.body;
//       print(responseBody);
//       if (response.statusCode == 200) {
//         setState(() {
//           addLoading = false;
//         });
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const HRAScreen(),
//         ));
//       }
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: AppColors.maincolor,
//           content: Text(
//             "${e.toString()} ",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           )));
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const HRAScreen(),
//       ));
//     }
//   }

// //STATE LIST API CALL
//   List<States> allStatesT = List.empty(growable: true);
//   dynamic stateData;
//   http.Response? res;
//   _getStateList() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     try {
//       res = await http.get(
//           Uri.parse(
//               '${TextConstant.baseURL}/api/common/common-routes/state?countryId=1'),
//           headers: {
//             'x-access-token': token,
//           });
//       stateData = jsonDecode(res!.body);
//       if (res!.statusCode == 200) {
//         setState(() {
//           for (int i = 0; i < stateData.length; i++) {
//             allStatesT.add(States(stateData[i]["name"], stateData[i]["id"]));
//           }
//         });
//       }
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: AppColors.maincolor,
//           content: Text(
//             "${e.toString()}",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           )));
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const HRAScreen(),
//       ));
//     }
//   }

// //CITY LIST API
//   List<Cityy> allCitiesT = List.empty(growable: true);
//   dynamic cityDataT;
//   bool cityLoading = false;

//   Future _getCitiesListT(int stateId, setState) async {
//     setState(() {
//       cityLoading = true;
//       selectedTempCity = null;
//       allCitiesT.clear();
//     });

//     String cityInfoUrl =
//         '${TextConstant.baseURL}/api/common/common-routes/city?stateId=$stateId';

//     try {
//       res = await http.get(Uri.parse(cityInfoUrl), headers: {
//         'x-access-token': token,
//       });

//       cityDataT = jsonDecode(res!.body);
//       if (res!.statusCode == 200) {
//         setState(() {
//           cityLoading = false;
//           for (int i = 0; i < cityDataT.length; i++) {
//             allCitiesT.add(Cityy(cityDataT[i]["name"], cityDataT[i]["id"]));
//           }
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: AppColors.maincolor,
//           content: Text(
//             "${e.toString()}",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           )));
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const HRAScreen(),
//       ));
//     }
//     setState(() {});
//   }

// //Post Add investment details
//   var editLoading = false;
//   void editHRA(setState) async {
//     setState(() {
//       editLoading = true;
//     });
//     try {
//       final uri = Uri.parse(
//           "${TextConstant.baseURL}/api/payroll/annual-taxation/employee/edit-deduction");

//       Map<String, dynamic> body = {
//         // "name": selectedInvestmentName,
//         // "description": selectedInvestmentName,
//         // "amount": amount.text,
//         // "categoryId": selectedCategoryId,
//         // "documentUrl": documentUrl,
//         // "employeeSalaryId": salaryId,
//         // "deductionId": 1
//       };
//       String jsonBody = json.encode(body);
//       final encoding = Encoding.getByName('utf-8');

//       var response = await http.patch(
//         uri,
//         headers: {
//           'Content-Type': 'application/json',
//           'Accept': '*/*',
//           'x-access-token': token
//         },
//         body: jsonBody,
//         encoding: encoding,
//       );

//       var responseBody = response.body;
//       print(responseBody);
//       if (response.statusCode == 200) {
//         setState(() {
//           editLoading = false;
//         });
//         Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (context) => const HRAScreen(),
//         ));
//       }
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           backgroundColor: AppColors.maincolor,
//           content: Text(
//             "${e.toString()} ",
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           )));
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const HRAScreen(),
//       ));
//     }
//   }

//   //Document Pick

//   bool isLoading = false;
//   File? fileToDisplay;
//   var documentLength;
//   var documentUrl;
//   bool nextPage = false;
//   String fileName = "";

//   void pickDocument(setState) async {
//     var dio = Dio();
//     FilePickerResult? result = await FilePicker.platform.pickFiles();
//     if (result != null) {
//       setState(() async {
//         File file = File(result.files.single.path ?? "");
//         fileName = file.path.split('/').last;
//         String filePath = file.path;

//         FormData data = FormData.fromMap({
//           'file': await MultipartFile.fromFile(filePath, filename: fileName)
//         });
//         var response = await dio.post(
//           '${TextConstant.baseURL}/api/common/common-routes/upload-single',
//           data: data,
//           options: Options(headers: {'x-access-token': token}),
//           onSendProgress: (count, total) {
//             print("$count, $total");
//           },
//         );
//         print(response.data);
//         if (response.statusCode == 200) {
//           setState(() {
//             documentUrl = response.data["url"];
//             saveDisable = false;
//             helpDocument1 = "documentUrl";
//             helpDocument2 = documentUrl;
//           });
//         }
//       });
//     } else {
//       print("Result is null");
//     }
//   }
// }

// class UpperCaseTextFormatter extends TextInputFormatter {
//   @override
//   TextEditingValue formatEditUpdate(
//       TextEditingValue oldValue, TextEditingValue newValue) {
//     return TextEditingValue(
//       text: newValue.text.toUpperCase(),
//       selection: newValue.selection,
//     );
//   }
// }
