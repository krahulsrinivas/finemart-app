import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummary extends StatefulWidget {
  final dynamic res;
  OrderSummary({this.res});
  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    if (widget.res['RESPCODE'] == "01") {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                'Fine Mart',
                style: TextStyle(
                    fontSize: 25.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.teal,
          ),
          body: Column(
            children: <Widget>[
              Container(
                  color: Colors.green,
                  padding: EdgeInsets.all(25.sp),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Transaction Successful ',
                          style: TextStyle(
                              fontSize: 55.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.check_circle_outline,
                            size: 55.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    } else if (widget.res['RESPCODE'] == "400" ||
        widget.res['RESPCODE'] == "402") {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                'Fine Mart',
                style: TextStyle(
                    fontSize: 25.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.teal,
          ),
          body: Column(
            children: <Widget>[
              Container(
                  color: Colors.yellow,
                  padding: EdgeInsets.all(25.sp),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Transaction Pending ',
                          style: TextStyle(
                              fontSize: 55.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.perm_device_information,
                            size: 55.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    } else {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Center(
              child: Text(
                'Fine Mart',
                style: TextStyle(
                    fontSize: 25.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.teal,
          ),
          body: Column(
            children: <Widget>[
              Container(
                  color: Colors.red,
                  padding: EdgeInsets.all(25.sp),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Transaction Failed ',
                          style: TextStyle(
                              fontSize: 55.sp,
                              fontStyle: FontStyle.italic,
                              color: Colors.white),
                        ),
                        WidgetSpan(
                          child: Icon(
                            Icons.cancel,
                            size: 55.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      );
    }
  }
}
