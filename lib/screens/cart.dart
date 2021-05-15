import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finemart/screens/home.dart';
import 'package:finemart/screens/location.dart';
import 'package:finemart/screens/verifyuserinfo.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/util/dataServices.dart';
import 'package:finemart/widgets/drawer/drawer.dart';
import 'package:finemart/widgets/BottomNavBar.dart';
import 'package:finemart/widgets/Items.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:finemart/screens/itembox.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/screens/OrderHistory.dart';
import 'package:finemart/screens/Loader.dart';

class Cart extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int currentindex = 3;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(
            'Fine Mart',
            style: TextStyle(
                fontSize: 25.sp,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.teal,
          actions: <Widget>[
            InkWell(
              onTap: () async {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Loader()));
                Firestore.instance
                    .collection('orders')
                    .where("userId", isEqualTo: uid)
                    .getDocuments()
                    .then((snapshot) {
                  Map orders = {};
                  for (var order in snapshot.documents) {
                    orders[order.documentID] = order.data;
                  }
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => OrderHistory(orders: orders)));
                }).catchError((e) {
                  Navigator.pop(context);
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ));
                });
              },
              child: ButtonBar(children: [
                Text(
                  'Order History',
                  style:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
                Icon(
                  Icons.history,
                  size: 25.sp,
                )
              ]),
            )
          ],
        ),
        body: StreamBuilder(
            stream:
                Firestore.instance.collection('cart').document(uid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.data == null || snapshot.data.data.isEmpty) {
                  return Column(
                    children: <Widget>[
                      SizedBox(height: 150.h),
                      Icon(
                        Icons.shopping_basket,
                        size: 130.sp,
                      ),
                      SizedBox(height: 50.h),
                      Container(
                          child: Text(
                        'Your cart is empty',
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
                                  MaterialPageRoute(
                                      builder: (context) => Home()),
                                  (Route<dynamic> route) => false);
                            },
                            child: Text(
                              'Add items',
                              style: TextStyle(
                                fontSize: 23.sp,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  lcart = snapshot.data;
                  totalPrice = 0;
                  for (var item in lcart.data.values) {
                    if (item['price'] != null) {
                      if (item['offerPrice'] == null) {
                        totalPrice =
                            totalPrice + (item['price'] * item['count']);
                      } else {
                        totalPrice =
                            totalPrice + (item['offerPrice'] * item['count']);
                      }
                    } else {
                      for (var weight in item['weights'].values) {
                        if (weight['offerPrice'] == null) {
                          totalPrice =
                              totalPrice + (weight['price'] * weight['count']);
                        } else {
                          totalPrice = totalPrice +
                              (weight['offerPrice'] * weight['count']);
                        }
                      }
                    }
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            List keys = lcart.data.keys.toList();
                            if (lcart.data[keys[index]]['price'] != null) {
                              if (lcart.data[keys[index]]['count'] == 0) {
                                DataBaseService(uid: uid)
                                    .deleteItem(lcart.data[keys[index]]['id']);
                              }
                            } else {
                              if (lcart
                                  .data[keys[index]]['weights'].isNotEmpty) {
                                for (var weight in lcart
                                    .data[keys[index]]['weights'].keys) {
                                  if (lcart.data[keys[index]]['weights'][weight]
                                          ['count'] ==
                                      0) {
                                    DataBaseService(uid: uid).deleteWeight(
                                        lcart.data[keys[index]]['id'], weight);
                                  }
                                }
                              } else {
                                DataBaseService(uid: uid)
                                    .deleteItem(lcart.data[keys[index]]['id']);
                              }
                            }
                            keys = lcart.data.keys.toList();
                            if (lcart.data[keys[index]]['price'] != null) {
                              return itemCard(lcart.data[keys[index]]);
                            } else {
                              return Column(
                                children:
                                    lcart.data[keys[index]]['weights'].values
                                        .map((weight) {
                                          return itemCard(
                                              lcart.data[keys[index]], weight);
                                        })
                                        .toList()
                                        .cast<Widget>(),
                              );
                            }
                          },
                          itemCount:
                              (lcart.data == null) ? 0 : lcart.data.length,
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        padding: EdgeInsets.all(8.sp),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(15.w, 0, 0, 0),
                                child: Text(
                                  'Total Price:\n Rs $totalPrice',
                                  style: TextStyle(
                                      fontSize: 20.sp,
                                      color: Colors.teal,
                                      fontWeight: FontWeight.bold),
                                )),
                            Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 15.w, 0),
                              child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(3.sp)),
                                  padding: EdgeInsets.fromLTRB(
                                      20.w, 10.h, 20.w, 10.h),
                                  color: Colors.teal,
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Loader()));
                                    Firestore.instance
                                        .collection('users')
                                        .document(uid)
                                        .get()
                                        .then((snapshot) {
                                      Map address = snapshot.data;
                                      Map order = {};
                                      Map items = {};
                                      List keys = lcart.data.keys.toList();
                                      for (String id in keys) {
                                        items[id] = lcart.data[id];
                                      }
                                      order['items'] = items;
                                      order['userId'] = uid;
                                      order['time'] = DateTime.now();
                                      order['status'] = 'placed';
                                      order['totalPrice']=totalPrice;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => Loader()));
                                      Firestore.instance
                                          .collection('users')
                                          .document(uid)
                                          .get()
                                          .then((snapshot) {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VerifyUserInfo(
                                                        order: order.cast<
                                                            String, dynamic>(),
                                                        address: snapshot.data)));
                                      }).catchError((e) {
                                        Navigator.pop(context);
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(e.toString()),
                                          backgroundColor: Colors.red,
                                        ));
                                      });
                                      
                                    }).catchError((e) {
                                      Navigator.pop(context);
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(e.toString()),
                                        backgroundColor: Colors.red,
                                      ));
                                    });
                                  },
                                  child: Text(
                                    'CHECKOUT',
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                      letterSpacing: 1,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      )
                    ],
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        drawer: Container(
          width: 300.w,
          child: Drawer(child: DrawerMenu()),
        ),
        bottomNavigationBar: Container(
          child: BottomBar(
            currentindex: currentindex,
          ),
        ),
      ),
    );
  }

  Widget itemCard(cart, [weightKey]) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ItemBox(id: cart['id'])));
      },
      child: Card(
        child: Row(children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
            child: CachedNetworkImage(
              imageUrl: cart['image'],
              imageBuilder: (context, imageProvider) => Container(
                  width: 130.w,
                  height: 150.h,
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  )),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                      width: 130.w,
                      height: 150.h,
                      child: Center(
                        child: CircularProgressIndicator(
                            value: downloadProgress.progress),
                      )),
              errorWidget: (context, url, error) => Container(
                width: 130.w,
                height: 150.h,
                child: Center(
                  child: Icon(
                    Icons.error,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            SizedBox(height: 10.h),
            Text(
              'Fine Mart\'s',
              style: TextStyle(fontSize: 18.sp, color: Colors.grey),
            ),
            Text('${cart['name']}',
                style: TextStyle(
                  fontSize: 20.sp,
                )),
            SizedBox(height: 5.h),
            (weightKey != null)
                ? Text('${weightKey['weight']} ${weightKey['type']} ',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ))
                : Container(height: 15.sp),
            SizedBox(height: 25.h),
            Container(
              width: 260.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  (weightKey == null)
                      ? Container(
                          child: (cart['offerPrice'] == null)
                              ? Text('Rs ${cart['price'] * cart['count']}',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    decorationThickness: 2.85.sp,
                                  ))
                              : RichText(
                                  text: TextSpan(
                                  text: 'Rs ${cart['price'] * cart['count']}',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2.85.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '\nRs ${cart['offerPrice'] * cart['count']}',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                )))
                      : Container(
                          child: (weightKey['offerPrice'] == null)
                              ? Text(
                                  'Rs ${weightKey['price'] * weightKey['count']}',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    decorationThickness: 2.85.sp,
                                  ))
                              : RichText(
                                  text: TextSpan(
                                  text:
                                      'Rs ${weightKey['price'] * weightKey['count']}',
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                    decorationThickness: 2.85.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          '\nRs ${weightKey['offerPrice'] * weightKey['count']}',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                    )
                                  ],
                                ))),
                  ButtonBar(
                    children: <Widget>[
                      Container(
                          width: 40.w,
                          child: OutlineButton(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2.w),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.sp)),
                            child: Icon(
                              Icons.remove,
                              size: 20.sp,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              setState(() {
                                if (weightKey == null) {
                                  if (cart['count'] > 0) {
                                    DataBaseService(uid: uid).updateCount(
                                        cart['id'], cart['count'] - 1);
                                  }
                                } else {
                                  if (weightKey['count'] > 0) {
                                    String key;
                                    for (var i in cart['weights'].keys) {
                                      if (cart['weights'][i]['weight'] ==
                                          weightKey['weight']) {
                                        key = i.toString();
                                      }
                                    }
                                    DataBaseService(uid: uid).updateWeightCount(
                                        cart['id'],
                                        key,
                                        weightKey['count'] - 1);
                                  }
                                }
                              });
                            },
                          )),
                      Container(
                        padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 0),
                        child: Center(
                            child: (weightKey == null)
                                ? Text('${cart['count']}',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal))
                                : Text('${weightKey['count']}',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.teal))),
                      ),
                      Container(
                          width: 40.w,
                          child: OutlineButton(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2.w),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.sp)),
                            child: Icon(Icons.add,
                                size: 20.sp, color: Colors.teal),
                            onPressed: () {
                              setState(() {
                                if (weightKey == null) {
                                  DataBaseService(uid: uid).updateCount(
                                      cart['id'], cart['count'] + 1);
                                } else {
                                  String key;
                                  for (var i in cart['weights'].keys) {
                                    if (cart['weights'][i]['weight'] ==
                                        weightKey['weight']) {
                                      key = i.toString();
                                    }
                                  }

                                  DataBaseService(uid: uid).updateWeightCount(
                                      cart['id'], key, weightKey['count'] + 1);
                                }
                              });
                            },
                          )),
                    ],
                  )
                ],
              ),
            )
          ]),
        ]),
      ),
    );
  }
}
