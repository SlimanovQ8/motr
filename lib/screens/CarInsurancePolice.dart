import 'package:Motri/screens/CarInfo.dart';
import 'package:Motri/screens/CarInfoAll.dart';
import 'package:Motri/screens/CarInfoAllPolice.dart';
import 'package:Motri/widgets/Auth/CarInsuranceInfo.dart';
import 'package:Motri/widgets/Auth/CarInsuranceInfoPolice.dart';
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
import 'mySelectedCar.dart';

void main() => runApp(CarInsurancePolice());

class CarInsurancePolice extends StatelessWidget {
  @override
  Future<String> getPlateNumber() async {
    final CollectionReference users = firestore.collection('MOI');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('PlateNumber');
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A',
      home: Scaffold(
        appBar: AppBar(

          leading:  IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, ),

            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => AllCarInfoPolice()),),

          ),
          title: Text('Car Insurance (Police)', style: TextStyle(
              color: Colors.black
          ),),



          backgroundColor: Color(0xfff7892b),

        ),

        body: Center(
          child: CarInsuranceInfoPolice(),
        ),
      ),
    );
  }
}