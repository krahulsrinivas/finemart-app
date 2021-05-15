import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return SafeArea(child: Scaffold(body: Center(child:SpinKitCircle(
          color: Colors.teal,
          size: 75.sp,
        ),)));
  }
}
