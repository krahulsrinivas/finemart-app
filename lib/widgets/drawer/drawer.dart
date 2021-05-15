import 'package:finemart/screens/OrderHistory.dart';
import 'package:finemart/widgets/drawer/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/screens/Home.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/screens/Loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DrawerMenu extends StatefulWidget {
  DrawerMenu({Key key}) : super(key: key);

  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Container(
      child: ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.teal,
          ),
          child: Text(
            'Fine Mart',
            style: TextStyle(
              color: Colors.white,
              fontStyle:FontStyle.italic,
              fontWeight:FontWeight.bold,
              fontSize: 30.sp,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.home),
          title: Text('Home'),
          onTap: () {
            return Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.history),
          title: Text('Order History'),
          onTap:() async {
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
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.account_box),
          title: Text('Your Account'),
          onTap:() async {
            Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Loader()));
                Firestore.instance
                    .collection('users').document(uid).get()
                    .then((snapshot) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Account(info:snapshot.data)));
                }).catchError((e) {
                  Navigator.pop(context);
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text(e.toString()),
                    backgroundColor: Colors.red,
                  ));
                });
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.store),
          title: Text('About Store'),
          onTap: () {
            return null;
          },
        ),
        Divider(),
      ]),
    );
  }
}