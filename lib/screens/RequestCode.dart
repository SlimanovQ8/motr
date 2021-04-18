import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/main.dart';
import 'package:Motri/models/lang.dart';
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
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

void main() => runApp(RequestCode());

class RequestCode extends StatelessWidget {


  @override
  Language engLang = new Language(1, 'English', 'U+1F1FA', 'en');
  Language arabLang = new Language(2, 'Arabic', 'U+1F1F0', 'ar');


  Widget build(BuildContext context) {
    final List<Features> GridFeatures = [
    Features(
      title: 'For myself',
      image: 'images/SelfTrans.png',
    ),
    Features(
    title: 'For my dependent',
    image: 'images/ChildTrans.png',
    ) ];
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


    return Scaffold(



      appBar: AppBar(
        title: Text("Request Code"),
        backgroundColor: Color(0xfff7892b),
        leading:  IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, ),

          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => MainMotri()),),

        ),
      ),

      body: Container(
        alignment: Alignment.center,
          child:  GridView.builder(
            padding: const EdgeInsets.all(20.0),




            itemCount: 2,
            shrinkWrap: true,
            itemBuilder: (ctx, i) =>
                MainFeaturesForm(
                  GridFeatures[i].title,
                  GridFeatures[i].image,
                ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,

              crossAxisSpacing: 25,

              mainAxisSpacing: 12.5,

            ),)
        ,
        /*GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: GridFeatures.length,
        itemBuilder: (ctx, i) => MainFeaturesForm(
          GridFeatures[i].title,
          GridFeatures[i].image,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
*/
      ),


    );
  }
}