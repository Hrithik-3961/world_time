import 'dart:convert';
import 'package:http/http.dart';

class Locations
{
  List locations = [];
  Future<void> getLocations() async
  {
    try
    {
      Response response = await get(Uri.https("worldtimeapi.org", "/api/timezones"));
      locations = jsonDecode(response.body);
    }
    catch(e)
    {
      print("Error occurred: $e");
    }
  }
}