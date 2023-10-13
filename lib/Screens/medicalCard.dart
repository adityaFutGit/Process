// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:expansion_tile_card/expansion_tile_card.dart';
// import '../Constants/color_constant.dart';
// import '../custom_widgets.dart';

// class MedicalCard extends StatefulWidget {
//   const MedicalCard({super.key});

//   @override
//   State<MedicalCard> createState() => _MedicalCardState();
// }

// class _MedicalCardState extends State<MedicalCard> {
//   final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();
//   var expandValue;
//   List header = ["UHID:", "Relationship:", "DOB:", "Gender:", "Sum Insured:"];
//   List subHeader = [
//     "NIC9886483",
//     "Son",
//     "July 3,1999",
//     "Male",
//     "40000.00",
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         bottomNavigationBar: CustomWidgets.navBar(onTap: () {}),
//         backgroundColor: Colors.white,
//         drawer: const Drawer(backgroundColor: Colors.white),
//         appBar: AppBar(
//           leading: Builder(
//             builder: (context) => IconButton(
//               icon: const Icon(Icons.menu_rounded,
//                   size: 30, color: Color.fromARGB(255, 30, 67, 159)),
//               onPressed: () => Scaffold.of(context).openDrawer(),
//             ),
//           ),

//           // iconTheme: IconThemeData(color: Color.fromARGB(255, 30, 67, 159)),
//           systemOverlayStyle: const SystemUiOverlayStyle(
//               systemNavigationBarColor: Colors.transparent,
//               statusBarColor: Colors.transparent),
//           elevation: 0,
//           backgroundColor: const Color.fromARGB(255, 245, 245, 245),
//           title: Text(
//             "Medical Card",
//             style: TextStyle(fontSize: 16, color: Colors.black87),
//           ),
//           centerTitle: true,
//         ),
//         body: SingleChildScrollView(
//             padding: EdgeInsets.symmetric(horizontal: 13),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               IconButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: Colors.black,
//                     size: 19,
//                   )),
//               Text(
//                 "Medical Card is on Working...",
//                 style: TextStyle(fontSize: 20, color: Colors.red),
//               ),
//               Container(
//                   //  height: 600,
//                   width: 400,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.transparent),
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                             color: Color.fromARGB(255, 227, 227, 227),
//                             blurRadius: 2,
//                             spreadRadius: 1)
//                       ]),
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "Employee Policy",
//                           style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500,
//                               color: AppColors.darkgrey),
//                         ),
//                         Divider(
//                           color: Colors.grey.shade200,
//                           height: 20,
//                           thickness: 2,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Policy Number:",
//                                   style: TextStyle(
//                                       color: Color.fromARGB(255, 101, 101, 101),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 SizedBox(
//                                   height: 3,
//                                 ),
//                                 FittedBox(
//                                   child: Text(
//                                     "123456789",
//                                     style: TextStyle(
//                                         color:
//                                             Color.fromARGB(255, 120, 120, 120),
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Policy Duration:",
//                                   style: TextStyle(
//                                       color: Color.fromARGB(255, 101, 101, 101),
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 SizedBox(
//                                   height: 3,
//                                 ),
//                                 FittedBox(
//                                   child: Text(
//                                     "Oct 1,2022 - Sep 3,2023",
//                                     style: TextStyle(
//                                         color:
//                                             Color.fromARGB(255, 120, 120, 120),
//                                         fontWeight: FontWeight.w400),
//                                   ),
//                                 ),
//                               ],
//                             )
//                           ],
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               "Sum Insured:",
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 101, 101, 101),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             Text(
//                               "llllllllllllllllllll",
//                               style: TextStyle(
//                                   color: Color.fromARGB(255, 101, 101, 101),
//                                   fontWeight: FontWeight.w600),
//                             ),
//                             SizedBox(
//                               height: 3,
//                             ),
//                             FittedBox(
//                               child: Text(
//                                 "400000.00",
//                                 style: TextStyle(
//                                     color: Color.fromARGB(255, 120, 120, 120),
//                                     fontWeight: FontWeight.w400),
//                               ),
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 30,
//                         ),
//                         Container(
//                             child: ListView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: 3,
//                                 itemBuilder: (context, index) {
//                                   return Container(
//                                     margin: EdgeInsets.only(bottom: 10),
//                                     child: ExpansionTileCard(
//                                       onExpansionChanged: (value) {
//                                         setState(() {
//                                           expandValue = value;
//                                         });
//                                       },
//                                       trailing: Icon(
//                                         expandValue == true
//                                             ? Icons.arrow_drop_up
//                                             : Icons.arrow_drop_down_outlined,
//                                         color: Colors.white,
//                                         size: 35,
//                                       ),
//                                       baseColor: AppColors.maincolor,
//                                       borderRadius: BorderRadius.circular(12),
//                                       expandedColor: AppColors.maincolor,
//                                       elevation: 0,
//                                       title: Row(
//                                         children: [
//                                           Icon(
//                                             Icons.account_circle_outlined,
//                                             color: Colors.white,
//                                             size: 35,
//                                           ),
//                                           SizedBox(
//                                             width: 10,
//                                           ),
//                                           Text(
//                                             "Shreya Thakur",
//                                             style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w600),
//                                           ),
//                                         ],
//                                       ),
//                                       children: [
//                                         Container(
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(8),
//                                               border: Border.all(
//                                                   color: Color.fromARGB(
//                                                       255, 205, 205, 205),
//                                                   width: 1.2),
//                                               color: Colors.white),
//                                           padding: EdgeInsets.all(10),
//                                           child: Column(
//                                             children: [
//                                               GridView.builder(
//                                                   physics:
//                                                       const NeverScrollableScrollPhysics(),
//                                                   shrinkWrap: true,
//                                                   gridDelegate:
//                                                       SliverGridDelegateWithFixedCrossAxisCount(
//                                                           childAspectRatio:
//                                                               4 / 2,
//                                                           crossAxisCount: 2,
//                                                           crossAxisSpacing: 100,
//                                                           mainAxisSpacing: 0),
//                                                   itemCount: 5,
//                                                   itemBuilder:
//                                                       (BuildContext ctx,
//                                                           index) {
//                                                     return Container(
//                                                       child: Row(
//                                                         children: [
//                                                           Column(
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Text(
//                                                                 header[index],
//                                                                 style:
//                                                                     TextStyle(
//                                                                   fontSize: 13,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .w500,
//                                                                   color: Color
//                                                                       .fromARGB(
//                                                                           255,
//                                                                           59,
//                                                                           59,
//                                                                           59),
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 3,
//                                                               ),
//                                                               Flexible(
//                                                                 flex: 1,
//                                                                 child:
//                                                                     Container(
//                                                                   width: 90,
//                                                                   child: Text(
//                                                                     subHeader[
//                                                                         index],
//                                                                     style: TextStyle(
//                                                                         fontSize:
//                                                                             14,
//                                                                         color: AppColors
//                                                                             .darkgrey,
//                                                                         fontWeight:
//                                                                             FontWeight.w400),
//                                                                   ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     );
//                                                   }),
//                                               Divider(
//                                                 thickness: 1.6,
//                                                 color: Colors.grey.shade300,
//                                               ),
//                                               SizedBox(
//                                                 height: 5,
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment
//                                                         .spaceBetween,
//                                                 children: [
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       print("donwlaod");
//                                                     },
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.download,
//                                                           color: AppColors
//                                                               .maincolor,
//                                                           size: 20,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5,
//                                                         ),
//                                                         Text(
//                                                           "Download",
//                                                           style: TextStyle(
//                                                               color: AppColors
//                                                                   .maincolor,
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                   GestureDetector(
//                                                     onTap: () {
//                                                       print("share");
//                                                     },
//                                                     child: Row(
//                                                       children: [
//                                                         Icon(
//                                                           Icons.share,
//                                                           color: AppColors
//                                                               .maincolor,
//                                                           size: 20,
//                                                         ),
//                                                         SizedBox(
//                                                           width: 5,
//                                                         ),
//                                                         Text(
//                                                           "Share",
//                                                           style: TextStyle(
//                                                               color: AppColors
//                                                                   .maincolor,
//                                                               fontSize: 14,
//                                                               fontWeight:
//                                                                   FontWeight
//                                                                       .w500),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   )
//                                                 ],
//                                               )
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 }))
//                       ])),
//             ])));
//   }
// }
