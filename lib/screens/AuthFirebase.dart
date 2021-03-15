import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();

}

String Name;
String CID;
String Email;



class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  AuthScreen As = new AuthScreen();

  var _isLoading = false;

  void _sumbitAuthForm(String name, String CivilID, String email,
      String password, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('Users').doc(authResult.user.uid).set({
          'Name': name,
          'Civil ID': CivilID,
          'email': email,
          'psssword': password
        });
      }
      ;


    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;

        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme
                .of(ctx)
                .errorColor,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Authform(
        _sumbitAuthForm,
        _isLoading,
      ),
    );
  }
}
