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

void main() => runApp(AlreadySelf());

class AlreadySelf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OK Self',
      home: Scaffold(
        appBar: AppBar(

          leading:  IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MainMotri()),),

          ),
          title: Text('Request sent')
          ,
          backgroundColor: Color(0xfff7892b),

        ),

        body: Center(
          child: Text('You already make a request for the MOI.', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18), ) ,




        ),

        bottomNavigationBar:
        new RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
          color: Color(0xfff7892b),
          child: const Text('Home'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MainMotri()),);
          },
        ),
      ),
    );
  }
}