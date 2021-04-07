import 'package:Motri/screens/Main.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/screens/loginPage.dart';
import 'package:Motri/screens/ok.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class ChangeMyEmail extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ChangeMyEmail> {
  final _auth = FirebaseAuth.instance;
  static GlobalObjectKey<ScaffoldState> _formKeym;

  var _isLoading = false;
  bool isExist = true;
  bool isEqual = true;
  bool reAuthenticate = false;
  bool isMatch = true;
  bool isEmptyNewC = true;
  bool isGreaterThan7New = true;
  bool isValid = true;
  bool isSame = false;
  bool isRegistered = false;

  void _sumbitAuthForm(String Email, String Password,
        BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
        isExist = true;
        isEqual = true;
        reAuthenticate = false;
        isMatch = true;
        isEmptyNewC = true;
        isGreaterThan7New = true;
        isValid = true;
        isSame = false;
        isRegistered = false;
      });

      final snapShot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser.uid)
          .get();
      final ss = await FirebaseFirestore.instance.collection('Users').get();
      for (var i = 0; i < ss.docs.length; i++)
        {
          if(Email.compareTo(ss.docs[i].get('email')) == 0) {
            isRegistered = true;
            break;
          }
        }
      print(ss.docs.length);
      print(ss.size);
      print(snapShot.id);
      String b = snapShot.get('psssword');
      if (Email.compareTo(_auth.currentUser.email) == 0)
        {
          setState(() {
            isSame = true;
          });
        }
      else 
        {
          setState(() {
            isSame = false;
          });
        }
      
      if (!Email.contains("@") || !Email.contains(".") || Email.contains(' ')) {
        //it exists
        setState(() {
          isValid = false;
          
        });
      } else {
        //not exists
        setState(() {
          isValid = true;
        });
      } if (b.compareTo(Password) == 0) {
        //it exists
        setState(() {
          isMatch = true;
        });
      } else {
        //not exists
        setState(() {
          isMatch = false;
        });
      }

      if (Password.length > 7) {
        //it exists
        setState(() {
          isGreaterThan7New = true;
        });
      } else {
        //not exists
        setState(() {
          isGreaterThan7New = false;
        });
      }
      final u = _auth.currentUser;

      final cred =
      EmailAuthProvider.credential(email: u.email, password: Password);
      if ( isGreaterThan7New && isMatch && isValid && !isSame && !isRegistered) {
        await u.reauthenticateWithCredential(cred);
        reAuthenticate = true;
        if (reAuthenticate) {
          await u.updateEmail(Email);

          FirebaseFirestore.instance
              .collection('Users')
              .doc(snapShot.id)
              .update({'email': Email.toLowerCase()});
          FirebaseAuth.instance.signOut();
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                title: new Text("Email changed successfully "),
                actions: <Widget>[
                  FlatButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');

                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => LoginPage())
                      );
                      _isLoading = false;
                    },
                  )
                ],
              ));

        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
        isExist = false;
      });
      print(err);
    }
  }

  void initState() {
    super.initState();
  }

  @override
  String Password = '';
  String NewEmail = '';
  String PasswordC = '';
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKeym,
              autovalidateMode: AutovalidateMode.always,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(

                      hintText: 'Enter Your New Email',
                      labelText: 'New Email',
                    ),
                    validator: (b) {
                      if (!isValid) {
                        return 'the email is badly formatted';
                      }
                      if (isSame)
                        return " The new email that you entered is the same current email";
                      if (isRegistered)
                        return "The email is already exists in the app";
                      return null;
                    },
                    onChanged: (String s) {
                      setState(() {
                        NewEmail = s;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter Password',
                      labelText: ' Password',
                    ),
                    validator: (b) {
                      if (!isMatch) {
                        return 'Password is Incorrect';
                      }
                      return null;
                    },
                    onChanged: (String s) {
                      setState(() {
                        Password = s;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  if (_isLoading)
                    Center(child: CircularProgressIndicator()),
                  if (!_isLoading &&
                      PasswordC.length > 0 &&
                      NewEmail.length > 0 )
                    new Container(
                        padding: EdgeInsets.all(15),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Color(0xfff7892b),
                          child: const Text('Change Email'),
                          onPressed: () {
                            _sumbitAuthForm(
                              NewEmail,
                              Password,

                              context,
                            );

                          },

                        )
                    )
                  else
                    new Container(
                        padding: const EdgeInsets.all(15),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.orange,
                          child: const Text('Change Email'),
                        )),
                ],
              ))),
    );
  }
}
