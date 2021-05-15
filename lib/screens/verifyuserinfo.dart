import 'package:finemart/screens/Checkout.dart';
import 'package:finemart/screens/googlemaps.dart';
import 'package:finemart/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/util/dataServices.dart';
import 'package:finemart/screens/Loader.dart';


class VerifyUserInfo extends StatefulWidget {
  final Map order;
  final Map address;
  VerifyUserInfo({this.order, this.address});
  @override
  _VerifyUserInfoState createState() => _VerifyUserInfoState(address);
}

class _VerifyUserInfoState extends State<VerifyUserInfo> {
  Map address;
  _VerifyUserInfoState(this.address);
  final formkey = new GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key:_scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Fine Mart',
          style: TextStyle(
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
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
                     Icons.where_to_vote_sharp,
                        size: 30.sp,
                        color: Colors.black,
                      ),
                      title: Text(
                              '${address['mapAddress']}',
                              maxLines: 1,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                      trailing: Icon(
                              Icons.radio_button_checked,
                              color: Colors.blue,
                            ),
                      onTap: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) =>
                                    Maps(coords:address['coords'])))
                            .then((result) {
                          if (result != null) {
                            setState(() {
                              address['coords'] = result['loc'];
                              address['mapAddress'] = result['address'];
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
                  'Please Verify User Info',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.sp,
                  ),
                ))),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    initialValue: address['full_name'],
                    decoration: InputDecoration(
                      hintText: 'Full Name',
                      fillColor: Colors.grey[150],
                      filled: true,
                      contentPadding: EdgeInsets.all(12.0.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal, width: 2.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) =>
                        (val.trim() == '') ? 'Please  enter a name' : null,
                    onChanged: (val) {
                      setState(() => address['full_name'] = val.trim());
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    initialValue: address['phone_number'],
                    decoration: InputDecoration(
                      hintText: '10 digit phone no',
                      fillColor: Colors.grey[150],
                      filled: true,
                      contentPadding: EdgeInsets.all(12.0.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal, width: 2.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (val) =>
                        val.length != 10 ? 'Enter a 10 digit phone no' : null,
                    onChanged: (val) {
                      setState(() => address['phone_number'] = val);
                    },
                  ),
                ),
                Divider(
                  height: 50.h,
                  thickness: 2,
                  color: Colors.black,
                ),
                Container(
                    child: Center(
                        child: Text(
                  'Please Verify User Address',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.sp,
                  ),
                ))),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    initialValue: address['address'],
                    decoration: InputDecoration(
                      hintText: 'Street/House address',
                      fillColor: Colors.grey[150],
                      filled: true,
                      contentPadding: EdgeInsets.all(12.0.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.teal, width: 2.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) =>
                        (val.trim() == '') ? 'Please enter an address' : null,
                    onChanged: (val) {
                      setState(() => address['address'] = val.trim());
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                Container(
                  padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    initialValue: address['outerAddress'],
                    decoration: InputDecoration(
                      fillColor: Colors.grey[150],
                      filled: true,
                      contentPadding: EdgeInsets.all(12.0.sp),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 2.0.w),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      address['outerAddress']=val;
                      return (val.trim() == '') ? 'Please enter an address' : null;
                    },
                    onChanged: (val) {
                      setState(() => address['outerAddress'] = val.trim());
                    },
                  ),
                ),
                SizedBox(
                  height: 75.h,
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(90.w, 0, 90.w, 0),
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 10.h),
                      onPressed: () async {
                        if (formkey.currentState.validate()) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Loader()));
                          DataBaseService(uid: uid)
                              .usersList(
                                  address['full_name'],
                                  address['phone_number'],
                                  address['address'],
                                  address['outerAddress'],
                                  address['token'],
                                  address['coords'],
                                  address['mapAddress']
                                  )
                              .whenComplete(() {
                            if (widget.order == null) {
                               Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (Route<dynamic> route) => false);
                            } else {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Checkout(
                                          order: widget.order
                                              .cast<String, dynamic>())),
                                  (Route<dynamic> route) => false);
                            }
                          }).catchError((e) {
                            Navigator.pop(context);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text(e.toString()),
                              backgroundColor: Colors.red,
                            ));
                          });
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Confirm Address',
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
