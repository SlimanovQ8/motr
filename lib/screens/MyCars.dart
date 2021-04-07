import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/main.dart';
import 'package:Motri/models/lang.dart';
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

void main() => runApp(MyCars());

class MyCars extends StatelessWidget {


  @override
  Language engLang = new Language(1, 'English', 'U+1F1FA', 'en');
  Language arabLang = new Language(2, 'Arabic', 'U+1F1F0', 'ar');


  Widget build(BuildContext context) {
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
      MyApp.setLocale(context, _temp);



    }



    return MaterialApp(

      title: 'My Cars',
      home: Scaffold(
        appBar: AppBar(



          leading:  IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).push(

              MaterialPageRoute(builder: (BuildContext ctx) => MainMotri()),),

          ),


          title:  Text("My Cars", style: TextStyle(
            color: Colors.black,
          ),)
          ,
          backgroundColor: Color(0xfff7892b),

        ),

        body: Center(
          child: SectionWidget(),
        ),
      ),
    );
  }
}