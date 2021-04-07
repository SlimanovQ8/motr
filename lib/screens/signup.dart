import 'dart:async';

import 'package:flutter/material.dart';
import 'package:Motri/screens/Widget/bezierContainer.dart';
import 'package:Motri/screens/Widget/customClipper.dart';
import 'package:Motri/screens/loginPage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../main.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKeyEmail = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKePy = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formPasswordConfirmation =
      new GlobalKey<FormState>();
  bool isValidCivilID = false;
  final GlobalKey<FormState> _formCivilID = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeyName = new GlobalKey<FormState>();

  bool ValidEmail = false;
  bool PassNotEqualPass = false;
  bool ExistEmail = false;
  bool PassLessthan7 = false;
  bool ExistCivilID = false;
  bool isLoading = false;
  String UserEmail = '';
  String UserPass = '';
  String UserPassConfirmation = '';
  String UserCivilID = '';
  String UserName = '';
  String errorf = '';
  bool isNameEmpty = false;
  bool baw = false;
  bool isCivilIDEmpty = false;
  String errorMessage = '';
  final _auth = FirebaseAuth.instance;

  void _sumbitAuthForm(String Name, String CivilID, String email,
      String password, String passwordConfirmation, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
        ValidEmail = false;
        PassNotEqualPass = false;
        ExistEmail = false;
        PassLessthan7 = false;
        ExistCivilID = false;
        isNameEmpty = false;
        isCivilIDEmpty = false;
        isValidCivilID = false;
      });

      final fbm = FirebaseMessaging();

      if (!email.contains("@") || !email.contains("."))
        setState(() {
          ValidEmail = true;
        });


      if (password.length < 7) {
        setState(() {
          PassLessthan7 = true;
        });
      }
      if (Name.length < 1) {
        setState(() {
          isNameEmpty = true;
        });
      }
      if (CivilID.length < 8) {
        setState(() {
          isCivilIDEmpty = true;
        });
      }

      if (password.compareTo(passwordConfirmation) != 0) {
        setState(() {
          PassNotEqualPass = true;
        });
      }
      final snapShot = await FirebaseFirestore.instance
          .collection('CivilIDs')
          .doc(CivilID)
          .get();
      if(snapShot.exists)
        {
          setState(() {
            ExistCivilID = true;
            isLoading = false;
          });
        }

      if (!ValidEmail &&
          !PassNotEqualPass &&
          !ExistEmail &&
          !PassLessthan7 &&
          !ExistCivilID &&
          !isNameEmpty) {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

String getToken = "";
fbm.getToken().then((value) => getToken = value);
        await FirebaseFirestore.instance
            .collection('CivilIDs')
            .doc(CivilID)
            .set({
          'Civil ID': CivilID,
        });
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(authResult.user.uid)
            .set({
          'Name': Name,
          'Civil ID': CivilID,
          'email': email.toLowerCase(),
          'psssword': password,
          'isDisability': 'false',
          'deviceID': getToken,
        });
          await _auth.signInWithEmailAndPassword(email: email, password: password);
          Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => MyApp())
          );

      } else {
        var timer = Timer(
            Duration(seconds: 1),
                () => setState(() {
              isLoading = false;
            }));
      }
    } on FirebaseAuthException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;

        switch (err.code) {
          case "invalid-email":
            setState(() {
              ValidEmail = true;
              isLoading = false;
            });
            ValidEmail= true;
            errorMessage = "Your email address appears to be malformed.";
            isLoading = false;
            break;
          case "email-already-in-use":
            setState(() {
              isLoading = false;
              ExistEmail = false;
            });
            ExistEmail = true;
            errorMessage = "email already exist.";
            isLoading = false;
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "ERROR_USER_DISABLED":
            errorMessage = "User with this email has been disabled.";
            break;
          case "ERROR_TOO_MANY_REQUESTS":
            errorMessage = "Too many requests. Try again later.";
            break;
          case "ERROR_OPERATION_NOT_ALLOWED":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        setState(() {
          isLoading = false;

        });
      }



      setState(() {
        isLoading = false;

      });
    } catch (err) {
      print(err);

      setState(() {
        errorf = err;
        isLoading = false;

      });
    }

  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    if (isLoading)
      return CircularProgressIndicator();
    else if (!UserName.isEmpty && !UserCivilID.isEmpty && !UserEmail.isEmpty &&!UserPass.isEmpty && !UserPassConfirmation.isEmpty ) {
      return RaisedButton(
        onPressed: () {
          _sumbitAuthForm(UserName, UserCivilID, UserEmail, UserPass,
              UserPassConfirmation, context);
        },
        color: Color(0xfff7892b),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.black),
        ),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
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
                  colors: [Color(0xfffbb448), Color(0xfff7892b)])),
          child: Text('Register',
              style: TextStyle(fontSize: 20, color: Colors.white)),
        ),
      );
    }
    else  {
      return RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
          child: Text('Register',
              ),
        ),
      );
    }
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Sign Up',
              style: TextStyle(
                  color: Color(0xfff79c4f),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'M',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children: [
            TextSpan(
              text: 'ot',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'ri',
              style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        Text(
          'Name',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            key: _formKeyName,
            autovalidateMode: AutovalidateMode.always,
            validator: (b) {
              if (isNameEmpty) return "Name cannot be empty";
              return null;
            },
            onChanged: (String s) {
              setState(() {
                UserName = s;
              });
            },
            obscureText: false,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true)),
        Text(
          'Civil ID',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            key: _formCivilID,
            autovalidateMode: AutovalidateMode.always,
            validator: (b) {
              if (isCivilIDEmpty) return "Civil ID cannot be less than 8";
              if (ExistCivilID) return "Civil ID is already exist";
              return null;
            },
            onChanged: (String s) {
              setState(() {
                UserCivilID = s;
              });
            },
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ],
            obscureText: false,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true)),
        Text(
          'Email',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(

            key: _formKeyEmail,
            autovalidateMode: AutovalidateMode.always,
            validator: (f) {
              if (ExistEmail) return "Email address already exist";
              if (ValidEmail) return "Email address not valid";
              return null;
            },
            onChanged: (String s) {
              setState(() {
                UserEmail = s;
              });
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true)),
        Text(
          'Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            key: _formKePy,
            autovalidateMode: AutovalidateMode.always,
            validator: (f) {
              if (PassLessthan7)
                return 'Password should be at least 7 Characters';
              return null;
            },
            onChanged: (String s) {
              setState(() {
                UserPass = s;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true)),
        Text(
          'Password Confirmation',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
            key: _formPasswordConfirmation,
            autovalidateMode: AutovalidateMode.always,
            validator: (f) {
              if (PassNotEqualPass)
                return 'Password Confirmation does not matches password';
              return null;
            },
            onChanged: (String s) {
              setState(() {
                UserPassConfirmation = s;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
      height: height,
      child: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: BezierContainer(),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * .2),
                  _title(),
                  SizedBox(
                    height: 50,
                  ),
                  _emailPasswordWidget(),
                  SizedBox(
                    height: 20,
                  ),
                  _submitButton(),
                  SizedBox(height: 14),
                  _loginAccountLabel(),
                ],
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    ));
  }
}
