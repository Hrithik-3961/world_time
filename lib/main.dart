import 'package:flutter/material.dart';
import 'package:world_time/pages/home.dart';
import 'package:world_time/pages/edit_location.dart';
import 'package:world_time/pages/loading.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => Loading(),
      "/home": (context) => Home(),
      "/location": (context) => Location(),
    },
    builder: (BuildContext context, Widget child) {
      return FlutterSmartDialog(child: child);
    },
  ));
}
