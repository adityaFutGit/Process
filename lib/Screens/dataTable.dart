// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'package:process/Widgets/customColors.dart';
import 'package:process/Widgets/customWidgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: ((OverscrollIndicatorNotification? notification) {
            notification!.disallowIndicator();
            return true;
          }),
          child: _getBodyWidget()),
    );
  }

  Widget _getBodyWidget() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: HorizontalDataTable(
        leftHandSideColumnWidth: 115,
        rightHandSideColumnWidth: 600,
        isFixedHeader: true,
        headerWidgets: _getTitleWidget(),
        leftSideItemBuilder: _generateFirstColumnRow,
        rightSideItemBuilder: _generateRightHandSideColumnRow,
        itemCount: 6,
        rowSeparatorWidget: const Divider(
          color: Colors.black38,
          height: 0.0,
          thickness: 0.0,
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('This Week', 100),
      _getTitleItemWidget('Updates', 100),
      _getTitleItemWidget('Owner', 100),
      _getTitleItemWidget('Status', 100),
      _getTitleItemWidget('Date', 100),
      _getTitleItemWidget('Priority', 100),
      _getTitleItemWidget('Time Est.', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.w400)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    final Color background = Color.fromARGB(255, 11, 107, 185);
    final Color fill = Colors.white;
    final List<Color> gradient = [
      background,
      background,
      fill,
      fill,
    ];
    final double fillPercent = 94;
    final double fillStop = (100 - fillPercent) / 100;
    final List<double> stops = [0.0, fillStop, fillStop, 1.0];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: gradient,
          stops: stops,
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
      ),
      child: Text('Task ${index + 1}'),
      width: 100,
      height: 52,
      padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
        VerticalDivider(color: Colors.red, thickness: 2, width: 2),
        Container(
          child: Row(
            children: <Widget>[
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.add_circle_outline_sharp,
                    size: 35,
                    color: Color.fromARGB(255, 201, 201, 201),
                  ))
            ],
          ),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.person_pin,
                size: 35,
                color: Color.fromARGB(255, 201, 201, 201),
              )),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('Waiting for review'),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('Aug ${index + 1}'),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('High'),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text('2h'),
          // width: 200,
          // height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}

class DataTableScreen extends StatefulWidget {
  const DataTableScreen({super.key});

  @override
  State<DataTableScreen> createState() => _DataTableScreenState();
}

class _DataTableScreenState extends State<DataTableScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 239, 248),
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              padding: EdgeInsets.zero,
              onPressed: () {},
              icon: Icon(
                Icons.more_vert_outlined,
                color: Colors.black,
              ),
            ),
          ],
          backgroundColor: Colors.white,
          title: Text(
            "Deals",
            style: TextStyle(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          elevation: 0),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((OverscrollIndicatorNotification? notification) {
          notification!.disallowIndicator();
          return true;
        }),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 270,
                      height: 35,
                      child: CupertinoSearchTextField(
                        placeholder: "Search deal...",
                        placeholderStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 174, 181, 197)),
                        backgroundColor: Color.fromARGB(255, 245, 247, 251),
                        controller: controller,
                        onChanged: (value) {},
                        onSubmitted: (value) {},
                        autocorrect: true,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: Color.fromARGB(255, 245, 247, 251),
                            minimumSize: Size(72, 35)),
                        onPressed: () {},
                        icon: Icon(
                          Icons.filter_list_rounded,
                          color: Colors.black,
                          size: 20,
                        ),
                        label: Text(
                          "Filter",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 600,
                  width: MediaQuery.of(context).size.width - 25,
                  child: DataTable2(
                      showBottomBorder: true,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                              left: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Color.fromARGB(255, 13, 155, 203),
                                  width: 5))),
                      columnSpacing: 20,
                      horizontalMargin: 10,
                      minWidth: 900,
                      fixedLeftColumns: 1,
                      border: TableBorder(
                        verticalInside: BorderSide(color: Colors.black12),
                      ),
                      columns: [
                        DataColumn(
                          label: Text('Active Deals',
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 23, 176, 228),
                                  fontSize: 14)),
                        ),
                        DataColumn2(
                          fixedWidth: 102,
                          label: Text('Stage'),
                        ),
                        DataColumn2(
                          fixedWidth: 102,
                          label: Text('Contacts'),
                        ),
                        DataColumn(
                          label: Text('Priority'),
                        ),
                        DataColumn(
                          label: Text('Date'),
                        ),
                        DataColumn(
                          label: Text('Priority'),
                        ),
                        DataColumn(
                          label: Text('Time Est.'),
                        ),
                      ],
                      rows: List<DataRow>.generate(
                          15,
                          (index) => DataRow(cells: [
                                DataCell(ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      fixedSize: Size(116, 41),
                                      backgroundColor: Colors.white),
                                  onPressed: () {},
                                  child: Text(
                                    "Task ${index + 1}",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )),
                                DataCell(ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Negotiation",
                                    style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(115, 41),
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.purple),
                                )),
                                DataCell(TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    "Ramdev",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400),
                                  ),
                                )),
                                DataCell(ElevatedButton(
                                  onPressed: () {},
                                  child: Text(
                                    "High",
                                    style: TextStyle(
                                        fontSize: 12,
                                        letterSpacing: .5,
                                        fontWeight: FontWeight.w300),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      fixedSize: Size(102, 41),
                                      padding: EdgeInsets.zero,
                                      backgroundColor: Colors.orange),
                                )),
                                DataCell(Text("Aug 1")),
                                DataCell(Text('High')),
                                DataCell(Text('2h')),
                              ]))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
