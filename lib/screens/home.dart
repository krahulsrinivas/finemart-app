import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finemart/screens/SignIn.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/widgets/drawer/drawer.dart';
import 'package:finemart/widgets/BottomNavBar.dart';
import 'package:finemart/widgets/Item.dart';
import 'package:finemart/widgets/Items.dart';
import 'package:finemart/screens/ItemBox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/screens/Loader.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
        drawer: Container(
          width: 300.w,
          child: Drawer(child: DrawerMenu()),
        ),
      body: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            floating: true,
            backgroundColor: Colors.teal,
            title: Text(
              'Fine Mart',
              style: TextStyle(
                  fontSize: 25.sp,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.all(5.sp),
                  child: FlatButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Loader()));
                      (imageUrl != '')
                          ? signOutGoogle().then((value) {
                              return Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignIn()),
                                  (Route<dynamic> route) => false);
                            })
                          : signOut().then((value) {
                              return Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          SignIn()),
                                  (Route<dynamic> route) => false);
                            });
                    },
                    hoverColor: Colors.white,
                    icon: (imageUrl != '')
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                            radius: 13.w,
                          )
                        : Icon(Icons.account_circle),
                    label: Text('Logout',
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                  ))
            ],
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            OffersSlider(),
          ])),
          StreamBuilder(
              stream: Firestore.instance
                  .collection('cart')
                  .document(uid)
                  .snapshots(),
              builder: (BuildContext context, snapshot2) {
                if (snapshot2.hasData && snapshot2.data != null ) {
                    lcart = snapshot2.data;
                }
                return StreamBuilder(
                    stream: Firestore.instance.collection('items').snapshots(),
                    builder: (BuildContext context, snapshot1) {
                      if (!snapshot1.hasData) {
                        return SliverList(
                            delegate: SliverChildListDelegate([
                          SizedBox(height: 300.h),
                          Center(child: CircularProgressIndicator())
                        ]));
                      } else {
                        if (snapshot1.data != null ||
                            snapshot2.data.data != null) {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                if (snapshot1.data.documents[index] != null) {
                                  return Item(
                                    document: snapshot1.data.documents[index],
                                  );
                                } else {
                                  return Container();
                                }
                              },
                              childCount: snapshot1.data.documents.length,
                            ),
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                    });
              })
        ],
      ),
      bottomNavigationBar: BottomBar(
        currentindex:0,
      ),
    );
  }
}

class OffersSlider extends StatefulWidget {
  OffersSlider({Key key}) : super(key: key);

  @override
  _OffersSliderState createState() => _OffersSliderState();
}

class _OffersSliderState extends State<OffersSlider> {
  @override
  Widget build(BuildContext context) {
    List offer = [];
    Future offers() async {
      return await Firestore.instance.collection('offers').getDocuments();
    }

    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FutureBuilder(
            future: offers(),
            builder: (BuildContext context, snapshot) {
              if (!snapshot.hasData) {
                return CircularProgressIndicator();
              } else {
                if (snapshot.data.documents.isEmpty) {
                  return Card(
                    child: Container(
                      padding: EdgeInsets.all(5.sp),
                      child: Center(
                        child: Text(
                          'Our Top Products',
                          style: TextStyle(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  for (var doc in snapshot.data.documents) {
                    offer.add(doc.data);
                  }
                  return Column(
                    children: [
                      Card(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.w),
                          child: Center(
                            child: Text(
                              'Today\'s Offers',
                              style: TextStyle(
                                fontSize: 20.sp,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CarouselSlider(
                          items: offer.map((document) {
                            return Builder(
                              builder: (BuildContext context) {
                                return (document.containsKey('id'))
                                    ? InkWell(
                                        onTap: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) => ItemBox(
                                                      id: document['id'])));
                                        },
                                        child: Container(
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        3.sp)),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    padding:EdgeInsets.all(5.sp),
                                                  child:Icon(
                                                    Icons.arrow_back_ios,
                                                    size: 20.sp,
                                                  ),
                                                  ),
                                                  CachedNetworkImage(
                                                    imageUrl: document['image'],
                                                    imageBuilder: (context,
                                                            imageProvider) =>
                                                        Container(
                                                            width: 135.w,
                                                            height: 140.h,
                                                            child: Image(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .fill)),
                                                    progressIndicatorBuilder:
                                                        (context, url,
                                                                downloadProgress) =>
                                                            Container(
                                                      width: 135.w,
                                                      height: 140.h,
                                                      child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress,
                                                        ),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        Container(
                                                            width: 135.w,
                                                            height: 140.h,
                                                            child: Center(
                                                                child: Icon(Icons
                                                                    .error))),
                                                  ),
                                                  SizedBox(width: 30.w),
                                                  Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          SizedBox(
                                                              height: 15.h),
                                                          Text(
                                                            'Fine Mart\'s',
                                                            style: TextStyle(
                                                                fontSize: 20.sp,
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                          (!document
                                                                  .containsKey(
                                                                      'weight'))
                                                              ? Text(
                                                                  '${document['name']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                  ))
                                                              : Text(
                                                                  '${document['name']},${document['weight']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        20.sp,
                                                                  )),
                                                          Text(
                                                              'Rs ${document['price']} ',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20.sp,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                  decorationThickness:
                                                                      2.85.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Text(
                                                              'Offer Price:\nRs ${document['offerPrice']}',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      20.sp,
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold))
                                                        ]),
                                                  ),
                                                  Container(
                                                    padding:EdgeInsets.all(5.sp),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20.sp,
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        3.sp)),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Container(
                                                    padding:EdgeInsets.all(5.sp),
                                                    child: Icon(
                                                      Icons.arrow_back_ios,
                                                      size: 20.sp,
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        SizedBox(height:10.h),
                                                        Text(document['name'],
                                                            style: TextStyle(
                                                                fontSize: 25.sp,
                                                                color:Colors.redAccent,
                                                                decoration:
                                                                    TextDecoration
                                                                        .underline,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        SizedBox(height:10.h),
                                                        Text(
                                                            document['message'],
                                                            style: TextStyle(
                                                                fontSize: 20.sp,
                                                                color:
                                                                    Colors.redAccent,
                                                                  fontStyle:FontStyle.italic,
                                                                )),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    padding:EdgeInsets.all(5.sp),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      size: 20.sp,
                                                    ),
                                                  ),
                                                ])));
                              },
                            );
                          }).toList(),
                          options: CarouselOptions(
                            height: 175.h,
                            viewportFraction: 0.95,
                            autoPlay: true,
                            autoPlayInterval: Duration(milliseconds: 3000),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          )),
                    ],
                  );
                }
              }
            }),
      ],
    ));
  }
}
