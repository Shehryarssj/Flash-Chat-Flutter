import 'package:flutter/material.dart';
import '../widgets.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String _email, _password;
  final _auth = FirebaseAuth.instance;
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
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
              onChanged: (value) {
                _email = value;
              },
              decoration:
                  kTextFieldDecoration.copyWith(hintText: 'Enter Your Email'),
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              obscureText: true,
              style: TextStyle(color: Colors.black),
              textAlign: TextAlign.center,
              onChanged: (value) {
                _password = value;
              },
              decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter Your Password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            ReusableButton(
              colour: Colors.blueAccent,
              title: 'Register',
              onPressed: () async {
                Loader.show(context,
                    progressIndicator: CircularProgressIndicator());
                try {
                  final newUser = await _auth.createUserWithEmailAndPassword(
                      email: _email, password: _password);
                  if (newUser != null) {
                    Loader.hide();
                    Navigator.pushNamed(context, 'chat_screen');
                  }
                } catch (e) {
                  Loader.hide();
                  print(e);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
