import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/models/lang.dart';
import 'package:Motri/screens/ChildCodes.dart';
import 'package:Motri/screens/CommonLogo.dart';
import 'package:Motri/screens/EditProfile.dart';
import 'package:Motri/screens/MyCars.dart';
import 'package:Motri/screens/MySelfCodeFD.dart';
import 'package:Motri/screens/MySelfCodeFH.dart';
import 'package:Motri/screens/ViewTickets.dart';
import 'package:Motri/screens/abd.dart';
import 'package:Motri/screens/addCar.dart';
import 'package:Motri/screens/loginPage.dart';
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:Motri/widgets/Auth/myCarInfo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import '../models/mainFeatures.dart';
import '../widgets/Auth/mainFeatures_form.dart';
import 'package:Motri/screens/AuthFirebase.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'AddDisability.dart';
import 'CarInfo.dart';
class MainMotri extends StatefulWidget {

  final Function onInit;
  final Widget child;
  const MainMotri({@required this.onInit, @required this.child});
  @override
  _StatefulWrapperState createState() => _StatefulWrapperState();
}

Map<int, Color> color =
{
  50:Color.fromRGBO(136,14,79, .1),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
};
int NotifyCount = 0;


String userEmail = FirebaseAuth.instance.currentUser.email;
String use = FirebaseAuth.instance.currentUser.uid;
var userName = FirebaseFirestore.instance
    .collection("Users")
    .doc(FirebaseAuth.instance.currentUser.uid)
    .id;

final firestore = FirebaseFirestore.instance; //
FirebaseAuth auth = FirebaseAuth.instance;
Language engLang = new Language(1, 'English', 'U+1F1FA', 'en');
Language arabLang = new Language(2, 'Arabic', 'U+1F1F0', 'ar');

Future<String> getUserName() async {
  final String uid = auth.currentUser.uid;
  print("ID =" + uid);

  final result =
  await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  final fbm = FirebaseMessaging();
  String getToken = "";
  fbm.getToken().then((value) => {
    FirebaseFirestore.instance
        .collection('Users').doc(FirebaseAuth.instance.currentUser.uid).update({

      'deviceID': value,
      "UserID": auth.currentUser.uid
    })
  });

  return result.get('Name');
}Future<String> getUsername() async {
  final String uid = auth.currentUser.uid;
  print("ID =" + uid);

  final result =
  await FirebaseFirestore.instance.collection('Users').doc(uid).get();
  final fbm = FirebaseMessaging();
  String getToken = "";
  fbm.getToken().then((value) => {
    FirebaseFirestore.instance
        .collection('Users').doc(FirebaseAuth.instance.currentUser.uid).update({

      'deviceID': value,
    })
  });

  return result.get('UserName');
}
final List<Features> GridFeatures = [
  Features(
    title: 'Car Info',
    image: 'images/carInfo.png',
  ),
  Features(
    title: 'Request Code',
    image: 'images/requestCode.png',
  ),

  Features(
    title: 'License',
    image: 'images/license.png',
  ),
  Features(
    title: 'Show Tickets',
    image: 'images/payTickets.png',
  ),
  Features(
    title: 'Add Disability',
    image: 'images/addDis.png',
  ),
  Features(
    title: 'Add User',
    image: 'images/addUser.png',
  ),
];
String UN = auth.currentUser.email;
int aaa = 1;
String UNN = '';
Future sleep1() {
  return new Future.delayed(const Duration(seconds: 1), () => "1");
}
class _StatefulWrapperState extends State<MainMotri>  {
  @override
  GlobalKey<ScaffoldState> key= new GlobalKey<ScaffoldState>();
  _buildSnackBar (){

    key.currentState.showSnackBar(
        new SnackBar(
          content: new Text("I am your snack bar"),
        )
    );
  }

