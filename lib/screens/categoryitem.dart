import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/widgets/BottomNavBar.dart';
import 'package:finemart/widgets/Item.dart';
import 'package:finemart/widgets/Items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategoryItem extends StatefulWidget {
  final catetype;
  final catename;
  CategoryItem({this.catetype,this.catename});
  @override
  _Categoryitemstate createState() => _Categoryitemstate(catetype);
}

class _Categoryitemstate extends State<CategoryItem> {
  int catetype;
  _Categoryitemstate(this.catetype);

  @override
  Widget build(BuildContext context) {
     ScreenUtil.init(context, width:423.5, height:964.3);
    return SafeArea(
      child: Scaffold(
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
                        Navigator.pushReplacementNamed(context, '/Sign-in');
                        (imageUrl != '') ? signOutGoogle() : signOut();
                      },
                      hoverColor: Colors.white,
                      icon: (imageUrl != '')
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 13.sp,
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
            Card(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5.w, 5.h, 5.w, 5.w),
                          child: Center(
                            child: Text(
                              widget.catename,
                              style: TextStyle(
                                fontSize: 25.sp,
                                letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ),
                      ),
          ])),
            StreamBuilder(
                stream: Firestore.instance
                    .collection('cart')
                    .document(uid)
                    .snapshots(),
                builder: (BuildContext context, snapshot2) {
                  lcart = snapshot2.data;
                  return StreamBuilder(
                      stream:
                          Firestore.instance.collection('items').snapshots(),
                      builder: (BuildContext context, snapshot1) {
                        if (!snapshot1.hasData)
                          return SliverList(
                            delegate:
                                SliverChildListDelegate.fixed([Text('h')]),
                          );
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (snapshot1.data.documents[index]['type'] ==
                                  catetype) {
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
                      });
                })
          ],
        ),
        bottomNavigationBar: BottomBar(
          currentindex: 1,
        ),
      ),
    );
  }
}
