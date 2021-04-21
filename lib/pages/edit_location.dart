import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:world_time/services/world_time.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {

  Map data = {};
  List locations = [];
  List filteredLocations = [];

  @override
  Widget build(BuildContext context) {

    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    locations = data["allLocations"];
    filteredLocations = filteredLocations.isNotEmpty ? filteredLocations : locations;
    return WillPopScope(
      onWillPop: (){
        Navigator.pop(context, data);
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Choose a Location"),
          centerTitle: true,
          backgroundColor: Colors.blue[900],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search Here...',
                ),
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(() {
                    filteredLocations = locations
                        .where((string) => string.toLowerCase().contains(text.toLowerCase()))
                        .toList();
                  });
                },
              ),
            ),
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: filteredLocations.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          onTap: () {
                            updateLocation(index);
                          },
                          title: getTitle("${filteredLocations[index]}"),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getTitle(location)
  {
    String title = location.substring(location.lastIndexOf('/') + 1) + ", " +
                    location.substring(0, location.indexOf('/'));
    return Text(title);
  }

  void updateLocation(index) async
  {
    SmartDialog.showLoading();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = filteredLocations[index].toString();
    String location = url.substring(url.lastIndexOf('/') + 1);
    WorldTime instance = WorldTime(location: location, url: url);
    await instance.getTime();
    await prefs.setString("location", location);
    await prefs.setString("url", url);
    SmartDialog.dismiss();
    Navigator.pop(context, {
      "location": instance.location,
      "time": instance.time,
      "isDayTime": instance.isDayTime,
      "allLocations": locations,
    });
  }
}