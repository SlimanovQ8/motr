import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/AddUser.dart';
import 'package:Motri/screens/CarInfoAll.dart';
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

GlobalKey globalKey = new GlobalKey();

class getUserCars {
  String _CarMake;
  String _CarName;
  int _CarYear;
  String _CarPlateNumber;
  bool _isSelected;

  getUserCars(this._CarMake, this._CarName, this._CarYear, this._CarPlateNumber,
      this._isSelected);

  bool get isSelected => _isSelected;

  set isSelected(bool value) {
    _isSelected = value;
  }

  String get CarPlateNumber => _CarPlateNumber;

  set CarPlateNumber(String value) {
    _CarPlateNumber = value;
  }

  int get CarYear => _CarYear;

  set CarYear(int value) {
    _CarYear = value;
  }

  String get CarName => _CarName;

  set CarName(String value) {
    _CarName = value;
  }

  String get CarMake => _CarMake;

  set CarMake(String value) {
    _CarMake = value;
  }
}

class myCars extends StatefulWidget {
  _myCars createState() => new _myCars();
}

class _myCars extends State<myCars> {
  List<String> _items = List<String>();
  List<getUserCars> Uc = List<getUserCars>();
  @override
  /*Future getCars() async {
    List<DocumentSnapshot> docs;
    String fc = await getCivilID();
    print(fc);
   var QSS = await FirebaseFirestore.instance.collection('Cars')

      .where("Car Owner Civil ID", isEqualTo: "f" )
          .get();

   print(docs.length);



    List <getUserCars> GUC = new List ();
    for (var i = 0; i < docs.length; i++)
      {
        String CM = docs[i]['Car Make'];
        String CN = docs[i]['Car Name'];
        int CY = int.parse(docs[i]['Car Year']);
        String CPN = docs[i]['Plate Number'];
        getUserCars newCar = new getUserCars(CM, CN, CY, CPN, false);
        GUC.add(newCar);
      }
    return QSS;
  }*/

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
  int indexXX = 0;

