import 'dart:io';
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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:Motri/screens/inputFormat.dart';
void main() => runApp(new Paymentp());

class Paymentp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Payment",

      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new Payment(),
    );
  }
}

class Payment extends StatefulWidget {


  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<Payment> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _formKey = new GlobalKey<FormState>();
  var numberController = new TextEditingController();
  var _autoValidateMode = AutovalidateMode.disabled;

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
  bool isClicked = false;
  bool isRequestExist = false;

  void _sumbitAuthForm(String CardName, CardNumber, CVV, ExpDate, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      final snapShot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser.uid).collection("UsersTickets").where("isSelected", isEqualTo: "true")
          .get();



      await FirebaseFirestore.instance
            .collection('Users').doc(auth.currentUser.uid).collection(
            'UsersTickets').doc(snapShot.docs[0].id).update({
          "isPaid": "true",
          "isSelected": "false",
        });

      showDialog(
          context: context,
          barrierDismissible: false ,
          builder: (context) => AlertDialog(
            title: Text("Ticket paid"),

            content: Text("You have paid the ticket successfully" ),
            actions: [
              FlatButton(
                textColor: Color(0xFF6200EE),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext ctx) => MyApp()),

                  );
                  isClicked = true;
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

  @override
  void initState() {
    super.initState();
  }

  String CardName = "";
  String CardNumber = "";
  String CVV = "";
  String ExpDate = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text("Payment"),
        ),
        body: new Container(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: new Form(
              key: _formKey,
              autovalidateMode: _autoValidateMode,
              child: new ListView(
                children: <Widget>[
                  new SizedBox(
                    height: 20.0,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: const Icon(
                        Icons.person,
                        size: 40.0,
                      ),
                      hintText: 'What name is written on card?',
                      labelText: 'Card Name',
                    ),

                    keyboardType: TextInputType.text,
                    onChanged: (value)
                    {
                      CardName = value;
                      print(CardName);
                    },
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(19),
                      new CardNumberInputFormatter()
                    ],
                    onChanged: (value)
                    {
                      CardNumber = value;
                      print(CardNumber);
                    },
                    controller: numberController,
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: new Image.asset(
                        'assets/images/visa.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'What number is written on card?',
                      labelText: 'Number',
                    ),

                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),

                    ],
                    keyboardType: TextInputType.number,

                    onChanged: (value)
                    {
                      CVV = value;
                      print(CVV);
                    },
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,
                      icon: new Image.asset(
                        'assets/images/card_cvv.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'Number behind the card',
                      labelText: 'CVV',
                    ),

                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  new TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(4),
                      new CardMonthInputFormatter()

                    ],
                    keyboardType: TextInputType.number,

                    onChanged: (value)
                    {
                      ExpDate = value;
                      print(ExpDate);
                    },
                    decoration: new InputDecoration(
                      border: const UnderlineInputBorder(),
                      filled: true,

                      icon: new Image.asset(
                        'assets/images/calender.png',
                        width: 40.0,
                        color: Colors.grey[600],
                      ),
                      hintText: 'MM/YY',
                      labelText: 'Expiry Date',
                    ),

                  ),
                  new SizedBox(
                    height: 50.0,
                  ),
                  new Container(
                    alignment: Alignment.center,
                    child: _getPayButton(),
                  )
                ],
              )),
        ));
  }

  @override
  Widget _getPayButton() {
    if (_isLoading) {
      return CircularProgressIndicator();
    }
    else {
      if (Platform.isIOS) {
        if (!CardName.isEmpty && !CardNumber.isEmpty && !CVV.isEmpty &&
            !ExpDate.isEmpty) {
          return new CupertinoButton(

            onPressed: () {
              _sumbitAuthForm(CardName, CardNumber, CVV, ExpDate, context);
            },
            color: CupertinoColors.activeBlue,
            child: const Text("Pay",
              style: const TextStyle(fontSize: 17.0),
            ),
          );
        }
        else
          {
            return new CupertinoButton(


              color: CupertinoColors.activeBlue,
              child: const Text("Pay",
                style: const TextStyle(fontSize: 17.0),
              ),
            );
          }
      } else {

        if (!CardName.isEmpty && !CardNumber.isEmpty && !CVV.isEmpty &&
            !ExpDate.isEmpty) {
          return new CupertinoButton(

            onPressed: () {
              _sumbitAuthForm(CardName, CardNumber, CVV, ExpDate, context);
            },
            color: CupertinoColors.activeBlue,
            child: const Text("Pay",
              style: const TextStyle(fontSize: 17.0),
            ),
          );
        }
        else
        {

          return new CupertinoButton(

            onPressed: () {
              _sumbitAuthForm(CardName, CardNumber, CVV, ExpDate, context);
            },

            color: CupertinoColors.activeBlue,
            child: const Text("Pay",
              style: const TextStyle(fontSize: 17.0),
            ),
          );
        }
      }
    }
  }
}

