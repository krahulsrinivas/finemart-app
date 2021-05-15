import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/util/dataServices.dart';
import 'package:finemart/widgets/Items.dart';
import 'package:flutter/material.dart';
import 'package:finemart/widgets/BottomNavBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemBox extends StatefulWidget {
  final String id;
  ItemBox({this.id});
  @override
  _ItemBoxState createState() => _ItemBoxState(id);
}

class _ItemBoxState extends State<ItemBox> {
  String id;
  int count = 0;
  _ItemBoxState(this.id);
  Map currentWeight = {};
  String recentWeight;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.all(10.sp),
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
      body: Container(
        child: Center(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('cart')
                    .document(uid)
                    .snapshots(),
                builder: (BuildContext context, snapshot2) {
                  if (snapshot2.hasData) {
                    lcart = snapshot2.data;
                  }
                  return StreamBuilder(
                      stream: Firestore.instance
                          .collection('items')
                          .where('id', isEqualTo: id)
                          .snapshots(),
                      builder: (BuildContext context, snapshot1) {
                        if (!snapshot1.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          var document = snapshot1.data.documents[0];
                          if (lcart.exists) {
                            if (lcart.data.isNotEmpty) {
                              for (var item in lcart.data.values) {
                                if (item['id'] == document['id']) {
                                  if (item.containsKey('price')) {
                                    count = item['count'];
                                  } else {
                                    recentWeight = item['recentWeight'];
                                    if (currentWeight.isEmpty) {
                                      for (var weight in item['weights'].keys) {
                                        if (item['weights'][weight]['count'] !=
                                            0) {
                                          if (recentWeight != null) {
                                            if (recentWeight == weight) {
                                              currentWeight =
                                                  item['weights'][weight];
                                              count = item['weights'][weight]
                                                  ['count'];
                                            }
                                          } else {
                                            currentWeight =
                                                item['weights'][weight];
                                            count = item['weights'][weight]
                                                ['count'];
                                          }
                                        } else {
                                          count = 0;
                                        }
                                      }
                                    } else if (currentWeight.isNotEmpty) {
                                      for (var weight
                                          in item['weights'].values) {
                                        if (currentWeight['weight'] ==
                                            weight['weight']) {
                                          currentWeight = weight;
                                          count = weight['count'];
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                          if (!document.data.containsKey('price')) {
                            (currentWeight.isEmpty)
                                ? currentWeight =
                                    document['weights']['weight_1']
                                : currentWeight = currentWeight;
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(
                                child: ListView(children: <Widget>[
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                                      child: Text(
                                        'Fine Mart\'s',
                                        style: TextStyle(
                                            fontSize: 25.h, color: Colors.grey),
                                      )),
                                  Container(
                                      padding:
                                          EdgeInsets.fromLTRB(20.w, 0, 0, 0),
                                      child: (document.data
                                              .containsKey('price'))
                                          ? Text(document['name'],
                                              style: TextStyle(
                                                letterSpacing:1.sp,
                                                fontSize: 35.h,
                                              ))
                                          : Text(
                                              document['name'] +
                                                  ', ${currentWeight['weight']} ${currentWeight['type']}',
                                              style: TextStyle(
                                                letterSpacing:1.sp,
                                                fontSize: 35.h,
                                              ))),
                                  SizedBox(height: 5.h),
                                  (document.data.containsKey('price'))
                                      ? Container(
                                          padding: EdgeInsets.fromLTRB(
                                              20.w, 0, 0, 0),
                                          child: (document['offerPrice'] ==
                                                  null)
                                              ? Text('Rs ${document['price']}',
                                                  style: TextStyle(
                                                    fontSize: 30.h,
                                                    letterSpacing:1.sp,
                                                    fontWeight: FontWeight.bold,
                                                    decorationThickness:
                                                        2.85.sp,
                                                  ))
                                              : RichText(
                                                  text: TextSpan(
                                                  text:
                                                      'Rs ${document['price']}',
                                                  style: TextStyle(
                                                    letterSpacing:1.sp,
                                                    fontSize: 30.h,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationThickness:
                                                        2.85.sp,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '\nOffer Price: Rs ${document['offerPrice']}',
                                                      style: TextStyle(
                                                        letterSpacing: 1.sp,
                                                        fontSize: 30.h,
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                )))
                                      : Container(
                                          padding: EdgeInsets.fromLTRB(
                                              20.w, 0, 0, 0),
                                          child: (currentWeight['offerPrice'] ==
                                                  null)
                                              ? Text(
                                                  'Rs ${currentWeight['price']}',
                                                  style: TextStyle(
                                                    letterSpacing:1.sp,
                                                    fontSize: 30.h,
                                                    fontWeight: FontWeight.bold,
                                                    decorationThickness:
                                                        2.85.sp,
                                                  ))
                                              : RichText(
                                                  text: TextSpan(
                                                  text:
                                                      'Rs ${currentWeight['price']}',
                                                  style: TextStyle(
                                                    letterSpacing:1.sp,
                                                    fontSize: 30.h,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationThickness:
                                                        2.85.sp,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '\nOffer Price: Rs ${currentWeight['offerPrice']}',
                                                      style: TextStyle(
                                                        letterSpacing:1.sp,
                                                        fontSize: 30.h,
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                        ),
                                  CachedNetworkImage(
                                    imageUrl: document['image'],
                                    imageBuilder: (context, imageProvider) =>
                                        Image(
                                      image: imageProvider,
                                      height: 300.h,
                                      fit: BoxFit.fitHeight,
                                    ),
                                    progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                        Container(
                                            child: CircularProgressIndicator(
                                                value:
                                                    downloadProgress.progress)),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                  (!document.data.containsKey('price'))
                                      ? Container(
                                          child: Column(
                                              children: document['weights']
                                                  .values
                                                  .map((weight) {
                                                    return Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              35.w,
                                                              10.h,
                                                              35.w,
                                                              10.h),
                                                      child: OutlineButton(
                                                          borderSide: (weight[
                                                                      'weight'] ==
                                                                  currentWeight[
                                                                      'weight'])
                                                              ? BorderSide(
                                                                  color: Colors
                                                                      .teal,
                                                                  width: 2.w)
                                                              : BorderSide(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2.w),
                                                          onPressed: () {
                                                            setState(() {
                                                              count = 0;
                                                              currentWeight =
                                                                  weight;
                                                            });
                                                          },
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Container(
                                                                    padding: EdgeInsets
                                                                        .fromLTRB(
                                                                            5.w,
                                                                            0,
                                                                            0,
                                                                            0),
                                                                    child: Text(
                                                                      '${weight['weight']} ',
                                                                      style: TextStyle(
                                                                        letterSpacing:1.sp,
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              20.sp),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    '${weight['type']} at ',
                                                                    style: TextStyle(
                                                                      letterSpacing: 1.sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            20.sp),
                                                                  ),
                                                                  (weight['offerPrice'] ==
                                                  null)
                                              ? Text(
                                                  'Rs ${weight['price']}',
                                                  style: TextStyle(
                                                    letterSpacing:1.sp,
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.bold,
                                                    decorationThickness:
                                                        2.85.sp,
                                                  ))
                                              : RichText(
                                                  text: TextSpan(
                                                  text:
                                                      'Rs ${weight['price']}',
                                                  style: TextStyle(
                                                    letterSpacing:1.sp,
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    decorationThickness:
                                                        2.85.sp,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          ' Rs ${weight['offerPrice']}',
                                                      style: TextStyle(
                                                        letterSpacing:1.sp,
                                                        fontSize: 20.h,
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                )),
                                                                ],
                                                              ),
                                                              (weight['weight'] ==
                                                                      currentWeight[
                                                                          'weight'])
                                                                  ? Icon(
                                                                      Icons
                                                                          .radio_button_checked,
                                                                      color: Colors
                                                                          .black87,
                                                                    )
                                                                  : Icon(Icons
                                                                      .radio_button_unchecked)
                                                            ],
                                                          )),
                                                    );
                                                  })
                                                  .toList()
                                                  .cast<Widget>()))
                                      : Container(),
                                ]),
                              ),
                              Container(
                                color: Colors.black,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    (count != 0)
                                        ? ((!document.data.containsKey('price'))
                                            ? Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    15.w, 0, 0, 0),
                                                child: (currentWeight['offerPrice']==null)?Text(
                                                  "Final Price:\n${currentWeight['price'] * currentWeight['count']}",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ):Text(
                                                  "Final Price:\n${currentWeight['offerPrice'] * currentWeight['count']}",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold),))
                                            : Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    15.w, 0, 0, 0),
                                                child: (document['offerPrice']==null)?Text(
                                                  "Final Price:\n${document['price'] * count}",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ):Text(
                                                  "Final Price:\n${document['offerPrice'] * count}",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      color: Colors.teal,
                                                      fontWeight:
                                                          FontWeight.bold),)))
                                        : Container(),
                                    (count == 0)
                                        ? Container(
                                            padding: EdgeInsets.all(10.sp),
                                            child: FlatButton.icon(
                                              padding: EdgeInsets.fromLTRB(
                                                  20.w, 12.h, 20.w, 12.h),
                                              icon: Icon(
                                                Icons.shopping_cart,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  var cart = {};
                                    if (document.data.containsKey('price')) {
                                      cart = {
                                        'id': document['id'],
                                        'name': document['name'],
                                        'image': document['image'],
                                        'price': document['price'],
                                        'count': count + 1
                                      };
                                      if (document['offerPrice']!=null){
                                        cart['offerPrice']=document['offerPrice'];
                                      }
                                    } else {
                                      String key;
                                      for (var i in document['weights'].keys) {
                                        if (document.data['weights'][i]
                                                ['weight'] ==
                                            currentWeight['weight']) {
                                          key = i.toString();
                                        }
                                      }
                                      currentWeight['count'] = count + 1;
                                      cart = {
                                        'id': document['id'],
                                        'name': document['name'],
                                        'image': document['image'],
                                        'recentWeight': key,
                                        'weights': {key: currentWeight}
                                      };
                                      if (currentWeight['offerPrice']!=null){
                                        cart['offerPrice']=document['offerPrice'];
                                      }
                                    }
                                    DataBaseService(uid: uid)
                                        .useritems(document['id'], cart);
                                                });
                                              },
                                              label: Text('ADD TO CART',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      letterSpacing: 1,
                                                      color: Colors.white)),
                                              color: Colors.teal,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.sp)),
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(2.sp),
                                            child: ButtonBar(children: <Widget>[
                                              Container(
                                                width: 45.w,
                                                child: FlatButton(
                                                  color: Colors.teal,
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10.h, 0, 10.h),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.sp)),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 25.sp,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (document.data
                                                          .containsKey(
                                                              'price')) {
                                                        DataBaseService(
                                                                uid: uid)
                                                            .updateCount(
                                                                document['id'],
                                                                count - 1);
                                                      } else {
                                                        String key;
                                                        for (var i in document[
                                                                'weights']
                                                            .keys) {
                                                          if (document.data[
                                                                      'weights'][i]
                                                                  ['weight'] ==
                                                              currentWeight[
                                                                  'weight']) {
                                                            key = i.toString();
                                                          }
                                                        }
                                                        DataBaseService(
                                                                uid: uid)
                                                            .updateRecentWeight(
                                                                document['id'],
                                                                key);
                                                        DataBaseService(
                                                                uid: uid)
                                                            .updateWeightCount(
                                                                document['id'],
                                                                key,
                                                                count - 1);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    25.w, 0, 25.w, 0),
                                                child: Text('$count',
                                                    style: TextStyle(
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white)),
                                              ),
                                              Container(
                                                width: 45.w,
                                                child: FlatButton(
                                                  color: Colors.teal,
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 10.h, 0, 10.h),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3.sp)),
                                                  child: Icon(Icons.add,
                                                      size: 25.sp,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (document.data
                                                          .containsKey(
                                                              'price')) {
                                                        DataBaseService(
                                                                uid: uid)
                                                            .updateCount(
                                                                document['id'],
                                                                count + 1);
                                                      } else {
                                                        String key;
                                                        for (var i in document[
                                                                'weights']
                                                            .keys) {
                                                          if (document.data[
                                                                      'weights'][i]
                                                                  ['weight'] ==
                                                              currentWeight[
                                                                  'weight']) {
                                                            key = i.toString();
                                                          }
                                                        }
                                                        DataBaseService(
                                                                uid: uid)
                                                            .updateRecentWeight(
                                                                document['id'],
                                                                key);
                                                        DataBaseService(
                                                                uid: uid)
                                                            .updateWeightCount(
                                                                document['id'],
                                                                key,
                                                                count + 1);
                                                      }
                                                    });
                                                  },
                                                ),
                                              ),
                                            ]),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      });
                })),
      ),
      bottomNavigationBar: BottomBar(
        currentindex: 4,
      ),
    );
  }
}