  _contentWidget(String PN) {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return Dialog(
        child: Container(

          height: 400,

            color: Colors.black12,
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
                  size: 0.3 * bodyHeight,


                ),
              ),
            ),
          ),

        ],
      ),
        ),
    );
  }

  Widget build(BuildContext context) {
    return new Scaffold(
     body: indexXX == 0? DefaultTabController(
      length: 3,
      child: new Scaffold(
        appBar: new TabBar(
          labelColor: Colors.orange,
          tabs: <Widget>[
            new Tab(
              text: "Accepted",
            ),
            new Tab(
              text: "Pending",
            ),
            new Tab(
              child: new Text(
                "Rejected",
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
                          .where('isVerified', isEqualTo: true.toString())
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
                                'You have no cars yet.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    color: Colors.black,
                                  ),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, int i) {
                                final now = new DateTime.now();
                                String a =
                                    snapshot.data.docs[i].get('Expire Date');
                                List<String> ExpireDate = a.split('/');

                                int day = int.parse(ExpireDate[0]);
                                int month = int.parse(ExpireDate[1]);
                                int year = int.parse(ExpireDate[2]);


                                final b = new DateTime(year, month, day);
                                int diff = b.difference(now).inDays;
                                print(diff);

                                bool red = false;
                                bool orange = false;
                                bool green = false;

                                if (diff > 30) {
                                  green = true;
                                  red = false;
                                  orange = false;
                                } else if (diff <= 30 && diff > 0) {
                                  orange = true;
                                  red = false;
                                  green = false;
                                } else {
                                  red = true;
                                  green = false;
                                  orange = false;
                                  diff = diff *-1;
                                }
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 20.0),
                                  child: Card(
                                    elevation: 8.0,
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              224, 224, 224, .9)),
                                      child: ListTile(
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            IconButton(
                                                icon: Icon(Icons.timer,
                                                    color: green == true
                                                        ? Colors.green
                                                        : orange == true
                                                            ? Colors.orange
                                                            : Colors.red,
                                                    size: 40.0),
                                                onPressed: () {

                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext context) =>

                                                          AlertDialog(
                                                            title: Text(
                                                                'Car Insurace expire date'),
                                                            content: green == true
                                                                ?  Text("Your Car insurance will be expire in " +
                                                                    diff
                                                                        .toString() +
                                                                    " days") : orange == true
                                                            ?Text("Your Car insurance will be expire in " +
                                                                diff
                                                                    .toString() +
                                                                " days")
                                                                : Text("Your Car insurance expired " +
                                                                    diff.toString() +
                                                                    " days ago"),
                                                            actions: [
                                                              FlatButton(
                                                                textColor: Color(
                                                                    0xFF6200EE),
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child:
                                                                    Text('Ok'),
                                                              ),
                                                            ],
                                                          ));
                                                }),


                                            IconButton(icon: Icon(Icons.more_horiz,
                                                color: Colors.black,
                                                size: 25.0), onPressed: ()
                                            {
                                              int buj = i;
                                              FirebaseFirestore.instance
                                                  .collection('Cars')
                                                  .doc(snapshot.data.docs[i].id)
                                                  .update({
                                                'isSelected': 'true',
                                              });
                                              if (snapshot.data.docs[i]
                                                  .get('Color') ==
                                                  '') {
                                                if (buj % 3 == 0) {
                                                  print(buj);
                                                  FirebaseFirestore.instance
                                                      .collection('Cars')
                                                      .doc(snapshot.data.docs[i].id)
                                                      .update({
                                                    'Color': 'black',
                                                    'Passenger': '4',
                                                    'Weight': '1.330',
                                                    'Height': '1.420',
                                                    'Insurance Company':
                                                    'Kuwait?? Insurance Company',
                                                    'Insurance type': 'Private',
                                                    'Car Reference': '1276905',
                                                    'Document No': '2299365475l560',
                                                  });
                                                } else if (i % 3 == 1) {
                                                  FirebaseFirestore.instance
                                                      .collection('Cars')
                                                      .doc(snapshot.data.docs[i].id)
                                                      .update({
                                                    'Color': 'grey',
                                                    'Passenger': '4',
                                                    'Weight': '1.200',
                                                    'Height': '1.220',
                                                    'Insurance Company':
                                                    'Ghazal Insurance Company',
                                                    'Insurance type': 'Private',
                                                    'Car Reference': '22434345',
                                                    'Document No': '22089647520',
                                                  });
                                                } else if (i % 3 == 2) {
                                                  FirebaseFirestore.instance
                                                      .collection('Cars')
                                                      .doc(snapshot.data.docs[i].id)
                                                      .update({
                                                    'Color': 'Red',
                                                    'Passenger': '4',
                                                    'Weight': '1.240',
                                                    'Height': '1.340',
                                                    'Insurance Company':
                                                    'Warba Insurance Company',
                                                    'Insurance type': 'Private',
                                                    'Car Reference': '144456345',
                                                    'Document No': '20096547720',
                                                  });
                                                }
                                              }
                                              for (var b = 0;
                                              b < snapshot.data.docs.length;
                                              b++)
                                                if (b != buj) {
                                                  FirebaseFirestore.instance
                                                      .collection('Cars')
                                                      .doc(snapshot.data.docs[b].id)
                                                      .update(
                                                      {'isSelected': 'false'});
                                                }
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        AllCarInfo()),
                                              );
                                            }),
                                          ],
                                        ),
                                        leading: Container(
                                          padding: EdgeInsets.only(right: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black))),
                                          child: Icon(
                                            Icons.car_rental,
                                            size: 35,
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.data.docs[i]
                                                  .get('Car Make') +
                                              "\n" +
                                              snapshot.data.docs[i]
                                                  .get('Car Name'),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          snapshot.data.docs[i]
                                                  .get('Plate Number') +
                                              '\n' +
                                              snapshot.data.docs[i]
                                                  .get('Expire Date'),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        onTap: () {

                                        },
                                      ),
                                    ),
                                  ),
                                );
                              });
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
                          .where('iaPending', isEqualTo: true.toString())
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
                                'You have no pending cars .',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    color: Colors.black,
                                  ),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, int i) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 20.0),
                                  child: Card(
                                    elevation: 8.0,
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              224, 224, 224, .9)),
                                      child: ListTile(
                                        leading: Container(
                                          padding: EdgeInsets.only(right: 12.0),
                                          decoration: new BoxDecoration(
                                              border: new Border(
                                                  right: new BorderSide(
                                                      width: 1.0,
                                                      color: Colors.black))),
                                          child: Icon(
                                            Icons.car_rental,
                                            size: 35,
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.data.docs[i]
                                                  .get('Car Make') +
                                              "\n" +
                                              snapshot.data.docs[i]
                                                  .get('Car Name'),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          snapshot.data.docs[i]
                                              .get('Plate Number'),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
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
                          .where('isRejected', isEqualTo: true.toString())
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
                          return ListView.separated(
                              separatorBuilder: (context, index) => Divider(
                                    color: Colors.black,
                                  ),
                              itemCount: snapshot.data.docs.length,
                              itemBuilder: (context, int i) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 20.0),
                                  child: Card(
                                    elevation: 8.0,
                                    margin: new EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 6.0),
                                    child: Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: Color.fromRGBO(
                                              224, 224, 224, .9)),
                                      child: ListTile(
                                        trailing: new IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.black,
                                            size: 40.0,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              FirebaseFirestore.instance
                                                  .collection('Cars')
                                                  .doc(snapshot.data.docs[i].id)
                                                  .delete();
                                            });
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
                                            Icons.car_rental,
                                            size: 35,
                                          ),
                                        ),
                                        title: Text(
                                          snapshot.data.docs[i]
                                                  .get('Car Make') +
                                              "\n" +
                                              snapshot.data.docs[i]
                                                  .get('Car Name'),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        subtitle: Text(
                                          snapshot.data.docs[i]
                                              .get('Plate Number'),
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }
                      }),
                ),
              ),
            ],
          ),
        ),

      ),
    ):  FutureBuilder(
       future: FirebaseFirestore.instance
           .collection('UserNames')
           .where('UID', isEqualTo: auth.currentUser.uid)

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

           return FutureBuilder(
             future: FirebaseFirestore.instance
                 .collection('UserNames')
                 .doc(snapshot.data.docs[0].id).collection("OtherCars")
                 .get(),
             builder: (context, AsyncSnapshot<QuerySnapshot> q) {
               if (q.data == null) {
                 return Container(
                   child: Center(
                     child: CircularProgressIndicator(),
                   ),
                 );
               } else if (q.data.docs.length == 0) {
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
                 print(q.data.docs.length);

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
                           "Other's Cars",
                           style: TextStyle(fontSize: 30),
                         ),
                       ),
                       Expanded(child: SizedBox(
                         height: 60,
                         child: ListView.separated(
                             separatorBuilder: (context, index) => Divider(
                               color: Colors.black,
                             ),
                             itemCount: q.data.docs.length,
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
                                         q.data.docs[i].get('CarOwnerName') +
                                             "\n" +
                                             q.data.docs[i].get('CarName'),
                                         style: TextStyle(color: Colors.black),
                                       ),
                                       subtitle: Text(
                                         q.data.docs[i].get('PlateNumber'),
                                         style: TextStyle(color: Colors.black),
                                       ),
                                       trailing: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: <Widget>[
                                       new Container(

                                         child: Transform.scale(scale: 1,
                                           child: IconButton(
                                             icon: Image.asset('images/ScanQR.png', )
                                            ,
                                            onPressed:() {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => _contentWidget(FirebaseFirestore.instance.collection('UserNames')
                                                      .doc(snapshot.data.docs[0].id).collection('OtherCars').doc(q.data.docs[i].id).id + "-" + auth.currentUser.uid)
                                              );
                                            },
                                           ),
                                         ),
                                       ),
                                           new IconButton(
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
                                                                       .collection('UserNames')
                                                                       .doc(snapshot.data.docs[0].id).collection('OtherCars').doc(q.data.docs[i].id)
                                                                       .delete();
                                                                   FirebaseFirestore.instance
                                                                       .collection('Cars')
                                                                       .doc(q.data.docs[i].get("PlateNumber")).collection('UsersList').doc(snapshot.data.docs[0].id)
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


                                         ],
                                       ),
                                     ),
                                   ),
                                 ),
                               );
                             }),))

                     ],
                   ),);
               }
             },
           );
         }
       },
     ),
       bottomNavigationBar: BottomNavigationBar(
         backgroundColor: Color(0xfff7892b),
         selectedItemColor: Colors.black,
         currentIndex: indexXX,
         onTap: (index) {
           setState(() {
             indexXX = index;
             print(index);
           });
         },
         items: [
           BottomNavigationBarItem(
             icon: new Icon(Icons.car_rental),
             label: 'My Cars',

           ),
           BottomNavigationBarItem(
             icon: Icon(Icons.car_repair),
             label: 'Other cars',
           )
         ],
       ),

     );

  }
}
