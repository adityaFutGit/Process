// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'dart:async';
// import 'package:flutter_face_api_beta/face_api.dart' as Regula;
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';

// class FaceComparingWidget {
//   var image1 = Regula.MatchFacesImage();
//   var image2 = Regula.MatchFacesImage();
//   var img1 = Image.asset('assets/profile.jpeg');
//   var img2 = Image.asset('assets/profile.jpeg');

//   String similarity = "nil";
//   String liveness = "nil";

//   // matchFaces() {
//   //   print(image1.bitmap);
//   //   print('image1.bitmap mathc');
//   //   print(image2.bitmap);
//   //   print('image2.bitmap mathc');
//   //   if (image1.bitmap == null ||
//   //       image1.bitmap == "" ||
//   //       image2.bitmap == null ||
//   //       image2.bitmap == "") return;
//   //   similarity = "Processing...";
//   //   print("mathe face start");
//   //   //  update();
//   //   var request = Regula.MatchFacesRequest();
//   //   request.images = [image1, image2];

//   //   Regula.FaceSDK.matchFaces(jsonEncode(request)).then((value) {
//   //     var response = Regula.MatchFacesResponse.fromJson(json.decode(value));
//   //     print('respons1 ${response?.results.first?.score}');
//   //     print('respons2 ${response?.results.single?.score}');
//   //     print('respons ${response?.results.map((e) => e?.toJson()).toList()}');

//   //     Regula.FaceSDK.matchFacesSimilarityThresholdSplit(
//   //             jsonEncode(response!.results), 0.75)
//   //         .then((str) {
//   //       var split = Regula.MatchFacesSimilarityThresholdSplit.fromJson(
//   //           json.decode(str));
//   //       similarity = split!.matchedFaces.isNotEmpty
//   //           ? ("${(split.matchedFaces[0]!.similarity! * 100).toStringAsFixed(2)}%")
//   //           : "error";
//   //       print(similarity);
//   //       //  update();
//   //     });
//   //   });
//   // }

//   setImage(bool first, Uint8List? imageFile, int type) {
//     if (imageFile == null) return;
//     similarity = "nil";
//     // update();

//     if (first) {
//       image1.bitmap = base64Encode(imageFile);
//       image1.imageType = type;

//       img1 = Image.memory(imageFile);
//       liveness = "nil";
//       //  update();

//       print(image1.bitmap);
//       print('image1.bitmap');
//     } else {
//       image2.bitmap = base64Encode(imageFile);
//       image2.imageType = type;
//       img2 = Image.memory(imageFile);
//       print(image2.bitmap);
//       print('image2.bitmap');
//       //  update();
//     }
//   }

//   // livenessImage() => Regula.FaceSDK.startLiveness().then((value) {
//   //       print('$value');
//   //       print('start live');

//   //       var result = Regula.LivenessResponse.fromJson(json.decode(value));
//   //       setImage(true, base64Decode(result!.bitmap!.replaceAll("\n", "")),
//   //           Regula.ImageType.LIVE);
//   //       liveness = result.liveness == Regula.LivenessStatus.PASSED
//   //           ? "passed"
//   //           : "unknown";
//   //       //  update();
//   //     });

//   // clearResults() {
//   //   img1 = Image.asset('assets/images/mostafiz_image.jpeg');
//   //   img2 = Image.asset('assets/images/mostafiz_image2.jpeg');
//   //   similarity = "nil";
//   //   liveness = "nil";
//   //   //  update();
//   //   image1 = Regula.MatchFacesImage();
//   //   image2 = Regula.MatchFacesImage();
//   // }

//   // Future<XFile> getImageFileFromAssets(String path) async {
//   //   final byteData = await rootBundle.load("assets/images/$path");
//   //   print(byteData);
//   //   print("byteData");

//   //   final file = File('${(await getTemporaryDirectory()).path}/$path');
//   //   final xfile = XFile('${(await getTemporaryDirectory()).path}/$path');
//   //   await file.writeAsBytes(byteData.buffer
//   //       .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
//   //   print(file);
//   //   print("file");
//   //   return xfile;
//   // }
// }

// class SignInController extends GetxController {}
