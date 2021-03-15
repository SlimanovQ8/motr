import 'package:Motri/localizations/setLocalization.dart';
import 'package:Motri/route/custom_route.dart';
import 'package:Motri/route/route_names.dart';
import 'package:Motri/screens/AuthFirebase.dart';
import 'package:Motri/screens/loginPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Motri/screens/Main.dart';
import 'package:Motri/models/userModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';



String _data;


Future<void> main() async
{

// Get a specific camera from the list of available cameras.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp()
  );
}

// A screen that allows users to take a picture using a given camera.

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
class MyApp extends StatefulWidget {
  BuildContext trfc;
  static void setLocale(BuildContext context, Locale locale)
  {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _local;
  @override
  void setLocale(Locale locale)
  {
    setState(() {
      _local = locale;
    });
  }
  static  getContext()
  {
  }  Widget build(BuildContext context) {
    print("gtyjmnhh ");
    print(context);
    return MaterialApp(
      theme: new ThemeData(primarySwatch: MaterialColor(0xfff7892b, color)),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapSh0ot) {
            if (userSnapSh0ot.hasData) {


              user = FirebaseAuth.instance.currentUser.email;
              print(user);
              return MainMotri();
            }
            return LoginPage();
          }),
      onGenerateRoute: CustomRoute.allRoutes,
      initialRoute: homeRoute,
      locale: _local,
      supportedLocales: [
        Locale('en', 'US'),
        Locale('ar', 'KW')
      ],
      localizationsDelegates: [

        SetLocalization.localizationsDelegate,

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,

        DefaultCupertinoLocalizations.delegate
      ],
      localeResolutionCallback: (deviceLocal, supportedLocales)
      {
        for (var local in supportedLocales)
        {
          if(local.languageCode == deviceLocal.languageCode && local.countryCode == deviceLocal.countryCode)
            return deviceLocal;
        }
        return supportedLocales.first;
      },
    );
  }
}

  @override


  MaterialColor colorCustom = MaterialColor(0xFFF7892B, color);

  String user = "";

