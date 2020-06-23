import 'package:flutter/material.dart';
import 'package:opin1on8/components/rounded_button.dart';
import 'package:opin1on8/login.dart';
import 'package:provider/provider.dart';
import 'providers/user.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Center(
      // heightFactor: size.height * .0020,
      child: Column(
        children: [
          Container(
            // width: size.width * .90,
            // height: size.height * .050,
            child: RoundedButton(
              colour: Colors.red,
              title: 'Log Out',
              onPressed: () {
                Provider.of<User>(context).signOut().whenComplete(() {
                  Navigator.pushReplacementNamed(context, LoginScreen.id);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
