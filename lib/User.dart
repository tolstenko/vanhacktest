import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

LocationUsers my_locusers;

class User {
  bool active;
  String created;
  String email;
  String firstName;
  double hourlyWage;
  int id;
  String lastName;
  int locationId;
  String modified;
  String photo;
  int userType;

  User({this.active, this.created, this.email, this.firstName, this.hourlyWage, this.id, this.lastName, this.locationId, this.modified, this.photo, this.userType});

  factory User.fromJson(Map<String, dynamic> json) {
    User returndata = User();

    returndata.active = json["active"] == true ? true : false;
    returndata.created = json["created"];
    returndata.email = json["email"];
    returndata.firstName = json["firstName"];
    returndata.hourlyWage = json["hourlyWage"];
    returndata.id = json["id"];
    returndata.lastName = json["lastName"];
    returndata.locationId = json["locationId"];
    returndata.modified = json["modified"];
    returndata.photo = json["photo"];
    returndata.userType = json["userType"];

    return returndata;
  }
}

class UserMap {
  Map<String,User> data;

  UserMap({this.data});

  factory UserMap.fromJson(Map<String, dynamic> json) {
    UserMap returndata = UserMap();
    returndata.data = Map<String,User>();

    Iterator it = json.keys.iterator;
    while(it.moveNext()) {
      returndata.data[it.current] = User.fromJson(json[it.current]);
    }

    return returndata;
  }
}

class LocationUsers {
  Map<String,UserMap> data;

  LocationUsers({this.data});

  factory LocationUsers.fromJson(Map<String, dynamic> json) {
    LocationUsers returndata = LocationUsers();
    returndata.data = Map<String,UserMap>();

    Iterator it = json.keys.iterator;
    while(it.moveNext()) {
      returndata.data[it.current] = UserMap.fromJson(json[it.current]);
    }

    return returndata;
  }
}

Future<LocationUsers> fetchUsers() async {
  final response = await http.get('https://shiftstestapi.firebaseio.com/users.json');
  final responseJson = json.decode(response.body);

  my_locusers = LocationUsers.fromJson(responseJson);
  return my_locusers;
}