import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:Motri/widgets/Auth/auth_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Authform extends StatefulWidget {
  Authform(
    this.submitFn,
    this.isLoading,
  );

  final bool isLoading;
  final void Function(
    String name,
    String CivilID,
    String email,
    String password,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;
  bool pressAttention = true;
  @override
  _AuthformState createState() => _AuthformState();

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

class _AuthformState extends State<Authform> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userCivilID = '';
  var _userName = '';
  var _userNationality = '';
  var _userEmail = '';
  var _userPassword = '';
  var _userPasswordConfirmation = '';
  bool ValidCivilID = false;
  bool ValidEmail = false;
  bool ValidPass = false;
  bool ValidConPass = false;
  bool ValidNationality = false;
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _sumbitAuthForm(String name, String CivilID, String email,
      String password, bool isLogin, BuildContext ctx) async {
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('Users').doc(authResult.user.uid).set({
          'Name': name,
          'Civil ID': CivilID,
          'email': email,
          'psssword': password
        });
      }
      ;


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
        _isLoading = false;
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
      });
    }
  }
  void _trySumbit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid && !_isLogin) {
      _formKey.currentState.save();
      widget.submitFn(
        _userName,
        _userCivilID,
        _userEmail.trim(),
        _userPassword.trim(),
        _isLogin,
        context,
      );

    }
    else if(isValid && _isLogin)
      {
        _formKey.currentState.save();
        widget.submitFn(
            _userName ,
            _userCivilID,
            _userEmail.trim(),
    _userPassword.trim(),
    _isLogin,
    context,
        );
      }
    final snapShot = await FirebaseFirestore.instance.collection('Users').doc(_userCivilID).get();

    if (snapShot.exists) {
      //it exists
      setState(() {
        isExistCiv = true;
      });
    }
    else {
      //not exists
      setState(() {
        isExistCiv = false;

      });
    }
  }
  bool isExistCiv = false;

  void isEx() async {

  }
  MaterialColor colorCustom = MaterialColor(0xFFF4C63F, color);
  @override
  Widget build(BuildContext context) {
    bool pressAttention = true;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Motri'),
        centerTitle: true,
        backgroundColor:  HexColor("F4C63F"),
      ),
        body: Stack(

            children: <Widget>[
        Container(
        decoration: new BoxDecoration(
        image: new DecorationImage(
        fit: BoxFit.cover,
            image: new AssetImage(
                'images/bk.jpg'))),
    ),


            Center(
            child: SingleChildScrollView(
            child: Form(child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [

            ListTile(
            title: Row(
                children: <Widget>[

                Expanded(child:  RaisedButton(
                  child: Text("Civilian"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black),
              ),
                color: pressAttention ? Colors.blue : Colors.black,
                  // 3
                  onPressed: () => {

                    setState(() {

                      pressAttention = !pressAttention;
                      print(pressAttention);


                    })
                  },

                ),
                ),

        Expanded(child: RaisedButton(
          onPressed: () {},

          child: Text("Police"),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.black),
        ),),
        ),],
      ),
    ),
                   Container( child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45.0),
              side: BorderSide(color: Colors.black)),
            margin: EdgeInsets.all(40),



              child: Padding(
                padding: EdgeInsets.all(16),

                child: Form(
                  key: _formKey,
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget> [


                    if(!_isLogin)
                    TextFormField(
                      key: ValueKey ('Name'),
                      validator: (value) {
                        if (value.isEmpty )
                        {

                          return 'Please enter your name';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),


                      onSaved: (value) {
                        _userName = value;
                      },
                    ),


                    if(!_isLogin)
                    TextFormField(
                      key: ValueKey ('Civil ID'),
                      validator: (value) {
                        if (value.isEmpty )
                        {
                          return 'Please enter a valid Civil ID';
                        }
                        if(value.length < 9)
                          {
                            return 'Civil ID must be at least 9 digits';
                          }
                        if(isExistCiv)
                          return 'Civil ID already registered';
                        return null;
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Civil ID',
                      ),
                      onSaved: (value) {
                        _userCivilID = value;
                      },
                    ),

                    TextFormField(
                      key: ValueKey ('Email'),
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@'))
                          {
                            return 'Please enter a valid email address';
                          }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    TextFormField(
                      key: ValueKey ('password'),

                      validator: (value) {
                        if (value.isEmpty || value.length < 7)
                        {
                          return 'Password must be at least 7 characters long';
                        }
                        else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText: 'Password'

                      ),
                      obscureText: true,
                      onChanged:
                          (val){
                        setState(() {
                          _userPassword = val;
                        });
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                    ),
                    if(!_isLogin)
                    TextFormField(
                      key: ValueKey ('passwordCon'),
                      validator: (value) {
                        if (value.isEmpty || value.length < 7)
                        {
                          return 'Password must be at least 7 characters long';
                        }
                        if (_userPasswordConfirmation.compareTo(_userPassword) != 0 )
                          return 'Password Confirmation does not match password';
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText: 'Re-enter password'

                      ),
                      obscureText: true,
                      onChanged:
                          (val){
                        setState(() {
                          _userPasswordConfirmation = val;
                          print("1: " + _userPassword + "\n" + "2: " + _userPasswordConfirmation);
                        });
                      },
                      onSaved: (value) {
                        _userPasswordConfirmation = value;
                      },
                    ),
                    SizedBox(height: 12),

                  ],
                ),
                ),
              ),


          ),


        ),
        /* add child content here */

                  if (widget.isLoading  )
                    CircularProgressIndicator(),
                  if (!widget.isLoading)
                    FlatButton(
                      child: Text (_isLogin ? 'Login' : 'Sign up'),
                      onPressed:

                      _trySumbit,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black)
                      ),
                      color: Colors.green,
                    ),
                  if (!widget.isLoading)
                    FlatButton( child: Text ( _isLogin ?'Create new account' : 'I already have an account'),
                      onPressed: ( ) {
                        color: Colors.purple;
                        highlightColor: Colors.purple;
                        setState(() {
                          _isLogin = !_isLogin;

                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black),

                      ),
                        color: Colors.deepOrange
                    ),
    //)
       ],

    ),
            ),
        ), ),

    ],),

    );

  }
}