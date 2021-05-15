import 'package:finemart/screens/location.dart';
import 'package:finemart/util/auth/userId.dart';
import 'package:flutter/material.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future loader() async {
    await getuserId();
    if (!(userCheck)) {
      return Navigator.pushReplacementNamed(context, '/Sign-in');
    } else if (!(locationCheck)) {
      return Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => Location(),
      ));
    } else {
      return Navigator.pushReplacementNamed(context, '/Home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
                future: loader(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container();
                  } else {
                    return snapshot.data;
                  }
                })
          ]),
    );
  }
}
