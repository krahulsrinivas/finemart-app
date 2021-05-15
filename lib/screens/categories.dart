import 'package:finemart/util/auth/userId.dart';
import 'package:finemart/widgets/drawer/drawer.dart';
import 'package:finemart/widgets/BottomNavBar.dart';
import 'package:finemart/widgets/Items.dart';
import 'package:finemart/screens/CategoryItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/screens/SignIn.dart';
import 'package:finemart/screens/Loader.dart';
class Categories extends StatefulWidget {
  Categories({Key key}) : super(key: key);
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  int catetype;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return SafeArea(
      child: Scaffold(
         backgroundColor:Colors.grey[200],
        body: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                    icon: (imageUrl != '')
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(imageUrl),
                            radius: 13.w,
                          )
                        : Icon(Icons.account_circle),
                    label: Text('Logout',
                        style:
                            TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                  ),
                ),
              ],
            ),
            SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    child: InkWell(
                      onTap: () {
                        catetype = cate[index]['type'];
                        return Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                CategoryItem(catetype: catetype,catename:cate[index]['name'])));
                      },
                      child: Card(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height:190.h,
                            child: Image(
                              image: AssetImage(cate[index]['image']),
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text(
                            cate[index]['name'],
                            style: TextStyle(
                                fontSize: 20.sp, fontWeight: FontWeight.bold,fontStyle:FontStyle.italic,color:Colors.grey[700]),
                          ),
                        ],
                      )),
                    ),
                  );
                },
                childCount: cate.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.90,
              ),
            ),
          ],
        ),
          drawer: Container(
          width: 300.w,
          child: Drawer(child: DrawerMenu()),
        ),
        bottomNavigationBar: BottomBar(
          currentindex:1,
        ),
      ),
    );
  }
}
