
import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/models/lang.dart';
import 'package:Motri/screens/EditProfile.dart';
import 'package:Motri/screens/MyCars.dart';
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


class MainMotri extends StatelessWidget {
  String userEmail = FirebaseAuth.instance.currentUser.email;
  String use = FirebaseAuth.instance.currentUser.uid;
  var userName = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .id;

  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  final firestore = FirebaseFirestore.instance; //
  FirebaseAuth auth = FirebaseAuth.instance;
  Language engLang = new Language(1, 'English', 'U+1F1FA', 'en');
  Language arabLang = new Language(2, 'Arabic', 'U+1F1F0', 'ar');
  
    Future<String> getUserName() async {
    final CollectionReference users = firestore.collection('Users');

    final String uid = auth.currentUser.uid;
    print("ID =" + uid);

    final CollectionReference b =  users.doc(uid).firestore.collection('Cars');

    final  result =  await FirebaseFirestore.instance.collection('Users').doc(uid).get();
    return result.get('Name');
  }
  Future<List<DocumentSnapshot>> getProduceID() async{
    var data = await FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).collection('Cars').get();
    var productId = data.docs;
    var products;
    getProduceID().then((data){
      for(int i = 0; i < 4; i++) {
        products = FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).collection('Cars')
            .doc(data[i]['Car'])
            .snapshots();
          products.forEach((g) {
            print(g.data);
          });
        
      }
    });
    return productId;
  }

  var products;
    BuildContext contextk;


  @override
  Widget build(BuildContext context) {
    print(context);
    final List<Features> GridFeatures = [
      Features(
        title: 'Car Info',
        image: 'images/carInfo.png',
      ),
      Features(
        title: 'Pay Tickets',
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
    void changeLang(Language lang)
    {
      Locale _temp;
      switch(lang.langCode)
      {
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
    return Scaffold(


      appBar: AppBar(
        title: Text('Motri'),
        backgroundColor: Color(0xfff7892b),
      ),
      drawer: Drawer(
        child: Container(
          color:  Colors.white,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,

            children: <Widget>[
              UserAccountsDrawerHeader(

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
                      (userEmail.substring(0,2)
                      ),
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
                title: Text('My Cars'),
                onTap: () {


                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => MyCars()),
                  );
                },
              ),
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


    ),)
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


    );



  }


}
