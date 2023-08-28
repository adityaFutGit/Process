// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:process/DataModel.dart';
import 'package:http/http.dart' as http;
import 'package:process/Screens/phaseList.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController controller = TextEditingController();
  bool hideMyProcess = false;
  final PagingController<int, DataModel> pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener((pageKey) {
      fetchData(pageKey);
    });
  }

  void fetchData(int pageKey) async {
    try {
      var response = await http.get(Uri.parse(
          "https://api.punkapi.com/v2/beers?page=$pageKey&per_page=10"));
      var data = dataModelFromJson(response.body);
      pagingController.appendPage(data, pageKey + 1);
    } catch (error) {
      pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 239, 248),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: ((OverscrollIndicatorNotification? notification) {
          notification!.disallowIndicator();
          return true;
        }),
        child: SingleChildScrollView(
          child: CupertinoPageScaffold(
            backgroundColor: Color.fromARGB(255, 236, 239, 248),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Column(
                      children: [
                        CupertinoSearchTextField(
                          placeholder: "Search process...",
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
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Text(
                              "Welcome, USER",
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 64, 53, 114)),
                            ),
                            SizedBox(
                              width: 13,
                            ),
                            Image.asset(
                              "assets/smile.png",
                              width: 18,
                              height: 19,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "My Processes",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 64, 53, 114),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (hideMyProcess == false) {
                                    hideMyProcess = true;
                                  } else if (hideMyProcess == true) {
                                    hideMyProcess = false;
                                  }
                                });
                              },
                              icon: hideMyProcess == false
                                  ? Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 20,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: !hideMyProcess,
                    child: Container(
                        height: MediaQuery.of(context).size.height - 300,
                        child: PagedListView<int, DataModel>(
                          pagingController: pagingController,
                          builderDelegate: PagedChildBuilderDelegate<DataModel>(
                            newPageErrorIndicatorBuilder: (context) {
                              return Container(
                                padding: EdgeInsets.all(16),
                                child: Center(
                                    child: Text("No More Data is Available")),
                              );
                            },
                            itemBuilder: (context, model, index) =>
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: 1,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PhaseListScreen()));
                                        },
                                        child: Container(
                                          height: 87,
                                          width: 375,
                                          color: Colors.white,
                                          margin: EdgeInsets.only(
                                              bottom: 1.5, left: 3, right: 3),
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [
                                              Image.asset(
                                                  "assets/fileIcon.png"),
                                              SizedBox(
                                                width: 15,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Container(
                                                    width: 220,
                                                    child: Text(
                                                      model.name,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 200,
                                                    child: Text(
                                                      "Main WorkSpace",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                  Text(
                                                    "Changed 8d ago",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                          ),
                        )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
