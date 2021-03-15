
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




  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> getCivilID() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;


    final result = await users.doc(uid).get();
    return result.get('Civil ID');
  }

  String b = ';';
  void changeLang(Language lang)
  {
    Locale _temp;
    switch(lang.langCode)
    {
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



  }
  Language engLang = new Language(1, 'English', 'U+1F1FA', 'en');
  Language arabLang = new Language(2, 'Arabic', 'U+1F1F0', 'ar');

  Future<void> initState()  {

    /*if (SetLocalization.of(context).getTranslateValue('App_Name').compareTo('Motri') == 0)
    {

      changeLang(engLang);
    }
    else
    {
      changeLang(arabLang);
    }*/
  }

  Widget build(BuildContext context) {

    return new Scaffold (
        body: FutureBuilder  (
          future: FirebaseFirestore.instance.collection('Cars').where('UserID', isEqualTo: auth.currentUser.uid).where('isVerified', isEqualTo: true.toString()) .get(),
          builder: (context, AsyncSnapshot <QuerySnapshot> snapshot) {
            if (snapshot.data == null) {
              return Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            else if (snapshot.data.docs.length == 0)
            {
              return Container(
                child: Center(
                  child: Text('You have no cars yet. To add a car please click on add sign button', textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),),

                ),
              );
            }
            else
            {
              print (snapshot.data.docs.length);

              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),

                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, int i)
                {
                  return ListTile(
                    leading: Icon(Icons.car_rental),
                    title: Text(snapshot.data.docs[i].get('Car Make') + "\n" + snapshot.data.docs[i].get('Car Name')),
                    subtitle: Text(snapshot.data.docs[i].get('Plate Number')),
                  );
                },
              );
            }
          },
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => addCar()),
          ); },
          child: Icon(Icons.add),
          backgroundColor: Color(0xfff7892b),
        )
    );

  }

