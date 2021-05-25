import 'package:Motri/screens/AddUserSelectCar.dart';
import 'package:Motri/screens/Main.dart';
import 'package:Motri/screens/SelectCarDis.dart';
import 'package:Motri/widgets/Auth/AddUserSelectCar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:Motri/screens/Widget/button_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import '../main.dart';
import 'MyCars.dart';
import 'mySelectedCar.dart';

class abd extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<abd> {
  String qrCode = 'Unknown';

  @override
  var _isLoading = false;
  bool isExist = true;
  bool isSameUser = false;
  String userEmail = FirebaseAuth.instance.currentUser.email;
  String use = FirebaseAuth.instance.currentUser.uid;
  var userName = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .id;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> getUserName() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('Name');
  }

  Future<String> getCivilID() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('Civil ID');
  }


  Future<String> getDeviceID() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('deviceID');
  }


  Future<String> getSenderCarName() async {
    final a = await FirebaseFirestore.instance.collection('Cars').where('UserID', isEqualTo: auth.currentUser.uid).where("isSelected" , isEqualTo: "true").get();


    return a.docs[0].get('Car Name');

  }
  Future<String> getPlateNumber() async {
    final a = await FirebaseFirestore.instance.collection('Cars').where('UserID', isEqualTo: auth.currentUser.uid).where("isSelected" , isEqualTo: "true").get();


    return a.docs[0].get('Plate Number');
  }
  Future<String> getSenderUserName() async {
    final a = await FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).get();


    return a.get('UserName');
  }

  Future<String> getReciverName(String getReciverName) async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final a = await FirebaseFirestore.instance.collection('Users').where('UserName', isEqualTo: getReciverName).get();
    return a.docs[0].get('Name');
  }
  Future<String> getRecieverEmail(String getReciverName) async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final a = await FirebaseFirestore.instance.collection('Users').where('UserName', isEqualTo: getReciverName).get();
    return a.docs[0].get('email');
  }
  Future<String> getRecieverUserID(String getReciverName) async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final a = await FirebaseFirestore.instance.collection('Users').where('UserName', isEqualTo: getReciverName).get();
    return a.docs[0].id;
  }

  Future<String> getReciverUserName(String getReciverName) async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final a = await FirebaseFirestore.instance.collection('Users').where('UserName', isEqualTo: getReciverName).get();
    return a.docs[0].get('UserName');
  }

  Future<String> getReciverDeviceIDD(String getReciverName) async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final a = await FirebaseFirestore.instance.collection('Users').where('UserName', isEqualTo: getReciverName).get();
    return a.docs[0].get('deviceID');
  }

  bool isRequestExist = false;

  void _sumbitAuthForm(String PlateNumber , String c, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
        isRequestExist = false;
        isExist = true;
        isSameUser  =false;
      });



      await FirebaseFirestore.instance
          .collection('Cars').doc(PlateNumber).update({
        "isRejected": "true",
        "TN": c


      });

      String b = "";
      await FirebaseFirestore.instance
          .collection('Cars').doc(PlateNumber).update({
        "isRejected": "false"

      }).then((value) {

      });
      await FirebaseFirestore.instance
          .collection('Cars').doc(PlateNumber).get().then((value) {
        FirebaseFirestore.instance.collection('temp').doc(value.get("UserID")).set({
          "PN": PlateNumber,
          "UID": value.get("UserID"),
        });
      });

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Request Sent"),
              content: Text("Your request has been sent to " ),
              actions: [
                FlatButton(
                  textColor: Color(0xFF6200EE),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK'),
                ),

              ],
            )
        );



      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      setState(() {
        _isLoading = false;

        isExist = false;
      });
      print(err);
    }
  }


  String PN = "";
  String Count= "";
  Widget build(BuildContext context) => MaterialApp(
    title: 'Add User',
    home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => AddUserSC()),
            ),
          ),
          title: Text('Add User', style: TextStyle(
              color: Colors.black
          ),),
          backgroundColor: Color(0xfff7892b),
        ),
        body: SingleChildScrollView (
            child: Container(
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.car_repair),
                            hintText: 'Enter car plate number',
                            labelText: 'Plate Number',
                          ),
                          validator: (b) {
                            if (isExist) {
                              return 'Plate Number is already registered';
                            }
                            return null;
                          },
                          onChanged: (String s) {
                            setState(() {
                              PN = s;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.car_repair),
                            hintText: 'Enter Tickets number',
                            labelText: 'Ticket Number',
                          ),
                          validator: (b) {
                            if (isExist) {
                              return 'Plate Number is already registered';
                            }
                            return null;
                          },
                          onChanged: (String s) {
                            setState(() {
                              Count = s;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),


                      if(_isLoading)
                        new Container(
                          child: new CircularProgressIndicator(
                            backgroundColor: Colors.black,

                          ),
                        )
                      else
                        RaisedButton(
                          onPressed: () {
                            _sumbitAuthForm(PN, Count, context);
                          },
                          color: Color(0xfff7892b),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.black),
                          ),

                          child: Container(
                            width: 200,
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
                            child: Text('Go',
                                style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                          ),

                        ),

                    ])))),
  );

}