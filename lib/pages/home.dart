import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:world_time/services/locations.dart';
import 'package:world_time/services/world_time.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map data = {};

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    String bgImage = "";
    Color color = Colors.grey[900];
    if(data["isDayTime"] != null) {
      bgImage = data["isDayTime"] ? "day.jpg" : "night.jpg";
      color = data["isDayTime"] ? Colors.blue[100] : Color(0xFF044B6B);
    }
    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: getTime,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: bgImage != "" ? BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("assets/$bgImage"),
                fit: BoxFit.cover,
              )) : BoxDecoration(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
                child: Column(
                  children: [
                    TextButton.icon(
                      onPressed: () async {
                        List locations = data["allLocations"];
                        if(locations.isEmpty) {
                          SmartDialog.showLoading();
                          Locations locationsList = Locations();
                          await locationsList.getLocations();
                          locations = locationsList.locations;
                          data["allLocations"] = locations;
                          SmartDialog.dismiss();
                        }
                        if(locations.isEmpty)
                          SmartDialog.showToast("Unable to get the Locations.\nPlease try again");
                        else {
                          dynamic result = await Navigator.pushNamed(
                              context, '/location', arguments: data);
                          setState(() {
                            data = result;
                          });
                        }
                      },
                      icon: Icon(
                        Icons.add_location,
                        color: Colors.white,
                      ),
                      label: Text("Edit Location",
                          style: TextStyle(
                            color: Colors.white,
                          )),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data["location"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.0,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      data["time"],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            data["time"] == "Could not get time" ? 35.0 : 65.0,
                        letterSpacing: 2.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> getTime() async{
    Locations locationsList = Locations();
    await locationsList.getLocations();
    WorldTime instance = WorldTime(location: data["location"], url: data["url"]);
    await instance.getTime();
    setState(() {
      data = {
        "location": instance.location,
        "url": instance.url,
        "time": instance.time,
        "isDayTime": instance.isDayTime,
        "allLocations": locationsList.locations,
      };
    });
  }
}
