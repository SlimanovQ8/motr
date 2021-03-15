import 'package:Motri/screens/Generate.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/screens/mySelectedCar.dart';
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
import 'package:http/http.dart' as http;

import 'dart:io';

import 'package:path_provider/path_provider.dart';

class getUserCars {
  String _CarMake;
  String _CarName;
  int _CarYear;
  String _CarPlateNumber;
  bool _isSelected;

  getUserCars(this._CarMake, this._CarName, this._CarYear, this._CarPlateNumber,
      this._isSelected);

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  String get CarPlateNumber => _CarPlateNumber;

  set CarPlateNumber(String value) {
    _CarPlateNumber = value;
  }

  int get CarYear => _CarYear;

  set CarYear(int value) {
    _CarYear = value;
  }

  String get CarName => _CarName;

  set CarName(String value) {
    _CarName = value;
  }

  String get CarMake => _CarMake;

  set CarMake(String value) {
    _CarMake = value;
  }
}

class myCars extends StatefulWidget {
  _myCars createState() => new _myCars();
}

class _myCars extends State<myCars> {
  List<String> _items = List<String>();
  List<getUserCars> Uc = List<getUserCars>();
  @override
  /*Future getCars() async {
    List<DocumentSnapshot> docs;
    String fc = await getCivilID();
    print(fc);
   var QSS = await FirebaseFirestore.instance.collection('Cars')

      .where("Car Owner Civil ID", isEqualTo: "f" )
          .get();

   print(docs.length);



    List <getUserCars> GUC = new List ();
    for (var i = 0; i < docs.length; i++)
      {
        String CM = docs[i]['Car Make'];
        String CN = docs[i]['Car Name'];
        int CY = int.parse(docs[i]['Car Year']);
        String CPN = docs[i]['Plate Number'];
        getUserCars newCar = new getUserCars(CM, CN, CY, CPN, false);
        GUC.add(newCar);
      }
    return QSS;
  }*/

  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> getCivilID() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('Civil ID');
  }

  String b = ';';
  Future<void> initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Cars')
            .where('UserID', isEqualTo: auth.currentUser.uid)
            .where('isVerified', isEqualTo: true.toString())
            .get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            print(snapshot.data.docs.length);

            return ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, int i) {
                return ListTile(
                  leading: Icon(Icons.car_rental),
                  title: Text(snapshot.data.docs[i].get('Car Make') +
                      "\n" +
                      snapshot.data.docs[i].get('Car Name')),
                  subtitle: Text(snapshot.data.docs[i].get('Plate Number')),
                  onTap: () {
                    int buj = i;
                    FirebaseFirestore.instance
                        .collection('Cars')
                        .doc(snapshot.data.docs[i].id)
                        .update({
                      'isSelected': 'true',
                    });
                    if (snapshot.data.docs[i].get('Color') =='')
                      {
                    if (buj == 0) {
                      print(buj);
                      FirebaseFirestore.instance
                          .collection('Cars')
                          .doc(snapshot.data.docs[i].id)
                          .update({
                        'Color': 'black',
                        'Passenger': '4',
                        'Weight': '1.330',
                        'Height': '1.420',
                        'Insurance Company': 'Kuwait  Insurance Company',
                        'Insurance type': 'Private',
                        'Car Reference': '1276905',
                        'Document No': '2299365475l560',
                        'Expire Date': '22/8/2023',
                      });
                    } else if (i == 1) {
                      FirebaseFirestore.instance
                          .collection('Cars')
                          .doc(snapshot.data.docs[i].id)
                          .update({
                        'Color': 'grey',
                        'Passenger': '4',
                        'Weight': '1.200',
                        'Height': '1.220',
                        'Insurance Company': 'Ghazal Insurance Company',
                        'Insurance type': 'Private',
                        'Car Reference': '22434345',
                        'Document No': '22089647520',
                        'Expire Date': '26/5/2022',
                      });
                    } else if (i == 2) {
                      FirebaseFirestore.instance
                          .collection('Cars')
                          .doc(snapshot.data.docs[i].id)
                          .update({
                        'Color': 'Red',
                        'Passenger': '4',
                        'Weight': '1.240',
                        'Height': '1.340',
                        'Insurance Company': 'Warba Insurance Company',
                        'Insurance type': 'Private',
                        'Car Reference': '144456345',
                        'Document No': '20096547720',
                        'Expire Date': '1/1/2022',
                      });
                    }

                    }
                    for (var b = 0; b < snapshot.data.docs.length; b++)
                      if (b != buj) {
                        FirebaseFirestore.instance
                            .collection('Cars')
                            .doc(snapshot.data.docs[b].id)
                            .update({'isSelected': 'false'});
                      }
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => GenerateScreen()),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
