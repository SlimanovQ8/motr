import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/models/lang.dart';
import 'package:Motri/screens/ChildCodes.dart';
import 'package:Motri/screens/EditProfile.dart';
import 'package:Motri/screens/MyCars.dart';
import 'package:Motri/screens/MySelfCodeFD.dart';
import 'package:Motri/screens/MySelfCodeFH.dart';
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

class _StatefulWrapperState extends State<MainMotri> {
  @override
  void initState() {
    if(widget.onInit != null) {
      widget.onInit();
    }
    final fbm = FirebaseMessaging();
    String getToken = "";
    final CarsUpdate = FirebaseFirestore.instance
        .collection('Cars')
        .where('UserID', isEqualTo: auth.currentUser.uid)
        .get();
    fbm.getToken().then((value) => {FirebaseFirestore.instance
        .collection('Users').doc(FirebaseAuth.instance.currentUser.uid).update({

      'deviceID': value,
    }).then((hj) {
      CarsUpdate.then((Cars) {
        for (var i = 0; i < Cars.docs.length; i++) {
          FirebaseFirestore.instance
              .collection('Cars')
              .doc(Cars.docs[i].id)
              .update({
            'deviceID':  value,

          });
        }
      });
    })


    });


    FirebaseAuth.instance.currentUser.getIdToken().then((value) => {
      FirebaseFirestore.instance
          .collection('Users').doc(FirebaseAuth.instance.currentUser.uid).update({

        'tokenID': value,
      })
    });
    print("jnb");
    fbm.getToken().whenComplete(() {
      fbm.getToken().then((value) => print(value));
    });


    fbm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        var tag = message['notification']['title'];
        var body = message['notification']['body'];
        var PN = message['notification']['tag'];
        print('');
        print(tag);
        if (tag == 'Car Rejected' || tag == 'Car Accepted')
        {
          return  showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(tag),
                content: Text(body),
                actions: [
                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => MyCarsInfo()),
                      );
                    },

