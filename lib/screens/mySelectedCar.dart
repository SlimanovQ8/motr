import 'package:Motri/screens/CarInfo.dart';
import 'package:Motri/screens/Generate.dart';
import 'package:Motri/widgets/Auth/addCarForm.dart';
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:Motri/widgets/Auth/elCarSelectedInfo.dart';
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
import 'MyCars.dart';

void main() => runApp(CarSelected());

class CarSelected extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add Car',
      home: Scaffold(
        appBar: AppBar(

          leading:  IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, ),

            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => GenerateScreen()),),

          ),
          title: Text('Car Info'),



          backgroundColor: Color(0xfff7892b),

        ),

        body: Center(
          child: CarSelectedInfo(),
        ),
      ),
    );
  }
}