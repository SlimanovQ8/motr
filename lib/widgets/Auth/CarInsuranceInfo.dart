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

class CarInsuranceInfo extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<CarInsuranceInfo> {
  var _isLoading = false;
  bool isExist = false;
  String userEmail = FirebaseAuth.instance.currentUser.email;
  String use = FirebaseAuth.instance.currentUser.uid;
  var userName = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .id;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> getUserName() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('Name');
  }

  Future<String> getCivilID() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('Civil ID');
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController PN = TextEditingController();

  String YR = '';

  void initState() {
    super.initState();
  }

  String _color = '';
  String CarM = '';
  String PlN = '';

  @override
  String selectedFc = '';
  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Cars')
            .where('UserID', isEqualTo: auth.currentUser.uid)
            .where('isVerified', isEqualTo: true.toString())
            .where('isSelected', isEqualTo: 'true')
            .get(),
        builder: (context, AsyncSnapshot <QuerySnapshot> snapshot)
        {
          if (snapshot.data == null)
            return Center(
              child: CircularProgressIndicator(),
            );
          else
          {
            return  SingleChildScrollView(child: new Column(
              children: <Widget>[

                new ListTile(
                  leading: const Icon(Icons.store),
                  title: const Text('Insurance Company'),
                  subtitle:  Text(snapshot.data.docs[0].get('Insurance Company')),
                ),
                const Divider(
                  color: Colors.black,
                  height: 4.0,
                ),
                new ListTile(
                  leading: const Icon(Icons.public),
                  title: const Text('Insurance type'),
                  subtitle:  Text(snapshot.data.docs[0].get('Insurance type')),
                ),
                const Divider(
                  color: Colors.black,
                  height: 4.0,
                ),
                new ListTile(
                  leading: const Icon(Icons.confirmation_num),
                  title: const Text('Document No'),
                  subtitle:  Text(snapshot.data.docs[0].get('Document No')),
                ),
                const Divider(
                  color: Colors.black,
                  height: 4.0,
                ),
                new ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Expire Date'),
                  subtitle:  Text(snapshot.data.docs[0].get('Expire Date')),

                ),
                const Divider(
                  color: Colors.black,
                  height:  4.0,
                ),

                new Container(
                    padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                    child: new RaisedButton(
                      color: Color(0xfff7892b),
                      child: const Text('Home Page'),
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => MainMotri())
                        );
                      },
                    ))
              ],
            )
            );


          }
        },
      ),
    );
  }
}
