import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User with ChangeNotifier {
  FirebaseUser _user;

  User() {
    FirebaseAuth.instance.currentUser().then((userData) {
      _user = userData;
      print("The user is: ${_user.displayName}");
    }).catchError((onError) {
      print(onError);
    });
  }

  FirebaseUser get user {
    return _user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    _user = user;
    notifyListeners();

    return user;
  }

  Future<String> signOut() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _auth.signOut();
    print(' sign out');

    _user = null;
    notifyListeners();

    return 'error';
  }
}
