import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:http/http.dart';
import 'package:finemart/util/dataServices.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/screens/Loader.dart';
import 'package:finemart/screens/Cart.dart';
import 'package:finemart/screens/OrderSummary.dart';


class Checkout extends StatefulWidget {
  final Map order;
  Checkout({this.order});
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  static const platform = const MethodChannel("samples.flutter.dev/payment");
  dynamic errMsg;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    print(errMsg);
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 30.sp,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => Cart()));
            }),
        title: Text(
          'Fine Mart',
          style: TextStyle(
              fontSize: 25.sp,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: Colors.teal[400],
              padding: EdgeInsets.all(25.sp),
              child: Text(
                'Choose A Payment Option Below',
                style: TextStyle(
                    fontSize: 45.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                'List of Items',
                style: TextStyle(
                    fontSize: 25.sp,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(
              thickness: 2,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: widget.order['items'].values
                    .map((item) {
                      if (item.containsKey('price')) {
                        return Container(
                          padding: EdgeInsets.all(15.sp),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  width: 100.w,
                                  child: Text(
                                    item['name'],
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width: 50.w,
                                  child: Text(
                                    '${item['count']} X',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(width: 100.w),
                                Container(
                                  width: 100.w,
                                  child: Text(
                                    'Rs ${item['price'] * item['count']}',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                        );
                      } else {
                        return Column(
                            children: item['weights']
                                .values
                                .map((weight) {
                                  return Container(
                                    padding: EdgeInsets.all(15.sp),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            width: 100.w,
                                            child: Text(
                                              item['name'],
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 50.w,
                                            child: Text(
                                              '${weight['count']} X',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 100.w,
                                            child: Text(
                                              '${weight['weight']} ${weight['type']}',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Container(
                                            width: 100.w,
                                            child: Text(
                                              'Rs ${weight['price'] * weight['count']}',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.grey[700],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ]),
                                  );
                                })
                                .toList()
                                .cast<Widget>());
                      }
                    })
                    .toList()
                    .cast<Widget>(),
              ),
            ),
            Divider(
              thickness: 3,
            ),
            SizedBox(height: 10.h),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/cashondelivery.jpg'),
                radius: 35.sp,
              ),
              onTap: cashOnDelivery,
              title: Text(
                'Cash On Delivery',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ),
            Divider(
              color: Colors.black,
            ),
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('images/paytm.jpg'),
                radius: 35.sp,
              ),
              onTap: paytm,
              title: Text(
                'Pay With Paytm',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black,
              ),
            ),
            Divider(
              color: Colors.black,
            ),
          ],
        )),
      ),
    ));
  }

  Future paytm() async {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Loader()));
    var id = "";
    var rnd = new Random();
    for (var i = 0; i < 6; i++) {
      id = id + rnd.nextInt(9).toString();
    }
    String value = '500';
    final HttpsCallable function = CloudFunctions.instance.getHttpsCallable(
      functionName: 'paytm',
    );
    dynamic response = await function.call(<String, dynamic>{
      'id': id,
      'value': value,
    }).then((value) async {
      return await post(
          'https://${value.data['hostname']}${value.data['path']}',
          headers: {'Content-Type': value.data['headers']['Content-Type']},
          body: value.data['body']);
    }).catchError((e) {
      setState(() {
        errMsg = "Network Error";
      });
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(errMsg),
        backgroundColor: Colors.red,
      ));
    });
    response = jsonDecode(response.body);
    dynamic info = jsonEncode({
      "orderId": id,
      "mid": "OfmBae55853358671790",
      "token": response["body"]["txnToken"],
      "amount": value,
      "callback":
          "https://securegw-stage.paytm.in/theia/paytmCallback?ORDER_ID=$id"
    });
    await platform.invokeMethod("getPaytm", info).then((value) {
      dynamic res = jsonDecode(value);
      print(res);
      Navigator.pop(context);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (BuildContext context) => OrderSummary(res: res)),
          (Route<dynamic> route) => false);
    }).catchError((e) {
      setState(() {
        errMsg = e.toString();
      });
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(errMsg),
        backgroundColor: Colors.red,
      ));
    });
    setState(() {
      errMsg = null;
    });
  }

  void cashOnDelivery() {
    DataBaseService(uid: uid).ordersList(widget.order.cast<String, dynamic>());
  }
}
