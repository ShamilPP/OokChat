import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ook_chat/constants/app_icons.dart';

import '../../chat/screens/chat_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 500)).then((result) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatScreen()));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SizedBox(
            height: 200,
            width: 200,
            child: Image.asset(AppIcons.appIcon),
          ),
        ),
      ),
    );
  }
}
