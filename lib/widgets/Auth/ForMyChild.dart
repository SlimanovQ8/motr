import 'package:Motri/screens/Main.dart';
import 'package:Motri/screens/OkChild.dart';
import 'package:Motri/screens/OkSelf.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/screens/ok.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

class MyChild extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyChild> {
  final _auth = FirebaseAuth.instance;

  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey gk = new GlobalKey();
  var _isLoading = false;
  bool isExistCivilID = false;
  bool isExist = false;
  bool isExistOnChild = false;
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
  final GlobalKey<FormState> _formKeyDisChild = new GlobalKey<FormState>();
  TextEditingController PN = TextEditingController();

  List<String> DisTypeArray = new List();

  void _sumbitAuthForm(
      String ChildName, String ChildCivilID, String DisNum, String BlueSNum, String DType, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
        isExistCivilID = false;
        isExist = false;
        isExistOnChild = false;
      });

      String DisName = await getUserName();
      String DisCivil = await getCivilID();
      String deviceID = await getDeviceID();

      final snapShot = await FirebaseFirestore.instance
          .collection('Disabilities')
          .doc(DisNum)
          .get();
      final ZsnapShot = await FirebaseFirestore.instance
          .collection('DisabilitiesChild')
          .doc(DisNum)
          .get();


      final ChildID = await FirebaseFirestore.instance
          .collection('DisabilitiesCID')
          .doc(ChildCivilID)
          .get();

      if (snapShot.exists) {
        //it exists
        setState(() {
          isExist = true;
        });
      } else {
        //not exists
        setState(() {
          isExist = false;
        });
      }
      if (ZsnapShot.exists) {
        //it exists
        setState(() {
          isExistOnChild = true;
        });
      } else {
        //not exists
        setState(() {
          isExistOnChild = false;
        });
      }
      if (ChildID.exists) {
        //it exists
        setState(() {
          isExistCivilID = true;
        });
      } else {
        //not exists
        setState(() {
          isExistCivilID = false;
        });
      }


      if (!isExist && !isExistCivilID &&  !isExistOnChild) {
        await FirebaseFirestore.instance
            .collection('DisabilitiesChild')
            .doc(DisNum)
            .set({
          'DisabilityParentName': DisName,
          'DisabilityParentCivilID': DisCivil,
          'ChildName' : ChildName,
          'ChildCivilID': ChildCivilID,
          'DisabilityNumber': DisNum,
          'BlueSignNum': BlueSNum,
          'DisabilityType': DType,
          'UserID': auth.currentUser.uid,
          'isDisability': '?',
          'deviceID': deviceID,
          'iaPending': true.toString(),
          'isRejected': false.toString(),
          'isVerified': false.toString(),
          'isSelected': false.toString(),
        });

        await FirebaseFirestore.instance
            .collection('DisabilitiesCID')
            .doc(ChildCivilID)
            .set({
          'DisabilityCivilID': ChildCivilID,
          'DisabilityName': DisName,
          'deviceID': deviceID,


        });
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => OkChild()),
        );
      }
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
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

  String ChildName = '';
  String ChildCID = '';
  String DisabilityNum = '';
  String BLueSignNumber = '';
  String DisType = '';

  @override
  String selectedFc = '';
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("For My Child", style: TextStyle(
          color: Colors.black,
        ),),
        backgroundColor: Color(0xfff7892b),
      ),
      body:  new SafeArea(
          top: false,

          bottom: false,
          child: new Form(
              key: _formKeyDisChild,
              autovalidateMode: AutovalidateMode.always,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: 'Enter Your Child Name',
                      labelText: 'Child Name',
                    ),

                    onChanged: (String s) {
                      setState(() {
                        ChildName = s;
                      });
                    }),
                  SizedBox(
                    height: 8,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.child_care),
                      hintText: 'Enter Child Civil ID',
                      labelText: ' Child CID ',
                    ),
                    validator: (b) {
                      if (isExistCivilID) {
                        return 'Civil ID is already registered as a disability person';
                      }
                      return null;
                    },
                    onChanged: (String s) {
                      setState(() {
                        ChildCID = s;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.wheelchair_pickup_rounded),
                      hintText: 'Enter Disability Number',
                      labelText: 'Disability Number',
                    ),
                    validator: (b) {
                      if (isExist || isExistOnChild) {
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
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  new TextFormField(
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.wheelchair_pickup_rounded),
                      hintText: 'Enter Blue Sign Number',
                      labelText: 'Blue Number',
                    ),
                    onChanged: (String s) {
                      setState(() {
                        BLueSignNumber = s;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9]')),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
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
                  SizedBox(
                    height: 8,
                  ),
                  if (_isLoading)
                    Center(child: CircularProgressIndicator()),
                  if (!_isLoading &&
                      DisabilityNum.length > 3 &&
                      DisType != '' &&
                      BLueSignNumber.length > 3)
                    new Container(
                        padding: EdgeInsets.all(15),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),

                          color: Color(0xfff7892b),
                          child: const Text('Request'),
                          onPressed: () {
                            FocusScope.of(context).requestFocus(FocusNode());

                            _sumbitAuthForm(
                              ChildName,
                              ChildCID,
                              DisabilityNum,
                              BLueSignNumber,
                              DisType,
                              context,
                            );
                          },
                        ))
                  else
                    new Container(
                        padding: EdgeInsets.all(20),
                        child: new RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),

                          color: Colors.orange,
                          child: const Text('Request'),
                        )),
                ],
              ))),


    );
  }

  _contentWidget(String PN) {
    final bodyHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).viewInsets.bottom;
    return Container(
      color: const Color(0xFFFFFFFF),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child: Container(
              height: _topSectionHeight,
            ),
          ),
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: gk,
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

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = gk.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');
    } catch (e) {
      print(e.toString());
    }
  }
}
