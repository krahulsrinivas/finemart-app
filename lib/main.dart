import 'package:finemart/routes.dart';
import 'package:finemart/widgets/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    get(
      'https://fine-mart.herokuapp.com/',
    );
    return MaterialApp(
      title: 'FineMart',
      debugShowCheckedModeBanner: false,
      builder: (context, child) => new SafeArea(child: child),
      home: Loading(),
      theme:ThemeData(highlightColor: Colors.teal),
      onGenerateRoute: Routes.materialRoutes,
    );
  }
}
