//Custom AppBar

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.notifications_none_outlined,
                  ),
                  color: Color.fromARGB(255, 157, 178, 206),
                  iconSize: 30,
                ),
                Positioned(
                    left: 25,
                    top: 7,
                    child: Container(
                        padding: EdgeInsets.all(2),
                        height: 17,
                        width: 17,
                        decoration: BoxDecoration(
                            color: Colors.blue, shape: BoxShape.circle),
                        child: Text(
                          "3",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500),
                        ))),
              ],
            ),
            SizedBox(
              width: 8,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.7, color: Color.fromARGB(255, 91, 134, 241)),
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 20,
                            color: Colors.black.withOpacity(0.1),
                            offset: Offset(0, 10))
                      ],
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ4rsSzLimlQyniEtUV4-1raljzFhS45QBeAw&usqp=CAU")
                          // getDisplayImage(),
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 20,
            ),
          ],
        )
      ],
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.black26,
          statusBarColor: Colors.black26),
      elevation: 0,
      backgroundColor: Colors.white,
      title: Image.asset(
        "assets/appLogo.png",
        fit: BoxFit.cover,
        height: 42,
        width: 42,
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 60);
}
