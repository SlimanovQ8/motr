import 'package:flutter/material.dart';

import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/models/lang.dart';
import 'package:Motri/screens/EditProfile.dart';
import 'package:Motri/screens/MyCars.dart';
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:Motri/widgets/Auth/myCarInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../models/mainFeatures.dart';
import '../widgets/Auth/mainFeatures_form.dart';
import 'package:Motri/screens/AuthFirebase.dart';
import 'package:hexcolor/hexcolor.dart';

class test extends StatefulWidget {
  @override
  _xcddxState createState() => _xcddxState();
}

class _xcddxState extends State<test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("word"),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          int count = 2;
          if (orientation == Orientation.landscape) {
            count = 3;
          }
          return GridView.count(
            crossAxisCount: count,
            children: <Widget>[
              RaisedButton.icon(
                onPressed: () {},
                label: Text('Park In', style: TextStyle(fontSize: 15.0)),
                icon: Icon(Icons.add),
              ),
              RaisedButton.icon(
                onPressed: () {},
                label: Text('Park Out', style: TextStyle(fontSize: 15.0)),
                icon: Icon(Icons.eject),
              ),
              RaisedButton.icon(
                onPressed: () {},
                label:
                Text('Maintainence In', style: TextStyle(fontSize: 15.0)),
                icon: Image.asset(
                  'images/bk.jpg',
                ),
              ),
              RaisedButton.icon(
                onPressed: () {},
                label:
                Text('Maintainence Out', style: TextStyle(fontSize: 15.0)),
                icon: Icon(Icons.vertical_align_top),
              ),
              RaisedButton.icon(
                onPressed: null,
                label: Text('Move', style: TextStyle(fontSize: 15.0)),
                icon: Icon(Icons.open_with),
              ),
            ],
          );
        },
      ),
    );
  }
}