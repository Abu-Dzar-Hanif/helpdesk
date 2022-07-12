import 'dart:async';

import 'package:flutter/material.dart';
import 'package:helpdesk/LoginPage.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    StartScreen();
  }

  StartScreen() {
    var duration = const Duration(seconds: 5);
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) {
          return LoginPage();
        }),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Image.asset('assets/logo_m2v_n2.jpg',
                    height: 200, width: 200),
              ),
              SizedBox(
                height: 100.0,
              ),
              Container(
                child: Text(
                  "Copyright M2V Rimuru Code",
                  style: TextStyle(fontSize: 14, color: Color(0xff29455b)),
                ),
              ),
            ],
          ),
        ));
  }
}
