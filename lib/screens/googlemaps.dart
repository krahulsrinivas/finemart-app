import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Maps extends StatefulWidget {
  final dynamic coords;
  Maps({this.coords});

  @override
  _MapsState createState() => _MapsState(coords);
}

class _MapsState extends State<Maps> {
  final dynamic coords;
  _MapsState(this.coords);
  List markers = [];
  List prev;
  bool loader = false;
  Address location;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    markers.add(Marker(
      markerId: MarkerId(
          LatLng(widget.coords[0], widget.coords[1]).toString()),
      position: LatLng(widget.coords[0], widget.coords[1]),
    ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    Future <Address> getCoords() async {
      var res = markers[0].markerId.value.split("(");
      res = res[1].split(",");
      var lng = res[1].split(")")[0];
      var lat = res[0];
      prev=[double.parse(lng),double.parse(lat)];
      Coordinates coordinates =
          new Coordinates(double.parse(lat), double.parse(lng));
      List<Address> address =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      return address.first;
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Fine Mart',
          style: TextStyle(
              fontSize: 25,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
                child: GoogleMap(
              onCameraIdle: () async {
                dynamic something= await getCoords();
                setState(() {
                  loader = true;
                  location = something;
                });
                setState(() {
                  loader = false;
                });
              },
              onCameraMove: (cameraposition) {
                setState(() {
                  markers = [];
                  markers.add(Marker(
                    markerId: MarkerId(cameraposition.target.toString()),
                    position: cameraposition.target,
                  ));
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.coords[0], widget.coords[1]),
                zoom: 18.0,
              ),
              markers: Set.from(markers),
            )),
          ),
          Container(
            child: (loader)
                ? Container(
                    color: Colors.black,
                    child: Center(child: CircularProgressIndicator()))
                : Container(
                    padding: EdgeInsets.all(5.sp),
                    child: Column(
                      children: <Widget>[
                        Container(child:Text("Select a Location",
                        style: TextStyle(
                                    fontSize: 20.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                        )),
                        Divider(),
                        Container(
                            padding: EdgeInsets.all(10.sp),
                            child: Center(
                              child: (location==null)?CircularProgressIndicator():Text(
                                '${location?.addressLine}',
                                maxLines:2,
                                style: TextStyle(
                                    fontSize: 18.sp,
                                    color: Colors.teal,
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 5.h,0, 0),
                          child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(3.sp)),
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 15.h),
                              color: Colors.teal,
                              onPressed: () {
                                (location!=null)?Navigator.pop(context,{"loc":prev??null,"address":location?.addressLine??null}):_scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text("Invalid Location",
                                  style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold)),
                              backgroundColor: Colors.red,
                            ));
                              },
                              child: Text(
                                'Confirm Your Location ->',
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
          )
        ],
      ),
    );
  }
}
