import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/main.dart';
import 'package:Motri/models/lang.dart';
import 'package:Motri/screens/PoliceEditProfile.dart';
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
import 'EditProfile.dart';
import 'Main.dart';

import 'package:flutter/material.dart';
import '../widgets/Auth/myCarsForm.dart';
import 'MyCars.dart';
import 'loginPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() => runApp(PoliceMain());

Future<String> getPoliceName() async {
  final String uid = auth.currentUser.uid;
  print("ID =" + uid);

  final result =
  await FirebaseFirestore.instance.collection('MOI').doc(uid).get();
  final fbm = FirebaseMessaging();
  String getToken = "";
  fbm.getToken().then((value) =>
  {
    FirebaseFirestore.instance
        .collection('MOI').doc(FirebaseAuth.instance.currentUser.uid).update({

      'deviceID': value,
    })
  });
  return result.get('Name');

}
class PoliceMain extends StatelessWidget {


  @override
  Language engLang = new Language(1, 'English', 'U+1F1FA', 'en');
  Language arabLang = new Language(2, 'Arabic', 'U+1F1F0', 'ar');


  Widget build(BuildContext context) {
    final List<Features> GridFeatures = [
      Features(
        title: 'Scan',
        image: 'images/ScanPolice.png',
      ),
      Features(
        title: 'Disability Check',
        image: 'images/CheckDis.png',
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
        title: Text("Police Main"),
        backgroundColor: Color(0xfff7892b),

      ),
      drawer: Drawer(

      child: Container(
      color: Colors.white,
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,

        children: <Widget>[
      UserAccountsDrawerHeader(
      arrowColor: Colors.orange,
        accountName: FutureBuilder(
          future: getPoliceName(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            return Text(snapshot.data);
          },

        ),
        accountEmail: Text(userEmail.substring(userEmail.indexOf('m') + 1, userEmail.indexOf("@"))),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Text(
            (userEmail.substring(0, 2)),
            style: TextStyle(fontSize: 40.0),
          ),
        ),
      ),
      ListTile(

        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () {
          PoliceMain();
        },
      ),


      //_DisabilityCode(),

      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Edit Profile'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => PoliceEditProfile()),
          );
        },
      ),



      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Sign out'),
        onTap: () {
          FirebaseAuth.instance.signOut();
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (ctx) => LoginPage()),
          );
        },
      )
      ]),),),

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

      ),


    );
  }
}