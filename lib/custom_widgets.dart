// ignore_for_file: sort_child_properties_last, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hrcosmoemployee/Constants/color_constant.dart';
import 'Screens/DashBoard/dashboard.dart';

class CustomWidgets {
  static Widget textFormField(String title,
      {bool isPassword = false,
      bool isNumber = false,
      var initialValue,
      int? length,
      bool readOnly = false,
      var onTap,
      void Function(String)? onChange,
      var onSave,
      var validator,
      var keyboardType,
      var suffixIcon,
      Icon? prefixIcon,
      var inputFormatters,
      dynamic textCapitalization,
      String? hintText,
      TextEditingController? textController,
      int lines = 1,
      var cornerRadius = 0.0}) {
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 2),
      //height: 40,
      width: 294,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 15,
                color: Color.fromARGB(178, 0, 0, 0)),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            onSaved: onSave,
            textCapitalization: TextCapitalization.none,
            onChanged: onChange,
            readOnly: readOnly,
            maxLines: lines,
            controller: textController,
            onTap: onTap,
            validator: validator,
            maxLength: length,
            initialValue: initialValue,
            inputFormatters: inputFormatters,
            obscureText: isPassword,
            //keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            keyboardType: keyboardType,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 13),
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 136, 136, 136),
                ),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 227, 227, 227), width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.white,
                filled: true),
          )
        ],
      ),
    );
  }

  static Widget textField(
      {bool isPassword = false,
      bool isNumber = false,
      int? length,
      bool readOnly = false,
      var onTap,
      var validator,
      //Size? width,
      double? width,
      double? height,
      TextStyle? style,
      var suffixIcon,
      void Function(String)? onChange,
      Icon? prefixIcon,
      List<TextInputFormatter>? inputFormatters,
      String? hintText,
      EdgeInsetsGeometry? contentPadding,
      TextEditingController? textController,
      int? lines,
      var cornerRadius = 0.0}) {
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 2),
      height: height,
      width: width,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            style: style,
            readOnly: readOnly,
            maxLines: lines,
            controller: textController,
            onTap: onTap,
            validator: validator,
            maxLength: length,
            inputFormatters: inputFormatters,
            obscureText: isPassword,
            onChanged: onChange,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
                contentPadding: contentPadding,
                // const EdgeInsets.symmetric(vertical: 10.0, horizontal: 13),
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(168, 0, 0, 0),
                ),
                suffixIcon: suffixIcon,
                prefixIcon: prefixIcon,
                counterText: '',
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 242, 242, 242), width: 1.5),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Color.fromARGB(255, 215, 215, 215)),
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: const Color.fromARGB(255, 249, 249, 249),
                filled: true),
          )
        ],
      ),
    );
  }

  static Widget button({
    var onPressed,
    required String text,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.maincolor,
          minimumSize: const Size(300, 55),
          elevation: 0,
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.transparent, width: 1.5),
              borderRadius: BorderRadius.circular(8.0))),
    );
  }

  static Widget dropdown(
    String title, {
    String? selectedItem,
    String? hintText,
    List? list,
    var validator,
  }) {
    return Container(
        width: 294,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                    color: Color.fromARGB(178, 0, 0, 0)),
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownButtonFormField<String>(
                validator: validator,
                borderRadius: BorderRadius.circular(10),
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 13),
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 136, 136, 136),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 227, 227, 227),
                          width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                isExpanded: false,
                icon: const Icon(Icons.arrow_drop_down_outlined),
                iconSize: 30,
                value: selectedItem,
                items: list!
                    .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item,
                            style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight: FontWeight.w400))))
                    .toList(),
                onChanged: (item) {
                  selectedItem = item!;
                },
                onSaved: (newValue) {
                  newValue = selectedItem;
                },
              ),
            ]));
  }

  static Widget navBar({
    required Function onTap,
  }) {
    return Container(
      height: 0.13.sw,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent),
          boxShadow: [
            const BoxShadow(
                blurRadius: 3,
                spreadRadius: 2,
                color: Color.fromARGB(255, 224, 224, 224))
          ],
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              Get.to(DashboardScreen());
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.home,
                  size: 27,
                  color: Color.fromARGB(255, 30, 67, 159),
                ),
                const Text(
                  "Home",
                  style: TextStyle(
                      color: Color.fromARGB(255, 30, 67, 159),
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                )
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: onTap(),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Icon(
          //         Icons.account_circle,
          //         size: 26,
          //         color: Color.fromARGB(255, 30, 67, 159),
          //       ),
          //       const Text(
          //         "Profile",
          //         style: TextStyle(
          //             color: Color.fromARGB(255, 30, 67, 159),
          //             fontWeight: FontWeight.w400,
          //             fontSize: 12),
          //       )
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}

//Custom AppBar

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      // systemOverlayStyle: const SystemUiOverlayStyle(
      //     systemNavigationBarColor: Colors.transparent,
      //     statusBarColor: Colors.transparent),
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
      title: Image.asset(
        "assets/appLogo.png",
        height: 60,
        width: 150,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
