import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/AddUser.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/screens/payment.dart';
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
import 'dart:convert';

import '../../main.dart';


class ViewTicketsForm extends StatefulWidget {
  VT createState() => new VT();

}

class VT extends State<ViewTicketsForm> {

  @override

  var count = 0;
  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> initState() {

    super.initState();
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser.uid).collection("UsersTickets").where("isPaid", isEqualTo: "false")
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
                  'You have no tickets.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            print(snapshot.data.docs.length);

            count = 0;
            for (var i = 0; i < snapshot.data.docs.length; i++)
              {
                count = count + int.parse(snapshot.data.docs[i].get("TicketAmount"));
                print(count);
              }
            /*  [     SingleChildScrollView(
              child: Container (
                child: Column (
                  children: [


                  ],
                ),
              ),
            )*/

            return Container(
              alignment: Alignment.center,
              child: Column
                (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(20),
                    child: Text(
                      "Your Tickets",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                  Expanded(child: SizedBox(
                    height: 20,
                    child: ListView.separated(
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {



                        return Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),

                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                              border: new Border.all(
                                  width: 1.0, style: BorderStyle.solid, color: Colors.black)),
                          margin: EdgeInsets.all(12.0),
                          child: ListTile(
                            leading: Container(
                              padding: EdgeInsets.only(right: 12.0),
                              decoration: new BoxDecoration(
                                  border: new Border(
                                      right: new BorderSide(
                                          width: 1.0, color: Colors.black))),
                              child: Transform.scale(scale: 2,
                                      child: IconButton(
                                icon: Image.asset('images/payTickets.png', )
                                ,
                              ),
                            ),
                            ),
                            onTap: () {},
                             trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.credit_card_rounded,

                                      color: Colors.lightGreen,
                                      size: 30.0),
                                  onPressed: () {


                                    int buj = index;
                                    FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(auth.currentUser.uid).collection("UsersTickets")
                                        .doc(snapshot.data.docs[index].id)
                                        .update({
                                      'isSelected': 'true',
                                    });

                                    for (var b = 0; b < snapshot.data.docs.length; b++)
                                      if (b != buj) {
                                        FirebaseFirestore.instance
                                             .collection('Users')
                                            .doc(auth.currentUser.uid).collection("UsersTickets")
                                            .doc(snapshot.data.docs[b].id)
                                            .update({'isSelected': 'false'});
                                      }
                                    Navigator.of(context).push(
                                      MaterialPageRoute(builder: (ctx) => Payment()),);

                                  }),
                              IconButton(
                                  icon: Icon(Icons.info_outline_rounded,

                                      size: 30.0),
                                  onPressed: () {
                                    return showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: Text("Ticket Info"),
                                              content: Text("Info: " + snapshot.data.docs[index].get("TicketInfo") + "\n \n"
                                                  "Location: " + snapshot.data.docs[index].get("TicketPlace") + "\n\n"
                                                  "Date: " + snapshot.data.docs[index].get("TicketDate") + "\n\n"
                                                  "Amount: " + snapshot.data.docs[index].get("TicketAmount") + " KD"+ "\n\n"
                                                  "Car Name: " + snapshot.data.docs[index].get("CarName") + "\n\n"
                                                  "Plate Number: " + snapshot.data.docs[index].get("PlateNumber") + "\n\n"

                                              ),
                                              actions: [


                                                FlatButton(
                                                  textColor: Color(0xFF6200EE),
                                                  onPressed: () {

                                                    Navigator.pop(context);
                                                  },
                                                  child: Text('Ok'),
                                                ),
                                              ],
                                            )
                                    );


                                  }),


                            ],
                          ),
                            title: Text(
                              snapshot.data.docs[index].get("TicketName") + "\n\n" + snapshot.data.docs[index].get("TicketDate"))

                          ),
                        ),
                        );
                      },
                    ),)),
                  Container(
                    margin: const EdgeInsets.all(30.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ), //       <--- BoxDecoration here
                    child: Text(
                      "Total: " + count.toString() + " KD",
                      style: TextStyle(fontSize: 30.0),
                    ),
                  ),
                ],
              ),);
          }
        },
      ),
    );
  }
}
