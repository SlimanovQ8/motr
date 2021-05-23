import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/CarInsurance.dart';
import 'package:Motri/screens/Generate.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/screens/mySelectedCar.dart';
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
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:path_provider/path_provider.dart';


class AllInfo extends StatefulWidget {
  _myCars createState() => new _myCars();
}

class _myCars extends State<AllInfo> {
  @override
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "554";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();
  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> getCivilID() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('Civil ID');
  }

  var d;
  Future<void> initState() {
    super.initState();
  }

  _contentWidget(String PN) {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            child: Text(
              "QR Code",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 10.0,
            ),
            child:  Container(
              //height: _topSectionHeight,

            ),
          ),
          Expanded(
            child:  Center(
              child: RepaintBoundary(
                key: globalKey,
                child: QrImage(
                  data: PN,
                  size: 0.5 * bodyHeight,

                ),
              ),
            ),
          ),

        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      child: new Scaffold(
        appBar: new TabBar(
          labelColor: Colors.orange,
          tabs: <Widget>[
            new Tab(
              text: "QR Code",
            ),
            new Tab(
              text: "Car Info",
            ),
            new Tab(
              child: new Text(
                "Users List",
              ),
            ),
            new Tab(
              child: new Text(
                "Disabilities",
              ),
            ),
          ],
        ),
        body: new Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 10),
          child: TabBarView(
            children: <Widget>[
              new Container(
                child: new Center(
                  child: new FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Cars')
                          .where('UserID', isEqualTo: auth.currentUser.uid)
                          .where('isSelected', isEqualTo: true.toString())
                          .get(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        else {
                          return _contentWidget(snapshot.data.docs[0].get('Plate Number') + "-" + auth.currentUser.uid);

                        }
                      }),
                ),
              ),
              new Container(
                child: new Center(
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Cars')
                        .where('UserID', isEqualTo: auth.currentUser.uid)
                        .where('isVerified', isEqualTo: true.toString())
                        .where('isSelected', isEqualTo: 'true')
                        .get(),
                    builder: (context, AsyncSnapshot <QuerySnapshot> snapshot)
                    {
                      if (snapshot.data == null)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else
                      {
                        return  SingleChildScrollView(child: new Column(
                          children: <Widget>[

                            new ListTile(
                              leading: const Icon(Icons.person),
                              title: const Text('Car Owner Name'),
                              subtitle:  Text(snapshot.data.docs[0].get('Car Owner Name')),
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 4.0,
                            ),
                            new ListTile(
                              leading: const Icon(Icons.car_rental),
                              title: const Text('Car Make'),
                              subtitle:  Text(snapshot.data.docs[0].get('Car Make')),         ),
                            const Divider(
                              color: Colors.black,
                              height: 4.0,
                            ),
                            new ListTile(
                              leading: const Icon(Icons.directions_car_rounded),
                              title: const Text('Car Name'),
                              subtitle:  Text(snapshot.data.docs[0].get('Car Name')),
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 4.0,
                            ),
                            new ListTile(
                              leading: const Icon(Icons.electric_car_sharp),
                              title: const Text('Car Year'),
                              subtitle:  Text(snapshot.data.docs[0].get('Car Year')),

                            ),
                            const Divider(
                              color: Colors.black,
                              height:  4.0,
                            ),
                            new ListTile(
                              leading: const Icon(Icons.electric_car_sharp),
                              title: const Text('Plate Number'),
                              subtitle:  Text(snapshot.data.docs[0].get('Plate Number')),

                            ),
                            const Divider(
                              color: Colors.black,
                              height: 4.0,
                            ),

                            new ListTile(
                                leading: const Icon(Icons.details),
                                title: const Text('Additional Information'),
                                subtitle:  Text('Weight: ' + snapshot.data.docs[0].get('Weight') + '\t' + ',         Height: ' + snapshot.data.docs[0].get('Height') + '\n' + 'Color: ' + snapshot.data.docs[0].get('Color') + '\t' + ',      Passenger: ' + snapshot.data.docs[0].get('Passenger'))
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 4.0,
                            ),
                            new Container(
                                padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                                child: new RaisedButton(
                                  color: Color(0xfff7892b),
                                  child: const Text('Car Insurance'),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (ctx) => CarInsurance())
                                    );
                                  },
                                ))
                          ],
                        )
                        );


                      }
                    },
                  ),
                ),
              ),
              new Container(
                child: new Center(
                  child: new FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Cars')
                          .where('UserID', isEqualTo: auth.currentUser.uid)
                          .where('isSelected', isEqualTo: true.toString())
                          .get(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                'You have no rejected cars.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return FutureBuilder( future: FirebaseFirestore.instance.collection('Cars').doc(snapshot.data.docs[0].id)
                              .collection('UsersList').where("Status", isEqualTo: "Accepted").get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> ss)
                          {
                            if (ss.data == null) {
                              return Container(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            } else if (ss.data.docs.length == 0) {
                              return Container(
                                child: Center(
                                  child: Text(
                                    'No users uses this car.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            }
                            else {
                              return  ListView.separated(
                                  separatorBuilder: (context, index) => Divider(
                                    color: Colors.black,
                                  ),
                                  itemCount: ss.data.docs.length,
                                  itemBuilder: (context, int i) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 20.0),
                                      child: Card(
                                        elevation: 8.0,
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        child: Container(
                                          height: 70,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, .9)),
                                          child: ListTile(
                                            trailing: new IconButton(
                                              icon: Icon(
                                                Icons.more_horiz_rounded,
                                                color: Colors.black,
                                                size: 40.0,
                                              ),
                                              onPressed: () {
                                                showModalBottomSheet(
                                                    context: context,
                                                    builder: (BuildContext bc){
                                                      return Container(
                                                        child: new Wrap(
                                                          children: <Widget>[
                                                            new ListTile(
                                                                leading: new Icon(Icons.delete),
                                                                title: new Text('Delete'),
                                                                tileColor: Colors.red,
                                                                onTap: () => {
                                                                setState(() {
                                                                  FirebaseFirestore.instance
                                                                      .collection('Cars')
                                                                      .doc(snapshot.data.docs[0].id).collection('UsersList').doc(ss.data.docs[i].id)
                                                                      .delete();
                                                                  FirebaseFirestore.instance
                                                                      .collection('UserNames')
                                                                      .doc(ss.data.docs[i].get('UserName')).collection('OtherCars').doc(snapshot.data.docs[0].id)
                                                                      .delete();
                                                                Navigator.pop(context);

                                                                })
                                                                }
                                                            ),
                                                            new ListTile(
                                                              leading: new Icon(Icons.cancel),
                                                              title: new Text('Cancel'),
                                                              onTap: () => {
                                                              Navigator.pop(context)

                                                            },
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                );

                                              },
                                            ),
                                            leading: Container(
                                              padding: EdgeInsets.only(right: 12.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(
                                                          width: 1.0,
                                                          color: Colors.black))),
                                              child: Icon(
                                                Icons.person,
                                                size: 35,
                                              ),
                                            ),
                                            title: Text(
                                              ss.data.docs[i]
                                                  .get('UserName')
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }) ;

                        }
                      }),
                ),
              ),
              new Container(
                child: new Center(
                  child: new FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('Cars')
                          .where('UserID', isEqualTo: auth.currentUser.uid)
                          .where('isSelected', isEqualTo: true.toString())
                          .get(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                'You have no Disabilities users uses this car.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return FutureBuilder( future: FirebaseFirestore.instance.collection('Cars').doc(snapshot.data.docs[0].id)
                              .collection('DisabilitiesList').where("Status", isEqualTo: "Accepted").get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> ss)
                              {
                                if (ss.data == null) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (ss.data.docs.length == 0) {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        'No disabilities users uses this car.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                }
                                else {
                                  return  ListView.separated(
                                      separatorBuilder: (context, index) => Divider(
                                        color: Colors.black,
                                      ),
                                      itemCount: ss.data.docs.length,
                                      itemBuilder: (context, int i) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 20.0),
                                          child: Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 6.0),
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      224, 224, 224, .9)),
                                              child: ListTile(
                                                trailing: new IconButton(
                                                  icon: Icon(
                                                    Icons.more_horiz_rounded,
                                                    color: Colors.black,
                                                    size: 40.0,
                                                  ),
                                                  onPressed: () {
                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext bc){
                                                          return Container(
                                                            child: new Wrap(
                                                              children: <Widget>[
                                                                new ListTile(
                                                                    leading: new Icon(Icons.delete),
                                                                    title: new Text('Delete'),
                                                                    tileColor: Colors.red,
                                                                    onTap: () => {
                                                                      setState(() {
                                                                        FirebaseFirestore.instance
                                                                            .collection('Cars')
                                                                            .doc(snapshot.data.docs[0].id).collection('DisabilitiesList').doc(ss.data.docs[i].id)
                                                                            .delete();
                                                                        Navigator.pop(context);

                                                                      })
                                                                    }
                                                                ),
                                                                new ListTile(
                                                                  leading: new Icon(Icons.cancel),
                                                                  title: new Text('Cancel'),
                                                                  onTap: () => {
                                                                    Navigator.pop(context)

                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                    );

                                                  },
                                                ),
                                                leading: Container(
                                                  padding: EdgeInsets.only(right: 12.0),
                                                  decoration: new BoxDecoration(
                                                      border: new Border(
                                                          right: new BorderSide(
                                                              width: 1.0,
                                                              color: Colors.black))),
                                                  child: Icon(
                                                    Icons.wheelchair_pickup,
                                                    size: 35,
                                                  ),
                                                ),
                                                title: Text(
                                                    ss.data.docs[i].get("DisUserName")
                                                ),
                                                subtitle: Text("Dis Number: " + ss.data.docs[i].get('DisabilityNumber')),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }) ;

                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
