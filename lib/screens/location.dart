import 'package:finemart/screens/UserInfo.dart';
import 'package:finemart/screens/verifyuserinfo.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as prompt;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  double distanceInMeters;
  bool _serviceEnabled;
  prompt.Location checklocation = new prompt.Location();
  Future getLocation() async {
    _serviceEnabled = await checklocation.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await checklocation.requestService();
      if (!_serviceEnabled) {
        return Center(
            child: Column(children: [
          Container(
            padding: EdgeInsets.fromLTRB(40.w, 0, 40.w, 0),
            child: Text("You cannot continue without providing location",
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 25.sp)),
          ),
          SizedBox(height: 50.h),
          FlatButton(
            onPressed: () {
              return Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => Location(),
              ));
            },
            child: Text('Enable Location',
                style: TextStyle(
                    letterSpacing: 1.sp, fontSize: 20.sp, color: Colors.white)),
            color: Colors.teal,
            splashColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.sp)),
          )
        ]));
      }
    }
    var status = await checklocation.requestPermission();
    if (status.toString() == "PermissionStatus.deniedForever") {
      return Center(
          child: Column(children: [
        Container(
          padding: EdgeInsets.fromLTRB(40.w, 0, 40.w, 0),
          child: Text(
              "You need to go to settings and enable location and restart app",
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 25.sp)),
        ),
      ]));
    }
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    List coords = [position.latitude, position.longitude];
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    distanceInMeters = await Geolocator().distanceBetween(
        position.latitude, position.longitude, 12.968867, 77.750000);

    return Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => UserInfo(first: first, coords: coords)));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
        appBar: AppBar(
          title: Center(
              child: Text('Fine Mart',
                  style: TextStyle(
                      fontSize: 25.sp,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold))),
          backgroundColor: Colors.teal,
        ),
        body: Container(
            child: Center(
                child: Column(
          children: <Widget>[
            SizedBox(height: 40.h),
            Container(
                padding: EdgeInsets.fromLTRB(25.w, 0, 25.w, 0),
                child: Text(
                  'Note:We are currently only delivering to houses within a 2 km range.',
                  style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.teal,
                      fontWeight: FontWeight.bold),
                )),
            SizedBox(height: 200.h),
            FutureBuilder(
                future: getLocation(),
                builder: (BuildContext context, snapshot) {
                  if (!snapshot.hasData) {
                    return SpinKitCircle(
                      color: Colors.teal,
                      size: 75.sp,
                    );
                  } else {
                    return snapshot.data;
                  }
                })
          ],
        ))));
  }
}
