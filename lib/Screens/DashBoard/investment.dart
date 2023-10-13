// // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

// import 'dart:convert';
// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:external_path/external_path.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lottie/lottie.dart';
// import 'package:hrcosmoemployee/Screens/DashBoard/regime.dart';
// import 'package:hrcosmoemployee/custom_widgets.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:quickalert/quickalert.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:http/http.dart' as http;
// import '../../Constants/color_constant.dart';
// import '../../Constants/text_constant.dart';
// import '../../Models/investmentCategoryNameModel.dart';

// class Investment extends StatefulWidget {
//   const Investment({super.key});

//   @override
//   State<Investment> createState() => _InvestmentState();
// }

// class _InvestmentState extends State<Investment> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

//   String? selectedCategory;
//   String? selectedInvestmentName;

//   int? selectedCategoryId;
//   int? selectPermCityId;

//   bool cityLoading = false;
//   @override
//   void initState() {
//     initPrefs();

//     super.initState();
//   }

//   var salaryId;
//   var token;
//   TextEditingController amount = TextEditingController();
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
//     _getListDeduction();
//     _getCategoryData();
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
//             child: allCatName.isEmpty && responseBody == null
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
//                             "Investment",
//                             style: TextStyle(
//                                 fontSize: 18.sp, fontWeight: FontWeight.w500),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => const Regime(),
//                               ));
//                             },
//                             child: Text(
//                               "Regime",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(110, 25),
//                               splashFactory: NoSplash.splashFactory,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               backgroundColor: AppColors.maincolor,
//                             ),
//                           ),
//                           ElevatedButton(
//                             onPressed: () {
//                               showModalBottomSheet<void>(
//                                 isScrollControlled: true,
//                                 context: context,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10.0),
//                                 ),
//                                 builder: (BuildContext context) {
//                                   return _showAddInvestmentModal();
//                                 },
//                               );
//                             },
//                             child: Text(
//                               "Add",
//                               style: TextStyle(fontSize: 16),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               fixedSize: Size(110, 25),
//                               splashFactory: NoSplash.splashFactory,
//                               elevation: 0,
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10)),
//                               backgroundColor: AppColors.maincolor,
//                             ),
//                           ),
//                         ],
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
//                                         "Category",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColors.darkgrey),
//                                       ),
//                                       SizedBox(
//                                         width: 40,
//                                       ),
//                                       Text(
//                                         "Name",
//                                         style: TextStyle(
//                                             fontSize: 15,
//                                             fontWeight: FontWeight.w600,
//                                             color: AppColors.darkgrey),
//                                       ),
//                                       SizedBox(
//                                         width: 65,
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
//                                                     listDeduction[index]
//                                                         ["name"],
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
//                                                     "${listDeduction[index]["name"]}",
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         color: Color.fromARGB(
//                                                             255, 94, 94, 94)),
//                                                   ),
//                                                 ),
//                                                 Text(
//                                                   "${listDeduction[index]["amount"]}",
//                                                   style: TextStyle(
//                                                       fontSize: 14,
//                                                       fontWeight:
//                                                           FontWeight.w500,
//                                                       color: Color.fromARGB(
//                                                           255, 94, 94, 94)),
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
//                                                             return _showEditInvestmentModal(
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
//     var url = "${listDeduction[index]["documentUrl"]}";
//     print(url);
//     Dio dio = Dio();
//     var downloadedExcelPath =
//         '$downloadDirectory/${listDeduction[index]["documentUrl"].toString().substring(50)}';
//     print(downloadedExcelPath);
//     try {
//       dio.download(url, downloadedExcelPath,
//           deleteOnError: true,
//           options: Options(headers: {
//             'x-access-token': token,
//           }), onReceiveProgress: (rec, total) {
//         setState(() {
//           print("pppppppppppp");
//           progress = rec / total;
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
//   Widget _showAddInvestmentModal() {
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//       return Form(
//           key: _formKey,
//           child: Container(
//               height: 600,
//               padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                       color: Color.fromARGB(255, 230, 230, 230), width: 2)),
//               child: SingleChildScrollView(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Add Investment",
//                             style: TextStyle(
//                                 color: AppColors.maincolor,
//                                 fontSize: 16,
//                                 letterSpacing: 0.4,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               icon: Icon(
//                                 Icons.close,
//                                 size: 20,
//                               ))
//                         ],
//                       ),
//                       Divider(
//                         color: Color.fromARGB(255, 228, 227, 227),
//                         thickness: 2,
//                         height: 10,
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               width: 294,
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     const Text(
//                                       "Category",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 15,
//                                           color: Color.fromARGB(178, 0, 0, 0)),
//                                     ),
//                                     const SizedBox(
//                                       height: 12,
//                                     ),
//                                     DropdownButtonFormField(
//                                       validator: (value) {
//                                         if (value == null) {
//                                           return ("Select Category");
//                                         }
//                                         return null;
//                                       },
//                                       borderRadius: BorderRadius.circular(10),
//                                       decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 0.0,
//                                                   horizontal: 13),
//                                           hintText: "Select Category",
//                                           hintStyle: const TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                             color: Color.fromARGB(
//                                                 255, 136, 136, 136),
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 color: Color.fromARGB(
//                                                     255, 227, 227, 227),
//                                                 width: 1.5),
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 color: Colors.grey),
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           fillColor: Colors.white,
//                                           filled: true),
//                                       isExpanded: false,
//                                       icon: const Icon(
//                                           Icons.arrow_drop_down_outlined),
//                                       iconSize: 30,
//                                       value: selectedCategory,
//                                       items: allCatName.map((ite) {
//                                         return DropdownMenuItem(
//                                           child: Text(
//                                             ite.name,
//                                           ),
//                                           value: ite.id.toString(),
//                                         );
//                                       }).toList(),
//                                       onChanged: (item) {
//                                         setState(() {
//                                           selectedCategory = item!;
//                                           selectedCategoryId = int.parse(item);
//                                           _getInvestmentData(
//                                               selectedCategoryId!, setState);
//                                         });
//                                       },
//                                     ),
//                                   ])),
//                           SizedBox(
//                             height: 17,
//                           ),
//                           Container(
//                               width: 294,
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Text(
//                                       "Investment ",
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 15,
//                                           color: Color.fromARGB(178, 0, 0, 0)),
//                                     ),
//                                     const SizedBox(
//                                       height: 12,
//                                     ),
//                                     cityLoading == true
//                                         ? Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 20),
//                                             child: SizedBox(
//                                               height: 20,
//                                               width: 20,
//                                               child: CircularProgressIndicator(
//                                                 strokeWidth: 2,
//                                                 color: AppColors.maincolor,
//                                               ),
//                                             ),
//                                           )
//                                         : DropdownButtonFormField(
//                                             validator: (value) {
//                                               if (value == null) {
//                                                 return ("Select Investment");
//                                               }
//                                               return null;
//                                             },
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             decoration: InputDecoration(
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 0.0,
//                                                         horizontal: 13),
//                                                 hintText: "Select Investment",
//                                                 hintStyle: const TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Color.fromARGB(
//                                                       255, 136, 136, 136),
//                                                 ),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: Color.fromARGB(
//                                                           255, 227, 227, 227),
//                                                       width: 1.5),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                                 focusedBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: Colors.grey),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                                 fillColor: Colors.white,
//                                                 filled: true),
//                                             isExpanded: false,
//                                             icon: const Icon(
//                                                 Icons.arrow_drop_down_outlined),
//                                             iconSize: 30,
//                                             value: selectedInvestmentName,
//                                             items: allInvestmentName.map((ite) {
//                                               return DropdownMenuItem(
//                                                 child: SizedBox(
//                                                   width: 230,
//                                                   child: Text(
//                                                     ite.name,
//                                                   ),
//                                                 ),
//                                                 value: ite.description,
//                                               );
//                                             }).toList(),
//                                             onChanged: (item) {
//                                               selectedInvestmentName =
//                                                   item! as String;
//                                               print(selectedInvestmentName);
//                                               // setState(() {
//                                               //   selectPermCityId =
//                                               //       int.parse(item);

//                                               // });
//                                               // setState;
//                                             },
//                                           ),
//                                   ])),
//                           SizedBox(
//                             height: 17,
//                           ),
//                           CustomWidgets.textFormField(
//                             "Amount",
//                             textController: amount,
//                             keyboardType: TextInputType.number,
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return ("Enter Amount");
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(
//                             height: 17,
//                           ),
//                           CustomWidgets.textFormField("Document upload",
//                               validator: (fileName) {
//                                 if (fileName == null) {
//                                   return ("Upload Document");
//                                 } else
//                                   return null;
//                               },
//                               hintText: fileName == null
//                                   ? "*No file chosen"
//                                   : fileName,
//                               onTap: () {
//                                 pickDocument(setState);
//                                 setState(() {});
//                               },
//                               readOnly: true,
//                               suffixIcon: Icon(
//                                 Icons.upload,
//                                 color: Colors.black54,
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text(
//                               "Cancel",
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 123, 123, 123),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 minimumSize: const Size(101, 35),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     side: BorderSide(
//                                         color:
//                                             Color.fromARGB(255, 232, 232, 232),
//                                         width: 1.5),
//                                     borderRadius: BorderRadius.circular(8.0))),
//                           ),
//                           addLoading == true
//                               ? CircularProgressIndicator(
//                                   color: AppColors.maincolor,
//                                 )
//                               : AbsorbPointer(
//                                   absorbing: saveDisable,
//                                   child: ElevatedButton(
//                                     onPressed: () {
//                                       if (!_formKey.currentState!.validate()) {
//                                         return;
//                                       }
//                                       addDeduction(setState);
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
//                                   ),
//                                 )
//                         ],
//                       ),
//                     ]),
//               )));
//     });
//   }

//   var editDocumentUrlMain;
//   var editAmountMain;
//   var helpTextamount1 = "";
//   var helpTextamount2 = "";
//   var helpCategoryText1 = "";
//   var helpCategoryText2;
//   var helpInvestmentText1 = "";
//   var helpInvestmentText2 = "";
//   var helpDocument1 = "";
//   var helpDocument2 = "";

//   Widget _showEditInvestmentModal(index) {
//     var deductionId = listDeduction[index]["id"];
//     TextEditingController editAmount =
//         TextEditingController(text: listDeduction[index]["amount"].toString());
//     var categoryName = listDeduction[index]["category"]["name"];

//     var investmentName = listDeduction[index]["name"];
//     var editDocumentUrl = listDeduction[index]["documentUrl"];
//     int documentUrlLength =
//         listDeduction[index]["documentUrl"].toString().length;
//     return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setState) {
//       return Form(
//           key: _formKey,
//           child: Container(
//               height: 600,
//               padding: EdgeInsets.symmetric(horizontal: 27, vertical: 10),
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                       color: Color.fromARGB(255, 230, 230, 230), width: 2)),
//               child: SingleChildScrollView(
//                 child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Investment",
//                             style: TextStyle(
//                                 color: AppColors.maincolor,
//                                 fontSize: 16,
//                                 letterSpacing: 0.4,
//                                 fontWeight: FontWeight.w600),
//                           ),
//                           IconButton(
//                               onPressed: () {
//                                 Navigator.pop(context);
//                               },
//                               icon: Icon(
//                                 Icons.close,
//                                 size: 20,
//                               ))
//                         ],
//                       ),
//                       Divider(
//                         color: Color.fromARGB(255, 228, 227, 227),
//                         thickness: 2,
//                         height: 10,
//                       ),
//                       SizedBox(
//                         height: 25,
//                       ),
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                               width: 294,
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     const Text(
//                                       "Category",
//                                       style: TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 15,
//                                           color: Color.fromARGB(178, 0, 0, 0)),
//                                     ),
//                                     const SizedBox(
//                                       height: 12,
//                                     ),
//                                     DropdownButtonFormField(
//                                       // validator: (value) {
//                                       //   if (value == null) {
//                                       //     return ("Select Category");
//                                       //   }
//                                       //   return null;
//                                       // },
//                                       borderRadius: BorderRadius.circular(10),
//                                       decoration: InputDecoration(
//                                           contentPadding:
//                                               const EdgeInsets.symmetric(
//                                                   vertical: 0.0,
//                                                   horizontal: 13),
//                                           hintText: categoryName,
//                                           hintStyle: const TextStyle(
//                                             fontSize: 14,
//                                             fontWeight: FontWeight.w500,
//                                             color: Color.fromARGB(
//                                                 255, 136, 136, 136),
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 color: Color.fromARGB(
//                                                     255, 227, 227, 227),
//                                                 width: 1.5),
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: const BorderSide(
//                                                 color: Colors.grey),
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                           ),
//                                           fillColor: Colors.white,
//                                           filled: true),
//                                       isExpanded: false,
//                                       icon: const Icon(
//                                           Icons.arrow_drop_down_outlined),
//                                       iconSize: 30,
//                                       value: selectedCategory,
//                                       items: allCatName.map((ite) {
//                                         return DropdownMenuItem(
//                                           child: Text(
//                                             ite.name,
//                                           ),
//                                           value: ite.id.toString(),
//                                         );
//                                       }).toList(),
//                                       onChanged: (item) {
//                                         setState(() {
//                                           selectedCategory = item!;
//                                           selectedCategoryId = int.parse(item);
//                                           helpCategoryText1 = "CategoryId";
//                                           helpCategoryText2 =
//                                               selectedCategoryId;
//                                           _getInvestmentData(
//                                               selectedCategoryId!, setState);
//                                         });
//                                       },
//                                     ),
//                                   ])),
//                           SizedBox(
//                             height: 17,
//                           ),
//                           Container(
//                               width: 294,
//                               child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Text(
//                                       "Investment ",
//                                       style: const TextStyle(
//                                           fontWeight: FontWeight.w500,
//                                           fontSize: 15,
//                                           color: Color.fromARGB(178, 0, 0, 0)),
//                                     ),
//                                     const SizedBox(
//                                       height: 12,
//                                     ),
//                                     cityLoading == true
//                                         ? Padding(
//                                             padding:
//                                                 const EdgeInsets.only(left: 20),
//                                             child: SizedBox(
//                                               height: 20,
//                                               width: 20,
//                                               child: CircularProgressIndicator(
//                                                 strokeWidth: 2,
//                                                 color: AppColors.maincolor,
//                                               ),
//                                             ),
//                                           )
//                                         : DropdownButtonFormField(
//                                             // validator: (value) {
//                                             //   if (value == null) {
//                                             //     return ("Select Investment");
//                                             //   }
//                                             //   return null;
//                                             // },
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             decoration: InputDecoration(
//                                                 contentPadding:
//                                                     const EdgeInsets.symmetric(
//                                                         vertical: 0.0,
//                                                         horizontal: 13),
//                                                 hintText: investmentName,
//                                                 hintStyle: const TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Color.fromARGB(
//                                                       255, 136, 136, 136),
//                                                 ),
//                                                 enabledBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: Color.fromARGB(
//                                                           255, 227, 227, 227),
//                                                       width: 1.5),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                                 focusedBorder:
//                                                     OutlineInputBorder(
//                                                   borderSide: const BorderSide(
//                                                       color: Colors.grey),
//                                                   borderRadius:
//                                                       BorderRadius.circular(10),
//                                                 ),
//                                                 fillColor: Colors.white,
//                                                 filled: true),
//                                             isExpanded: false,
//                                             icon: const Icon(
//                                                 Icons.arrow_drop_down_outlined),
//                                             iconSize: 30,

//                                             value: selectedInvestmentName,
//                                             items: allInvestmentName.map((ite) {
//                                               return DropdownMenuItem(
//                                                 child: SizedBox(
//                                                   width: 230,
//                                                   child: Text(
//                                                     ite.name,
//                                                   ),
//                                                 ),
//                                                 value: ite.description,
//                                               );
//                                             }).toList(),
//                                             onChanged: (item) {
//                                               selectedInvestmentName =
//                                                   item! as String;
//                                               helpInvestmentText1 = "name";
//                                               helpInvestmentText2 =
//                                                   selectedInvestmentName
//                                                       .toString();
//                                               print(selectedInvestmentName);
//                                               // setState(() {
//                                               //   selectPermCityId =
//                                               //       int.parse(item);

//                                               // });
//                                               // setState;
//                                             },
//                                           ),
//                                   ])),
//                           SizedBox(
//                             height: 17,
//                           ),
//                           CustomWidgets.textFormField(
//                             "Amount",
//                             textController: editAmount,
//                             keyboardType: TextInputType.number,
//                             onChange: (text) {
//                               // setState(() {
//                               listDeduction[index]["amount"] = text;
//                               helpTextamount1 = "amount";
//                               helpTextamount2 = editAmount.text;
//                               // });
//                             },
//                             validator: (value) {
//                               if (value.isEmpty) {
//                                 return ("Enter Amount");
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(
//                             height: 17,
//                           ),
//                           CustomWidgets.textFormField("Document upload",
//                               hintText: fileName == ""
//                                   ? documentUrlLength < 30
//                                       ? editDocumentUrl.toString().substring(10)
//                                       : editDocumentUrl.toString().substring(90)
//                                   : fileName, onTap: () {
//                             pickDocument(setState);
//                             setState(() {});
//                           },
//                               readOnly: true,
//                               suffixIcon: Icon(
//                                 Icons.upload,
//                                 color: Colors.black54,
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 20,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                             onPressed: () {
//                               Navigator.pop(context);
//                             },
//                             child: Text(
//                               "Cancel",
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 123, 123, 123),
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 minimumSize: const Size(101, 35),
//                                 elevation: 0,
//                                 shape: RoundedRectangleBorder(
//                                     side: BorderSide(
//                                         color:
//                                             Color.fromARGB(255, 232, 232, 232),
//                                         width: 1.5),
//                                     borderRadius: BorderRadius.circular(8.0))),
//                           ),
//                           editLoading == true
//                               ? CircularProgressIndicator(
//                                   color: AppColors.maincolor,
//                                 )
//                               : ElevatedButton(
//                                   onPressed: () async {
//                                     if (!_formKey.currentState!.validate()) {
//                                       return;
//                                     }
//                                     setState(() {
//                                       editLoading = true;
//                                     });
//                                     try {
//                                       final uri = Uri.parse(
//                                           "${TextConstant.baseURL}/api/payroll/annual-taxation/employee/edit-deduction");

//                                       Map<String, dynamic> body = {
//                                         helpInvestmentText1:
//                                             helpInvestmentText2,
//                                         helpTextamount1: helpTextamount2,
//                                         helpCategoryText1: helpCategoryText2,
//                                         helpDocument1: helpDocument2,
//                                         "deductionId": deductionId
//                                       };
//                                       String jsonBody = json.encode(body);
//                                       final encoding =
//                                           Encoding.getByName('utf-8');
//                                       print(body);
//                                       var response = await http.patch(
//                                         uri,
//                                         headers: {
//                                           'Content-Type': 'application/json',
//                                           'Accept': '*/*',
//                                           'x-access-token': token
//                                         },
//                                         body: jsonBody,
//                                         encoding: encoding,
//                                       );

//                                       var responseBody = response.body;
//                                       print(responseBody);
//                                       if (response.statusCode == 200) {
//                                         setState(() {
//                                           editLoading = false;
//                                         });
//                                         Navigator.of(context)
//                                             .pushReplacement(MaterialPageRoute(
//                                           builder: (context) =>
//                                               const Investment(),
//                                         ));
//                                       }
//                                     } on Exception catch (e) {
//                                       ScaffoldMessenger.of(context)
//                                           .showSnackBar(SnackBar(
//                                               backgroundColor:
//                                                   AppColors.maincolor,
//                                               content: Text(
//                                                 "${e.toString()} ",
//                                                 style: TextStyle(
//                                                     color: Colors.white,
//                                                     fontSize: 18),
//                                               )));
//                                       Navigator.of(context)
//                                           .pushReplacement(MaterialPageRoute(
//                                         builder: (context) =>
//                                             const Investment(),
//                                       ));
//                                     }
//                                   },
//                                   child: Text(
//                                     "Save",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w500),
//                                   ),
//                                   style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           Color.fromARGB(255, 30, 67, 159),

//                                       //maximumSize: Size(7, 3),
//                                       minimumSize: const Size(101, 35),
//                                       elevation: 0,
//                                       shape: RoundedRectangleBorder(
//                                           side: BorderSide(
//                                               color: Colors.transparent,
//                                               width: 1.5),
//                                           borderRadius:
//                                               BorderRadius.circular(8.0))),
//                                 )
//                         ],
//                       ),
//                     ]),
//               )));
//     });
//   }

// //List Deduction
//   dynamic listDeduction;
//   var responseBody;
//   List<InvestmentListDeduction> allData = List.empty(growable: true);
//   _getListDeduction() async {
//     try {
//       var url = Uri.parse(
//           '${TextConstant.baseURL}/api/payroll/annual-taxation/employee/list-deduction?employeeSalaryId=$salaryId');

//       http.Response res = await http.get(url, headers: {
//         'x-access-token': token,
//       });
//       if (mounted) {
//         setState(() {
//           responseBody = res.body;
//         });
//       }
//       if (res.statusCode == 200) {
//         listDeduction = jsonDecode(res.body);
//         for (int i = 0; i < listDeduction.length; i++) {
//           allData.add(InvestmentListDeduction(
//             listDeduction[i]["id"],
//             listDeduction[i]["name"],
//             listDeduction[i]["description"],
//             listDeduction[i]["amount"],
//             listDeduction[i]["categoryId"],
//             listDeduction[i]["financialYear"],
//             listDeduction[i]["status"],
//             listDeduction[i]["documentUrl"],
//             listDeduction[i]["employeeSalaryId"],
//           ));
//           print(listDeduction[i]["name"]);
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
//       _getListDeduction();
//     }
//     return;
//   }

// //Post Add investment details
//   var addLoading = false;
//   void addDeduction(setState) async {
//     setState(() {
//       addLoading = true;
//     });
//     try {
//       final uri = Uri.parse(
//           "${TextConstant.baseURL}/api/payroll/annual-taxation/employee/add-deduction");

//       Map<String, dynamic> body = {
//         "name": selectedInvestmentName,
//         "description": selectedInvestmentName,
//         "amount": amount.text,
//         "categoryId": selectedCategoryId,
//         "financialYear": "2022-2023",
//         "status": "Submited",
//         "documentUrl": documentUrl,
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
//           builder: (context) => const Investment(),
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
//         builder: (context) => const Investment(),
//       ));
//     }
//   }

// //Post Add investment details
//   var editLoading = false;

//   //Category Name and id API
//   List<CategoryName> allCatName = List.empty(growable: true);
//   dynamic categoryData;

//   _getCategoryData() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var res;
//     try {
//       res = await http.get(
//           Uri.parse(
//               '${TextConstant.baseURL}/api/payroll/annual-taxation/list-tax-deduction-category'),
//           headers: {
//             'x-access-token': token,
//           });
//       categoryData = jsonDecode(res.body);
//       for (int i = 0; i < categoryData.length; i++) {
//         allCatName
//             .add(CategoryName(categoryData[i]["name"], categoryData[i]["id"]));
//       }
//       setState(() {});
//     } on Exception catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//         builder: (context) => const Investment(),
//       ));
//     }

//     setState(() {});
//   }

//   // InvestmentName
//   List<InvestmentName> allInvestmentName = List.empty(growable: true);
//   dynamic investmentData;

//   void _getInvestmentData(int categoryId, setState) async {
//     setState(() {
//       selectedInvestmentName = null;
//       allInvestmentName.clear();
//       cityLoading = true;
//     });

//     String url =
//         '${TextConstant.baseURL}/api/payroll/annual-taxation/list-deduction-details?id=$categoryId';
//     http.Response res;
//     try {
//       res = await http.get(Uri.parse(url), headers: {
//         'x-access-token': token,
//       });
//       investmentData = jsonDecode(res.body);
//       if (res.statusCode == 200) {
//         setState(() {
//           cityLoading = false;
//         });
//       }
//       for (int i = 0; i < investmentData.length; i++) {
//         allInvestmentName.add(InvestmentName(investmentData[i]["name"],
//             investmentData[i]["id"], investmentData[i]["description"]));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(e.toString())));
//     }

//     setState(() {});
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
//             print("POPOPOPOPPOP$fileName");
//           },
//         );
//         print(response.data);
//         if (response.statusCode == 200) {
//           print("LOLOLOLOLOL");
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
