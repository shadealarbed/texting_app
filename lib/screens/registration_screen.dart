import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:texting_app/components/Rounded_button.dart';
import 'package:texting_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:texting_app/screens/chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  bool b = true;
  bool show = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: show,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                  tag: "s",
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: kTextFieldDecoraation.copyWith(
                      hintText: 'Enter your Email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: b,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoraation.copyWith(
                    hintText: 'Enter your password'),
              ),
              FlatButton(
                  onPressed: () {
                    setState(() {
                      if (b == true) {
                        b = false;
                      } else {
                        b = true;
                      }
                    });
                  },
                  child: Icon(Icons.remove_red_eye_outlined)),
              SizedBox(
                height: 24.0,
              ),
              roundedBox(
                  color: Colors.blueAccent,
                  title: 'Regester',
                  onPressed: () async {
                    setState(() {
                      show = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                      setState(() {
                        show = false;
                      });
                      setState(() {
                        show=false;
                      });
                    } catch (e) {
                      print(e);
                      setState(() {
                        show = false;
                      });
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
