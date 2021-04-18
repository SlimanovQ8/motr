import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/AddUser.dart';
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


class SelectUserForm extends StatefulWidget {
  AddUserSelectCar createState() => new AddUserSelectCar();

}

class AddUserSelectCar extends State<SelectUserForm> {

  @override

  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
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
          } else if (snapshot.data.docs.length == 0) {
            return Container(
              child: Center(
                child: Text(
                  'You have no cars yet.',
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
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.person,

                                      size: 40.0),
                                  onPressed: () {

                                  }),
                              Text(snapshot.data.docs[i].get('UsersCount'), style: TextStyle(
                                fontSize: 20,
                                color: Colors.black
                              ),),

                            ],
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
                                  builder: (ctx) => AddUser()),
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
