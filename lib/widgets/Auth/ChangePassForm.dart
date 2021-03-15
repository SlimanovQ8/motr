import 'package:Motri/screens/Main.dart';
import 'package:Motri/screens/addCar.dart';
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

class ChangeMyPass extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ChangeMyPass> {
  final _auth = FirebaseAuth.instance;
  static GlobalObjectKey<ScaffoldState> _formKeym;

  bool checkPlateNum(String PlateNumber) {}
  var _isLoading = false;
  bool isExist = true;
  bool isEqual = true;
  bool reAuthenticate = false;
  bool isEmptyNew = true;
  bool isEmptyNewC = true;
  bool isLessThan7New = true;

  void _sumbitAuthForm(String CPassword, String NewPassword,
      String NewPasswordConfirmation, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });

      final snapShot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(_auth.currentUser.uid)
          .get();
      print(snapShot.id);
      String b = snapShot.get('psssword');
      print(b);
      if (b.compareTo(CPassword) == 0) {
        //it exists
        setState(() {
          isExist = true;
        });
      } else {
        //not exists
        setState(() {
          isExist = false;
        });
      }
      if (NewPassword.compareTo(NewPasswordConfirmation) == 0) {
        //it exists
        setState(() {
          isEqual = true;
        });
      } else {
        //not exists
        setState(() {
          isEqual = false;
        });
      }
      if (NewPassword.length > 6) {
        //it exists
        setState(() {
          isLessThan7New = true;
        });
      } else {
        //not exists
        setState(() {
          isLessThan7New = false;
        });
      }
      final u = _auth.currentUser;

      final cred =
          EmailAuthProvider.credential(email: u.email, password: CPassword);
      if (isEqual && isExist && isLessThan7New) {
        await u.reauthenticateWithCredential(cred);
        reAuthenticate = true;
        if (reAuthenticate) {
          await u.updatePassword(NewPassword);

          FirebaseFirestore.instance
              .collection('Users')
              .doc(snapShot.id)
              .update({'psssword': NewPassword}).then((value) {
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: new Text("Password changed successfully "),

                  actions: <Widget>[
                    FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => MyApp())
                        );
                        _isLoading = false;
                      },
                    )
                  ],
                ));
              }
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  void initState() {
    super.initState();
  }

  @override
  String PasswordN = '';
  String Password = '';
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
                    obscureText: true,
                    decoration: const InputDecoration(

                      hintText: 'Enter your Current Password',
                      labelText: 'Current Password',
                    ),
                    validator: (b) {
                      if (!isExist) {
                        return 'the password is incorrect';
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
                  new TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter new  Password',
                      labelText: 'New Password',
                    ),
                    validator: (b) {
                      if (!isLessThan7New) {
                        return 'Password should be at least 6 characters';
                      }
                      return null;
                    },
                    onChanged: (String s) {
                      setState(() {
                        PasswordN = s;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Repeat new password',
                      labelText: 'Repeat new Password',
                    ),
                    validator: (b) {
                      if (!isEqual) {
                        return 'the password does not match';
                      }
                      return null;
                    },
                    onChanged: (String s) {
                      setState(() {
                        PasswordC = s;
                      });
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                  if (!_isLoading &&
                      PasswordC.length > 0 &&
                      Password.length > 0 &&
                      PasswordN.length > 0)
                    new Container(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Color(0xfff7892b),
                          child: const Text('Change Password'),
                          onPressed: () {
                            _sumbitAuthForm(
                              Password,
                              PasswordN,
                              PasswordC,
                              context,
                            );

                          },

                        )
                    )
                  else
                    new Container(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          color: Colors.orange,
                          child: const Text('Change Password'),
                        )),
                ],
              ))),
    );
  }
}
