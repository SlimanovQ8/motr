import 'package:Motri/main.dart';
import 'package:Motri/widgets/Auth/auth_form.dart';
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
import 'addCar.dart';

void main() => runApp(ok());

class ok extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Cars',
      home: Scaffold(
        appBar: AppBar(

          leading:  IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MyApp()),),

          ),
          title: Text('Add Car')
          ,
          backgroundColor: Color(0xfff7892b),

        ),

        body: Center(
          child: Text('Thank you. Your request has been sent to MOI. Your Car will be added within 24 hour if it is yours', textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18), ) ,


        ),

        bottomNavigationBar:
        FloatingActionButton(
          onPressed: () {Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => addCar()),
          ); },
          child: Icon(Icons.add),
          backgroundColor: Color(0xfff7892b),
        ),

      ),
    );
  }
}