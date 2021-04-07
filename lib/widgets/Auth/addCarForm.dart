import 'package:Motri/screens/Main.dart';
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
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<Album> fetchAlbum(String Make, String year) async {
  final response = await http.get(
      'https://vpic.nhtsa.dot.gov/api/vehicles/getmodelsformakeyear/make/' +
          Make +
          '/modelyear/' +
          year +
          '?format=json');

  if (response.statusCode == 200) {
    return Album.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

class Album {
  int count;
  String message;
  String searchCriteria;
  List<Results> results;

  Album({this.count, this.message, this.searchCriteria, this.results});

  Album.fromJson(Map<String, dynamic> json) {
    count = json['Count'];
    message = json['Message'];
    searchCriteria = json['SearchCriteria'];
    if (json['Results'] != null) {
      results = new List<Results>();
      json['Results'].forEach((v) {
        results.add(new Results.fromJson(v));
      });
    }
  }
}

class Results {
  int makeID;
  String makeName;
  int modelID;
  String modelName;

  Results({this.makeID, this.makeName, this.modelID, this.modelName});

  Results.fromJson(Map<String, dynamic> json) {
    makeID = json['Make_ID'];
    makeName = json['Make_Name'];
    modelID = json['Model_ID'];
    modelName = json['Model_Name'];
  }
}

class AddCar extends StatefulWidget {
  Album _currentDesignation;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<AddCar> {
  final _auth = FirebaseAuth.instance;

  bool checkPlateNum(String PlateNumber) {}
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


  Future<String> getDeviceID() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;

    final result = await users.doc(uid).get();
    return result.get('deviceID');
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController PN = TextEditingController();

  List<String> CarsMakes = new List();
  Album a = new Album();
  Results _selected;
  List<String> Years = new List();
  List<String> Dates = new List();
  Future<Album> futureAlbum = fetchAlbum('', '');
  String YR = '';

  void _sumbitAuthForm(String CarMake, String CarName, String CarYear,
      String PlateNumber, BuildContext ctx) async {
    UserCredential authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      final a = await FirebaseFirestore.instance.collection('Cars').where('UserID', isEqualTo: auth.currentUser.uid).get();
      int size = a.docs.length;

      String CarOwnerName = await getUserName();
      String CarOwnerCID = await getCivilID();
      String deviceID = await getDeviceID();

      final snapShot = await FirebaseFirestore.instance
          .collection('Cars')
          .doc(PlateNumber)
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
        final fbm = FirebaseMessaging();
        String getToken = "";

        await FirebaseFirestore.instance
            .collection('Cars')
            .doc(PlateNumber)
            .set({
          'Car Owner Name': CarOwnerName,
          'CarOwnerName': CarOwnerName,
          'Car Owner Civil ID': CarOwnerCID,
          'Car Make': CarMake,
          'Car Name': CarName,
          'CarName': CarName,
          'Car Year': CarYear,
          'Plate Number': PlateNumber,
          'UserID': auth.currentUser.uid,
          'iaPending': true.toString(),
          'isRejected': false.toString(),
          'isVerified': false.toString(),
          'isSelected': false.toString(),
          'isDisability': false.toString(),
          'deviceID': deviceID,
          'Color': '',
          'Expire Date': Dates.elementAt(size % 5),

        });


        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => ok()),
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


  List <String> ModelNameList = new List();
  void initState() {
    Years.add('');
    ModelNameList.add('');

    for (var i = 2021; i >= 1990; i--) {
      Years.add(i.toString());
    }
    Dates.add('22/8/2023');
    Dates.add('8/5/2022');
    Dates.add('4/11/2021');
    Dates.add('8/2/2023');
    Dates.add('12/8/2022');
    print(Years.length);
    CarsMakes.add("");

    CarsMakes.add("Toyota");
    CarsMakes.add("Kia");
    CarsMakes.add("Mercedes-Benz");
    CarsMakes.add("Nissan");
    CarsMakes.add("Hyundai");
    CarsMakes.add("BMW");
    CarsMakes.add("Ford");
    CarsMakes.add("Audi");
    CarsMakes.add("Chevrolet");
    CarsMakes.add("Honda");
    CarsMakes.add("Mitsubishi");
    CarsMakes.add("Lexus");
    CarsMakes.add("Genesis");

    CarsMakes.add("Acura");
    CarsMakes.add("Alfa Romeo");
    CarsMakes.add("Aston Martin");
    CarsMakes.add("Bentley");
    CarsMakes.add("Bugatti");
    CarsMakes.add("Cadillac");
    CarsMakes.add("Chrysler");
    CarsMakes.add("Dodge");
    CarsMakes.add("Ferrari");
    CarsMakes.add("Fiat");
    CarsMakes.add("Geely");
    CarsMakes.add("GMC");
    CarsMakes.add("Infiniti");
    CarsMakes.add("Isuzu");
    CarsMakes.add("Jaguar");
    CarsMakes.add("Jeep");
    CarsMakes.add("Lamborghini");
    CarsMakes.add("Land Rover");
    CarsMakes.add("Lincoln");
    CarsMakes.add("Lotus");
    CarsMakes.add("Maserati");
    CarsMakes.add("Mazda");
    CarsMakes.add("McLaren");
    CarsMakes.add("Mini");
    CarsMakes.add("Peugeot");
    CarsMakes.add("Porsche");
    CarsMakes.add("RAM");
    CarsMakes.add("Rolls Royce");
    CarsMakes.add("Subaru");
    CarsMakes.add("Suzuki");
    CarsMakes.add("Volkswagen");
    CarsMakes.add("Volvo");
    CarsMakes.sort();
    super.initState();
  }

  String _color = '';
  String CarM = '';
  String PlN = '';

  @override
  String selectedFc = '';
  Widget build(BuildContext context) {
    return new Scaffold(

      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.always,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new FormField(builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.directions_car_rounded),
                        labelText: 'Car Makes',
                      ),
                      isEmpty: CarM == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          value: CarM,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              CarM = newValue;
                              futureAlbum = fetchAlbum(CarM, YR);
                              state.didChange(newValue);
                              selectedFc = '';

                            });
                          },
                          items: CarsMakes.map((String value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),
                  new FormField(builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: const Icon(Icons.date_range),
                        labelText: 'Car Year',
                      ),
                      isEmpty: YR == '',
                      child: new DropdownButtonHideUnderline(
                        child: new DropdownButton(
                          value: YR,
                          isDense: true,
                          onChanged: (String newValue) {
                            setState(() {
                              YR = newValue;
                              futureAlbum = fetchAlbum(CarM, YR);
                              selectedFc = '';
                              state.didChange(newValue);
                            });
                          },
                          items: Years.map((String value) {
                            return new DropdownMenuItem(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  }),
                  new FormField(builder: (FormFieldState state) {
                    return InputDecorator(
                      decoration: InputDecoration(
                        icon: Icon(Icons.car_rental),
                        labelText: 'Car Name',
                      ),
                      isEmpty: selectedFc == '  ',
                      child: FutureBuilder<Album>(
                          future: futureAlbum,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting || CarM == '' || YR == '') {
                              return DropdownButton(items: null, onChanged: null);
                            } else {
                              final album = snapshot.data;
                              final results = album.results;
                              print(results[0].modelName);

                              ModelNameList.clear();
                              ModelNameList.add('');

                              for (var i = 0; i < results.length; i++)
                                {
                                  ModelNameList.add(results[i].modelName);
                                }
                              return DropdownButtonHideUnderline(

                                  child: DropdownButton(
                                isExpanded: true,
                                isDense: true,
                                value: selectedFc,



                                onChanged: (value) {
                                  // selected album
                                  setState(() {
                                    //_selected = album;
                                    selectedFc = value;
                                    print(selectedFc);
                                    state.didChange(selectedFc);
                                  });

                                },
                                    items: ModelNameList.map((String value) {
                                      return new DropdownMenuItem(
                                        value: value,
                                        child: new Text(value),
                                      );
                                    }).toList(),

                              ));
                            }
                          }),
                    );
                  }),
                  new TextFormField(
                    focusNode: FocusNode(),
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
                        PlN = s;
                      });
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  if (_isLoading) Center(child: CircularProgressIndicator()),
                  if (!_isLoading &&
                      YR != '' &&
                      CarM != '' &&
                      selectedFc != '' &&
                      PlN.length > 3)
                    new Container(
                        padding: const EdgeInsets.all(15),
                        child: new RaisedButton(
                          color: Color(0xfff7892b),
                          child: const Text('Submit'),
                          onPressed: () {
                            _sumbitAuthForm(
                              CarM,
                              selectedFc,
                              YR,
                              PlN,
                              context,
                            );
                          },
                        ))
                  else
                    new Container(
                        padding: const EdgeInsets.all(15),
                        child: new RaisedButton(
                          color: Colors.orange,
                          child: const Text('Submit'),
                        )),
                ],
              ))),
    );
  }
}
