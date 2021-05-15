import 'package:finemart/screens/Loader.dart';
import 'package:finemart/screens/verifyuserinfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/util/auth/userId.dart';

class Account extends StatefulWidget {
  final dynamic info;
  Account({this.info});
  @override
  _AccountState createState() => _AccountState(info);
}

class _AccountState extends State<Account> {
  dynamic info;
  _AccountState(this.info);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fine Mart',
          style: TextStyle(
              fontSize: 25.sp,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(height: 20.h),
        Center(
            child: Text('Your Account',
                style: TextStyle(
                    fontSize: 35.sp,
                    letterSpacing: 2.sp,
                    fontStyle: FontStyle.italic))),
        SizedBox(height: 10.h),
        Container(
          margin: EdgeInsets.all(10.sp),
          child: Card(
              elevation: 3.sp,
              color: Colors.grey[100],
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 5.h),
                    (imageUrl != '')
                        ? Center(
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 50.h,
                            ),
                          )
                        : Icon(
                            Icons.account_circle,
                            color: Colors.white,
                            size: 100.h,
                          ),
                    SizedBox(height: 5.h),
                    Center(
                      child: Text(info['fullName'],
                          style: TextStyle(
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              fontStyle: FontStyle.italic)),
                    ),
                    SizedBox(height: 5.h),
                    Center(
                      child: Text(info['phoneNumber'],
                          style: TextStyle(
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              fontStyle: FontStyle.italic)),
                    ),
                    SizedBox(height: 5.h),
                  ])),
        ),
        SizedBox(height: 30.h),
        Center(
            child: Text('Your Info',
                style: TextStyle(
                    fontSize: 35.sp,
                    letterSpacing: 2.sp,
                    fontStyle: FontStyle.italic))),
        SizedBox(height: 10.h),
        Container(
          margin: EdgeInsets.all(10.sp),
          child: Card(
              elevation: 3.sp,
              color: Colors.grey[100],
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Text(info['fullName'],
                          style: TextStyle(
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              fontStyle: FontStyle.italic)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Text(info['phoneNumber'],
                          style: TextStyle(
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              fontStyle: FontStyle.italic)),
                    ),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Text('Address',
                          style: TextStyle(
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic)),
                    ),
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Text(info['address'],
                          style: TextStyle(
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              fontStyle: FontStyle.italic)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Text(info['outerAddress'],
                          style: TextStyle(
                              fontSize: 20.sp,
                              letterSpacing: 1.sp,
                              fontStyle: FontStyle.italic)),
                    ),
                  ])),
        ),
        SizedBox(height: 30.h),
        Center(
          child: FlatButton(
              padding: EdgeInsets.all(10.sp),
              color: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Loader()));
                return Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) =>
                        VerifyUserInfo(order: null, address: info)));
              },
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5.sp),
                      child: Text('Edit Address',
                          style: TextStyle(
                            fontSize: 15.sp,
                            letterSpacing: 1.sp,
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(width: 10.w),
                    Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 25.sp,
                    )
                  ])),
        )
      ]),
    );
  }
}
