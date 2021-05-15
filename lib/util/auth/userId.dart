import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();
String uid;
String imageUrl;
bool userCheck;
bool locationCheck;

Future getuserId() async {
  final prefs = await SharedPreferences.getInstance();
  uid = prefs.getString('uid') ?? '';
  imageUrl = prefs.getString('imageUrl') ?? '';
  userCheck = prefs.getBool('userCheck') ?? false;
  locationCheck = prefs.getBool('locationCheck') ?? false;
}

Future getCurrentUser() async {
  FirebaseUser _user = await FirebaseAuth.instance.currentUser();
  return _user;
}

Future signOut() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('userCheck', false);
  prefs.setBool('locationCheck', false);
  await FirebaseAuth.instance.signOut();
  await googleSignIn.signOut();
}

Future signOutGoogle() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('userCheck', false);
  prefs.setBool('locationCheck', false);
  await FirebaseAuth.instance.signOut();
  await googleSignIn.signOut();
}
