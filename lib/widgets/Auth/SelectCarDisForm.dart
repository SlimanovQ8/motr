import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/addCar.dart';
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
import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/models/lang.dart';

import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../../main.dart';

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

class SelectDisForm extends StatefulWidget {
  SelectDis createState() => new SelectDis();
}

class SelectDis extends State<SelectDisForm> {
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
  void changeLang(Language lang) {
    Locale _temp;
    switch (lang.langCode) {
      case 'en':
        _temp = Locale(lang.langCode, 'US');
        break;
      case 'ar':
        _temp = Locale(lang.langCode, 'KW');
        break;
      default:
        _temp = Locale('en', 'US');
        break;
    }
    MyApp.setLocale(context, _temp);
  }

  Language engLang = new Language(1, 'English', 'U+1F1FA', 'en');
  Language arabLang = new Language(2, 'Arabic', 'U+1F1F0', 'ar');

  Future<void> initState() {
    /*if (SetLocalization.of(context).getTranslateValue('App_Name').compareTo('Motri') == 0)
    {

      changeLang(engLang);
    }
    else
    {
      changeLang(arabLang);
    }*/
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
          } else if (snapshot.data.docs.length == 0) {
            return Container(
              child: Center(
                child: Text(
                  'You have no cars yet. To add a car please click on add sign button',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            print(snapshot.data.docs.length);

     /*  [     SingleChildScrollView(
              child: Container (
                child: Column (
                  children: [

                  ],
                ),
              ),
            )*/
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                    ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, int i) {
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
                    child: Card(
                      elevation: 8.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        height: 80,
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(224, 224, 224, .9)),
                        child: ListTile(
                          leading: Container(
                            padding: EdgeInsets.only(right: 12.0),
                            decoration: new BoxDecoration(
                                border: new Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.black))),
                            child: Icon(
                              Icons.car_rental,
                              size: 35,
                            ),
                          ),
                          title: Text(
                            snapshot.data.docs[i].get('Car Make') +
                                "\n" +
                                snapshot.data.docs[i].get('Car Name'),
                            style: TextStyle(color: Colors.black),
                          ),
                          subtitle: Text(
                            snapshot.data.docs[i].get('Plate Number'),
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            int buj = i;
                            FirebaseFirestore.instance
                                .collection('Cars')
                                .doc(snapshot.data.docs[i].id)
                                .update({
                              'isSelected': 'true',
                            });

                            for (var b = 0; b < snapshot.data.docs.length; b++)
                              if (b != buj) {
                                FirebaseFirestore.instance
                                    .collection('Cars')
                                    .doc(snapshot.data.docs[b].id)
                                    .update({'isSelected': 'false'});
                              }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => AddDisability()),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
