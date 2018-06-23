import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

TimePunches my_timePunches;

class TimePunch {
  DateTime clockedIn;
  DateTime clockedOut;
  DateTime created;
  double hourlyWage;
  int id;
  int locationId;
  DateTime modified;
  int userId;

  TimePunch({this.clockedIn, this.clockedOut, this.created, this.hourlyWage, this.id, this.locationId, this.modified, this.userId});

  factory TimePunch.fromJson(Map<String, dynamic> json) {
    TimePunch returndata = TimePunch();

    returndata.clockedIn = DateTime.parse(json["clockedIn"]);
    returndata.clockedOut = DateTime.parse(json["clockedOut"]);
    returndata.created = DateTime.parse(json["created"]);
    returndata.hourlyWage = json["hourlyWage"];
    returndata.id = json["id"];
    returndata.locationId = json["locationId"];
    returndata.modified = DateTime.parse(json["modified"]);
    returndata.userId = json["userId"];

    return returndata;
  }
}

class TimePunches{
  Map<String, TimePunch> data;

  TimePunches({this.data});

  factory TimePunches.fromJson(Map<String, dynamic> json) {
    TimePunches returndata = TimePunches();
    returndata.data = Map<String,TimePunch>();

    Iterator it = json.keys.iterator;
    while(it.moveNext()) {
      returndata.data[it.current] = TimePunch.fromJson(json[it.current]);
    }

    return returndata;
  }
}

Future<TimePunches> fetchTimePunches() async {
  final response = await http.get('https://shiftstestapi.firebaseio.com/timePunches.json');
  final responseJson = json.decode(response.body);
  my_timePunches = TimePunches.fromJson(responseJson);
  return my_timePunches;
}
