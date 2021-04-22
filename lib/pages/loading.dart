import 'package:flutter/material.dart';
import 'package:world_time/services/world_time.dart';
import 'package:world_time/services/locations.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  @override
  void initState() {
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: SpinKitCircle(
          color: Colors.white,
          size: 80.0,
        ),
      ),
    );
  }

  void getTime() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    Locations locations = Locations();
    await locations.getLocations();
    if(prefs.containsKey("url"))
    {
      String location = prefs.getString("location") ?? "";
      String url = prefs.getString("url") ?? "";
      WorldTime instance = WorldTime(location: location, url: url);
      await instance.getTime();
      Navigator.pushReplacementNamed(context, '/home', arguments: {
        "location": instance.location,
        "time": instance.time,
        "isDayTime": instance.isDayTime,
        "allLocations": locations.locations,
      });
    }
    else
      {
        Navigator.pushReplacementNamed(context, '/location', arguments: {
          "allLocations": locations.locations,
        });
      }
  }
}