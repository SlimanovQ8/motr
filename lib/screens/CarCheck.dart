import 'package:Motri/screens/CarInfoAllPolice.dart';
import 'package:Motri/screens/Main.dart';
import 'package:Motri/screens/MainPolice.dart';
import 'package:Motri/screens/SelectCarDis.dart';
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

class CarCheck extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<CarCheck> {
  String qrCode = 'Unknown';

  @override
  var _isLoading = false;
  bool isExist = true;
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
  Future<String> getReciverDeviceID(String getReciverID) async {
    final CollectionReference users = firestore.collection('DisabilitiesCID');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(getReciverID).get();
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
  Future<String> getRecieverEmail(String getE) async {
    final CollectionReference users = firestore.collection('DisabilitiesCID');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(getE).get();
    return result.get('email');
  }
  Future<String> getDisabilityName(String getReciverID) async {
    final CollectionReference users = firestore.collection('DisabilitiesCID');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(getReciverID).get();
    return result.get('DisabilityName');
  }
  Future<String> getReciverUserName(String getReciverName) async {
    final CollectionReference users = firestore.collection('DisabilitiesCID');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(getReciverName).get();
    return result.get('UserName');
  }
  bool isRequestExist = false;
  void _sumbitAuthForm(String PlateNumber, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
        isExist = true;
      });

      final chk =  await FirebaseFirestore.instance
          .collection('Cars').doc(PlateNumber).get();
      if (chk.exists) {
        //it exists
        setState(() {
          isExist = true;
          print('ghb');
        });
      } else {
        //not exists
        print('hgjfjnj');
        isExist = false;
        setState(() {
          print("zrga");
          isExist = false;
        });
      }
      if (isExist ) {

        await FirebaseFirestore.instance.collection("MOI").doc(auth.currentUser.uid).update({
          "PlateNumber": PlateNumber,
          "CurrentlyUseCar": " "
        });
        await FirebaseFirestore.instance.collection("Cars").doc(PlateNumber).get().then((value) {
          FirebaseFirestore.instance.collection("MOI").doc(auth.currentUser.uid).update({
            "CarID": value.get("UserID"),
          });
        });


        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => AllCarInfoPolice()),);


      }


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
  void _sumbitAuthFormQR(String PlateNumber, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
        isExist = true;
      });

      String PlateNum = PlateNumber.substring(0, PlateNumber.indexOf('-'));
      String CarUse = PlateNumber.substring(PlateNumber.indexOf('-') + 1);
      final chk =  await FirebaseFirestore.instance
          .collection('Cars').doc(PlateNum).get();
      if (chk.exists) {
        //it exists
        setState(() {
          isExist = true;
          print('ghb');
        });
      } else {
        //not exists
        print('hgjfjnj');
        isExist = false;
        setState(() {
          print("zrga");
          isExist = false;
        });
      }
      if (isExist ) {

        await FirebaseFirestore.instance.collection("MOI").doc(auth.currentUser.uid).update({
          "PlateNumber": PlateNum,
          "CurrentlyUseCar": CarUse

        });
        await FirebaseFirestore.instance.collection("Cars").doc(PlateNum).get().then((value) {
          FirebaseFirestore.instance.collection("MOI").doc(auth.currentUser.uid).update({
            "CarID": value.get("UserID"),
          });
        });


        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => AllCarInfoPolice()),);


      }


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

  Future<void> scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (!mounted) return;

      setState(() {
        this.qrCode = qrCode;
        print(this.qrCode);
        _sumbitAuthFormQR(qrCode,  context);
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
  String disNumber = "";
  Widget build(BuildContext context) => MaterialApp(
    title: 'Add Disability',
    home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MyApp()),
            ),
          ),
          title: Text('Car Scan', style: TextStyle(
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
                        child: Text(
                          "Enter Car plate number",
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        child: new TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          focusNode: FocusNode(),
                          decoration: const InputDecoration(
                            hintText: 'Enter car plate number',
                            labelText: 'Plate Number',
                          ),
                          keyboardType: TextInputType.phone,
                          onChanged: (String s )
                          {
                            setState(() {
                              disNumber = s;
                            });
                          },
                          validator: (b)
                          {
                            if (isExist == false) {
                              return "Plate number does not exist!";
                            }

                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                        ),
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
                            _sumbitAuthForm(disNumber, context);
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
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(20),
                        child: Text(
                          " OR \n Scan the QR Code",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      new Container(
                        width: 200,
                        child: new IconButton(
                          onPressed: () {
                            scanQRCode();
                          },

                          icon: Icon(
                            Icons.camera_alt_rounded,
                            color: Color(0xfff7892b),
                            size: 100.0,
                          ),
                        ),
                      )
                    ])))),
  );

}