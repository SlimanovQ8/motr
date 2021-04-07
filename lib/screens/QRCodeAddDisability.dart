import 'package:Motri/widgets/Auth/SelectCarDisForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:Motri/screens/Widget/button_widget.dart';

import '../main.dart';
import 'MyCars.dart';
import 'mySelectedCar.dart';

class QRScanPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String qrCode = 'Unknown';

  @override
  Widget build(BuildContext context) =>  MaterialApp(
  title: 'Add Disability',
  home: Scaffold(
  appBar: AppBar(
  leading: IconButton(
  icon: Icon(Icons.arrow_back, color: Colors.black),
  onPressed: () =>
  Navigator.of(context).push(
  MaterialPageRoute(builder: (ctx) => SelectDisForm()),
  ),
  ),
  title: Text('Add Disability', style: TextStyle(
    color: Colors.black,
  ),),
  backgroundColor: Color(0xfff7892b),
  ),
  body: Container(
  alignment: Alignment.center,
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
  Container(
  alignment: Alignment.center,
  margin: EdgeInsets.all(20),
  child: Text(
  "Enter Disabillity Code",
  style: TextStyle(fontSize: 30),
  ),
  ),
  Container(
  alignment: Alignment.center,
  margin: EdgeInsets.all(20),
  child: new TextFormField(
  focusNode: FocusNode(),
  decoration: const InputDecoration(
  hintText: 'Enter disability number',
  labelText: 'Disability Number',
  ),

  keyboardType: TextInputType.phone,
  inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
  ],
  ),
  ),

  RaisedButton(
  onPressed: () {},
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
  borderRadius: BorderRadius.all(Radius.circular(5)),
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

  icon: Icon(
  Icons.camera_alt_rounded,
  color: Color(0xfff7892b),

  size: 100.0,
  ),
  ),
  )
  ]))),
  );

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
        if (this.qrCode.endsWith('32'))
        {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => CarSelected()));

        }
      });
    } on PlatformException {
      qrCode = 'Failed to get platform version.';
    }
  }
}
