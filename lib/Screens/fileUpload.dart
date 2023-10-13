import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:hrcosmoemployee/Constants/color_constant.dart';

import '../custom_widgets.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  FilePickerResult? result;
  String? _fileName;
  PlatformFile? pickedfile;
  bool isLoading = false;
  void pickPan() async {
    try {
      setState(() {
        isLoading = true;
      });
      result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result != null) {
        _fileName = result!.files.first.name;
        pickedfile = result!.files.first;
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  showAlertDialog(BuildContext context) {
    // Create button
    Widget noButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget deleteButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        setState(() {
          pickedfile = null;
        });
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      //title: Text("Details: "),
      content: Text(
        "Are you sure want to delete?",
        style: TextStyle(
          fontSize: 16,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CustomWidgets.navBar(onTap: () {}),
        backgroundColor: Colors.white,
        drawer: const Drawer(backgroundColor: Colors.white),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_rounded,
                  size: 30, color: Color.fromARGB(255, 30, 67, 159)),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications,
              ),
              color: AppColors.maincolor,
            ),
            SizedBox(
              width: 10,
            )
          ],
          // iconTheme: IconThemeData(color: Color.fromARGB(255, 30, 67, 159)),
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: Colors.transparent,
              statusBarColor: Colors.transparent),
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 245, 245, 245),
          title: Image.asset(
            "assets/mTrack.png",
            height: 100,
            width: 190,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 13),
            child: Column(children: [
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
                    "File Upload",
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset("assets/upload.png"),
                  Image.asset("assets/upload2.png")
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Upload your file here",
                style: TextStyle(
                  fontSize: 20,
                  letterSpacing: 0.3,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              ElevatedButton(
                onPressed: () {
                  pickPan();
                },
                child: Text(
                  "Browse file",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w500),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.maincolor,
                    minimumSize: const Size(219, 48),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.transparent, width: 1.5),
                        borderRadius: BorderRadius.circular(25.0))),
              ),
              SizedBox(
                height: 0.12.sw,
              ),
              pickedfile == null
                  ? Container()
                  : Row(
                      children: [
                        Container(
                          height: 49,
                          width: 315,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: Color.fromARGB(255, 233, 233, 233),
                                  width: 1),
                              color: Color.fromARGB(255, 241, 241, 241)),
                          child: Row(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset("assets/pdf1.png",
                                      height: 32, width: 25),
                                  Image.asset(
                                    "assets/pdf2.png",
                                    height: 24,
                                    width: 15,
                                  )
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Text(
                                  "$_fileName",
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "View File",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppColors.maincolor,
                                        fontWeight: FontWeight.w600),
                                  ))
                            ],
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: AppColors.maincolor,
                            ))
                      ],
                    )
            ])));
  }
}
