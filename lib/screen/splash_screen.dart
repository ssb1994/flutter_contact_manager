import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './authenticate/sign_in.dart';
import './home/home_screen.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> _splashTimerFunction() async {
    await Future.delayed(
        Duration(
          seconds: 5,
        ),
        () {});
    try {
      final result = await FirebaseAuth.instance.currentUser();
      if (result == null) {
        Navigator.pushNamedAndRemoveUntil(
            context, SignIn.routeName, (Route<dynamic> route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.routeName, (Route<dynamic> route) => false);
      }
    } catch (error) {
      print('splash error ' + error.toString());
      Navigator.pushNamedAndRemoveUntil(
          context, SignIn.routeName, (Route<dynamic> route) => false);
    }
  }

  @override
  void initState() {
    _splashTimerFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Shimmer.fromColors(
                child: Icon(
                  Icons.computer,
                  size: 100,
                ),
                baseColor: Color(0xff7f00ff),
                highlightColor: Color(0xffe100ff)),
            Shimmer.fromColors(
                child: Text(
                  'Contact Manager',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 35,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                baseColor: Color(0xff7f00ff),
                highlightColor: Color(0xffe100ff)),
          ],
        ),
      ),
    );
  }
}
