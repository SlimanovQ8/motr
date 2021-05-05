import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import '../main.dart';

import 'package:Motri/screens/AddDisability.dart';
import 'package:Motri/screens/CarInsurance.dart';
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
import 'package:photo_view/photo_view.dart';

File _BackImage= null;
String _uploadedFileURL;
File _Frontimage = null;
String _uploadedfrontFileURL;
final firestore = FirebaseFirestore.instance; //
FirebaseAuth auth = FirebaseAuth.instance;
Future<String> getCivilID() async {
  final CollectionReference users = firestore.collection('Users');

  final String uid = auth.currentUser.uid;

  final result = await users.doc(uid).get();
  return result.get('Civil ID');
}
class AddLicense extends StatefulWidget {
  @override
  _AddLicenseState createState() => _AddLicenseState();
}
bool isFrontChoosen = false;
bool isFrontLoading = false;
bool isBackChoosen = false;
bool isBackLoading = false;
GlobalKey gk = new GlobalKey();


class _AddLicenseState extends State<AddLicense> {
  @override
  Widget build(BuildContext context) {

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
                  key: gk,
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
    return new DefaultTabController(
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
                                .where('UserID', isEqualTo: auth.currentUser.uid)
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


                                return new SingleChildScrollView(
                                    child: Center(
                                  child: isFrontLoading == true ?
                                  CircularProgressIndicator() :
                                  Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(20),

                                      ),
                                      _Frontimage != null
                                          ? Image.asset(
                                        _Frontimage.path,
                                        height: 300,
                                      )
                                          : Container(height: 150),
                                      _Frontimage == null
                                          ? new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                            ),
                                            color: Color(0xfff7892b),
                                            child: const Text('Choose Picture'),
                                            onPressed:
                                            chooseFrontFile

                                        ),)
                                          : Container(),
                                      _Frontimage != null
                                          ? new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                            ),
                                            color: Color(0xfff7892b),
                                            child: const Text('Upload Picture'),
                                            onPressed: (){
                                              uploadFrontImage();
                                              setState(() {
                                                isFrontChoosen =  false;
                                              });
                                            }

                                        ),)
                                          : Container(),
                                      _Frontimage != null
                                          ? new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                            ),
                                            color: Color(0xfff7892b),
                                            child: const Text("Clear Selection"),
                                            onPressed:
                                            clearFrontSelection

                                        ),)
                                          : Container(),

                                    ],
                                  ),
                                    ),
                                );
                              }
                              else
                              {
                                return new Center(
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(20),

                                      ),
                                      _Frontimage != null
                                          ? Material(
                                        child: InkWell(
                                          onTap: () {
                                            print('ergdhb ');

                                            showDialog(
                                              context: context,
                                              builder: (context) => _contentWidget(_Frontimage.path, 1),
                                            );


                                          },
                                          child: Container(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20.0),
                                              child: Image.asset(
                                                _Frontimage.path ,
                                                height: 300,
                                              ),),
                                          ),
                                        ),
                                      ):
                                      snapshot.data.docs[0].get("FrontURL") != null
                                          ? Material(
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
                                                )),
                                          ),
                                      ),
                                      )
                                          : CircularProgressIndicator(),
                                      new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          color: Color(0xfff7892b),
                                          child: const Text('Edit Picture'),
                                          onPressed:
                                            chooseFrontFile


                                        ),),
                                      SizedBox(
                                        height: 4,
                                      ),

                                      isFrontChoosen  == true ?
                                      new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),


                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                            ),
                                            color: Color(0xfff7892b),
                                            child: const Text('Upload Picture'),
                                            onPressed: (){

                                              uploadFrontImage();
                                              setState(() {
                                                isFrontChoosen =  false;

                                              });
                                            }

                                        ),): new Container(),

                                      new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15),

                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          color: Color(0xfff7892b),
                                          child: const Text('Delete Picture'),
                                          onPressed: () {
                                            setState(() {
                                              clearFrontSelection();
                                            });
                                            setState(() {
                                              if (snapshot.data.docs[0].get("FrontURL") != null) {
                                                deleteFrontImage(
                                                    snapshot.data.docs[0].get(
                                                        "FrontURL"));
                                              }
                                              FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).update({
                                                "FrontURL": "",
                                                "FrontPic": "false"
                                              });
                                            });
                                          },
                                        ),)
                                    ],
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
                                .where('UserID', isEqualTo: auth.currentUser.uid)
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


                                return new SingleChildScrollView(
                                  child: Center(
                                    child: isBackLoading == true ?
                                    CircularProgressIndicator() :
                                    Column(
                                      children: <Widget>[
                                        Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.all(20),

                                        ),
                                        _BackImage != null
                                            ? Image.asset(
                                          _BackImage.path,
                                          height: 300,
                                        )
                                            : Container(height: 150),
                                        _BackImage == null
                                            ? new Container(
                                          padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                              ),
                                              color: Color(0xfff7892b),
                                              child: const Text('Choose Picture'),
                                              onPressed:
                                              chooseBackFile

                                          ),)
                                            : Container(),
                                        _BackImage != null
                                            ? new Container(
                                          padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                              ),
                                              color: Color(0xfff7892b),
                                              child: const Text('Upload Picture'),
                                              onPressed: (){
                                                uploadBackImage();
                                                setState(() {
                                                  isBackChoosen =  false;
                                                });
                                              }

                                          ),)
                                            : Container(),
                                        _BackImage != null
                                            ? new Container(
                                          padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                          child: RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(18.0),
                                              ),
                                              color: Color(0xfff7892b),
                                              child: const Text("Clear Selection"),
                                              onPressed:
                                              clearBackSelection

                                          ),)
                                            : Container(),

                                      ],
                                    ),
                                  ),
                                );
                              }
                              else
                              {
                                return new Center(

                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.all(20),

                                      ),
                                      _BackImage != null
                                          ? Material(
                                        child: InkWell(
                                          onTap: () {
                                            print('ergdhb ');

                                            showDialog(
                                              context: context,
                                              builder: (context) => _contentWidget(_BackImage.path, 1),
                                            );


                                          },
                                          child: Container(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(20.0),
                                              child: Image.asset(
                                                _BackImage.path ,
                                                height: 300,
                                              ),),
                                          ),
                                        ),
                                      ):
                                      snapshot.data.docs[0].get("BackURL") != null
                                          ? Material(
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
                                      )
                                          : CircularProgressIndicator(),
                                      new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),

                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                            ),
                                            color: Color(0xfff7892b),
                                            child: const Text('Edit Picture'),
                                            onPressed:
                                            chooseBackFile

                                        ),),
                                      SizedBox(
                                        height: 4,
                                      ),

                                      isBackChoosen  == true ?
                                      new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15 , bottom: 8.5),


                                        child: RaisedButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(18.0),
                                            ),
                                            color: Color(0xfff7892b),
                                            child: const Text('Upload Picture'),
                                            onPressed: (){
                                              uploadBackImage();
                                              setState(() {
                                                isBackChoosen =  false;

                                              });
                                            }

                                        ),): new Container(),

                                      new Container(
                                        padding: EdgeInsets.only(left: 15, right: 15),

                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(18.0),
                                          ),
                                          color: Color(0xfff7892b),
                                          child: const Text('Delete Picture'),
                                          onPressed: () {
                                            setState(() {
                                              clearBackSelection();
                                            });
                                            setState(() {
                                              deleteBackImage(snapshot.data.docs[0].get("BackURL"));
                                              FirebaseFirestore.instance.collection('Users').doc(auth.currentUser.uid).update({
                                                "BackURL": "",
                                                "BackPic": "false"
                                              });
                                            });
                                          },
                                        ),)
                                    ],
                                  ),
                                );


                              }
                            }),
                      ),
                    ),


                  ],
                )
            ),
          ),


            /*Center(
        child: */
    );
  }

  Future chooseBackFile() async {
    PickedFile selectedFile = await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _BackImage = File(image.path);
        isBackChoosen = true;
      });
    });
  }

  Future uploadBackImage() async {
    setState(() {
      isBackLoading = true;
      FirebaseFirestore.instance.collection("Users").doc(auth.currentUser.uid).update({
        "BackPic": "false",
        "BackURL": '',
      });
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Users/${auth.currentUser.uid}/BackImage');
    StorageUploadTask uploadTask = storageReference.putFile(_BackImage);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
      FirebaseFirestore.instance.collection("Users").doc(auth.currentUser.uid).update({
        "BackPic": "true",
        "BackURL": fileURL,
      });
      setState(() {
        isBackLoading = false;
      });
    });

  }
  void clearBackSelection() {
    setState(() {
      _BackImage = null;
      _uploadedFileURL = null;
    });
  }
  Future<bool> deleteBackImage(String urlFile) async {

    setState(() {
      isBackLoading = true;
    });
    print(urlFile);
    StorageReference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child('Users/${auth.currentUser.uid}/BackImage')
        .delete()
        .then((_) { print('Successfully deleted $urlFile storage item');
    setState(() {
      _BackImage = null;
      _uploadedFileURL = null;
      isBackLoading = false;
    });
    });

  }

  Future chooseFrontFile() async {
    PickedFile selectedFile = await ImagePicker().getImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _Frontimage = File(image.path);
        isFrontChoosen = true;
      });
    });
  }

  Future uploadFrontImage() async {
    setState(() {
      isFrontLoading = true;
      FirebaseFirestore.instance.collection("Users").doc(auth.currentUser.uid).update({
        "FrontPic": "false",
        "FrontURL": '',
      });
    });
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('Users/${auth.currentUser.uid}/FrontImage');

    StorageUploadTask uploadTask = storageReference.putFile(_Frontimage);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedfrontFileURL = fileURL;
      });
      FirebaseFirestore.instance.collection("Users").doc(auth.currentUser.uid).update({
        "FrontPic": "true",
        "FrontURL": fileURL,
      });
      setState(() {
        isFrontLoading = false;
      });
    });

  }
  void clearFrontSelection() {
    setState(() {
      _Frontimage = null;
      _uploadedfrontFileURL = null;
    });
  }
  Future<bool> deleteFrontImage(String urlFile) async {
    setState(() {
      isFrontLoading = true;
    });
    print(urlFile);
    StorageReference storageReferance = FirebaseStorage.instance.ref();
    storageReferance
        .child('Users/${auth.currentUser.uid}/FrontImage')
        .delete()
        .then((_) { print('Successfully deleted $urlFile storage item');
    setState(() {
      _Frontimage = null;
      _uploadedfrontFileURL = null;
      isFrontLoading = false;
    });
    });

  }


}
