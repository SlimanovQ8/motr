import 'package:Motri/main.dart';
import 'package:Motri/widgets/Auth/ForMyChild.dart';
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
import 'addCar.dart';

void main() => runApp(OkChild());

class OkChild extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OK Child',
      home: Scaffold(
        appBar: AppBar(

          leading:  IconButton(
            icon: Icon(Icons.home, color: Colors.black),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MainMotri()),),

          ),
          title: Text('Request sent', style: TextStyle(
            color: Colors.black,
          ),)
          ,
          backgroundColor: Color(0xfff7892b),

        ),

        body: Container(
            alignment: Alignment.center,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget> [ Text('Thank you. Your request code for your child has been sent to MOI.', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18), ) ,
                SizedBox(height: 49,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RaisedButton(
                      onPressed: () {Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => MainMotri()),
                      ); },
                      color: Color(0xfff7892b),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black),
                      ),

                      child: Container(
                        width: 140,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2,
                              )
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xfffbb448),
                                  Color(0xfff7892b)
                                ])),
                        child: Text('Home',
                            style:
                            TextStyle(fontSize: 20, color: Colors.white)),
                      ),


                    ),
                    SizedBox(width: 30,)
                    ,
                    RaisedButton(
                      onPressed: () {Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => MyChild()),
                      ); },
                      color: Color(0xfff7892b),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black),
                      ),

                      child: Container(
                        width: 160,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.grey.shade200,
                                offset: Offset(2, 4),
                                blurRadius: 5,
                                spreadRadius: 2,
                              )
                            ],
                            gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: [
                                  Color(0xfffbb448),
                                  Color(0xfff7892b)
                                ])),
                        child: Text('Add another code',
                            style:
                            TextStyle(fontSize: 20, color: Colors.white)),
                      ),

                    ),
                  ],
                )

              ],
            )

        ),

      ),
    );
  }
}