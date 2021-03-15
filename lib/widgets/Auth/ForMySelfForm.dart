import 'package:Motri/screens/Main.dart';
import 'package:Motri/screens/OkSelf.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/screens/ok.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/models/lang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MySelf extends StatefulWidget {

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MySelf> {
  final _auth = FirebaseAuth.instance;


  var _isLoading = false;
  bool isExist = false;
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

  final GlobalKey<FormState> _formKeyDis= new GlobalKey<FormState>();
  TextEditingController PN = TextEditingController();

  List<String> DisTypeArray = new List();


  void _sumbitAuthForm(String DisNum, String BlueSNum, String DType,
       BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });


      String DisName = await getUserName();
      String DisCivil = await getCivilID();


      final snapShot = await FirebaseFirestore.instance.collection('Disabilities').doc(DisNum).get();

      if (snapShot.exists) {
        //it exists
        setState(() {
          isExist = true;
        });
      }
      else {
        //not exists
        setState(() {
          isExist = false;
        });

        await FirebaseFirestore.instance.collection('Disabilities')
            .doc(DisNum)
            .set({
          'Disability Name': DisName,
          'Disability Civil ID': DisCivil,
          'Disability Number': DisNum,
          'Blue Sign Num': BlueSNum,
          'Disability Type': DType,
          'UserID': auth.currentUser.uid,
          'isDisability': false.toString(),


        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => OkSelf()),);
      }
      setState(() {
        _isLoading = false;
      });
    }
    catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  void initState() {
    DisTypeArray.add("");

    DisTypeArray.add("Physical disability");
    DisTypeArray.add("Brain disability");
    super.initState();
  }

  String DisabilityNum = '';
  String BLueSignNumber = '';
  String DisType = '';

  @override
  String selectedFc = '';
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: FutureBuilder(
          future: getUserName(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text( '');
            }
            return Text(snapshot.data + '');
          },
        ),
        backgroundColor: Color(0xfff7892b),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKeyDis,
              autovalidateMode: AutovalidateMode.always,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[

                  new TextFormField(
                    focusNode: FocusNode(),


                    decoration: const InputDecoration(
                      icon: const Icon(Icons.wheelchair_pickup_rounded),
                      hintText: 'Enter Disability Number',
                      labelText: 'Disability Number',
                    ),
                    validator: (b) {
                      if (isExist)
                      {
                        return 'Disability Number is already registered';
                      }
                      return null;
                    },
                    onChanged: (String s) {
                      setState(() {
                        DisabilityNum = s;


                      });
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  SizedBox(height: 8,),


                  new TextFormField(
                    focusNode: FocusNode(),


                    decoration: const InputDecoration(
                      icon: const Icon(Icons.wheelchair_pickup_rounded),
                      hintText: 'Enter Blue Sign Number',
                      labelText: 'Blue Number',
                    ),
                    validator: (b) {
                      if (isExist)
                      {
                        return 'Disability Number is already registered';
                      }
                      return null;
                    },
                    onChanged: (String s) {
                      setState(() {
                        BLueSignNumber = s;


                      });
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),

                  SizedBox(height: 8,),

                  new FormField(builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.merge_type),
                        labelText: 'Disability Type',
                      ),
                      isEmpty: DisType == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          value: DisType,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              DisType = newValue;
                              state.didChange(newValue);
                            });
                          },
                          items: DisTypeArray.map((String value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),


                  SizedBox(height: 8,),
                  if (_isLoading)

                    Center(child: CircularProgressIndicator()),
                  if (!_isLoading &&

                      DisabilityNum.length > 3 && DisType != '' && BLueSignNumber.length > 3)

                    new Container(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: new RaisedButton(
                          color: Color(0xfff7892b),
                          child: const Text('Request'),
                          onPressed: () {


                            _sumbitAuthForm(DisabilityNum, BLueSignNumber, DisType, context,);

                          },
                        ))
                  else
                    new Container(
                        padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                        child: new RaisedButton(
                          color: Colors.orange,
                          child: const Text('Request'),
                        )),
                ],
              ))),
    );
  }
}
