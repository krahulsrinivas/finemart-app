import 'package:finemart/screens/itembox.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List results;
  var test;
  bool loader = false;
  final query = TextEditingController();
  clearInput() {
    query.clear();
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  Future load() async {
    var result = await get(
      'https://fine-mart.herokuapp.com/',
    );
    setState(() {
      test = result.body;
    });
    print('hi');
    return result.body;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
        body: (test == null)
            ? Center(
                child: SpinKitChasingDots(
                  color: Colors.teal,
                  size: 50.0,
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: query,
                    maxLines: 1,
                    keyboardType: TextInputType.text,
                    autofocus: true,
                    decoration: InputDecoration(
                        hintText: 'Search',
                        hintStyle: TextStyle(fontSize: 20.sp),
                        prefixIcon: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Colors.grey,
                          iconSize: 25.sp,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: clearInput,
                          color: Colors.grey,
                          iconSize: 25.sp,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        fillColor: Colors.white),
                    onChanged: (value) async {
                      if (value == '') {
                        setState(() {
                          results = [];
                        });
                      } else {
                        setState(() {
                          loader = true;
                        });
                        var result = await get(
                          'https://fine-mart.herokuapp.com/search?search=$value',
                        );
                        List res = jsonDecode(result.body);
                        setState(() {
                          results = res;
                          loader = false;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  (loader)
                      ? Center(
                          child: Theme(
                          data: Theme.of(context)
                              .copyWith(accentColor: Colors.grey),
                          child: Container(
                            margin:EdgeInsets.all(100.sp),
                            child: CircularProgressIndicator()),
                        ))
                      : Expanded(
                          child: ListView.builder(
                              itemBuilder: (context, index) {
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Container(
                                          padding: EdgeInsets.all(5.sp),
                                          child: Text(results[index]['name'],
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => ItemBox(
                                                    id: results[index]['id'])));
                                      },
                                      leading: Icon(Icons.fastfood),
                                    ),
                                    Divider(
                                      thickness: 1,
                                    )
                                  ],
                                );
                              },
                              itemCount:
                                  (results != null) ? results.length : 0),
                        )
                ],
              ));
  }
}
