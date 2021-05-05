import 'package:Motri/screens/ChangeEmail.dart';
import 'package:Motri/screens/ChangePassword.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/widgets/Auth/ChangeEmailForm.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:core';
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class EditMyProfile extends StatefulWidget {
  MyProfile createState() => new MyProfile();
}

class MyProfile extends State<EditMyProfile> {

  @override

  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Container(
      alignment: Alignment.center,
      child: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('Users').where('email', isEqualTo : auth.currentUser.email).get(),
          // ignore: missing_return
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {

              print(snapshot.data.docs.length);

              return Center(

                child: Container(


                child: ListView( children: <Widget>[
                  Padding( padding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: 20.0),
                  child : Card(

                    elevation: 8.0,
                    margin: new EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 6.0),
                  child: Container(
                      height: 120,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(
                              224, 224, 224, .9)),
                  child: ListTile(

                    leading: Icon(Icons.person),
                    title: Text("Name: " +
                        snapshot.data.docs[0].get('Name') +
                        "\n" +
                        "Username: " +
                        snapshot.data.docs[0].get('UserName') +
                        "\n" +
                        "Civil ID: " +
                        snapshot.data.docs[0].get('Civil ID')),
                    subtitle: Text(snapshot.data.docs[0].get('email')),
                  ),
                  ),
                  ),
                  ),

                  SizedBox(
                  height: 12,
                ),
                new Container(
                  padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                    child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Color(0xfff7892b),
                  child: const Text('Change Email'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ChangeEmail()),);
                  },
                ),),
                SizedBox(
                  height: 4,
                ),
                new Container(
                    padding: EdgeInsets.only(left: 15, right: 15),

                    child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  color: Color(0xfff7892b),
                  child: const Text('Change Password'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => ChangePsssword()),);
                  },
                ),)
              ]),
            ),);
          }
        },
      ),
    );
    return new Container(
        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
        child: new RaisedButton(
          color: HexColor("F4C63F"),
          child: const Text('Submit'),
          onPressed: () {},
        ));
  }
}
