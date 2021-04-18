import 'package:Motri/main.dart';
import 'package:Motri/screens/CarInfo.dart';
import 'package:Motri/widgets/Auth/CarInfoAllForm.dart';
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:Motri/widgets/Auth/myCarInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mainFeatures.dart';
import '../widgets/Auth/mainFeatures_form.dart';
import 'package:Motri/screens/AuthFirebase.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Main.dart';

import 'package:flutter/material.dart';
import '../widgets/Auth/myCarsForm.dart';

void main() => runApp(AllCarInfo());

class AllCarInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Info',

      home: Scaffold(
        appBar: AppBar(

          leading:  IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MyCarsInfo()),),

          ),
          title: Text('Car Info', style: TextStyle(
              color: Colors.black
          ) ,)
          ,
          backgroundColor: Color(0xfff7892b),

        ),

        body: Center(
          child: AllInfo(),
        ),
      ),
    );
  }
}