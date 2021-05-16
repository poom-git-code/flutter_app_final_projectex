import 'package:flutter/material.dart';
import 'package:flutter_app_final_projectex/screens/ScreenUI.dart';
import 'package:flutter_app_final_projectex/screens/home_ui.dart';
import 'package:firebase_core/firebase_core.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ScreenUI(),
        theme: ThemeData(
            fontFamily: 'Kanit',
            primaryColor: Color(0xffd55e2d)
        ),
      )
  );
}