import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class BottomBar extends StatefulWidget {
  final int currentindex;
  BottomBar({this.currentindex});
  @override
  _BottomBarState createState() => _BottomBarState(currentindex);
}

class _BottomBarState extends State<BottomBar> {
  int currentindex;
  int prevIndex;
  _BottomBarState(this.currentindex);
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width:423.5, height:964.3);
    return BottomNavigationBar(
      elevation:1,
      //iconSize: 20.sp,
      currentIndex: (currentindex == 4) ? 0 : currentindex,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.teal,
      selectedItemColor: (currentindex == 4) ? Colors.white : Colors.black,
      unselectedItemColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text("Home",style: TextStyle(fontSize:15.sp),),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          title: Text("Categories",style: TextStyle(fontSize:15.sp)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text("Search",style: TextStyle(fontSize:15.sp)),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          title: Text("Cart",style: TextStyle(fontSize:15.sp)),
        ),
      ],
      onTap: (index) {
        setState(() {
          prevIndex=currentindex;
          currentindex = index;
        });
        if (currentindex == 0) {
          return Navigator.pushReplacementNamed(context, '/Home');
        }
        else if (currentindex == 1) {
          return Navigator.pushReplacementNamed(context, '/Categories');
        } else if (currentindex==2){
          return Navigator.pushNamed(context, '/Search').then((value){setState(() {
            currentindex=prevIndex;
          });});
        }else{
          return Navigator.pushReplacementNamed(context, '/Cart');
        }
      },
    );
  }
}
