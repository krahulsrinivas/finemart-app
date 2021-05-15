import 'dart:ui';
import 'package:finemart/screens/location.dart';
import 'package:finemart/util/auth/googleservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finemart/screens/Loader.dart';

class SignIn extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50.h),
                  Container(
                    padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
                    child: Center(
                        child: Text('Welcome to',
                            style: TextStyle(
                                fontSize: 55.sp,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1,
                                color: Colors.teal))),
                  ),
                  Center(
                      child: Text('Fine Mart',
                          style: TextStyle(
                              fontSize: 50.sp,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              letterSpacing: 1,
                              color: Colors.teal))),
                  SizedBox(height: 30.h),
                  Center(
                    child: Text('Login/Sign-Up',
                        style: TextStyle(
                            fontSize: 35.sp,
                            letterSpacing: 1,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal)),
                  ),
                  SingleChildScrollView(
                                      child: Column(
                      children: [
                        SizedBox(height: 50.h),
                        PhoneField(),
                        SizedBox(height: 50.h),
                        GSignIn(),
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}

class GSignIn extends StatefulWidget {
  @override
  _GSignInState createState() => _GSignInState();
}

class _GSignInState extends State<GSignIn> {
  String errmsg;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Container(
      child: Column(
        children: <Widget>[
          RaisedButton(
            color: Colors.white,
            splashColor: Colors.grey,
            onPressed: () async {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => Loader()));
              final prefs = await SharedPreferences.getInstance();
              await signInWithGoogle().catchError((e) {
                setState(() {
                  errmsg = e.toString();
                });
                Navigator.pop(context);
              }).then((value) async {
                if (value != null) {
                  prefs.setBool('userCheck', true);
                  if (value[0] == prefs.getString('uid')) {
                    prefs.setBool('locationCheck', true);
                    Navigator.pop(context);
                    return Navigator.pushReplacementNamed(context, '/Home');
                  } else {
                    prefs.setString('uid', value[0]);
                    prefs.setString('imageUrl', value[1]);
                    Navigator.pop(context);
                    return Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(
                      builder: (context) => Location(),
                    ));
                  }
                } else {
                  return null;
                }
              });
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white, width: 3.w)),
            highlightElevation: 0,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 10.h, 0, 10.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage("images/google.jpg"), height: 35.0.h),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: Text(
                      'Google Sign-In',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          (errmsg != null)
              ? Container(
                  padding: EdgeInsets.all(30.sp),
                  child: Text(
                    errmsg,
                    style: TextStyle(
                        fontSize: 15.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

class PhoneField extends StatefulWidget {
  @override
  _PhoneFieldState createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final formKey = new GlobalKey<FormState>();
  String phoneNo, verificationId, smsCode;
  bool codeSent = false;
  String errmsg;
  bool loader = false;
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 423.5, height: 964.3);
    return Container(
      child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
                child: TextFormField(
                  readOnly: codeSent,
                  decoration: InputDecoration(
                    hintText: '10 digit phone no',
                    fillColor: (codeSent) ? Colors.white : Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(12.0.sp),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 2.0.w),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0.w),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (val) =>
                      val.length != 10 ? 'Enter a 10 digit phone no' : null,
                  onChanged: (val) {
                    setState(() => this.phoneNo = '+91' + val);
                  },
                ),
              ),
              SizedBox(height: 20.h),
              codeSent
                  ? Container(
                      padding: EdgeInsets.fromLTRB(50.w, 0, 50.w, 0),
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Enter OTP',
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(12.0.sp),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.black, width: 2.0.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.teal, width: 2.0.w),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val.length != 6 ? 'Enter a 6 digit sms code' : null,
                        onChanged: (val) {
                          setState(() => this.smsCode = val);
                        },
                      ),
                    )
                  : Container(),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.fromLTRB(123.w, 0, 125.w, 0),
                child: RaisedButton(
                    child: Center(
                        child: codeSent
                            ? Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            : Text(
                                'Verify',
                                style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black, width: 1.w)),
                    color: Colors.white,
                    splashColor: Colors.grey,
                    elevation: 10,
                    onPressed: () {
                      if (formKey.currentState.validate()) {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          errmsg = null;
                          loader = true;
                        });
                        codeSent
                            ? signInWithOTP(smsCode, verificationId)
                            : verifyPhone(phoneNo);
                      }
                    }),
              ),
              SizedBox(height: 10.h),
              (errmsg == null)
                  ? Container()
                  : Container(
                      padding: EdgeInsets.fromLTRB(30.w, 0, 30.w, 0),
                      child: Text(errmsg,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold))),
              (loader)
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                  : Container(),
            ],
          )),
    );
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      setState(() {
        this.errmsg = null;
      });
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      setState(() {
        this.errmsg = authException.message;
        this.loader = false;
      });
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.errmsg = null;
        this.codeSent = true;
        this.loader = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };
    await FirebaseAuth.instance
        .verifyPhoneNumber(
            phoneNumber: phoneNo,
            timeout: const Duration(seconds: 5),
            verificationCompleted: verified,
            verificationFailed: verificationfailed,
            codeSent: smsSent,
            codeAutoRetrievalTimeout: autoTimeout)
        .catchError((e) => print(e));
  }

  signInWithOTP(smsCode, verId) async {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => Loader()));
    final prefs = await SharedPreferences.getInstance();
    AuthCredential creds = PhoneAuthProvider.getCredential(
        verificationId: verId, smsCode: smsCode);
    await FirebaseAuth.instance.signInWithCredential(creds).then((value) {
      prefs.setBool('userCheck', true);
      if (value.user.uid == prefs.getString('uid')) {
        prefs.setBool('locationCheck', true);
        Navigator.pop(context);
        return Navigator.pushReplacementNamed(context, '/Home');
      } else {
        prefs.setString('uid', value.user.uid);
        prefs.setString('imageUrl', '');
        Navigator.pop(context);
        return Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => Location(),
        ));
      }
    }).catchError((e) {
      setState(() {
        this.codeSent = false;
        this.errmsg = e.toString();
        this.loader = false;
      });
      Navigator.pop(context);
    });
  }
}
