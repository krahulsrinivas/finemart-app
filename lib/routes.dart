import 'package:finemart/screens/SignIn.dart';
import 'package:finemart/widgets/drawer/account.dart';
import 'package:finemart/widgets/Search.dart';
import 'package:finemart/screens/Cart.dart';
import 'package:finemart/screens/Categories.dart';
import 'package:finemart/screens/Home.dart';
import 'package:finemart/screens/Location.dart';
import 'package:finemart/screens/UserInfo.dart';
import 'package:flutter/material.dart';
abstract class Routes {
  static MaterialPageRoute materialRoutes(RouteSettings settings) {
    switch (settings.name) {
      case "/Home":
        return MaterialPageRoute(builder: (context) => Home());
      case "/Categories":
        return MaterialPageRoute(builder: (context) => Categories());
      case "/Cart":
        return MaterialPageRoute(builder: (context) => Cart());
      case "/Search":
        return MaterialPageRoute(builder: (context) => Search());
      case "/Sign-in":
        return MaterialPageRoute(builder: (context) => SignIn());
      case "/Account":
        return MaterialPageRoute(builder: (context) => Account());
      case "/Location":
        return MaterialPageRoute(builder: (context) => Location());
      case "/userinfo":
        return MaterialPageRoute(builder: (context) => UserInfo());
      default:
        return MaterialPageRoute(builder: (context) => Home());
    }
  }
}
