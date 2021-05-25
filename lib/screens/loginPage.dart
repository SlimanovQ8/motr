
import 'package:Motri/main.dart';
import 'package:Motri/screens/ResetPassword.dart';
import 'package:Motri/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:Motri/screens/Widget/bezierContainer.dart';
import 'package:Motri/screens/Widget/customClipper.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hexcolor/hexcolor.dart';
import 'Widget/bezierContainer.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKePy = new GlobalKey<FormState>();

  bool ValidEmail = false;
  bool ValidMoiNumber = false;
  bool ValidPass = false;
  bool isLoading = false;
  bool isCivPressed = true;
  String UserEmail = '';
  String UserPass = '';
  List <String> PoliceNames = new List ();
  List <String> PoliceCID = new List ();
  final _auth = FirebaseAuth.instance;

  void _sumbitAuthForm( String email,
      String password, BuildContext ctx) async {
    UserCredential authResult;
    try {
      print(email);
      setState(() {
        isLoading = true;
        ValidEmail = false;
      });

      PoliceNames.add("Sliman");
      PoliceNames.add("Yousef");
      PoliceNames.add("Abdulrahman");
      PoliceNames.add("Saad");
      PoliceNames.add("Fahad");
      PoliceCID.add("29069850520");
      PoliceCID.add("29801410520");
      PoliceCID.add("27521020525");
      PoliceCID.add("29855252202");
      PoliceCID.add("25256235252");

      authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );


      final a = await FirebaseFirestore.instance.collection('MOI').get();
      int size = a.docs.length;
      final firstTime = await FirebaseFirestore.instance.collection("MOI").where("MOINumber", isEqualTo: email.toLowerCase()).get();

      if(email.endsWith("@policemotri.com"))
      {
        if (firstTime.docs.length == 0) {
          await FirebaseFirestore.instance
              .collection('MOI')
              .doc(authResult.user.uid)
              .set({
            'Name': PoliceNames.elementAt(size % 5),
            'Civil ID': PoliceCID.elementAt(size & 5),
            'MOINumber': email.toLowerCase(),
            'MOINum': email.substring(email.indexOf("m") + 1, email.indexOf("@")),
            'psssword': password,
            "UserID": authResult.user.uid,
            "PlateNumber": ".",

          });

        }
        else
          {
            await FirebaseFirestore.instance
                .collection('MOI')
                .doc(firstTime.docs[0].id)
                .update({
              'MOINumber': email.toLowerCase(),
              'MOINum': email.substring(email.indexOf("m") + 1, email.indexOf("@")),
              'psssword': password,
              "UserID": firstTime.docs[0].id,
              "PlateNumber": "..",
            });
          }
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) => MyApp()),);

      }
      else
        {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => MyApp()),);

        }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message;

        Scaffold.of(ctx).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Theme
                .of(ctx)
                .errorColor,
          ),
        );
      }
      setState(() {
        isLoading = false;
        ValidEmail = true;
      });
    } catch (err) {
      print(err);
      setState(() {
        isLoading = false;
        ValidEmail = true;
      });
    }
  }


  String PoliceEmail = "";
  Widget _submitButton() {

    if (isLoading)
      return CircularProgressIndicator();
    else
    return RaisedButton(
      onPressed: () {
        if (isCivPressed)
          _sumbitAuthForm(UserEmail, UserPass, context);
        else {
          PoliceEmail = "m" + UserEmail + "@policemotri.com";
          _sumbitAuthForm(PoliceEmail, UserPass, context);
        }
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

        'Login',
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
             // if (isCivPressed)
              Text(
                isCivPressed?
                'Email' : 'MOI Number',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                  validator: (f) {
                    if(!ValidEmail)
                    return  !isCivPressed?  'Invalid MOI number' : 'Invalid email address';
                    return null;
                  },
                  keyboardType: isCivPressed ? TextInputType.emailAddress :  TextInputType.phone,
                  inputFormatters: !isCivPressed ? [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ]:
                      [

                      ],
                   onChanged: (String s) {
                    setState(() {
                      UserEmail = s;
                      print(UserEmail);


                    });
                  },
                  obscureText: false,
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
                  autovalidateMode: AutovalidateMode.always ,
                  validator: (f) {
                    if(ValidEmail)
                      return !isCivPressed? 'Invalid MOI number or password' : 'Invalid email address or password';
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
                      filled: true))
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
                  SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
          ),
                        onPressed: () {

                          setState(() {
                            isCivPressed = true;
                            ValidEmail = false;
                          });

                        },
                        child: SizedBox(
                          child: Text("Civilian") ,

                        ),

                        color: isCivPressed == true ?
                        Color(0xfff7892b) : HexColor("e4e4e4")
                      ),
                      SizedBox(width: 20,),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                          setState(() {
                            isCivPressed = false;
                            ValidEmail = false;

                          });

                        },
                        child: SizedBox(
                            child: Text("Police")),
                          color: isCivPressed == false ?
                          Color(0xfff7892b) : HexColor("e4e4e4")
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  _emailPasswordWidget(),
                  SizedBox(height: 20),
                  _submitButton(),
                  Container(

                    padding: EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.centerRight,
                    child: new InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => ResetPass()),);

                      },
                      child: Text('Forgot Password ?',

                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500)),
                  ),
                  ),
                  if(isCivPressed)
                    _divider(),
                  if(isCivPressed)
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
