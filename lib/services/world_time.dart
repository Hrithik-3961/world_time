import 'dart:convert';
import 'package:http/http.dart';
import 'package:intl/intl.dart';

class WorldTime
{
  String location;
  String time;
  String url;
  bool isDayTime;

  WorldTime({this.location, this.url});

  Future<void> getTime() async
  {
    try {
      Response response = await get(Uri.https("worldtimeapi.org", "/api/timezone/$url"));
      Map data = jsonDecode(response.body);
      DateTime dateTime = DateTime.parse(data["datetime"]);
      String offset = data["utc_offset"];
      dateTime = dateTime.add(Duration(hours: int.parse(offset.substring(1, 3))));
      dateTime = dateTime.add(Duration(minutes: int.parse(offset.substring(4))));
      time = DateFormat.jm().format(dateTime);
      isDayTime = dateTime.hour > 6 && dateTime.hour < 18 ? true : false;
    } catch (e) {
      time = "Could not get time";
    }
  }
}