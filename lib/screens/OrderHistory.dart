import 'package:finemart/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:finemart/screens/Loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/screens/Cart.dart';

class OrderHistory extends StatefulWidget {
  final Map orders;
  OrderHistory({this.orders});
  @override
  _OrderHistoryState createState() => _OrderHistoryState(orders);
}

class _OrderHistoryState extends State<OrderHistory> {
  Map orders;
  _OrderHistoryState(this.orders);
  final ScrollController controller = ScrollController();
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
      body: (orders.length != 0)
          ? Column(
              children: <Widget>[
                SizedBox(height: 20.h),
                Center(
                    child: Text('Your Orders',
                        style: TextStyle(
                            fontSize: 35.sp,
                            letterSpacing: 2.sp,
                            fontStyle: FontStyle.italic))),
                SizedBox(height: 10.h),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      List keys = orders.keys.toList();
                      var date = DateTime.fromMillisecondsSinceEpoch(
                          orders[keys[index]]['time'].seconds * 1000);
                      var formattedDate = DateFormat.yMMMd().format(date);
                      return Container(
                        padding: EdgeInsets.fromLTRB(25.w, 8.h, 25.w, 8.h),
                        child: InkWell(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Scrollbar(
                                      isAlwaysShown: true,
                                      controller: controller,
                                      child: ListView(
                                        controller: controller,
                                        children: <Widget>[
                                          Center(
                                            child: Container(
                                              padding: EdgeInsets.all(5.sp),
                                              child: Text(
                                                'OrderId:#00${keys[index]}',
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: orders[keys[index]]
                                                    ['items']
                                                .values
                                                .map((item) {
                                                  if (item
                                                      .containsKey('price')) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.all(15.sp),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: <Widget>[
                                                            Container(
                                                              width: 100.w,
                                                              child: Text(
                                                                item['name'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 50.w,
                                                              child: Text(
                                                                '${item['count']} X',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                            Container(
                                                                width: 100.w),
                                                            Container(
                                                              width: 100.w,
                                                              child: Text(
                                                                'Rs ${item['price'] * item['count']}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                    color: Colors
                                                                            .grey[
                                                                        700],
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ),
                                                          ]),
                                                    );
                                                  } else {
                                                    return Column(
                                                        children:
                                                            item['weights']
                                                                .values
                                                                .map((weight) {
                                                                  return Container(
                                                                    padding: EdgeInsets
                                                                        .all(15
                                                                            .sp),
                                                                    child: Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceEvenly,
                                                                        children: <
                                                                            Widget>[
                                                                          Container(
                                                                            width:
                                                                                100.w,
                                                                            child:
                                                                                Text(
                                                                              item['name'],
                                                                              style: TextStyle(fontSize: 20.sp, color: Colors.grey[700], fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                50.w,
                                                                            child:
                                                                                Text(
                                                                              '${weight['count']} X',
                                                                              style: TextStyle(fontSize: 20.sp, color: Colors.grey[700], fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                100.w,
                                                                            child:
                                                                                Text(
                                                                              '${weight['weight']} ${weight['type']}',
                                                                              style: TextStyle(fontSize: 20.sp, color: Colors.grey[700], fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            width:
                                                                                100.w,
                                                                            child:
                                                                                Text(
                                                                              'Rs ${weight['price'] * weight['count']}',
                                                                              style: TextStyle(fontSize: 20.sp, color: Colors.grey[700], fontWeight: FontWeight.bold),
                                                                            ),
                                                                          ),
                                                                        ]),
                                                                  );
                                                                })
                                                                .toList()
                                                                .cast<
                                                                    Widget>());
                                                  }
                                                })
                                                .toList()
                                                .cast<Widget>(),
                                          ),
                                          SizedBox(height: 10.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              OutlineButton.icon(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.red,
                                                ),
                                                label: Text(
                                                  'Back',
                                                  style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                                textColor: Colors.red,
                                                borderSide: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              OutlineButton(
                                                onPressed: () async {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              Loader()));
                                                  Firestore.instance
                                                      .collection('cart')
                                                      .document(uid)
                                                      .setData(
                                                          orders[keys[index]]
                                                              ['items'],
                                                          merge: true)
                                                      .then((value) {
                                                    return Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        Cart()),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false);
                                                  });
                                                },
                                                child: Text(
                                                  'Add to cart',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      color: Colors.teal),
                                                ),
                                                borderSide: BorderSide(
                                                    color: Colors.teal),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5)),
                                              )
                                            ],
                                          ),
                                          SizedBox(height:20.h)
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                          child: Card(
                              elevation: 3.sp,
                              color: Colors.grey[200],
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Text(
                                        'Date:$formattedDate',
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Text(
                                        'OrderId:#00${keys[index]}',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Text(
                                        'Price: Rs 500',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(5.sp),
                                      child: Text(
                                        'Order Status: ${orders[keys[index]]['status']}',
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                        ),
                                      ),
                                    ),
                                  ])),
                        ),
                      );
                    },
                    itemCount: orders.length,
                  ),
                ),
              ],
            )
          : Column(
              children: <Widget>[
                SizedBox(height: 120.h),
                Container(
                    child: Text(
                  'Oops!!',
                  style: TextStyle(
                    fontSize: 35.sp,
                  ),
                )),
                SizedBox(height: 5.h),
                Container(
                    child: Text(
                  'You Have No Orders',
                  style: TextStyle(
                    fontSize: 30.sp,
                  ),
                )),
                SizedBox(height: 40.h),
                Center(
                  child: Container(
                    child: FlatButton(
                      padding: EdgeInsets.fromLTRB(25.w, 8.h, 25.w, 8.h),
                      color: Colors.teal,
                      onPressed: () {
                        return Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => Home()),
                            (Route<dynamic> route) => false);
                      },
                      child: Text(
                        'Add items',
                        style: TextStyle(
                          fontSize: 23.sp,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
