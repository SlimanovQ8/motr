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

class AddUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<AddUser> {
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

  void _sumbitAuthForm(String DisNum, BuildContext ctx) async {
    UserCredential authResult;
    print(DisNum);
    try {
      setState(() {
        _isLoading = true;
        isRequestExist = false;
        isExist = true;
        isSameUser  =false;
      });
      final snapShot = await FirebaseFirestore.instance.collection('Users').where('UserName', isEqualTo: DisNum).get();
      print(snapShot);
      if (snapShot.size > 0) {
        //it exists
        setState(() {
          isExist = true;
          print('rtgutgv');
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
      String CarOwnerName = await getUserName();
      String deviceID = await getDeviceID();
      String getReciverDeviceID = await getReciverDeviceIDD(DisNum);
      String CarName = await getSenderCarName();
      String PlateNumber = await getPlateNumber();
      String ReciverName = await getReciverName(DisNum);
      String ReciverUserID = await getRecieverUserID(DisNum);
      String ReciverUserName = await getReciverUserName(DisNum);
      String UserN = await getSenderUserName();
      String email = await getRecieverEmail(DisNum);
      final chk =  await FirebaseFirestore.instance
          .collection('Cars').doc(PlateNumber).collection(
          'UsersList').doc(ReciverUserName).get();
      if (chk.exists) {
        //it exists
        setState(() {
          isRequestExist = true;
          print('ghb');
        });
      } else {
        //not exists
        print('hgjfjnj');
        isRequestExist = false;
        setState(() {
          print("zrga");
          isRequestExist = false;
        });
      }
       if(UserN == DisNum)
       {
         setState(() {
           isSameUser = true;
         });
       }
       else
         {
           isSameUser = false;
         }
      if (isExist && !isRequestExist && !isSameUser) {


       var docid =  await FirebaseFirestore.instance.collection('AddUser').add({
          "SenderDeviceID": deviceID,
          "SenderName": CarOwnerName,
          "SenderUserName": UserN,
          "CarName": CarName,
          "deviceID": getReciverDeviceID,
          "geterName": ReciverName,
         "UN": ReciverUserName,
          "Status": "Pending",
          "PlateNumber": PlateNumber,
         "geterEmail": email,

         "authID":  auth.currentUser.uid,

       });
       docid.update({
         "NotifyID": docid.id
       });
       var ID = await FirebaseFirestore.instance.collection('Requests').doc(auth.currentUser.uid).collection('MyRequests').doc(docid.id).set({
         "title": 'User Request',
         "SenderDeviceID": deviceID,
         "SenderName": CarOwnerName,
         "SenderCar": CarName,
         "deviceID": getReciverDeviceID,
         "geterName": ReciverName,
         "Status": "Pending",
         "PlateNumber": PlateNumber,
         "RequestID": docid.id,
         "UserName": ReciverUserName,
         "geterEmail": email
       });
       await FirebaseFirestore.instance
           .collection('Cars').doc(PlateNumber).collection(
           'UsersList').doc(ReciverUserName).set({
         "title": 'User Request',
         "SenderDeviceID": deviceID,
         "SenderName": CarOwnerName,
         "SenderCar": CarName,
         "deviceID": getReciverDeviceID,
         "geterName": ReciverName,
         "Status": "Pending",
         "DisabilityNumber": disNumber,
         "PlateNumber": PlateNumber,
         "RequestID": docid.id,
         "UserName": ReciverUserName,
         "GeterUserID": ReciverUserID


       });
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Request Sent"),
              content: Text("Your request has been sent to "  + ReciverUserName),
              actions: [
                FlatButton(
                  textColor: Color(0xFF6200EE),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext ctx) => MainMotri()),
                    );
                  },
                  child: Text('OK'),
                ),

              ],
            )
        );
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
        _sumbitAuthForm(qrCode,  context);
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
  String disNumber = "";
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
                        child: Text(
                          "Enter Username",
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
                            hintText: 'Enter UserName',
                            labelText: 'Username',
                          ),
                          onChanged: (String s )
                          {
                            setState(() {
                              disNumber = s;
                            });
                          },
                          validator: (b)
                          {
                            if (isExist == false) {
                              return "Username does not exist!";
                            }
                            if (isRequestExist)
                              return "You make a request for this disability person on this car before";
                            if(isSameUser)
                              return "You Can't add yourself";
                            return null;
                          },

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

                    ])))),
  );

}