                    child: Text('My Cars'),
                  ),

                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Ok'),
                  ),
                ],
              )
          );
        }
        else if (tag == ' Self Request Accepted' || tag == 'Self Request Rejected' || tag == 'Child Request Accepted' || tag == 'Child Request Rejected')
        {
          showDialog(
              context: context,
              builder: (BuildContext context)  => AlertDialog(
                title: Text(tag),
                content: Text(body),
                actions: [

                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Ok'),
                  ),
                ],
              )
          );
        }

        else if (tag == 'Request Accepted' || tag == 'Request Rejected' ) {
          showDialog(
              context: context,
              builder: (BuildContext context)  =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
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
        else if (tag.toString().contains('0') ||tag.toString().contains('1') ||tag.toString().contains('2') ||tag.toString().contains('3') ||tag.toString().contains('4') ||tag.toString().contains('5') ||tag.toString().contains('6') ||tag.toString().contains('7') ||tag.toString().contains('8') ||tag.toString().contains('9') ) {
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
                          FirebaseFirestore.instance
                              .collection('AddDisabilities').doc(tag).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).update({

                            'isDisability': 'true',
                          });
                           Navigator.pop(context);

                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('AddDisabilities').doc(tag).update({

                            'Status': 'Rejected',
                          }).then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddDisabilities').doc(tag).delete();
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
        if (tag == 'Car Rejected' || tag == 'Car Accepted')
        {
          return  showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(tag),
                content: Text(body),
                actions: [
                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => MyCarsInfo()),
                      );
                    },

                    child: Text('My Cars'),
                  ),

                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Ok'),
                  ),
                ],
              )
          );
        }
        else if (tag == ' Self Request Accepted' || tag == 'Self Request Rejected' || tag == 'Child Request Accepted' || tag == 'Child Request Rejected')
        {
          showDialog(
              context: context,
              builder: (BuildContext context)  => AlertDialog(
                title: Text(tag),
                content: Text(body),
                actions: [

                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Ok'),
                  ),
                ],
              )
          );
        }

        else if (tag == 'Request Accepted' || tag == 'Request Rejected' ) {
          showDialog(
              context: context,
              builder: (BuildContext context)  =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
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
        else if (tag.toString().contains('0') ||tag.toString().contains('1') ||tag.toString().contains('2') ||tag.toString().contains('3') ||tag.toString().contains('4') ||tag.toString().contains('5') ||tag.toString().contains('6') ||tag.toString().contains('7') ||tag.toString().contains('8') ||tag.toString().contains('9') ) {
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
                          FirebaseFirestore.instance
                              .collection('AddDisabilities').doc(tag).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).update({

                            'isDisability': 'true',
                          });
                          Navigator.pop(context);

                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('AddDisabilities').doc(tag).update({

                            'Status': 'Rejected',
                          }).then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddDisabilities').doc(tag).delete();
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
        if (tag == 'Car Rejected' || tag == 'Car Accepted')
        {
        return  showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(tag),
                content: Text(body),
                actions: [
                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => MyCarsInfo()),
                      );
                    },

                    child: Text('My Cars'),
                  ),

                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Ok'),
                  ),
                ],
              )
          );
        }
        else if (tag == ' Self Request Accepted' || tag == 'Self Request Rejected' || tag == 'Child Request Accepted' || tag == 'Child Request Rejected')
        {
          showDialog(
              context: context,
              builder: (BuildContext context)  => AlertDialog(
                title: Text(tag),
                content: Text(body),
                actions: [

                  FlatButton(
                    textColor: Color(0xFF6200EE),
                    onPressed: () {Navigator.pop(context);},
                    child: Text('Ok'),
                  ),
                ],
              )
          );
        }

        else if (tag == 'Request Accepted' || tag == 'Request Rejected' ) {
          showDialog(
              context: context,
              builder: (BuildContext context)  =>
                  AlertDialog(
                    title: Text(tag),
                    content: Text(body),
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
        else if (tag.toString().contains('0') ||tag.toString().contains('1') ||tag.toString().contains('2') ||tag.toString().contains('3') ||tag.toString().contains('4') ||tag.toString().contains('5') ||tag.toString().contains('6') ||tag.toString().contains('7') ||tag.toString().contains('8') ||tag.toString().contains('9') ) {
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
                          FirebaseFirestore.instance
                              .collection('AddDisabilities').doc(tag).update({

                            'Status': 'Accepted',
                          });
                          FirebaseFirestore.instance
                              .collection('Cars').doc(tag).update({

                            'isDisability': 'true',
                          });
                          Navigator.pop(context);

                        },
                        child: Text('Accept'),

                      ),
                      FlatButton(
                        textColor: Colors.red,
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('AddDisabilities').doc(tag).update({

                            'Status': 'Rejected',
                          }).then((value) {
                            FirebaseFirestore.instance.collection(
                                'AddDisabilities').doc(tag).delete();
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
  }  String userEmail = FirebaseAuth.instance.currentUser.email;
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
    })
    });

    return result.get('Name');
  }

  BuildContext contextk;

  @override

  Widget build(BuildContext context) {
    print(context);
    final chk = FirebaseFirestore.instance
        .collection('Disabilities')
        .where('UserID', isEqualTo: auth.currentUser.uid)
        .where('isDisability', isEqualTo: 'true')
        .get();
    final  ChildChec = FirebaseFirestore.instance
        .collection('DisabilitiesChild')
        .where('UserID', isEqualTo: auth.currentUser.uid)
        .where('isDisability', isEqualTo: 'true')
        .get();
    final CarsUpdate = FirebaseFirestore.instance
        .collection('Cars')
        .where('UserID', isEqualTo: auth.currentUser.uid)
        .get();
    chk.then((value) {
      if (value.docs.length > 0) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser.uid)
            .update({
          'isDisability': 'true',
        });
        CarsUpdate.then((Cars) {
          for (var i = 0; i < Cars.docs.length; i++) {
            FirebaseFirestore.instance
                .collection('Cars')
                .doc(Cars.docs[i].id)
                .update({
              'isDisability': 'true',

            });
          }
        });
      }
    });
    chk.then((value) {
      if (value.docs.length > 0) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser.uid)
            .update({
          'isDisability': 'true',
        });
        CarsUpdate.then((Cars) {
          for (var i = 0; i < Cars.docs.length; i++) {
            FirebaseFirestore.instance
                .collection('Cars')
                .doc(Cars.docs[i].id)
                .update({
              'isDisability': 'true',
            });
          }
        });
      }
    });

    ChildChec.then((value) {
      if (value.docs.length > 0) {

        CarsUpdate.then((Cars) {
          for (var i = 0; i < Cars.docs.length; i++) {
            FirebaseFirestore.instance
                .collection('Cars')
                .doc(Cars.docs[i].id)
                .update({
              'isDisability': 'true',
            });
          }
        });
      }
    });
    final List<Features> GridFeatures = [
      Features(
        title: 'Car Info',
        image: 'images/carInfo.png',
      ),
      Features(
        title: 'Show Tickets',
        image: 'images/payTickets.png',
      ),
      Features(
        title: 'Request Code',
        image: 'images/requestCode.png',
      ),
      Features(
        title: 'Add Disability',
        image: 'images/addDis.png',
      ),
      Features(
        title: 'Add User',
        image: 'images/addUser.png',
      ),
      Features(
        title: 'License ',
        image: 'images/license.png',
      ),
    ];
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

    return MaterialApp(
      theme: new ThemeData(primarySwatch: MaterialColor(0xfff7892b, color)),


      home: new Scaffold(

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
                leading: Icon(Icons.notifications),
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Sign out'),
                onTap: () {
                  FirebaseAuth.instance.signOut();
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
                        return ListTile();
                      }
                    } else {
                      return ListTile();
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
                          title: Text('My Children Codes'),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (ctx) => ChildrenCodes()),
                            );
                          },
                        );
                      } else {
                        return ListTile();
                      }
                    } else {
                      return ListTile();
                    }
                  }),

              /*  ListTile(
                leading: Icon(Icons.language),
                title: Text(SetLocalization.of(context).getTranslateValue("Language")),


                onTap: () {
                  String langg = SetLocalization.of(context).getTranslateValue("Language");
                  if(langg.compareTo('English') == 0)
                  {
                  changeLang(engLang);
                  }
                  else
                    changeLang(arabLang);

                },


              ),*/
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          /*  Container(
            decoration: new BoxDecoration(
                image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new AssetImage(
                        'images/bk.jpg'))),
          ),*/
          GridView.builder(
            padding: const EdgeInsets.all(20.0),
            itemCount: GridFeatures.length,
            itemBuilder: (ctx, i) => MainFeaturesForm(
              GridFeatures[i].title,
              GridFeatures[i].image,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.6),
              crossAxisSpacing: 25,
              mainAxisSpacing: 12.5,
            ),
          )
        ],
        /*GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: GridFeatures.length,
        itemBuilder: (ctx, i) => MainFeaturesForm(
          GridFeatures[i].title,
          GridFeatures[i].image,
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
*/
      ),
    ),);
  }
}
