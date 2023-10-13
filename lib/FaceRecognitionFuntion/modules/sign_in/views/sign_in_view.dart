// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:get/get.dart';

// import '../controllers/sign_in_controller.dart';
// import 'dart:io' as io;
// import 'package:flutter_face_api_beta/face_api.dart' as Regula;
// import 'package:image_picker/image_picker.dart';

// class SignInView extends GetView<SignInController> {
//   SignInView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SignInView'),
//         centerTitle: true,
//       ),
//       body: GetBuilder<SignInController>(builder: (_) {
//         return Container(
//             margin: const EdgeInsets.fromLTRB(0, 0, 0, 100),
//             width: double.infinity,
//             child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   // createImage(
//                   //     _.img1.image, () => showAlertDialog(context, true)),
//                   // createImage(
//                   //     _.img2.image, () => showAlertDialog(context, false)),
//                   // Container(margin: const EdgeInsets.fromLTRB(0, 0, 0, 15)),
//                   // createButton("Match", () => _.matchFaces()),
//                   // Container(
//                   //     margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
//                   //     child: Row(
//                   //       mainAxisAlignment: MainAxisAlignment.center,
//                   //       children: [
//                   //         Text("Similarity: ${_.similarity}",
//                   //             style: const TextStyle(fontSize: 18)),
//                   //       ],
//                   //     ))
//                 ]));
//       }),
//     );
//   }

//   Widget createImage(image, VoidCallback onPress) => Material(
//           child: InkWell(
//         onTap: onPress,
//         child: Container(
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(20.0),
//             child: Image(height: 150, width: 150, image: image),
//           ),
//         ),
//       ));
//   Widget createButton(String text, VoidCallback onPress) => SizedBox(
//         width: 250,
//         child: TextButton(
//             style: ButtonStyle(
//               foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
//               backgroundColor: MaterialStateProperty.all<Color>(Colors.black12),
//             ),
//             onPressed: onPress,
//             child: Text(text)),
//       );
//   showAlertDialog(BuildContext context, bool first) => showDialog(
//       context: context,
//       builder: (BuildContext context) =>
//           AlertDialog(title: const Text("Select option"), actions: [
//             // ignore: deprecated_member_use

//             // ignore: deprecated_member_use
//             // TextButton(
//             //     child: const Text("Use camera"),
//             //     onPressed: () {
//             //       Regula.FaceSDK.presentFaceCaptureActivity().then((result) => {
//             //             print('result present face capture $result'),
//             //             controller.setImage(
//             //                 first,
//             //                 base64Decode(Regula.FaceCaptureResponse.fromJson(
//             //                         json.decode(result))!
//             //                     .image!
//             //                     .bitmap!
//             //                     .replaceAll("\n", "")),
//             //                 Regula.ImageType.LIVE)
//             //           });

//             //       Navigator.pop(context);
//             //     })
//           ]));
// }
