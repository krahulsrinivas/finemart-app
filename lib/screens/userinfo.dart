import 'package:finemart/screens/googlemaps.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/util/dataServices.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/screens/Loader.dart';
import 'package:finemart/screens/Home.dart';

class UserInfo extends StatefulWidget {
  final dynamic first;
  final dynamic coords;
  UserInfo({this.first, this.coords});
  @override
  _UserInfoState createState() => _UserInfoState(first);
}

class _UserInfoState extends State<UserInfo> {
  final FirebaseMessaging messaging = FirebaseMessaging();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  var first;
  _UserInfoState(this.first);
  final formkey = new GlobalKey<FormState>();
  String name;
  String phno;
  String address;
  String token;
  String outerAddress;
  List loc;
  String map;

  @override
  void initState() {
    super.initState();
    messaging.getToken().then((value) => {token = value});
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
          child: Text(
            'Fine Mart',
            style: TextStyle(
                fontSize: 25.sp,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Container(
          child: SingleChildScrollView(
        child: Form(
            key: formkey,
            child: Column(
              children: <Widget>[
                Divider(thickness: 1.w, color: Colors.black),
                Container(
                    padding: EdgeInsets.all(0.sp),
                    child: ListTile(
                      leading: Icon(
                        (map == null)
                            ? Icons.add_location
                            : Icons.where_to_vote_sharp,
                        size: 30.sp,
                        color: Colors.black,
                      ),
                      title: (map == null)
                          ? Text(
                              'Select Your Location',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              '$map',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                      trailing: (map == null)
                          ? Icon(Icons.radio_button_unchecked)
                          : Icon(
                              Icons.radio_button_checked,
                              color: Colors.blue,
                            ),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) => Maps(
                                    coords:
                                        (loc == null) ? widget.coords : loc)))
                            .then((result) {
                          if (result != null) {
                            setState(() {
                              loc = result['loc'];
                              map = result['address'];
                            });
                          }
                        });
                      },
                    )),
                Divider(thickness: 1.w, color: Colors.black),
                SizedBox(height: 20.sp),
                Container(
                    child: Center(
                        child: Text(
                  'Please enter user details',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp,
                  ),
                ))),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      fillColor: Colors.grey[200],
                      filled: true,
                      contentPadding: EdgeInsets.all(12.0.sp),
                      errorStyle: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal, width: 3.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) =>
                        (val.trim() == '') ? 'Please enter a name' : null,
                    onChanged: (val) {
                      setState(() => name = val.trim());
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    decoration: InputDecoration(
                      hintText: '10 digit phone no',
                      fillColor: Colors.grey[200],
                      filled: true,
                      errorStyle: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                      contentPadding: EdgeInsets.all(12.0.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal, width: 3.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) => val.length != 10
                        ? 'Please enter a 10 digit phone no'
                        : null,
                    onChanged: (val) {
                      setState(() => phno = val);
                    },
                  ),
                ),
                Divider(
                  height: 75.h,
                  thickness: 3.h,
                  color: Colors.black,
                ),
                Container(
                    child: Center(
                        child: Text(
                  'Please enter user Address',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 25.sp,
                  ),
                ))),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    decoration: InputDecoration(
                      hintText: 'Street/House address',
                      fillColor: Colors.grey[150],
                      filled: true,
                      contentPadding: EdgeInsets.all(12.0.sp),
                      errorStyle: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal, width: 3.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) =>
                        (val.trim() == '') ? 'Please enter an address' : null,
                    onChanged: (val) {
                      setState(() => address = val.trim());
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    initialValue:
                        '${first.subLocality}, ${first.locality}, ${first.adminArea}, ${first.postalCode}',
                    decoration: InputDecoration(
                      fillColor: Colors.grey[200],
                      filled: true,
                      contentPadding: EdgeInsets.all(12.0.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal, width: 3.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      outerAddress = val;
                      return (val.trim() == '')
                          ? 'Please enter an address'
                          : null;
                    },
                    onChanged: (val) {
                      setState(() => outerAddress = val.trim());
                    },
                  ),
                ),
                SizedBox(
                  height: 125.h,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(140.w, 0, 140.w, 0),
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                      onPressed: () async {
                        if (formkey.currentState.validate()) {
                          if (map != null) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Loader()));
                            final prefs = await SharedPreferences.getInstance();
                            await getuserId();
                            DataBaseService(uid: uid)
                                .usersList(name, phno, address, outerAddress,
                                    token, loc, map)
                                .whenComplete(() {
                              prefs.setBool('locationCheck', true);
                              return Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (Route<dynamic> route) => false);
                            });
                          } else {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Please select a Location",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold)),
                              backgroundColor: Colors.red,
                            ));
                          }
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Submit',
                            style: TextStyle(
                                letterSpacing: 1.sp,
                                fontSize: 20.sp,
                                color: Colors.white),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      color: Colors.teal,
                      splashColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.sp)),
                    )),
              ],
            )),
      )),
    );
  }
}
