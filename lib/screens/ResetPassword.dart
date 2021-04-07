
import 'package:Motri/screens/loginPage.dart';
import 'package:Motri/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:Motri/screens/Widget/bezierContainer.dart';
import 'package:Motri/screens/Widget/customClipper.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Widget/bezierContainer.dart';

class ResetPass extends StatefulWidget {
  ResetPass({Key key, this.title}) : super(key: key);

  final String title;


  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<ResetPass> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormState> _formKePy = new GlobalKey<FormState>();

  bool ValidEmail = false;
  bool ValidPass = false;
  bool isLoading = false;
  String UserEmail = '';
  bool isSent = false;
  String UserPass = '';
  String errorMessage = '';
  final _auth = FirebaseAuth.instance;

  void _sumbitAuthForm( String email,
      BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
        ValidEmail = false;
      });
       await _auth.sendPasswordResetEmail(
        email: email,
      ).then((value) {
         isSent = true;
         showDialog(
             context: context,
             builder: (_) => new AlertDialog(
               title: new Text("Link has been sent "),
               content: new Text("check your email"),
               actions: <Widget>[
                 FlatButton(
                   child: Text('OK'),
                   onPressed: () {
                     Navigator.of(context, rootNavigator: true).pop('dialog');
                     isLoading = false;
                   },
                 )
               ],
             ));

       });



    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;


        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
              title: new Text(err.message),
              content: new Text(err.code),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => LoginPage()),);
                    isLoading = false;
                  },
                )
              ],
            ));
      }
      setState(() {
        isLoading = false;
        ValidEmail = true;
      });
    } catch (err) {
      print(err.code);
      switch (err.code) {
        case "invalid-email":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
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
      if (email.isEmpty)
    {
        errorMessage = "email field is empty";
    }
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
            title: new Text("Error"),
            content: new Text(errorMessage),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  isLoading = false;
                },
              )
            ],
          ));
      setState(() {
        isLoading = false;
        ValidEmail = true;
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
  Widget _submitButton() {

    if (isLoading)
    return CircularProgressIndicator();
    else
      return RaisedButton(
        onPressed: () {
          _sumbitAuthForm(UserEmail, context);
          if (isSent)
            showDialog(
                context: context,
                builder: (_) => new AlertDialog(
                  title: new Text("Material Dialog"),
                  content: new Text("Hey! I'm Coflutter!"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Close me!'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
        }
        ,
        color: Color(0xfff7892b),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.black),
        ),

        child: Container(

          width: MediaQuery.of(context).size.width,
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

          child: Text(

              'Reset',
              style: TextStyle(fontSize: 20, color: Colors.white)
          ),
        ),);
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Email',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  validator: (f) {
                    if(!ValidEmail)
                      return 'Invalid email address';
                    return null;
                  },
                  onChanged: (String s) {
                    setState(() {
                      UserEmail = s;


                    });
                  },
                  obscureText: false,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Color(0xfff3f3f4),
                      filled: true)),

            ],
          ),
        )
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
                      top: -height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer()),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * .2),
                        _title(),
                        SizedBox(height: 50),
                        _emailPasswordWidget(),
                        SizedBox(height: 20),
                        _submitButton(),

                        _divider(),
                        _createAccountLabel(),
                      ],
                    ),
                  ),

                ]
            ),

          ),
        ));
  }
}
