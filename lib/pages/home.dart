import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Map data = {};

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    String bgImage = data["isDayTime"] ? "day.jpg" : "night.jpg";
    Color color = data["isDayTime"] ? Colors.blue[100] : Color(0xFF044B6B);

    return Scaffold(
      backgroundColor: color,
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/$bgImage"),
              fit: BoxFit.cover,
            )
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 120, 0, 0),
            child: Column(
              children: [
                TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/location');
                    },
                    icon: Icon(Icons.add_location, color: Colors.white,),
                    label: Text("Edit Location", style: TextStyle(color: Colors.white,)),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data["location"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      letterSpacing: 2.0,
                    ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Text(data["time"],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: data["time"] == "could not get time" ? 35.0 : 65.0,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
