import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/CarInsurance.dart';
import 'package:Motri/screens/CarInsurancePolice.dart';
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
import 'package:photo_view/photo_view.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:path_provider/path_provider.dart';

GlobalKey gkp = new GlobalKey();

class Tickets{
  int TicketID;
  int Price;
  bool isChecked;
  String TicketTitle;
  String TicketInfo;

  Tickets({this.TicketID, this.Price, this.isChecked, this.TicketTitle, this.TicketInfo});

  static List<Tickets> getTicketsInfo() {
    return <Tickets>[
      Tickets(
          TicketID: 1,
          Price: 50,
          isChecked: false,
          TicketTitle: "Disabiltiy Ticket",
          TicketInfo: "Parked in disability parking spot and no disability person in the car"
      ),

      Tickets(
          TicketID: 2,
          Price: 10,
          isChecked: false,
          TicketTitle: "Driver not registered",
          TicketInfo: "The car driver is not added in car users list"
      ),
      Tickets(
        TicketID: 3,
        Price: 5,
        isChecked: false,
        TicketTitle: "Expired car insurance",
        TicketInfo: "Car insurance is expired",
      ),
    ];
  }


}
var _isLoading = false;
bool isExist = true;
bool isSameUser = false;
String userEmail = FirebaseAuth.instance.currentUser.email;
String use = FirebaseAuth.instance.currentUser.uid;

class AllInfoPolice extends StatefulWidget {
  _myCars createState() => new _myCars();
}
final firestore = FirebaseFirestore.instance; //
FirebaseAuth auth = FirebaseAuth.instance;

Future<String> getCarPlateNumber() async {
  final CollectionReference users = FirebaseFirestore.instance.collection('MOI');

  final String uid = auth.currentUser.uid;

  final result = await users.doc(uid).get();
  return result.get('PlateNumber');
}
class _myCars extends State<AllInfoPolice> {

