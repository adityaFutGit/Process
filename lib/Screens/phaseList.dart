// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:process/Screens/dataTable.dart';

import 'package:process/Widgets/customWidgets.dart';

class PhaseListScreen extends StatefulWidget {
  const PhaseListScreen({super.key});

  @override
  State<PhaseListScreen> createState() => _PhaseListScreenState();
}

class _PhaseListScreenState extends State<PhaseListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 236, 239, 248),
        appBar: CustomAppBar(),
        body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: ((OverscrollIndicatorNotification? notification) {
            notification!.disallowIndicator();
            return true;
          }),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Column(
                    children: [
                      BreadCrumb(divider: Icon(Icons.chevron_right), items: [
                        BreadCrumbItem(
                            content: TextButton(
                          style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              alignment: Alignment.centerLeft),
                          child: Text("Home Page"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )),
                        BreadCrumbItem(content: Text('CRM')),
                      ]),
                      SizedBox(
                        height: 12,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DataTableScreen()));
                        },
                        child: Container(
                          height: 87,
                          width: 375,
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 2, left: 3, right: 3),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.asset("assets/appIcon2.png"),
                              SizedBox(
                                width: 15,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    width: 220,
                                    child: Text(
                                      "Leads",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    "Changed 8d ago",
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ));
  }
}
