import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:texting_app/screens/login_screen.dart';
import 'package:texting_app/screens/registration_screen.dart';
import 'package:texting_app/components/Rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = "welcome_screen";

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {

    controller =
        AnimationController(duration: Duration(seconds: 3), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    super.initState();
    controller.forward();

    controller.addListener(() {
      setState(() {});
      print(animation.value);
    });
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Flexible(
                  child: Hero(
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60,
                    ),
                    tag: "s",
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: const Duration(milliseconds: 200),
                  text: ['Flash Cart'],
                  textStyle: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            roundedBox(
              color: Colors.lightBlueAccent,
              title: 'Log In',
              onPressed: () =>
                  Navigator.pushNamed(context, LoginScreen.id)
              //Go to login screen.,
            ),
            roundedBox(
                color: Colors.blueAccent,
                title: 'Regesteration',
                onPressed: () =>
                    Navigator.pushNamed(context, RegistrationScreen.id)
            ),
          ],
        ),
      ),
    );
  }
}