  _contentWidget(String PN, int num) {
    //final bodyHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).viewInsets.bottom;
    return  Dismissible(
      direction: DismissDirection.vertical,
      key: const Key('key'),

      onDismissed: (_) {
        Navigator.of(context, rootNavigator: true).pop();

      },
      child: Container(
        height: 400,
        color: const Color(0xFFFFFFFF),
        child: Column(
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  right: 10.0,
                ),
                child: Container(
                  //height: _topSectionHeight,

                ),
              ),
              Expanded(
                child: Center(
                  child: RepaintBoundary(
                    key: gkp,
                    child: Container(


                      child: PhotoView(

                        imageProvider: num == 2? NetworkImage(PN):
                        AssetImage(PN),
                      ),
                    ), /*PhotoView(

                    imageProvider: NetworkImage(PN),
                  ),*/
                  ),


                ),
              ),
            ]
        ),



      ),
    );
  }
  int indexXX = 0;
  @override
  static const double _topSectionTopPadding = 50.0;
  static const double _topSectionBottomPadding = 20.0;
  static const double _topSectionHeight = 50.0;
  void _sumbitAuthForm(String TicketName, String TicketInfo, String Price, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;

      });

      String PlNumber = await getCarPlateNumber();

      final CarInfo = await FirebaseFirestore.instance.collection('Cars').doc(PlNumber).get();
      final UserID = await FirebaseFirestore.instance.collection('Users').doc(CarInfo.get('UserID')).get();


      final now = new DateTime.now();

      String Date = now.day.toString() + '-' + now.month.toString() + '-' + now.year.toString();
      await FirebaseFirestore.instance.collection("Users").doc(CarInfo.get("UserID")).collection("UsersTickets").add({
        "TicketName": TicketName,
        "TicketPlace": "Kuwait",
        "TicketDate": Date,
        "CarName": CarInfo.get("Car Name"),
        "PlateNumber": CarInfo.get("Plate Number"),
        "isPaid": "false",
        "TicketAmount": Price,
        "TicketInfo": TicketInfo,
      });

      await FirebaseFirestore.instance.collection("AddTicket").add({
        "TicketName": TicketName,
        "TicketPlace": "Kuwait",
        "TicketDate": Date,
        "CarName": CarInfo.get("Car Name"),
        "PlateNumber": CarInfo.get("Plate Number"),
        "isPaid": "false",
        "TicketAmount": Price,
        "TicketInfo": TicketInfo,
        "deviceID": UserID.get("deviceID"),
        "Name": UserID.get("Name"),
        "UserID": UserID.id,
      });





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
  List <Tickets> ticketsList = Tickets.getTicketsInfo();
  GlobalKey globalKey = new GlobalKey();
  String _dataString = "554";
  String _inputErrorText;
  final TextEditingController _textController =  TextEditingController();
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



  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 4,
      child: new Scaffold(
        appBar: new TabBar(
          labelColor: Colors.orange,
          tabs: <Widget>[

            new Tab(
              child: new Text(
                "Car info",
                style: TextStyle(
                    fontSize: 14
                ),
              ),
            ),
            new Tab(
              child: new Text(
                "Users list",
                style: TextStyle(
                    fontSize: 14
                ),
              ),
            ),
            new Tab(
              child: new Text(
                "Disabilities", style: TextStyle(
                fontSize: 14
              ),
              ),

            ),
            new Tab(
              child: new Text(
                "Tickets",
                style: TextStyle(
                    fontSize: 14
                ),
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
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('MOI')
                        .where('UserID', isEqualTo: auth.currentUser.uid)
                        .get(),
                    builder: (context, AsyncSnapshot <QuerySnapshot> q)
                    {
                      if (q.data == null)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      else
                      {
                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Cars')
                              .where('Plate Number', isEqualTo: q.data.docs[0].get("PlateNumber"))
                              .where('isVerified', isEqualTo: true.toString())
                              .get(),
                          builder: (context, AsyncSnapshot <QuerySnapshot> snapshot)
                          {
                            if (snapshot.data == null)
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            else
                            {
                              final now = new DateTime.now();
                              String a =
                              snapshot.data.docs[0].get('Expire Date');
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
                              return  SingleChildScrollView(child: new Column(
                                children: <Widget>[


                                  new ListTile(
                                    leading: const Icon(Icons.person),
                                    title: const Text('Car Owner Name'),
                                    trailing:  Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  if (q.data.docs[0].get("isD") == 'true')
                              Container(
                                padding: EdgeInsets.only(right: 12.0),
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        right: new BorderSide(
                                            width: 1.0, color: Colors.black))),
                                child: Transform.scale(scale: 1.2,
                                  child: IconButton(
                                    icon: Image.asset('images/addDis.png', )
                                    ,
                                      onPressed: () {

                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  content: Text("The car owner is disability"),
                                                  actions: [

                                                    FlatButton(
                                                      textColor: Color(0xFF6200EE),
                                                      onPressed: () {

                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('Ok'),
                                                    ),
                                                  ],
                                                )
                                        );


                                      }
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
                                                      leading: new Icon(Icons.image_aspect_ratio),
                                                      title: new Text('Show License'),
                                                      onTap: () => {
                                                        showDialog(
                                                          context: context,

                                                          builder: (BuildContext context) =>
                                                          new Dialog(

                                                            child: Container(
                                                              height: 500,
                                                              width: 500,
                                                              child: DefaultTabController(
                                                                length: 2,
                                                                child: Scaffold(
                                                                  appBar: new TabBar(
                                                                    labelColor: Colors.orange,
                                                                    tabs: <Widget>[
                                                                      new Tab(
                                                                        text: "Front Picture",
                                                                      ),
                                                                      new Tab(
                                                                        text: "Back Picture",
                                                                      ),

                                                                    ],
                                                                  ),
                                                                  body: new Container(

                                                                    alignment: Alignment.center,
                                                                    padding: const EdgeInsets.only(top: 10),
                                                                    child: TabBarView(
                                                                      children: <Widget> [
                                                                        new Container(
                                                                          child: new Center(
                                                                            child: new FutureBuilder(
                                                                                future: FirebaseFirestore.instance
                                                                                    .collection('Users')
                                                                                    .where('Civil ID', isEqualTo: snapshot.data.docs[0].get("Car Owner Civil ID"))
                                                                                    .where('FrontPic', isEqualTo: true.toString())
                                                                                    .get(),
                                                                                builder:
                                                                                    (context, AsyncSnapshot<QuerySnapshot> qa) {
                                                                                  if (qa.data == null) {
                                                                                    return Container(
                                                                                      child: Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                  else if (qa.data.docs.length == 0){


                                                                                    return new Text("No Front Picture");
                                                                                  }
                                                                                  else
                                                                                  {
                                                                                    return new Center(
                                                                                      child: Material(
                                                                                        child: InkWell(
                                                                                          onTap: () {
                                                                                            print('ergdhb ');



                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (context) => _contentWidget(qa.data.docs[0].get("FrontURL"), 2),
                                                                                            );


                                                                                          },
                                                                                          child: Container(
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                                              child: Image.network(
                                                                                                qa.data.docs[0].get("FrontURL") ,
                                                                                                height: 300,
                                                                                              ),),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );

                                                                                  }
                                                                                }),
                                                                          ),
                                                                        ),

                                                                        new Container(
                                                                          child: new Center(
                                                                            child: new FutureBuilder(
                                                                                future: FirebaseFirestore.instance
                                                                                    .collection('Users')
                                                                                    .where('Civil ID', isEqualTo: snapshot.data.docs[0].get("Car Owner Civil ID"))
                                                                                    .where('BackPic', isEqualTo: true.toString())
                                                                                    .get(),
                                                                                builder:
                                                                                    (context, AsyncSnapshot<QuerySnapshot> qa) {
                                                                                  if (qa.data == null) {
                                                                                    return Container(
                                                                                      child: Center(
                                                                                        child: CircularProgressIndicator(),
                                                                                      ),
                                                                                    );
                                                                                  }
                                                                                  else if (qa.data.docs.length == 0){


                                                                                    return new Text("No Back picture");

                                                                                  }
                                                                                  else
                                                                                  {
                                                                                    return new Center(


                                                                                      child: Material(
                                                                                        child: InkWell(
                                                                                          onTap: () {
                                                                                            print('ergdhb ');


                                                                                            showDialog(
                                                                                              context: context,
                                                                                              builder: (context) => _contentWidget(qa.data.docs[0].get("BackURL"), 2),
                                                                                            );



                                                                                          },
                                                                                          child: Container(
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(20.0),
                                                                                              child: Image.network(
                                                                                                qa.data.docs[0].get("BackURL") ,
                                                                                                height: 300,
                                                                                              ),),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );


                                                                                  }
                                                                                }),
                                                                          ),
                                                                        ),


                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),


                                                                /*Center(
        child: */
                                                              ),
                                                            ),

                                                          ),
                                                        )
                                                      }
                                                  ),

                                                  new ListTile(
                                                    leading: new Icon(Icons.info_outline_rounded),
                                                    title: new Text("Personal Info"),
                                                    onTap: () => {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) =>
                                                              AlertDialog(
                                                                title: Text("Personal Info"),
                                                                content: FutureBuilder(future: FirebaseFirestore.instance.collection('Users')
                                                                    .where('Civil ID', isEqualTo: snapshot.data.docs[0].get("Car Owner Civil ID"))
                                                                    .get(),
                                                                    builder: (context, AsyncSnapshot<QuerySnapshot> qs)
                                                                    {
                                                                      if (qs.data == null) {
                                                                        return Container(
                                                                          height: 40,
                                                                          width: 40,
                                                                          child: Center(
                                                                            child: CircularProgressIndicator(),
                                                                          ),
                                                                        );
                                                                      } else if (qs.data.docs.length == 0) {
                                                                        return Container(
                                                                          child: Center(
                                                                            child: Text(
                                                                              'No users uses this car.',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(fontSize: 18),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }
                                                                      else
                                                                      {

                                                                        return Text ("Name: " + qs.data.docs[0].get("Name") + "\n \n"
                                                                            "Civil ID: " + qs.data.docs[0].get("Civil ID") + "\n \n"
                                                                            "Username: " + qs.data.docs[0].get("UserName") + "\n \n"
                                                                        );
                                                                      }
                                                                    }

                                                                ),




                                                                actions: [


                                                                  FlatButton(
                                                                    textColor: Color(0xFF6200EE),
                                                                    onPressed: () {

                                                                      Navigator.pop(context);
                                                                    },
                                                                    child: Text('Ok'),
                                                                  ),
                                                                ],
                                                              )
                                                      ),
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
                                    subtitle:  q.data.docs[0].get('CurrentlyUseCar') == snapshot.data.docs[0].get("UserID") ?
                                  Text(snapshot.data.docs[0].get('Car Owner Name') + "\n(Currently uses the car)")
                                    : Text(snapshot.data.docs[0].get('Car Owner Name')),

                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 4.0,
                                  ),
                                  new ListTile(
                                    leading: const Icon(Icons.car_rental),
                                    title: const Text('Car Make'),
                                    subtitle:  Text(snapshot.data.docs[0].get('Car Make')),         ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 4.0,
                                  ),
                                  new ListTile(
                                    leading: const Icon(Icons.directions_car_rounded),
                                    title: const Text('Car Name'),
                                    subtitle:  Text(snapshot.data.docs[0].get('Car Name')),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 4.0,
                                  ),
                                  new ListTile(
                                    leading: const Icon(Icons.electric_car_sharp),
                                    title: const Text('Car Year'),
                                    subtitle:  Text(snapshot.data.docs[0].get('Car Year')),

                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height:  4.0,
                                  ),
                                  new ListTile(
                                    leading: const Icon(Icons.electric_car_sharp),
                                    title: const Text('Plate Number'),
                                    subtitle:  Text(snapshot.data.docs[0].get('Plate Number')),

                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 4.0,
                                  ),


                                  new ListTile(


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
                                                              ?  Text("Car insurance will be expire in " +
                                                              diff
                                                                  .toString() +
                                                              " days") : orange == true
                                                              ?Text("\ Car insurance will be expire in " +
                                                              diff
                                                                  .toString() +
                                                              " days")
                                                              : Text("Car insurance expired " +
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



                                        ],
                                      ),
                                      title: const Text('Car insurance expire date'),
                                  
                                    subtitle: Text (snapshot.data.docs[0].get('Expire Date')),
                                    leading: Icon(Icons.calendar_today),
                                  ),
                                  const Divider(
                                    color: Colors.black,
                                    height: 4.0,
                                  ),
                                  new Container(
                                      padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                                      child: new RaisedButton(
                                        color: Color(0xfff7892b),
                                        child: const Text('Car Insurance'),
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(builder: (ctx) => CarInsurancePolice())
                                          );
                                        },
                                      ))
                                ],
                              )
                              );


                            }
                          },
                        );

                      }
                    },
                  ),
                ),
              ),
              new Container(
                child: new Center(
                  child: new FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('MOI')
                          .where('UserID', isEqualTo: auth.currentUser.uid)
                          .get(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> q) {
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
                                'You have no rejected cars.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return FutureBuilder( future: FirebaseFirestore.instance.collection('Cars').doc(q.data.docs[0].get('PlateNumber'))
                              .collection('UsersList').where("Status", isEqualTo: "Accepted").get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> ss)
                              {
                                if (ss.data == null) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (ss.data.docs.length == 0) {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        'No users uses this car.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                }
                                else {
                                  return  ListView.separated(
                                      separatorBuilder: (context, index) => Divider(
                                        color: Colors.black,
                                      ),
                                      itemCount: ss.data.docs.length,
                                      itemBuilder: (context, int i) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 20.0),
                                          child: Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 6.0),
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      224, 224, 224, .9)),
                                              child: ListTile(
                                                trailing: new IconButton(
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
                                                                    leading: new Icon(Icons.image_aspect_ratio),
                                                                    title: new Text('Show License'),
                                                                    onTap: () => {
                                                                      showDialog(
                                                                        context: context,

                                                                        builder: (BuildContext context) =>
                                                                        new Dialog(

                                                                          child: Container(
                                                                            height: 500,
                                                                            width: 500,
                                                                            child: DefaultTabController(
                                                                              length: 2,
                                                                              child: Scaffold(
                                                                                appBar: new TabBar(
                                                                                  labelColor: Colors.orange,
                                                                                  tabs: <Widget>[
                                                                                    new Tab(
                                                                                      text: "Front Picture",
                                                                                    ),
                                                                                    new Tab(
                                                                                      text: "Back Picture",
                                                                                    ),

                                                                                  ],
                                                                                ),
                                                                                body: new Container(

                                                                                  alignment: Alignment.center,
                                                                                  padding: const EdgeInsets.only(top: 10),
                                                                                  child: TabBarView(
                                                                                    children: <Widget> [
                                                                                      new Container(
                                                                                        child: new Center(
                                                                                          child: new FutureBuilder(
                                                                                              future: FirebaseFirestore.instance
                                                                                                  .collection('Users')
                                                                                                  .where('UserName', isEqualTo: ss.data.docs[i].id)
                                                                                                  .where('FrontPic', isEqualTo: true.toString())
                                                                                                  .get(),
                                                                                              builder:
                                                                                                  (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                                if (snapshot.data == null) {
                                                                                                  return Container(
                                                                                                    child: Center(
                                                                                                      child: CircularProgressIndicator(),
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                                else if (snapshot.data.docs.length == 0){


                                                                                                  return new Text("No Front Picture");
                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                  return new Center(
                                                                                                    child: Material(
                                                                                                      child: InkWell(
                                                                                                        onTap: () {
                                                                                                          print('ergdhb ');



                                                                                                          showDialog(
                                                                                                            context: context,
                                                                                                            builder: (context) => _contentWidget(snapshot.data.docs[0].get("FrontURL"), 2),
                                                                                                          );


                                                                                                        },
                                                                                                        child: Container(
                                                                                                          child: ClipRRect(
                                                                                                            borderRadius: BorderRadius.circular(20.0),
                                                                                                            child: Image.network(
                                                                                                              snapshot.data.docs[0].get("FrontURL") ,
                                                                                                              height: 300,
                                                                                                            ),),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );

                                                                                                }
                                                                                              }),
                                                                                        ),
                                                                                      ),

                                                                                      new Container(
                                                                                        child: new Center(
                                                                                          child: new FutureBuilder(
                                                                                              future: FirebaseFirestore.instance
                                                                                                  .collection('Users')
                                                                                                  .where('UserName', isEqualTo: ss.data.docs[i].id)
                                                                                                  .where('BackPic', isEqualTo: true.toString())
                                                                                                  .get(),
                                                                                              builder:
                                                                                                  (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                                                                                                if (snapshot.data == null) {
                                                                                                  return Container(
                                                                                                    child: Center(
                                                                                                      child: CircularProgressIndicator(),
                                                                                                    ),
                                                                                                  );
                                                                                                }
                                                                                                else if (snapshot.data.docs.length == 0){


                                                                                                  return new Text("No Back picture");

                                                                                                }
                                                                                                else
                                                                                                {
                                                                                                  return new Center(


                                                                                                    child: Material(
                                                                                                      child: InkWell(
                                                                                                        onTap: () {
                                                                                                          print('ergdhb ');


                                                                                                          showDialog(
                                                                                                            context: context,
                                                                                                            builder: (context) => _contentWidget(snapshot.data.docs[0].get("BackURL"), 2),
                                                                                                          );



                                                                                                        },
                                                                                                        child: Container(
                                                                                                          child: ClipRRect(
                                                                                                            borderRadius: BorderRadius.circular(20.0),
                                                                                                            child: Image.network(
                                                                                                              snapshot.data.docs[0].get("BackURL") ,
                                                                                                              height: 300,
                                                                                                            ),),
                                                                                                        ),
                                                                                                      ),
                                                                                                    ),
                                                                                                  );


                                                                                                }
                                                                                              }),
                                                                                        ),
                                                                                      ),


                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ),


                                                                              /*Center(
        child: */
                                                                            ),
                                                                          ),

                                                                        ),
                                                                      )
                                                                    }
                                                                ),

                                                                new ListTile(
                                                                  leading: new Icon(Icons.info_outline_rounded),
                                                                  title: new Text("Personal Info"),
                                                                  onTap: () => {
                                                                    showDialog(
                                                                        context: context,
                                                                        builder: (BuildContext context) =>
                                                                            AlertDialog(
                                                                              title: Text("Personal Info"),
                                                                              content: FutureBuilder(future: FirebaseFirestore.instance.collection('Users')
                                                                                  .where('UserName', isEqualTo: ss.data.docs[i].id)
                                                                                  .get(),
                                                                                  builder: (context, AsyncSnapshot<QuerySnapshot> qs)
                                                                                  {
                                                                                    if (qs.data == null) {
                                                                                      return Container(
                                                                                        height: 40,
                                                                                        width: 40,
                                                                                        child: Center(
                                                                                          child: CircularProgressIndicator(),
                                                                                        ),
                                                                                      );
                                                                                    } else if (qs.data.docs.length == 0) {
                                                                                      return Container(
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            'No users uses this car.',
                                                                                            textAlign: TextAlign.center,
                                                                                            style: TextStyle(fontSize: 18),
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                    else
                                                                                    {

                                                                                      return Text ("Name: " + qs.data.docs[0].get("Name") + "\n \n"
                                                                                          "Civil ID: " + qs.data.docs[0].get("Civil ID") + "\n \n"
                                                                                          "Username: " + qs.data.docs[0].get("UserName") + "\n \n"
                                                                                      );
                                                                                    }
                                                                                  }

                                                                              ),




                                                                              actions: [


                                                                                FlatButton(
                                                                                  textColor: Color(0xFF6200EE),
                                                                                  onPressed: () {

                                                                                    Navigator.pop(context);
                                                                                  },
                                                                                  child: Text('Ok'),
                                                                                ),
                                                                              ],
                                                                            )
                                                                    ),
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
                                                leading: Container(
                                                  padding: EdgeInsets.only(right: 12.0),
                                                  decoration: new BoxDecoration(
                                                      border: new Border(
                                                          right: new BorderSide(
                                                              width: 1.0,
                                                              color: Colors.black))),
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 35,
                                                  ),
                                                ),
                                                title: Text(
                                                    ss.data.docs[i]
                                                        .get('UserName')
                                                ),
                                                subtitle: q.data.docs[0].get('CurrentlyUseCar') == ss.data.docs[i].get('GeterUserID')? Text("Currently uses the car"):
                                                Text(""),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }) ;

                        }
                      }),
                ),
              ),
              new Scaffold(
                body: indexXX == 0 ?

                new Container(
                  child: new FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('MOI')
                          .where('UserID', isEqualTo: auth.currentUser.uid)
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
                                'You have no Zrga users uses this car.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return FutureBuilder( future: FirebaseFirestore.instance.collection('Cars').doc(snapshot.data.docs[0].get("PlateNumber"))
                              .collection('DisabilitiesList').where("Status", isEqualTo: "Accepted").get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> ss)
                              {
                                if (ss.data == null) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (ss.data.docs.length == 0) {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        'No disabilities users uses this car.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                }
                                else {
                                  return  ListView.separated(
                                      separatorBuilder: (context, index) => Divider(
                                        color: Colors.black,
                                      ),
                                      itemCount: ss.data.docs.length,
                                      itemBuilder: (context, int i) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 20.0),
                                          child: Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 6.0),
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      224, 224, 224, .9)),
                                              child: ListTile(
                                                trailing: new IconButton(
                                                  icon: Icon(
                                                    Icons.more_horiz_rounded,
                                                    color: Colors.black,
                                                    size: 40.0,
                                                  ),
                                                  onPressed: () {

                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) =>
                                                            AlertDialog(
                                                              title: Text("Disability Info"),
                                                              content: FutureBuilder(future: FirebaseFirestore.instance.collection('Disabilities')
                                                                  .where("DisabilityNumber", isEqualTo: ss.data.docs[i].get("DisabilityNumber")).get(),
                                                                  builder: (context, AsyncSnapshot<QuerySnapshot> qs)
                                                                  {
                                                                    if (qs.data == null) {
                                                                      return Container(
                                                                        height: 40,
                                                                        width: 40,
                                                                        child: Center(
                                                                          child: CircularProgressIndicator(),
                                                                        ),
                                                                      );
                                                                    } else if (qs.data.docs.length == 0) {
                                                                      return Container(
                                                                        child: Center(
                                                                          child: Text(
                                                                            'No disabilities users uses this car.',
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(fontSize: 18),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    else
                                                                    {

                                                                      return Text ("Name: " + qs.data.docs[0].get("DisabilityName") + "\n \n"
                                                                          "Civil ID: " + qs.data.docs[0].get("DisabilityCivilID") + "\n \n"
                                                                          "Blue Sign Number: " + qs.data.docs[0].get("BlueSignNum") + "\n \n"
                                                                          "Disability Number: " + qs.data.docs[0].get("DisabilityNumber") + "\n \n"
                                                                          "Disability Type: " + qs.data.docs[0].get("DisabilityType") + "\n \n"

                                                                      );
                                                                    }
                                                                  }

                                                              ),




                                                              actions: [


                                                                FlatButton(
                                                                  textColor: Color(0xFF6200EE),
                                                                  onPressed: () {

                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text('Ok'),
                                                                ),
                                                              ],
                                                            )
                                                    );
                                                    new FutureBuilder(future: FirebaseFirestore.instance.collection('Disabilities')
                                                        .where("DisabilityNumber", isEqualTo: ss.data.docs[i].get("DisabilityNumber")).get(),
                                                        builder: (context, AsyncSnapshot<QuerySnapshot> qs)
                                                        {
                                                          if (qs.data == null) {
                                                            return Container(
                                                              child: Center(
                                                                child: CircularProgressIndicator(),
                                                              ),
                                                            );
                                                          } else if (qs.data.docs.length == 0) {
                                                            return Container(
                                                              child: Center(
                                                                child: Text(
                                                                  'No disabilities users uses this car.',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(fontSize: 18),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          else
                                                          {

                                                          }
                                                        }

                                                    );

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
                                                    Icons.wheelchair_pickup,
                                                    size: 35,
                                                  ),
                                                ),
                                                title: Text(
                                                    ss.data.docs[i].get("DisUserName")
                                                ),
                                                subtitle: Text("Dis Number: " + ss.data.docs[i].get('DisabilityNumber')),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }) ;

                        }
                      }),
                ) :

                  FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('MOI')
                          .where('UserID', isEqualTo: auth.currentUser.uid)
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
                                'You have no Disabilities users uses this car.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return FutureBuilder( future: FirebaseFirestore.instance.collection('DisabilitiesChild')
                              .where("isDisability", isEqualTo: "true").where("UserID", isEqualTo: snapshot.data.docs[0].get("CarID")).get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> ss)
                              {
                                if (ss.data == null) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (ss.data.docs.length == 0) {
                                  return Container(
                                    child: Center(
                                      child: Text(
                                        'No disabilities users uses this car.',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  );
                                }
                                else {
                                  return  ListView.separated(
                                      separatorBuilder: (context, index) => Divider(
                                        color: Colors.black,
                                      ),
                                      itemCount: ss.data.docs.length,
                                      itemBuilder: (context, int i) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 0.0, horizontal: 20.0),
                                          child: Card(
                                            elevation: 8.0,
                                            margin: new EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 6.0),
                                            child: Container(
                                              height: 70,
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      224, 224, 224, .9)),
                                              child: ListTile(
                                                trailing: new IconButton(
                                                  icon: Icon(
                                                    Icons.more_horiz_rounded,
                                                    color: Colors.black,
                                                    size: 40.0,
                                                  ),
                                                  onPressed: () {

                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) =>
                                                            AlertDialog(
                                                              title: Text("Disability Info"),
                                                              content: FutureBuilder(future: FirebaseFirestore.instance.collection('DisabilitiesChild')
                                                                  .where("DisabilityNumber", isEqualTo: ss.data.docs[i].get("DisabilityNumber")).get(),
                                                                  builder: (context, AsyncSnapshot<QuerySnapshot> qs)
                                                                  {
                                                                    if (qs.data == null) {
                                                                      return Container(
                                                                        height: 40,
                                                                        width: 40,
                                                                        child: Center(
                                                                          child: CircularProgressIndicator(),
                                                                        ),
                                                                      );
                                                                    } else if (qs.data.docs.length == 0) {
                                                                      return Container(
                                                                        child: Center(
                                                                          child: Text(
                                                                            'No disabilities users uses this car.',
                                                                            textAlign: TextAlign.center,
                                                                            style: TextStyle(fontSize: 18),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }
                                                                    else
                                                                    {

                                                                      return Text ("Name: " + qs.data.docs[0].get("ChildName") + "\n \n"
                                                                          "Civil ID: " + qs.data.docs[0].get("ChildCivilID") + "\n \n"
                                                                          "Blue Sign Number: " + qs.data.docs[0].get("BlueSignNum") + "\n \n"
                                                                          "Disability Number: " + qs.data.docs[0].get("DisabilityNumber") + "\n \n"
                                                                          "Disability Type: " + qs.data.docs[0].get("DisabilityType") + "\n \n"

                                                                      );
                                                                    }
                                                                  }
                                                                  ),




                                                              actions: [


                                                                FlatButton(
                                                                  textColor: Color(0xFF6200EE),
                                                                  onPressed: () {

                                                                    Navigator.pop(context);
                                                                  },
                                                                  child: Text('Ok'),
                                                                ),
                                                              ],
                                                            )
                                                    );
                                                    new FutureBuilder(future: FirebaseFirestore.instance.collection('DisabilitiesChild')
                                                        .where("DisabilityNumber", isEqualTo: ss.data.docs[i].get("DisabilityNumber")).get(),
                                                        builder: (context, AsyncSnapshot<QuerySnapshot> qs)
                                                        {
                                                          if (qs.data == null) {
                                                            return Container(
                                                              child: Center(
                                                                child: CircularProgressIndicator(),
                                                              ),
                                                            );
                                                          } else if (qs.data.docs.length == 0) {
                                                            return Container(
                                                              child: Center(
                                                                child: Text(
                                                                  'No disabilities users uses this car.',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(fontSize: 18),
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          else
                                                          {

                                                          }
                                                        }

                                                    );

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
                                                    Icons.wheelchair_pickup,
                                                    size: 35,
                                                  ),
                                                ),
                                                title: Text(
                                                    ss.data.docs[i].get("ChildName")
                                                ),
                                                subtitle: Text("Dis Number: " + ss.data.docs[i].get('DisabilityNumber')),
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                }
                              }) ;

                        }
                      }),

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
                      icon: new Icon(Icons.wheelchair_pickup),
                      label: 'Dependents',

                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.car_repair),
                      label: 'Non-dependent ',
                    )
                  ],
                ),

              ),

              new Container(
                child: new Center(
                  child: new FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('MOI')
                          .where('UserID', isEqualTo: auth.currentUser.uid)
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
                                'No unpaid tickets on this car.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          );
                        } else {
                          return FutureBuilder( future: FirebaseFirestore.instance.collection('Users').doc(snapshot.data.docs[0].get("CarID"))
                              .collection('UsersTickets').where("isPaid", isEqualTo: "false").get(),
                              builder: (context, AsyncSnapshot<QuerySnapshot> ss)
                              {
                                if (ss.data == null) {
                                  return Container(
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                } else if (ss.data.docs.length == 0) {
                                  return new Container(
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
                                            "No unpaid tickets in this car.",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        Container(

                                          padding: EdgeInsets.only(bottom: 90),

                                          child: new RaisedButton(

                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                            ),
                                            color: Colors.red,
                                            child: const Text('Violate', style: TextStyle(
                                                fontSize: 20
                                            ),),
                                            onPressed: () {

                                              int selected;

                                              int count = 0;

                                              showModalBottomSheet(context: context, builder: (_) =>
                                                  StatefulBuilder(builder: (modalContext, modalSetState) =>

                                                      Container(
                                                        height: 500,
                                                        child: Column (
                                                          children: <Widget>[
                                                            new Text("Select Tickets",
                                                              style: TextStyle(
                                                                  fontSize: 30
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 8,
                                                            ),
                                                            new Expanded(child: SizedBox (
                                                              child: ListView.builder(
                                                                  itemCount: ticketsList.length,

                                                                  itemBuilder: (BuildContext context, int index) {
                                                                    return new Card(
                                                                      child: new Container(
                                                                        padding: new EdgeInsets.all(10.0),
                                                                        child: Column(
                                                                          children: <Widget>[

                                                                            new CheckboxListTile(
                                                                                activeColor: Colors.pink[300],
                                                                                dense: true,
                                                                                //font change
                                                                                title: new Text(
                                                                                  ticketsList[index].TicketTitle,
                                                                                  style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.w600,
                                                                                      letterSpacing: 0.5),
                                                                                ),
                                                                                value: ticketsList[index].isChecked,

                                                                                onChanged: (val) { modalSetState (() => ticketsList[index].isChecked == false? ticketsList[index].isChecked = true : ticketsList[index].isChecked = false);

                                                                                count = 0;
                                                                                for (var i = 0; i < ticketsList.length; i++)
                                                                                {
                                                                                  if (ticketsList[i].isChecked)
                                                                                  {
                                                                                    count += ticketsList[i].Price;
                                                                                  }
                                                                                }
                                                                                }
                                                                            )
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                              ),

                                                            ),
                                                            ),
                                                            new Container(
                                                              padding: EdgeInsets.all(15),
                                                              child: Text("Total: " + count.toString() + " KD", style: TextStyle(
                                                                  fontSize: 20
                                                              ),),
                                                            ),

                                                            if (_isLoading)
                                                              new CircularProgressIndicator()
                                                            else
                                                              new Container(
                                                                  padding: EdgeInsets.all(15),
                                                                  child: _isLoading == true ? new CircularProgressIndicator()
                                                                      : new RaisedButton(
                                                                    shape: RoundedRectangleBorder(
                                                                      borderRadius: BorderRadius.circular(18.0),
                                                                    ),
                                                                    color: Color(0xfff7892b),
                                                                    child: const Text('Confirm'),
                                                                    onPressed: () {

                                                                      int c = 0;
                                                                      for (var i = 0; i < ticketsList.length; i++)
                                                                      {
                                                                        if (ticketsList[i].isChecked)
                                                                        {
                                                                          c++;
                                                                          _sumbitAuthForm(ticketsList[i].TicketTitle, ticketsList[i].TicketInfo, ticketsList[i].Price.toString(), context);
                                                                        }
                                                                      }
                                                                      if (c > 0)
                                                                      {

                                                                        FirebaseFirestore.instance
                                                                            .collection('Cars').doc(snapshot.data.docs[0].get("PlateNumber")).update({
                                                                          "isRejected": "true",
                                                                          "TN": c.toString()


                                                                        });

                                                                        String b = "";
                                                                        FirebaseFirestore.instance
                                                                            .collection('Cars').doc(snapshot.data.docs[0].get("PlateNumber")).update({
                                                                          "isRejected": "false"

                                                                        }).then((value) {

                                                                        });
                                                                        FirebaseFirestore.instance
                                                                            .collection('Cars').doc(snapshot.data.docs[0].get("PlateNumber")).get().then((value) {
                                                                          FirebaseFirestore.instance.collection('temp').doc(value.get("UserID")).set({
                                                                            "PN": snapshot.data.docs[0].get("PlateNumber"),
                                                                            "UID": value.get("UserID"),
                                                                          });
                                                                        });
                                                                      }

                                                                      c > 0 ?
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => AlertDialog(
                                                                            title: Text("Ticket Sent"),
                                                                            content: Text("You have give " + c.toString() + " tickets"),
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
                                                                      ) :
                                                                      showDialog(
                                                                          context: context,
                                                                          builder: (context) => AlertDialog(
                                                                            title: Text("Select tickets"),
                                                                            content: Text("Please select tickets to give"),
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
                                                                      for (var i = 0; i < ticketsList.length; i++)
                                                                      {
                                                                        setState(() {
                                                                          ticketsList[i].isChecked = false;

                                                                        });
                                                                      }

                                                                      Navigator.pop(context);
                                                                    },

                                                                  )
                                                              )
                                                          ],
                                                        ),
                                                      ),
                                                  )
                                              ).whenComplete(() {
                                                print("Selected: $selected");
                                              });
                                            },

                                          ),
                                          width: 250,
                                          height: 137,
                                        ),

                                        ],
                                    ),);

                                }
                                else {
                                  return   Container(
                                    child: Column
                                      (
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: <Widget>[

                                        Expanded(child: Container( child: ListView.separated(
                                            separatorBuilder: (context, index) => Divider(
                                              color: Colors.black,
                                            ),
                                            itemCount: ss.data.docs.length,
                                            itemBuilder: (context, index) {



                                              return Padding(
                                                padding:
                                                EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),

                                                child: Container(
                                                  height: 100,
                                                  width: 100,
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(4.0),
                                                      border: new Border.all(
                                                          width: 1.0, style: BorderStyle.solid, color: Colors.black)),
                                                  margin: EdgeInsets.all(12.0),
                                                  child: ListTile(
                                                      leading: Container(
                                                        padding: EdgeInsets.only(right: 12.0),
                                                        decoration: new BoxDecoration(
                                                            border: new Border(
                                                                right: new BorderSide(
                                                                    width: 1.0, color: Colors.black))),
                                                        child: Transform.scale(scale: 2,
                                                          child: IconButton(
                                                            icon: Image.asset('images/payTickets.png', )
                                                            ,
                                                          ),
                                                        ),
                                                      ),
                                                      onTap: () {},
                                                      trailing: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: <Widget>[

                                                          IconButton(
                                                              icon: Icon(Icons.info_outline_rounded,

                                                                  size: 30.0),
                                                              onPressed: () {
                                                                return showDialog(
                                                                    context: context,
                                                                    builder: (BuildContext context) =>
                                                                        AlertDialog(
                                                                          title: Text("Ticket Info"),
                                                                          content: Text("Info: " + ss.data.docs[index].get("TicketInfo") + "\n \n"
                                                                              "Location: " + ss.data.docs[index].get("TicketPlace") + "\n\n"
                                                                              "Date: " + ss.data.docs[index].get("TicketDate") + "\n\n"
                                                                              "Amount: " + ss.data.docs[index].get("TicketAmount") + " KD"+ "\n\n"
                                                                              "Car Name: " + ss.data.docs[index].get("CarName") + "\n\n"
                                                                              "Plate Number: " + ss.data.docs[index].get("PlateNumber") + "\n\n"

                                                                          ),
                                                                          actions: [


                                                                            FlatButton(
                                                                              textColor: Color(0xFF6200EE),
                                                                              onPressed: () {

                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text('Ok'),
                                                                            ),
                                                                          ],
                                                                        )
                                                                );


                                                              }),


                                                        ],
                                                      ),
                                                      title: Text(
                                                          ss.data.docs[index].get("TicketName") + "\n\n" + ss.data.docs[index].get("TicketDate"))

                                                  ),
                                                ),
                                              );
                                            },
                                          ),

                                        ),

                                        ),


                                        new Container(

                                            padding: EdgeInsets.only(bottom: 90),

                                            child: new RaisedButton(

                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                              ),
                                              color: Colors.red,
                                              child: const Text('Violate', style: TextStyle(
                                                fontSize: 20
                                              ),),
                                              onPressed: () {

                                                int selected;

                                                int count = 0;

                                                showModalBottomSheet(context: context, builder: (_) =>
                                                    StatefulBuilder(builder: (modalContext, modalSetState) =>

                                                    Container(
                                                      height: 500,
                                                    child: Column (
                                                      children: <Widget>[
                                                        new Text("Select Tickets",
                                                          style: TextStyle(
                                                            fontSize: 30
                                                          ),
                                                        ),
                                                          SizedBox(
                                                            height: 8,
                                                          ),
                                                          new Expanded(child: SizedBox (
                                                            child: ListView.builder(
                                                                itemCount: ticketsList.length,

                                                                itemBuilder: (BuildContext context, int index) {
                                                                  return new Card(
                                                                    child: new Container(
                                                                      padding: new EdgeInsets.all(10.0),
                                                                      child: Column(
                                                                        children: <Widget>[

                                                                          new CheckboxListTile(
                                                                            activeColor: Colors.pink[300],
                                                                            dense: true,
                                                                            //font change
                                                                            title: new Text(
                                                                              ticketsList[index].TicketTitle,
                                                                              style: TextStyle(
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.w600,
                                                                                  letterSpacing: 0.5),
                                                                            ),
                                                                            value: ticketsList[index].isChecked,

                                                                            onChanged: (val) { modalSetState (() => ticketsList[index].isChecked == false? ticketsList[index].isChecked = true : ticketsList[index].isChecked = false);

                                                                            count = 0;
                                                                            for (var i = 0; i < ticketsList.length; i++)
                                                                              {
                                                                                if (ticketsList[i].isChecked)
                                                                                  {
                                                                                    count += ticketsList[i].Price;
                                                                                  }
                                                                              }
                                                                            }
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                }
                                                                ),

                                                          ),
                                                          ),
                                                        new Container(
                                                          padding: EdgeInsets.all(15),
                                                          child: Text("Total: " + count.toString() + " KD", style: TextStyle(
                                                            fontSize: 20
                                                          ),),
                                                        ),

                                                        if (_isLoading)
                                                          new CircularProgressIndicator()
                                                        else
                                                        new Container(
                                                            padding: EdgeInsets.all(15),
                                                            child: _isLoading == true ? new CircularProgressIndicator()
                                                                : new RaisedButton(
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(18.0),
                                                              ),
                                                              color: Color(0xfff7892b),
                                                              child: const Text('Confirm'),
                                                              onPressed: () {

                                                                int c = 0;
                                                                for (var i = 0; i < ticketsList.length; i++)
                                                                {
                                                                  if (ticketsList[i].isChecked)
                                                                  {
                                                                    c++;

                                                                    _sumbitAuthForm(ticketsList[i].TicketTitle, ticketsList[i].TicketInfo, ticketsList[i].Price.toString(), context);
                                                                  }


                                                               }
                                                                if (c > 0)
                                                                  {

                                                                  FirebaseFirestore.instance
                                                                      .collection('Cars').doc(snapshot.data.docs[0].get("PlateNumber")).update({
                                                                    "isRejected": "true",
                                                                    "TN": c.toString()


                                                                  });

                                                                String b = "";
                                                                FirebaseFirestore.instance
                                                                    .collection('Cars').doc(snapshot.data.docs[0].get("PlateNumber")).update({
                                                                  "isRejected": "false"

                                                                }).then((value) {

                                                                });
                                                                 FirebaseFirestore.instance
                                                                    .collection('Cars').doc(snapshot.data.docs[0].get("PlateNumber")).get().then((value) {
                                                                  FirebaseFirestore.instance.collection('temp').doc(value.get("UserID")).set({
                                                                    "PN": snapshot.data.docs[0].get("PlateNumber"),
                                                                    "UID": value.get("UserID"),
                                                                  });
                                                                });
                                                                }
                                                                c > 0 ?
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) => AlertDialog(
                                                                      title: Text("Ticket Sent"),
                                                                      content: Text("You have give " + c.toString() + " tickets"),
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
                                                                ) :
                                                                showDialog(
                                                                    context: context,
                                                                    builder: (context) => AlertDialog(
                                                                      title: Text("Select tickets"),
                                                                      content: Text("Please select tickets to give"),
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
                                                                for (var i = 0; i < ticketsList.length; i++)
                                                                  {
                                                                    setState(() {
                                                                      ticketsList[i].isChecked = false;

                                                                    });
                                                                  }

                                                                Navigator.pop(context);
                                                              },

                                                            )
                                                        )
                                                      ],
                                                    ),
                                                    ),
                                                    )
                                                ).whenComplete(() {
                                                  print("Selected: $selected");
                                                });
                                              },

                                            ),
                                          width: 250,
                                          height: 137,
                                        ),
                                      ],


                                    ),
                                  );
                                }
                              }
                              ) ;

                        }
                      }),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
  void itemChange(bool val, int index) {
    setState(() {
      ticketsList[index].isChecked = true;
    });
  }

}
