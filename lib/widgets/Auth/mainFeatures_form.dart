import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/AddLic.dart';
import 'package:Motri/screens/AddLicense.dart';
import 'package:Motri/screens/AddUserSelectCar.dart';
import 'package:Motri/screens/AlreadySelf.dart';
import 'package:Motri/screens/CarCheck.dart';
import 'package:Motri/screens/CarInfo.dart';
import 'package:Motri/screens/DisCheck.dart';
import 'package:Motri/screens/ForMyself.dart';
import 'package:Motri/screens/Generate.dart';
import 'package:Motri/screens/MyCars.dart';
import 'package:Motri/screens/MySelfCodeFD.dart';
import 'package:Motri/screens/MySelfCodeFH.dart';
import 'package:Motri/screens/RequestCode.dart';
import 'package:Motri/screens/SelectCarDis.dart';
import 'package:Motri/screens/ViewTickets.dart';
import 'package:Motri/screens/qr_scan_page.dart';
import 'package:Motri/screens/tstosy.dart';
import 'package:Motri/widgets/Auth/ForMyChild.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/models/lang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainFeaturesForm extends StatelessWidget {
  final String title;
  final String image;
  final auth = FirebaseAuth.instance;


  MainFeaturesForm(this.title, this.image);
  @override

  Widget build(BuildContext context) {

    return Center ( child: GridTile(



      //child: ConstrainedBox(

       // constraints: BoxConstraints.expand(),
        child:
      FutureBuilder(
      future: FirebaseFirestore.instance
        .collection('Disabilities')
        .where('UserID', isEqualTo: auth.currentUser.uid)
        .get(),
    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {



        return RaisedButton(



          onPressed: () {



            if(title.compareTo('Car Info') == 0 || title.compareTo('معلومات السياره') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => MyCarsInfo()),
              );
            if(title.compareTo('Add User') == 0 || title.compareTo('اضافة شخص') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => AddUserSC()),
              );

            if(title.compareTo('Request Code') == 0 || title.compareTo('طلب رمز') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => RequestCode()),
              );

            if(title.compareTo('Scan') == 0 || title.compareTo('مسح') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => CarCheck()),
              );
            if(title.compareTo('Disability Check') == 0 || title.compareTo('التأكد من معاق') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => DisCheck()),
              );

            if(title.compareTo('License') == 0 || title.compareTo('رخصة قياده') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => Licenser()),
              );
            if(title.compareTo('Show Tickets') == 0 || title.compareTo('مشاهدة المخالفات') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => ViewTickets()),
              );
            if(title.compareTo('Add Disability') == 0 || title.compareTo('اضافة ذوي احتياجات') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => SelectCarDis()),
              );
            if(title.compareTo('For myself') == 0 || title.compareTo('لنفئسي') == 0)
              if (snapshot.data.size <= 0)
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => ForMySelf()),
                );
            else if (true.toString().compareTo(snapshot.data.docs[0].get('isDisability')) == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => MySelfCodeFromDisability()),
              );
            else
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => AlreadySelf()),
            );
            if(title.compareTo('For my dependent') == 0 || title.compareTo('لطفلي') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => MyChild()),
              );
          },
        /*  shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
  */        padding: EdgeInsets.all(0.0),



          color: HexColor("#FFFAFA"),


          child: Image.asset(
            image,
            height: 120,

          ),



        ); }),

     //),
      footer: Center(
      //  backgroundColor: Colors.black,
        child: Text(title,
        textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),


          ),

      ),),
    );
  }
}
