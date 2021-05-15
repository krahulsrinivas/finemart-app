import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/util/dataServices.dart';
import 'package:finemart/widgets/Items.dart';
import 'package:finemart/screens/ItemBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Item extends StatefulWidget {
  final DocumentSnapshot document;
  Item({this.document});
  @override
  ItemState createState() => ItemState(document);
}

class ItemState extends State<Item> {
  DocumentSnapshot document;
  ItemState(this.document);
  Map currentWeight = {};
  String recentWeight;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    if (lcart != null) {
      //cause it takes time for lcart to initialize
      if (lcart.exists) {
        //when cart had data
        for (var item in lcart.data.values) {
          if (item['price'] != null) {
            if (item['count'] == 0) {
              DataBaseService(uid: uid).deleteItem(item['id']);
            }
          } else {
            if (item['id'] == document['id']) {
              recentWeight = item['recentWeight'];
            }
            if (item['weights'].isNotEmpty) {
              for (var weight in item['weights'].keys) {
                if (item['weights'][weight]['count'] == 0) {
                  DataBaseService(uid: uid).deleteWeight(item['id'], weight);
                }
              }
            } else {
              DataBaseService(uid: uid).deleteItem(item['id']);
            }
          }
          if (item['id'] == document['id']) {
            // checks if cart id and item id are same
            if (document.data.containsKey('price')) {
              // item type is price then just take count from cart
              count = item['count'];
            } else {
              if (currentWeight.isEmpty) {
                for (var weight in item['weights'].keys) {
                  if (item['weights'][weight]['count'] != 0) {
                    if (recentWeight != null) {
                      if (recentWeight == weight) {
                        currentWeight = item['weights'][weight];
                        count = item['weights'][weight]['count'];
                      }
                    } else {
                      currentWeight = item['weights'][weight];
                      count = item['weights'][weight]['count'];
                    }
                  } else {
                    count = 0;
                  }
                }
              } else if (currentWeight.isNotEmpty) {
                for (var weight in item['weights'].values) {
                  if (weight['count'] != 0) {
                    if (currentWeight['weight'] == weight['weight']) {
                      currentWeight = weight;
                      count = weight['count'];
                    }
                  } else {
                    currentWeight = {};
                    count = 0;
                  }
                }
              }
            }
          }
        }
      }
    } else {
      // Cirucular progress indicator when cart is yet to be initialized
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 250.h),
          Center(
            child: Container(
              child: CircularProgressIndicator(
                strokeWidth: 5.w,
              ),
              width: 100.w,
              height: 100.h,
            ),
          ),
          SizedBox(height: 250.h),
        ],
      );
    }
    if (!document.data.containsKey('price')) {
      (currentWeight.isEmpty)
          ? currentWeight = document['weights']['weight_1']
          : currentWeight = currentWeight;
    }
    return InkWell(
      onTap: () {
        // when item card is tapped
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ItemBox(id: document['id']),
                maintainState: true))
            .then((value) {
          setState(() {
            currentWeight = {};
          });
        });
      },
      child: Container(
        child: Card(
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <
              Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(5.w, 0, 0, 0),
              child: CachedNetworkImage(
                imageUrl: document['image'],
                imageBuilder: (context, imageProvider) => Container(
                    width: 130.w,
                    height: 155.h,
                    child: Image(image: imageProvider, fit: BoxFit.fill)),
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Container(
                  width: 130.w,
                  height: 150.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
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
              Text('${document['name']}',
                  style: TextStyle(
                    fontSize: 20.sp,
                  )),
              (document['price'] == null)
                  ? Container(
                      width: 250.w,
                      child: OutlineButton(
                          borderSide: BorderSide(width: 1.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('${currentWeight['weight']} ' +
                                  currentWeight['type']),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      title: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Available quantities for',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.sp),
                                          ),
                                          Text(
                                            '${document['name']}',
                                            style: TextStyle(fontSize: 20.sp),
                                          )
                                        ],
                                      ),
                                      content: Container(
                                          width: 300.w,
                                          height: (60 *
                                                  (document['weights'].length))
                                              .toDouble(),
                                          child: ListView.builder(
                                            itemBuilder:
                                                (BuildContext context, index) {
                                              String key = document['weights']
                                                  .keys
                                                  .elementAt(index);
                                              return Column(
                                                children: <Widget>[
                                                  FlatButton(
                                                    color: (document['weights']
                                                                    [key]
                                                                ['weight'] ==
                                                            currentWeight[
                                                                'weight'])
                                                        ? Colors.grey[850]
                                                        : Colors.white,
                                                    child: Center(
                                                        child:(document['weights'][key]['offerPrice']==null)?Text(
                                                      '${document['weights'][key]['weight']} ' +
                                                          document['weights'][key]['type'] +
                                                          ' at Rs ${document['weights'][key]['price']}',
                                                      style: TextStyle(
                                                        fontWeight:FontWeight.bold,
                                                        fontSize: 18.sp,
                                                        letterSpacing:1.sp,
                                                        color: (document['weights']
                                                                        [key][
                                                                    'weight'] ==
                                                                currentWeight[
                                                                    'weight'])
                                                            ? Colors.white
                                                            : Colors.black54,
                                                      )):RichText(
                                      text: TextSpan(
                                      text: '${document['weights'][key]['weight']} ' +
                                                          document['weights'][key]['type'] +
                                                          ' at',
                                      style: TextStyle(
                                        fontWeight:FontWeight.bold,
                                                        fontSize: 18.sp,
                                                        letterSpacing:1.sp,
                                                        color: (document['weights']
                                                                        [key][
                                                                    'weight'] ==
                                                                currentWeight[
                                                                    'weight'])
                                                            ? Colors.white
                                                            : Colors.black54,
                                      
                                      ),
                                      children: [
                                        TextSpan(
                                          text: ' Rs ${document['weights'][key]['price']}',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            letterSpacing:1.sp,
                                            decoration:TextDecoration.lineThrough,
                                            decorationThickness: 2.85.sp,
                                            fontWeight: FontWeight.bold,
                                            color: (document['weights']
                                                                        [key][
                                                                    'weight'] ==
                                                                currentWeight[
                                                                    'weight'])
                                                            ? Colors.white
                                                            : Colors.black54,
                                          ),
                                        ),
                                        TextSpan(
                                          text: ' Rs ${document['weights'][key]['offerPrice']}',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            letterSpacing:1.sp,
                                            decoration:TextDecoration.none,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ))
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        count = 0;
                                                        currentWeight =
                                                            document['weights']
                                                                [key];
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  Divider(),
                                                ],
                                              );
                                            },
                                            itemCount:
                                                document['weights'].length,
                                          )));
                                });
                          }),
                    )
                  : Container(
                      height: 40.h,
                    ),
              SizedBox(height: 5.h),
              Container(
                width: 260.w,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      (document['price'] != null)
                          ? Container(
                              child: (document['offerPrice'] == null)
                                  ? Text('Rs ${document['price']}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        decorationThickness: 2.85.sp,
                                      ))
                                  : RichText(
                                      text: TextSpan(
                                      text: 'Rs ${document['price']}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2.85.sp,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '\nRs ${document['offerPrice']}',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            decoration:TextDecoration.none,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    )))
                          : Container(
                              child: (currentWeight['offerPrice'] == null)
                                  ? Text('Rs ${currentWeight['price']}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        decorationThickness: 2.85.sp,
                                      ))
                                  : RichText(
                                      text: TextSpan(
                                      text: 'Rs ${currentWeight['price']}',
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        decoration: TextDecoration.lineThrough,
                                        decorationThickness: 2.85.sp,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: '\nRs ${currentWeight['offerPrice']}',
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            decoration:TextDecoration.none,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    )),
                            ),
                      (count == 0)
                          ? Container(
                              padding: EdgeInsets.all(8.sp),
                              child: FlatButton(
                                padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
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
                                child: Text('ADD',
                                    style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                        color: Colors.white)),
                                color: Colors.teal,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.sp)),
                              ),
                            )
                          : Container(
                              child: ButtonBar(children: <Widget>[
                                Container(
                                  width: 40.w,
                                  child: OutlineButton(
                                    highlightColor: Colors.redAccent,
                                    highlightedBorderColor: Colors.redAccent,
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 2.w),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.sp)),
                                    child: Icon(
                                      Icons.remove,
                                      size: 20.sp,
                                      color: Colors.teal,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (document.data
                                            .containsKey('price')) {
                                          DataBaseService(uid: uid).updateCount(
                                              document['id'], count - 1);
                                        } else {
                                          String key;
                                          for (var i
                                              in document['weights'].keys) {
                                            if (document.data['weights'][i]
                                                    ['weight'] ==
                                                currentWeight['weight']) {
                                              key = i.toString();
                                            }
                                          }
                                          DataBaseService(uid: uid)
                                              .updateRecentWeight(
                                                  document['id'], key);
                                          DataBaseService(uid: uid)
                                              .updateWeightCount(document['id'],
                                                  key, count - 1);
                                        }
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(6.w, 0, 6.w, 0),
                                  child: Text('$count',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal)),
                                ),
                                Container(
                                  width: 40.w,
                                  child: OutlineButton(
                                    highlightColor: Colors.greenAccent,
                                    highlightedBorderColor: Colors.greenAccent,
                                    borderSide: BorderSide(
                                        color: Colors.teal, width: 2.w),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.sp)),
                                    child: Icon(Icons.add,
                                        size: 20.sp, color: Colors.teal),
                                    onPressed: () {
                                      setState(() {
                                        if (document.data
                                            .containsKey('price')) {
                                          DataBaseService(uid: uid).updateCount(
                                              document['id'], count + 1);
                                        } else {
                                          String key;
                                          for (var i
                                              in document['weights'].keys) {
                                            if (document.data['weights'][i]
                                                    ['weight'] ==
                                                currentWeight['weight']) {
                                              key = i.toString();
                                            }
                                          }
                                          DataBaseService(uid: uid)
                                              .updateRecentWeight(
                                                  document['id'], key);
                                          DataBaseService(uid: uid)
                                              .updateWeightCount(document['id'],
                                                  key, count + 1);
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ]),
                            ),
                    ]),
              )
            ]),
          ]),
        ),
      ),
    );
  }
}
