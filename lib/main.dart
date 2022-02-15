import 'package:flutter/material.dart';
import 'package:texting_app/screens/welcome_screen.dart';
import 'package:texting_app/screens/login_screen.dart';
import 'package:texting_app/screens/registration_screen.dart';
import 'package:texting_app/screens/chat_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen()
      },
    );
  }
}
