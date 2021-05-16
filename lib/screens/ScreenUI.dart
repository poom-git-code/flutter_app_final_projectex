import 'package:flutter/material.dart';
import 'package:flutter_app_final_projectex/screens/home_ui.dart';
import 'package:splashscreen/splashscreen.dart';

class ScreenUI extends StatefulWidget {
  @override
  _ScreenUIState createState() => _ScreenUIState();
}

class _ScreenUIState extends State<ScreenUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SplashScreen(
          seconds: 4,
          navigateAfterSeconds: HomeUI(),
          title: Text(
            'Covid Timeline',
            style: TextStyle(
              color: Color(0xffFF4A00),
              fontSize: 35.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kanit',
            ),
          ),
          image: Image.asset('assets/images/icon-map.ico'),
          backgroundColor: Color(0xffFFB698),
          photoSize: 120.0,
          loaderColor: Color(0xffFF4A00),
          loadingText: Text(
            'กรุณารอสักครู่',
            style: TextStyle(
              color: Color(0xffFF4A00),
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    );

  }
}