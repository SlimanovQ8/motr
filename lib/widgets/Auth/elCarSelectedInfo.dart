import 'package:Motri/screens/CarInsurance.dart';
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

class CarSelectedInfo extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<CarSelectedInfo> {
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
        leading: const Icon(Icons.person),
        title: const Text('Car Owner Name'),
        subtitle:  Text(snapshot.data.docs[0].get('Car Owner Name')),
        ),
          const Divider(
            color: Colors.black,
            height: 4.0,
          ),
          new ListTile(
            leading: const Icon(Icons.car_rental),
            title: const Text('Car Make'),
            subtitle:  Text(snapshot.data.docs[0].get('Car Make')),         ),
          const Divider(
            color: Colors.black,
            height: 4.0,
          ),
        new ListTile(
        leading: const Icon(Icons.directions_car_rounded),
        title: const Text('Car Name'),
        subtitle:  Text(snapshot.data.docs[0].get('Car Name')),
        ),
          const Divider(
            color: Colors.black,
            height: 4.0,
          ),
          new ListTile(
            leading: const Icon(Icons.electric_car_sharp),
            title: const Text('Car Year'),
            subtitle:  Text(snapshot.data.docs[0].get('Car Year')),

          ),
          const Divider(
            color: Colors.black,
            height:  4.0,
          ),
          new ListTile(
            leading: const Icon(Icons.electric_car_sharp),
            title: const Text('Plate Number'),
            subtitle:  Text(snapshot.data.docs[0].get('Plate Number')),

          ),
          const Divider(
            color: Colors.black,
            height: 4.0,
          ),

          new ListTile(
            leading: const Icon(Icons.details),
            title: const Text('Additional Information'),
            subtitle:  Text('Weight: ' + snapshot.data.docs[0].get('Weight') + '\t' + ',         Height: ' + snapshot.data.docs[0].get('Height') + '\n' + 'Color: ' + snapshot.data.docs[0].get('Color') + '\t' + ',      Passenger: ' + snapshot.data.docs[0].get('Passenger'))
          ),
          const Divider(
            color: Colors.black,
            height: 4.0,
          ),
          new Container(
              padding: const EdgeInsets.only(left: 20.0, top: 20.0),
              child: new RaisedButton(
                color: Color(0xfff7892b),
                child: const Text('Car Insurance'),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => CarInsurance())
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
