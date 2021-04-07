import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:Motri/screens/CarInsurance.dart';
import 'package:Motri/screens/Main.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'CarInfo.dart';
import 'mySelectedCar.dart';

class GenerateScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => GenerateScreenState();
}

class GenerateScreenState extends State<GenerateScreen> {

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
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;

  GlobalKey globalKey = new GlobalKey();
  String _dataString = "554";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Car QR Code' ,style: TextStyle(
          color: Colors.black,
        ),),
        leading:  IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, ),

          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => MyCarsInfo()),),

        ),
        backgroundColor: Color(0xfff7892b),

        actions: <Widget>[

        ],
      ),
      body: FutureBuilder(
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
                 return _contentWidget(snapshot.data.docs[0].get('Plate Number'));
              }
          }
      )
    );
  }

  Future<void> _captureAndSharePng() async {
    try {
      RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
      var image = await boundary.toImage();
      ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
      Uint8List pngBytes = byteData.buffer.asUint8List();

      final tempDir = await getTemporaryDirectory();
      final file = await new File('${tempDir.path}/image.png').create();
      await file.writeAsBytes(pngBytes);

      final channel = const MethodChannel('channel:me.alfian.share/share');
      channel.invokeMethod('shareFile', 'image.png');

    } catch(e) {
      print(e.toString());
    }
  }

  _contentWidget(String PN) {
    final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Container(
      color: const Color(0xFFFFFFFF),
      child:  Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: _topSectionTopPadding,
              left: 20.0,
              right: 10.0,
              bottom: _topSectionBottomPadding,
            ),
            child:  Container(
              height: _topSectionHeight,

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
          new Center(
            child: new RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              color: Color(0xfff7892b),
              child: const Text('Get Car info'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => CarSelected()));
              },
            ),
          )
        ],
      ),
    );
  }
}