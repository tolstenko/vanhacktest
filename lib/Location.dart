import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

Locations my_locations;

class AutoBreakRules {
  int breakLength;
  int threshold;
}

class LabourSettings {
  bool autoBreak;
  List<AutoBreakRules> autoBreakRules;
  double dailyOvertimeMultiplier;
  int dailyOvertimeThreshold;
  bool overtime;
  double weeklyOvertimeMultiplier;
  int weeklyOvertimeThreshold;

  LabourSettings({this.autoBreak, this.autoBreakRules, this.dailyOvertimeMultiplier, this.dailyOvertimeThreshold, this.overtime, this.weeklyOvertimeMultiplier, this.weeklyOvertimeThreshold});

  factory LabourSettings.fromJson(Map<String, dynamic> json) {
    LabourSettings returndata = LabourSettings();

    returndata.autoBreak = json["autoBreak"];
    returndata.dailyOvertimeMultiplier = json["dailyOvertimeMultiplier"];
    returndata.dailyOvertimeThreshold = json["dailyOvertimeThreshold"];
    returndata.overtime = json["overtime"];
    returndata.weeklyOvertimeMultiplier = json["weeklyOvertimeMultiplier"];
    returndata.weeklyOvertimeThreshold = json["weeklyOvertimeThreshold"];

    returndata.autoBreakRules = List<AutoBreakRules>();
    List x = json["autoBreakRules"];
    Iterator it = x.iterator;
    while(it.moveNext()){
      AutoBreakRules a = AutoBreakRules();
      a.breakLength = it.current["breakLength"];
      a.threshold = it.current["threshold"];
      returndata.autoBreakRules.add(a);
    }

    return returndata;
  }
}

class Location {
  String address;
  String city;
  String country;
  DateTime created;
  int id;
  LabourSettings labourSettings;
  double lat;
  double lng;
  DateTime modified;
  String state;
  String timezone;

  Location({this.address, this.city, this.country, this.created, this.id, this.labourSettings, this.lat, this.lng, this.modified, this.state, this.timezone});

  factory Location.fromJson(Map<String, dynamic> json) {
    Location returndata = Location();

    returndata.address = json["address"];
    returndata.city = json["city"];
    returndata.country = json["country"];
    returndata.created = DateTime.parse(json["created"]);
    returndata.id = json["id"];
    returndata.lat = json["lat"];
    returndata.lng = json["lng"];
    returndata.modified = DateTime.parse(json["modified"]);
    returndata.state = json["state"];
    returndata.timezone = json["timezone"];

    returndata.labourSettings = LabourSettings.fromJson(json["labourSettings"]);

    return returndata;
  }
}

class Locations {
  Map<String,Location> data;

  Locations({this.data});

  factory Locations.fromJson(Map<String, dynamic> json) {
    Locations loc = Locations();
    loc.data = Map<String,Location>();

    Iterator it = json.keys.iterator;
    while(it.moveNext()) {
      loc.data[it.current] = Location.fromJson(json[it.current]);
    }
    return loc;
  }
}

Future<Locations> fetchLocations() async {
  final response = await http.get('https://shiftstestapi.firebaseio.com/locations.json');
  final responseJson = json.decode(response.body);
  my_locations = Locations.fromJson(responseJson);
  return my_locations;
}

