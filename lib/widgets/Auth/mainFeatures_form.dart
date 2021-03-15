import 'package:Motri/screens/CarInfo.dart';
import 'package:Motri/screens/ForMyself.dart';
import 'package:Motri/screens/Generate.dart';
import 'package:Motri/screens/MyCars.dart';
import 'package:Motri/screens/RequestCode.dart';
import 'package:Motri/screens/qr_scan_page.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MainFeaturesForm extends StatelessWidget {
  final String title;
  final String image;

  MainFeaturesForm(this.title, this.image);
  @override
  Widget build(BuildContext context) {

    return Center ( child: GridTile(



      //child: ConstrainedBox(

       // constraints: BoxConstraints.expand(),
        child: RaisedButton(



          onPressed: () {



            if(title.compareTo('Car Info') == 0 || title.compareTo('معلومات السياره') == 0)
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MyCarsInfo()),
            );

            if(title.compareTo('Request Code') == 0 || title.compareTo('طلب رمز') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => RequestCode()),
              );
            if(title.compareTo('For myself') == 0 || title.compareTo('لنفئسي') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => ForMySelf()),
              );
            if(title.compareTo('For my child') == 0 || title.compareTo('لطفلي') == 0)
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => QRScanPage()),
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



        ),

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
