import 'package:Motri/main.dart';
import 'package:Motri/route/route_names.dart';
import 'package:flutter/material.dart';

class CustomRoute {
  static Route <dynamic> allRoutes(RouteSettings settings)
  {

    switch (settings.name) {
      case homeRoute:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}