  void initState() {
    if (widget.onInit != null) {
      widget.onInit();
    }
   getUsername().then((value) => UNN = value);


    FirebaseFirestore.instance
        .collection('Users').doc(FirebaseAuth.instance.currentUser.uid).get().then((value) => {
          if (value.get("FirstTime") == true.toString())
            {
         showDialog(
        context: context,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text("HI " + value.get("Name")),
              content: Text("Would you like to add your first car?"),
              actions: [
                FlatButton(
                  textColor: Color(0xFF6200EE),
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).update({
                    "FirstTime": "false"
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => addCar()),
                    );
                  },

                  child: Text('Yes'),
                ),

                FlatButton(
                  textColor: Color(0xFF6200EE),
                  onPressed: () {
                    FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).update({
                      "FirstTime": "false"
                    });
                    Navigator.pop(context);
                  },
                  child: Text('No'),
                ),
              ],
            )
    ),
    FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).update({
      "FirstTime": "false"
    }),

            }
    });
    print('NC');
    print( NotifyCount);
    final fbm = FirebaseMessaging();
    String getToken = "";
    setState(() {
      final CarsUpdate = FirebaseFirestore.instance
          .collection('Cars')
          .where('UserID', isEqualTo: auth.currentUser.uid)
          .get();
      final UID = FirebaseFirestore.instance
          .collection('UserNames')
          .where('UID', isEqualTo: auth.currentUser.uid)
          .get();


      fbm.getToken().then((value) =>
      {FirebaseFirestore.instance
          .collection('Users').doc(FirebaseAuth.instance.currentUser.uid).update({

        'deviceID': value,
      }).then((hj) {
        CarsUpdate.then((Cars) {
          for (var i = 0; i < Cars.docs.length; i++) {
            FirebaseFirestore.instance
                .collection('Cars')
                .doc(Cars.docs[i].id)
                .update({
              'deviceID': value,

            });
            FirebaseFirestore.instance.collection("Cars").doc(Cars.docs[i].id).collection('DisabilitiesList').where("Status", isEqualTo: "Accepted").get().then((value) {
              FirebaseFirestore.instance.collection('Cars').doc(Cars.docs[i].id).update({
                'DisabilitiesCount': value.docs.length.toString(),
              });
            });
            FirebaseFirestore.instance.collection("Cars").doc(Cars.docs[i].id).collection('UsersList').where("Status", isEqualTo: "Accepted").get().then((value) {
              FirebaseFirestore.instance.collection('Cars').doc(Cars.docs[i].id).update({
                'UsersCount': value.docs.length.toString(),
              });
            });
          }
        });
      })
      });


      FirebaseAuth.instance.currentUser.getIdToken().then((value) =>
      {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser.uid)
            .update({

          'tokenID': value,
        })
      });
      print("jnb");
      fbm.getToken().whenComplete(() {
        fbm.getToken().then((value) => print(value));
      });
      String h = '';
      UID.then((value) {
        h = value.docs[0].get('UserName');
        print('dddd ' + h);
      });
    });


    fbm.configure(

      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");

        var tag = message['notification']['title'];
        var body = message['notification']['body'];
        var screen = message['data']['screen'];
        var notifyID = message['data']['NotifyID'];
        var geterUN = message['data']['geterUN'];
        var geterName = message['data']['geterUN'];
        var PlateNumber = message['data']['PlateNumber'];
        var SenderName = message['data']['SenderName'];
        var SenderUserName = message['data']['SenderUserName'];
        var email = message['data']['email'];
        var Us = message['data']['UserName'];
        var DisNumber = message['data']['DisabilityNumber'];
        var authID = message['data']['authID'];
        var CarName = message['data']['CarName'];

        print(screen);
        var SenderUN = message['notification']['tag'];
        print('');
        print(SenderUN);
        if (tag == 'Car Rejected' || tag == 'Car Accepted') {
          print(tag);
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now

          });
          docid.update({
            "NotifyID": docid.id
          });
         //String cx = await FirebaseFirestore.instance.collection('Cars').doc(PlateNumber);
          return showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text("Ticket receive"),
                    content: Text("you have receive tickets"),
                    actions: [
                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => ViewTickets()),
                          );
                        },

                        child: Text('My Ticket'),
                      ),

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }
        else
        if (tag == ' Self Request Accepted' || tag == 'Self Request Rejected' ||
            tag == 'Dependent Request Accepted' ||
            tag == 'Dependent Request Rejected') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now
          });
          docid.update({
            "NotifyID": docid.id
          });
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }

        else if (tag == 'Request Accepted' || tag == 'Request Rejected') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now
          });
          docid.update({
            "NotifyID": docid.id
          });
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }
        else if (tag == 'Disabiltiy Ticket' || tag == 'Driver not registered' || tag == 'Expired car insurance') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now
          });
          docid.update({
            "NotifyID": docid.id
          });
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }
        else if (tag == 'Add Request') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now,
            "email": email,
            "authID": authID,
            "PlateNumber": PlateNumber,
            "UN": geterUN,
            "CarOwnerUserName": SenderUserName,
            "CarOwnerName": SenderName,
            "CarName": CarName,

          });
          docid.update({
            "NotifyID": docid.id,
            "NoID": notifyID,
          });

          print(tag.toString() + 'YHNB GVBHM ');
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text('Add Request'),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Colors.lightGreen,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('AddUser').doc(notifyID).update({

                            'Status': 'Accepted',
                          });

                          FirebaseFirestore.instance
                              .collection('UserNames').doc(geterUN).collection("OtherCars").doc(PlateNumber).set({
                            "PlateNumber": PlateNumber,
                            "email": email,
                           "authID": authID,
                            "UN": geterUN,
                            "CarOwnerUserName": SenderUserName,
                            "CarOwnerName": SenderName,
                            "CarName": CarName,

                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').doc(geterUN).update({
                            'Status': 'Accepted',

                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').get().then((value) {
                            FirebaseFirestore.instance.collection('Cars').doc(PlateNumber).update({
                              'UsersCount': value.docs.length.toString(),
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Rejected',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').doc(geterUN).delete();
                          FirebaseFirestore.instance
                              .collection('AddUser').doc(notifyID).update({

                            'Status': 'Rejected',
                          }).then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddUser').doc(notifyID).delete();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Decline'),

                      ),
                    ],
                  )
          );
        }

        else if (tag.toString().contains('0') || tag.toString().contains('1') ||
            tag.toString().contains('2') || tag.toString().contains('3') ||
            tag.toString().contains('4') || tag.toString().contains('5') ||
            tag.toString().contains('6') || tag.toString().contains('7') ||
            tag.toString().contains('8') || tag.toString().contains('9')) {
          print(tag.toString() + 'YHNB GVBHM ');
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": "Disability Add Request",
            "body": body,
            "Status": "Unread",
            "time": now,
            "PlateNumber": tag,
            "email": email,
            "DisNumber": DisNumber,
            "authID": authID,
          });
          docid.update({
            "NotifyID": docid.id,
            "NoID": notifyID,

          });
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text('Add Request'),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Colors.lightGreen,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('AddDisabilities')
                              .doc(notifyID)
                              .update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).update({

                            'isDisability': 'true',
                          });

                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').doc(DisNumber).update({
                            'Status': "Accepted",

                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').get().then((value) {
                            FirebaseFirestore.instance.collection('Cars').doc(tag).update({
                              'DisabilitiesCount': value.docs.length.toString(),
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Rejected',
                          });

                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').doc(DisNumber).delete();
                          FirebaseFirestore.instance
                              .collection('AddDisabilities')
                              .doc(notifyID)
                              .update({

                            'Status': 'Rejected',
                          })
                              .then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddDisabilities').doc(notifyID).delete();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Decline'),

                      ),
                    ],
                  )
          );
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        var tag = message['data']['title'];
        var body = message['data']['body'];
        var PN = message['data']['tag'];
        var screen = message['data']['screen'];
        var notifyID = message['data']['NotifyID'];
        var geterUN = message['data']['geterUN'];
        var PlateNumber = message['data']['PlateNumber'];
        var Us = message['data']['UserName'];
        var email = message['data']['email'];
        var DisNumber = message['data']['DisabilityNumber'];
        var authID = message['data']['authID'];
        print(screen);
        print('');
        if (tag == 'Car Rejected' || tag == 'Car Accepted') {
          print(tag);
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now

          });
          docid.update({
            "NotifyID": docid.id
          });
          return showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => MyCarsInfo()),
                          );
                        },

                        child: Text('My Cars'),
                      ),

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }
        else
        if (tag == ' Self Request Accepted' || tag == 'Self Request Rejected' ||
            tag == 'Dependent Request Accepted' ||
            tag == 'Dependent Request Rejected') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now
          });
          docid.update({
            "NotifyID": docid.id
          });
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }

        else if (tag == 'Request Accepted' || tag == 'Request Rejected') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now
          });
          docid.update({
            "NotifyID": docid.id
          });
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }
        else if (tag == 'Add Request') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now,
            "email": email,
            "authID": authID,
          });
          docid.update({
            "NotifyID": docid.id,
            "NoID": notifyID,
          });

          print(tag.toString() + 'YHNB GVBHM ');
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text('Add Request'),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Colors.lightGreen,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('AddUser').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').doc(geterUN).update({
                            'Status': 'Accepted',

                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').get().then((value) {
                            FirebaseFirestore.instance.collection('Cars').doc(PlateNumber).update({
                              'UsersCount': value.docs.length.toString(),
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Rejected',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').doc(geterUN).delete();
                          FirebaseFirestore.instance
                              .collection('AddUser').doc(notifyID).update({

                            'Status': 'Rejected',
                          }).then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddUser').doc(notifyID).delete();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Decline'),

                      ),
                    ],
                  )
          );
        }

        else if (tag.toString().contains('0') || tag.toString().contains('1') ||
            tag.toString().contains('2') || tag.toString().contains('3') ||
            tag.toString().contains('4') || tag.toString().contains('5') ||
            tag.toString().contains('6') || tag.toString().contains('7') ||
            tag.toString().contains('8') || tag.toString().contains('9')) {
          print(tag.toString() + 'YHNB GVBHM ');
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": "Disability Add Request",
            "body": body,
            "Status": "Unread",
            "time": now,
            "PlateNumber": tag,
            "email": email,
            "DisNumber": DisNumber,
            "authID": authID,
          });
          docid.update({
            "NotifyID": docid.id,
            "NoID": notifyID,

          });
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text('Add Request'),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Colors.lightGreen,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('AddDisabilities')
                              .doc(notifyID)
                              .update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).update({

                            'isDisability': 'true',
                          });

                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').doc(DisNumber).update({
                            'Status': "Accepted",

                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').get().then((value) {
                            FirebaseFirestore.instance.collection('Cars').doc(tag).update({
                              'DisabilitiesCount': value.docs.length.toString(),
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Rejected',
                          });

                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').doc(DisNumber).delete();
                          FirebaseFirestore.instance
                              .collection('AddDisabilities')
                              .doc(notifyID)
                              .update({

                            'Status': 'Rejected',
                          })
                              .then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddDisabilities').doc(notifyID).delete();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Decline'),

                      ),
                    ],
                  )
          );
        }
      },
      onResume: (Map<String, dynamic> message) async {
        var tag = message['data']['title'];
        var body = message['data']['body'];
        var PN = message['data']['tag'];
        var screen = message['data']['screen'];
        var notifyID = message['data']['NotifyID'];
        var geterUN = message['data']['geterUN'];
        var PlateNumber = message['data']['PlateNumber'];
        var Us = message['data']['UserName'];
        var email = message['data']['email'];
        var DisNumber = message['data']['DisabilityNumber'];
        var authID = message['data']['authID'];
        print(screen);
        print('');
        if (tag == 'Car Rejected' || tag == 'Car Accepted') {
          print(tag);
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now

          });
          docid.update({
            "NotifyID": docid.id
          });
          return showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (ctx) => MyCarsInfo()),
                          );
                        },

                        child: Text('My Cars'),
                      ),

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }
        else
        if (tag == ' Self Request Accepted' || tag == 'Self Request Rejected' ||
            tag == 'Dependent Request Accepted' ||
            tag == 'Dependent Request Rejected') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now
          });
          docid.update({
            "NotifyID": docid.id
          });
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }

        else if (tag == 'Request Accepted' || tag == 'Request Rejected') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now
          });
          docid.update({
            "NotifyID": docid.id
          });
          showDialog(
              context: context,
              builder: (BuildContext context) =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
                    actions: [

                      FlatButton(
                        textColor: Color(0xFF6200EE),
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Ok'),
                      ),
                    ],
                  )
          );
        }
        else if (tag == 'Add Request') {
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": tag,
            "body": body,
            "Status": "Unread",
            "time": now,
            "email": email,
            "authID": authID,
          });
          docid.update({
            "NotifyID": docid.id,
            "NoID": notifyID,
          });

          print(tag.toString() + 'YHNB GVBHM ');
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text('Add Request'),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Colors.lightGreen,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('AddUser').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').doc(geterUN).update({
                            'Status': 'Accepted',

                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').get().then((value) {
                            FirebaseFirestore.instance.collection('Cars').doc(PlateNumber).update({
                              'UsersCount': value.docs.length.toString(),
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Rejected',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(PlateNumber).collection(
                              'UsersList').doc(geterUN).delete();
                          FirebaseFirestore.instance
                              .collection('AddUser').doc(notifyID).update({

                            'Status': 'Rejected',
                          }).then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddUser').doc(notifyID).delete();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Decline'),

                      ),
                    ],
                  )
          );
        }

        else if (tag.toString().contains('0') || tag.toString().contains('1') ||
            tag.toString().contains('2') || tag.toString().contains('3') ||
            tag.toString().contains('4') || tag.toString().contains('5') ||
            tag.toString().contains('6') || tag.toString().contains('7') ||
            tag.toString().contains('8') || tag.toString().contains('9')) {
          print(tag.toString() + 'YHNB GVBHM ');
          final now = new DateTime.now();

          var docid = await FirebaseFirestore.instance.collection(
              "Notifications").doc(UN).collection("UserNotifications").add({
            "title": "Disability Add Request",
            "body": body,
            "Status": "Unread",
            "time": now,
            "PlateNumber": tag,
            "email": email,
            "DisNumber": DisNumber,
            "authID": authID,
          });
          docid.update({
            "NotifyID": docid.id,
            "NoID": notifyID,

          });
          showDialog(
              context: context,
              builder: (context) =>
                  AlertDialog(
                    title: Text('Add Request'),
                    content: Text(body),
                    actions: [
                      FlatButton(
                        textColor: Colors.lightGreen,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('AddDisabilities')
                              .doc(notifyID)
                              .update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).update({

                            'isDisability': 'true',
                          });

                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').doc(DisNumber).update({
                            'Status': "Accepted",

                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').get().then((value) {
                            FirebaseFirestore.instance.collection('Cars').doc(tag).update({
                              'DisabilitiesCount': value.docs.length.toString(),
                            });
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          docid.update({
                            "Status": "Read"
                          });
                          FirebaseFirestore.instance
                              .collection('Requests').doc(authID).collection('MyRequests').doc(notifyID).update({

                            'Status': 'Rejected',
                          });

                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).collection(
                              'DisabilitiesList').doc(DisNumber).delete();
                          FirebaseFirestore.instance
                              .collection('AddDisabilities')
                              .doc(notifyID)
                              .update({

                            'Status': 'Rejected',
                          })
                              .then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddDisabilities').doc(notifyID).delete();
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Decline'),

                      ),
                    ],
                  )
          );
        }
      },
    );

    super.initState();
  }

  BuildContext contextk;

  @override
  int indexXX = 0;


  Widget build(BuildContext context) {
    void changeLang(Language lang) {
      Locale _temp;
      switch (lang.langCode) {
        case 'en':
          _temp = Locale(lang.langCode, 'US');
          break;
        case 'ar':
          _temp = Locale(lang.langCode, 'KW');
          break;
        default:
          _temp = Locale('ar', 'KW');
          break;
      }
      MyApp.setLocale(context, _temp);
    }
    /* var currentTab = [
      Home(),
      Notification(),
      Setting(),
    ];*/


    return MaterialApp(
      theme: new ThemeData(primarySwatch: MaterialColor(0xfff7892b, color)),


      home:   new Scaffold(
        key: key,
        appBar: AppBar(
          title: Text('Motri', style: TextStyle(
              color: Colors.black
          ),),
          backgroundColor: Color(0xfff7892b),
        ),
        drawer: Drawer(

          child: Container(
            color: Colors.white,
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,

              children: <Widget>[
                UserAccountsDrawerHeader(
                  arrowColor: Colors.orange,
                  accountName: FutureBuilder(
                    future: getUserName(),
                    builder: (_, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return Text(snapshot.data);
                    },

                  ),
                  accountEmail: Text(userEmail),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Text(
                      (userEmail.substring(0, 2)),
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
                ListTile(

                  leading: Icon(Icons.home),
                  title: Text('Home'),
                  onTap: () {
                    MainMotri();
                  },
                ),

                ListTile(
                  leading: Icon(Icons.car_rental),
                  title: Text('Add Car'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => MyCars()),
                    );
                  },
                ),

                //_DisabilityCode(),

                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Edit Profile'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => EditProfile()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.contact_support_rounded),
                  title: Text('About us'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => abd()),
                    );
                  },
                ),

                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Disabilities')
                        .where('UserID', isEqualTo: auth.currentUser.uid)
                        .where('isDisability', isEqualTo: 'true')
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {

                        if (snapshot.data.size > 0) {
                          return ListTile(
                            leading: Icon(Icons.wheelchair_pickup),
                            title: Text('My Disability Code'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => MySelfCodeFH()),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),


                FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('DisabilitiesChild')
                        .where('UserID', isEqualTo: auth.currentUser.uid)
                        .where('isDisability', isEqualTo: 'true')
                        .get(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.size > 0) {
                          return ListTile(
                            leading: Icon(Icons.wheelchair_pickup),
                            title: Text('My Dependents Codes'),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (ctx) => ChildrenCodes()),
                              );
                            },
                          );
                        } else {
                          return Container();
                        }
                      } else {
                        return Container();
                      }
                    }),
                ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sign out'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => LoginPage()),
                    );
                  },
                ),


              ],
            ),
          ),
        ),
        body: indexXX == 1 ? new Scaffold(

            body:  new Container(
              child: new Center(
                child: new FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('Notifications').doc(UN).collection(
                        'UserNotifications').where("Status" , isEqualTo: "Unread")
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
                              'You have no notifications yet.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      } else {
                          return Container(
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
                                  "Notifications",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                              Expanded(child: SizedBox(
                                height: 60,
                              child: ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(
                                        color: Colors.black,
                                      ),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, int i) {


                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 20.0),

                                      child: Card(
                                        elevation: 8.0,
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),



                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, .9)),

                                          child: ListTile(

                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[

                                                if(snapshot.data.docs[i].get(
                                                    'title') ==
                                                    'Disability Add Request' ||
                                                    snapshot.data.docs[i].get(
                                                        'title') ==
                                                        'Add Request')
                                                  IconButton(icon: Icon(Icons
                                                      .keyboard_arrow_right,
                                                    color: Colors.black,
                                                    size: 40.0,

                                                  ),
                                                    onPressed: () {
                                                      setState(() {
                                                        if (snapshot.data.docs[i].get('title') == 'Disability Add Request') {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  AlertDialog(
                                                                    title: Text('Add Request'),
                                                                    content: Text(snapshot.data.docs[i].get('body')),
                                                                    actions: [
                                                                      FlatButton(
                                                                        textColor: Colors.lightGreen,
                                                                        onPressed: () {
                                                                          FirebaseFirestore.instance.collection('AddDisabilities').doc(snapshot.data.docs[i].get('NoID')).update({


                                                                            'Status': 'Accepted',
                                                                          });
                                                                          FirebaseFirestore.instance
                                                                              .collection('Requests').doc(snapshot.data.docs[i].get('authID')).collection('MyRequests').doc(snapshot.data.docs[i].get('NoID')).update({

                                                                            'Status': 'Accepted',
                                                                          });
                                                                          FirebaseFirestore.instance
                                                                              .collection('Cars').doc(snapshot.data.docs[i].get('PlateNumber')).update({
                                                                            'isDisability': 'true',
                                                                          });
                                                                          FirebaseFirestore.instance
                                                                              .collection('Cars').doc(snapshot.data.docs[i].get('PlateNumber')).collection(
                                                                              'DisabilitiesList').doc(snapshot.data.docs[i].get("DisNumber")).update({
                                                                            'Status': "Accepted",

                                                                          });
                                                                          FirebaseFirestore.instance.collection("Cars").doc(snapshot.data.docs[i].get("PlateNumber")).collection('DisabilitiesList').get().then((value) {
                                                                            FirebaseFirestore.instance.collection('Cars').doc(snapshot.data.docs[i].get("PlateNumber")).update({
                                                                              'DisabilitiesCount': value.docs.length.toString(),
                                                                            });
                                                                          });


                                                                          Navigator.pop(context);

                                                                          setState(() {
                                                                            FirebaseFirestore.instance
                                                                                .collection('Notifications').doc(UN).collection('UserNotifications').doc(snapshot.data.docs[i].id).delete();

                                                                          });
                                                                        },
                                                                        child: Text('Accept'),
                                                                      ),
                                                                      FlatButton(
                                                                        textColor: Colors.red,
                                                                        onPressed: () {
                                                                          Navigator.pop(context);



                                                                          setState(() {
                                                                            FirebaseFirestore
                                                                                .instance.collection('Notifications').doc(UN).collection('UserNotifications').doc(snapshot.data.docs[i].id).delete();

                                                                          });

                                                                          FirebaseFirestore.instance
                                                                              .collection('AddDisabilities').doc(snapshot.data.docs[i].get('NoID')).update({

                                                                            'Status': 'Rejected',
                                                                          })
                                                                              .then((
                                                                              value) {
                                                                            FirebaseFirestore.instance
                                                                                .collection('AddDisabilities').doc(snapshot.data.docs[i].get('NoID')).delete();
                                                                          });
                                                                          FirebaseFirestore.instance
                                                                              .collection('Requests').doc(snapshot.data.docs[i].get('authID')).collection('MyRequests').doc(snapshot.data.docs[i].get('NoID')).update({

                                                                            'Status': 'Rejected',
                                                                          });
                                                                        },

                                                                        child: Text('Decline'),

                                                                      ),
                                                                    ],
                                                                  )
                                                          );
                                                        }
                                                        else
                                                        if (snapshot.data.docs[i].get('title') == 'Add Request') {
                                                          showDialog(
                                                              context: context,
                                                              builder: (context) =>
                                                                  AlertDialog(
                                                                    title: Text(
                                                                        'Add Request'),
                                                                    content: Text(snapshot.data.docs[i].get('body')),
                                                                    actions: [
                                                                      FlatButton(
                                                                        textColor: Colors
                                                                            .lightGreen,
                                                                        onPressed: () {
                                                                          Navigator.pop(context);

                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('AddUser').doc(snapshot.data.docs[i].get('NoID')).update({

                                                                            'Status': 'Accepted',
                                                                          });
                                                                          FirebaseFirestore.instance
                                                                              .collection('UserNames').doc(snapshot.data.docs[i].get("UN"))
                                                                              .collection("OtherCars").doc(snapshot.data.docs[i].get('PlateNumber')).set({
                                                                            "PlateNumber": snapshot.data.docs[i].get('PlateNumber'),
                                                                            "email": snapshot.data.docs[i].get('email'),
                                                                            "authID": snapshot.data.docs[i].get('authID'),
                                                                            "UN": snapshot.data.docs[i].get('UN'),
                                                                            "CarOwnerUserName": snapshot.data.docs[i].get('CarOwnerUserName'),
                                                                            "CarOwnerName": snapshot.data.docs[i].get('CarOwnerName'),
                                                                            "CarName": snapshot.data.docs[i].get('CarName'),

                                                                          });
                                                                          FirebaseFirestore.instance
                                                                              .collection('Requests').doc(snapshot.data.docs[i].get('authID')).collection('MyRequests').doc(snapshot.data.docs[i].get('NoID')).update({

                                                                            'Status': 'Accepted',
                                                                          });

                                                                          FirebaseFirestore.instance
                                                                              .collection('Cars').doc(snapshot.data.docs[i].get('PlateNumber')).collection(
                                                                              'UsersList').doc(snapshot.data.docs[i].get('UN')).update({
                                                                            'Status': 'Accepted',

                                                                          });
                                                                          FirebaseFirestore.instance
                                                                              .collection('Cars').doc(snapshot.data.docs[i].get('PlateNumber')).collection(
                                                                              'Users').get().then((value) {
                                                                            FirebaseFirestore.instance.collection(
                                                                                'Cars').doc(snapshot.data.docs[i].get(
                                                                                'PlateNumber')).update({
                                                                              'UsersCount': value.docs.length
                                                                                  .toString(),
                                                                            });
                                                                          });

                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('Cars')
                                                                              .doc(snapshot.data.docs[i].get('PlateNumber')).collection('UsersList').doc(snapshot.data.docs[i].get('UN')).update({
                                                                            'UserName': snapshot.data.docs[i].get('UN')

                                                                              });
                                                                          setState(() {
                                                                            FirebaseFirestore.instance
                                                                                .collection('Notifications').doc(UN).collection('UserNotifications').doc(snapshot.data.docs[i].id).delete();

                                                                          });

                                                                        },
                                                                        child: Text('Accept'),
                                                                      ),
                                                                      FlatButton(
                                                                        textColor: Colors.red,
                                                                        onPressed: () {

                                                                          FirebaseFirestore.instance
                                                                              .collection('Requests').doc(snapshot.data.docs[i].get('authID')).collection('MyRequests').doc(snapshot.data.docs[i].get('NoID')).update({

                                                                            'Status': 'Rejected',
                                                                          });
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('AddUser').doc(snapshot.data.docs[i].get('NoID'))
                                                                              .update({

                                                                            'Status': 'Rejected',
                                                                          });
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('Cars')
                                                                              .doc(snapshot.data.docs[i].get('PlateNumber')).collection('UsersList').doc(snapshot.data.docs[i].get('UN')).delete();


                                                                          setState(() {
                                                                            FirebaseFirestore.instance.
                                                                            collection('Notifications').doc(UN).collection('UserNotifications').doc(snapshot.data.docs[i].id).delete();

                                                                          });


                                                                          Navigator.pop(context);
                                                                        },
                                                                        child: Text('Decline'),

                                                                      ),
                                                                    ],
                                                                  )
                                                          );
                                                        }
                                                      });
                                                    },
                                                  )
                                                else
                                                  IconButton(
                                                    icon: Icon(Icons.more_horiz,),
                                                    onPressed: ()
                                                    {
                                                      showModalBottomSheet(
                                                          context: context,
                                                          builder: (BuildContext bc){
                                                            return Container(
                                                              child: new Wrap(
                                                                children: <Widget>[
                                                                  new ListTile(
                                                                      leading: new Icon(Icons.delete),
                                                                      title: new Text('Delete'),
                                                                      tileColor: Colors.red,
                                                                      onTap: () => {
                                                                      setState(() {
                                                                      FirebaseFirestore.instance.
                                                                      collection('Notifications').doc(UN).collection('UserNotifications').doc(snapshot.data.docs[i].id).delete();

                                                                      }) ,


                                                                Navigator.pop(context)
                                                                      },
                                                                  ),
                                                                  new ListTile(
                                                                    leading: new Icon(Icons.cancel),
                                                                    title: new Text('Cancel'),
                                                                    onTap: () => {},
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


                                            leading: Container(
                                              padding: EdgeInsets.only(
                                                  right: 12.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .black))),
                                              child: Icon(
                                                Icons.notifications,
                                                size: 35,
                                              ),
                                            ),
                                            title: Text(
                                              snapshot.data.docs[i]
                                                  .get('title') +
                                                  "\n" +
                                                  snapshot.data.docs[i]
                                                      .get('body'),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),



                                          ),
                                        ),
                                      ),
                                    );
                                  }),))

                            ],
                          ),
                        );


                      }
                    }),
              ),
            ),




        ) : indexXX == 0 ? Stack(
          children: [
            /*  Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new AssetImage(
                        'images/bk.jpg'))),
          ),
          */
            new FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('Cars')
                    .where('UserID', isEqualTo: auth.currentUser.uid)
                    .where('isVerified', isEqualTo: true.toString())
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
                    return
                        GridView.builder(
                          padding: const EdgeInsets.all(20.0),
                          itemCount: 3,
                          itemBuilder: (ctx, i) =>
                              MainFeaturesForm(
                                GridFeatures[i].title,
                                GridFeatures[i].image,
                              ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: MediaQuery
                                .of(context)
                                .size
                                .width /
                                (MediaQuery
                                    .of(context)
                                    .size
                                    .height / 1.6),
                            crossAxisSpacing: 25,
                            mainAxisSpacing: 12.5,
                          ),
                        );

                  } else {

                    return GridView.builder(
                      padding: const EdgeInsets.all(20.0),
                      itemCount: 6,
                      itemBuilder: (ctx, i) =>
                          MainFeaturesForm(
                            GridFeatures[i].title,
                            GridFeatures[i].image,
                          ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: MediaQuery
                            .of(context)
                            .size
                            .width /
                            (MediaQuery
                                .of(context)
                                .size
                                .height / 1.6),
                        crossAxisSpacing: 25,
                        mainAxisSpacing: 12.5,
                      ),
                    );
                  }
                }),

          ],
        ) : new DefaultTabController(
          length: 3,
          child: new Scaffold(
            appBar: new TabBar(
              labelColor: Colors.blue,
              tabs: <Widget>[
                new Tab(
                  text: "Accepted",
                ),
                new Tab(
                  text: "Pending",
                ),
                new Tab(
                  text: "Rejected",

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
                      child: new FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Requests').doc(auth.currentUser.uid).collection(
                              'MyRequests')
                              .where('Status', isEqualTo: 'Accepted')
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
                                    'You have no accepted requests.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            } else {
                              return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(
                                        color: Colors.black,
                                      ),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, int i) {


                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 20.0),
                                      child: Card(
                                        elevation: 8.0,
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, .9)),
                                          child: ListTile(
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[

                                                IconButton(
                                                  icon: Icon(Icons.more_horiz,),
                                                  onPressed: ()
                                                  {

                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext bc){
                                                          return Container(
                                                            child: new Wrap(
                                                              children: <Widget>[
                                                                new ListTile(
                                                                    leading: new Icon(Icons.delete),
                                                                    title: new Text('Clear'),
                                                                    tileColor: Colors.red,
                                                                    onTap: ()  {
                                                                      setState(() {
                                                                        FirebaseFirestore.instance
                                                                            .collection('Requests').doc(auth.currentUser.uid).collection(
                                                                            'MyRequests').doc(snapshot.data.docs[i].id).delete();
                                                                        Navigator.pop(context);

                                                                      });
                                                                    }
                                                                ),
                                                                new ListTile(
                                                                  leading: new Icon(Icons.cancel),
                                                                  title: new Text('Cancel'),
                                                                  onTap: ()  {
                                                                    Navigator.pop(context);
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
                                            leading: Container(
                                              padding: EdgeInsets.only(
                                                  right: 12.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .black))),
                                              child: Icon(
                                                Icons.inbox,
                                                size: 35,
                                              ),
                                            ),
                                            title: Text(
                                              snapshot.data.docs[i]
                                                  .get('title') +
                                                  "\n" +
                                                 'To: ' + snapshot.data.docs[i]
                                                      .get('UserName'),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            subtitle: Text(snapshot.data.docs[i].get('SenderCar') ),


                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }),
                    ),
                  ),
                  new Container(
                    child: new Center(
                      child: new FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Requests').doc(auth.currentUser.uid).collection(
                              'MyRequests')
                              .where('Status', isEqualTo: 'Pending')
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
                                    'You have no pending requests.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            } else {
                              return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(
                                        color: Colors.black,
                                      ),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, int i) {


                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 20.0),
                                      child: Card(
                                        elevation: 8.0,
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, .9)),
                                          child: ListTile(
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[

                                                IconButton(
                                                  icon: Icon(Icons.more_horiz,),
                                                  onPressed: ()
                                                  {

                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext bc){
                                                          return Container(
                                                            child: new Wrap(
                                                              children: <Widget>[
                                                                new ListTile(
                                                                    leading: new Icon(Icons.delete),
                                                                    title: new Text('Delete'),
                                                                    tileColor: Colors.red,
                                                                    onTap: ()  {
                                                                      setState(() {
                                                                        FirebaseFirestore.instance
                                                                            .collection('Requests').doc(auth.currentUser.uid).collection(
                                                                            'MyRequests').doc(snapshot.data.docs[i].id).delete();
                                                                        Navigator.pop(context);

                                                                        var c = FirebaseFirestore.instance.collection('Notifications')
                                                                            .doc(snapshot.data.docs[i].get('geterEmail')).collection('UserNotifications')
                                                                            .get().then((value)  {
                                                                           FirebaseFirestore.instance.collection('Notifications')
                                                                              .doc(snapshot.data.docs[i].get('geterEmail')).collection('UserNotifications')
                                                                               .doc(value.docs[0].get('NotifyID')).delete();

                                                                             if(snapshot.data.docs[i].get('title') == 'Disability Request')
                                                                               {
                                                                                 FirebaseFirestore.instance.collection('Cars')
                                                                                     .doc(snapshot.data.docs[i].get('PlateNumber'))
                                                                                     .collection('DisabilitiesList')
                                                                                     .doc(snapshot.data.docs[i].get('DisabilityNumber')).delete();
                                                                               }
                                                                             else
                                                                               {
                                                                                 FirebaseFirestore.instance.collection('Cars')
                                                                                     .doc(snapshot.data.docs[i].get('PlateNumber'))
                                                                                     .collection('UsersList')
                                                                                     .doc(snapshot.data.docs[i].get('UserName')).delete();

                                                                               }
                                                                            });

                                                                      });
                                                                    }
                                                                ),
                                                                new ListTile(
                                                                  leading: new Icon(Icons.cancel),
                                                                  title: new Text('Cancel'),
                                                                  onTap: ()  {
                                                                    Navigator.pop(context);
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
                                            leading: Container(
                                              padding: EdgeInsets.only(
                                                  right: 12.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .black))),
                                              child: Icon(
                                                Icons.inbox,
                                                size: 35,
                                              ),
                                            ),
                                            title: Text(
                                              snapshot.data.docs[i]
                                                  .get('title') +
                                                  "\n" +
                                                  'To: ' + snapshot.data.docs[i]
                                                  .get('UserName'),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            subtitle: Text(snapshot.data.docs[i].get('SenderCar') ),


                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }),
                    ),
                  ), new Container(
                    child: new Center(
                      child: new FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('Requests').doc(auth.currentUser.uid).collection(
                              'MyRequests')
                              .where('Status', isEqualTo: 'Rejected')
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
                                    'You have no rejected requests.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              );
                            } else {
                              return ListView.separated(
                                  separatorBuilder: (context, index) =>
                                      Divider(
                                        color: Colors.black,
                                      ),
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, int i) {


                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 0.0, horizontal: 20.0),
                                      child: Card(
                                        elevation: 8.0,
                                        margin: new EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 6.0),
                                        child: Container(
                                          height: 80,
                                          decoration: BoxDecoration(
                                              color: Color.fromRGBO(
                                                  224, 224, 224, .9)),
                                          child: ListTile(
                                            trailing: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[

                                                IconButton(
                                                  icon: Icon(Icons.more_horiz,),
                                                  onPressed: ()
                                                  {

                                                    showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext bc){
                                                          return Container(
                                                            child: new Wrap(
                                                              children: <Widget>[
                                                                new ListTile(
                                                                    leading: new Icon(Icons.delete),
                                                                    title: new Text('Clear'),
                                                                    tileColor: Colors.red,
                                                                    onTap: ()  {
                                                                      setState(() {
                                                                        FirebaseFirestore.instance
                                                                            .collection('Requests').doc(auth.currentUser.uid).collection(
                                                                            'MyRequests').doc(snapshot.data.docs[i].id).delete();
                                                                        Navigator.pop(context);

                                                                      });
                                                                    }
                                                                ),
                                                                new ListTile(
                                                                  leading: new Icon(Icons.cancel),
                                                                  title: new Text('Cancel'),
                                                                  onTap: ()  {
                                                                    Navigator.pop(context);
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
                                            leading: Container(
                                              padding: EdgeInsets.only(
                                                  right: 12.0),
                                              decoration: new BoxDecoration(
                                                  border: new Border(
                                                      right: new BorderSide(
                                                          width: 1.0,
                                                          color: Colors
                                                              .black))),
                                              child: Icon(
                                                Icons.inbox,
                                                size: 35,
                                              ),
                                            ),
                                            title: Text(
                                              snapshot.data.docs[i]
                                                  .get('title') +
                                                  "\n" +
                                                  'To: ' + snapshot.data.docs[i]
                                                  .get('UserName'),
                                              style: TextStyle(
                                                  color: Colors.black),
                                            ),
                                            subtitle: Text(snapshot.data.docs[i].get('SenderCar') ),


                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          }),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
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
              icon: new Icon(Icons.home),
              label: 'Home',

            ),
            BottomNavigationBarItem(
              label: 'Notifications',
              icon:
              new FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('Notifications').doc(UN).collection(
                      'UserNotifications')
                      .where('Status', isEqualTo: 'Unread')
                      .get(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data == null) {
                      return BadgeIcon(
                          icon: Icon(Icons.notifications, size: 30,),
                          badgeCount: 0
                      );
                    }
                    else {
                     return BadgeIcon(
                          icon: Icon(Icons.notifications, size: 30,),
                          badgeCount: snapshot.data.size
                      );

                    }})
              ),


            BottomNavigationBarItem(
              icon: Icon(Icons.inbox),
              label: 'Requests',
            )
          ],
        ),
      ),);
  }

  Widget personDetailCard(Person) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.circle,

                    )),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Z",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18
                    ),
                  ),
                  Text("ESE",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

}
class BadgeIcon extends StatelessWidget {
  BadgeIcon(
      {this.icon,
        this.badgeCount = 0,
        this.showIfZero = false,
        this.badgeColor = Colors.red,
        TextStyle badgeTextStyle})
      : this.badgeTextStyle = badgeTextStyle ??
      TextStyle(
        color: Colors.white,
        fontSize: 8,
      );
  final Widget icon;
  final int badgeCount;
  final bool showIfZero;
  final Color badgeColor;
  final TextStyle badgeTextStyle;

  @override
  Widget build(BuildContext context) {
    return new Stack(children: <Widget>[
      icon,
      if (badgeCount > 0 || showIfZero) badge(badgeCount),
    ]);
  }

  Widget badge(int count) => Positioned(
    right: 0,
    top: 0,
    child: new Container(
      padding: EdgeInsets.all(1),
      decoration: new BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8.5),
      ),
      constraints: BoxConstraints(
        minWidth: 15,
        minHeight: 15,
      ),
      child: Text(
        count.toString(),
        style: new TextStyle(
          color: Colors.white,
          fontSize: 10,
        ),
        textAlign: TextAlign.center,
      ),
    ),
  );
}
