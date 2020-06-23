import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:opin1on8/home.dart';
import 'package:opin1on8/providers/user.dart';
import 'package:provider/provider.dart';
import 'components/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;

  void storeUser(FirebaseUser userData) async {
    await Firestore.instance
        .collection("users")
        .document(userData.uid)
        .setData({
      'name': userData.displayName,
      'email': userData.email,
    });
  }

  void _showUserNotFoundDialog(String header, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(header),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg1.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedButton(
                  title: 'Log In With Google',
                  colour: Colors.deepPurpleAccent,
                  onPressed: () {
                    setState(() {
                      showSpinner = true;
                    });

                    Provider.of<User>(context)
                        .signInWithGoogle()
                        .then((FirebaseUser user) {
                      storeUser(user);

                      setState(() {
                        showSpinner = false;
                      });

                      Navigator.of(context).pushReplacementNamed(HomeScreen.id);
                    }).catchError((e) {
                      print(e);
                      setState(() {
                        showSpinner = false;
                        _showUserNotFoundDialog(e.code, e.message);
                      });
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
