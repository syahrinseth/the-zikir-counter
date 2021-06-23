import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zikir_app/screens/home_page.dart';
import 'package:zikir_app/theme/colors/light_colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: LightColors.kLightYellow, // navigation bar color
    statusBarColor: Color(0xff43c59e), // status bar color
  ));

  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Color(0xff3d7068),
            displayColor: Color(0xff3d7068),
            fontFamily: 'Poppins'),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
