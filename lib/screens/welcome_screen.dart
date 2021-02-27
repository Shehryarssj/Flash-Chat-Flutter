import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../widgets.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
    _animation.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset(
                      'images/logo.png',
                    ),
                    height: _animation.value * 80,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  repeatForever: false,
                  totalRepeatCount: 2,
                  text: ['Flash Chat'],
                  speed: Duration(milliseconds: 130),
                  textStyle: TextStyle(
                      fontSize: 45.0,
                      fontWeight: FontWeight.w900,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            ReusableButton(
              colour: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () {
                Navigator.pushNamed(context, 'login_screen');
              },
            ),
            ReusableButton(
              colour: Colors.blueAccent,
              title: 'Register',
              onPressed: () {
                Navigator.pushNamed(context, 'registration_screen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
