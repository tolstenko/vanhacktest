import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Punch.dart';
import 'User.dart';
import 'Location.dart';
import 'TimeSeriesAnalyser.dart';

class UserCards extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16.0),
        child: new FutureBuilder(
            future: fetchData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!=null) {
                  return new Column (
                    children: <Widget>[
                      new Expanded(
                          child: new ListView(
                            children: _getData(snapshot),
                          ))
                    ],
                  );
                } else {
                  return new CircularProgressIndicator();
                }
              }
            }
        )
    );

  }

  List<Widget> _getData(AsyncSnapshot snapshot) {
    List<Widget> cards = List<Widget>();

    List<UserTimer> data = snapshot.data;

    Iterator it = data.iterator;
    while(it.moveNext()) {
      UserTimer user =  it.current;

      
    }

    return cards;

    //turn the snapshot to a list of widget as you like...

  }
}

List<UserTimer> timers;

Future<List<UserTimer>> fetchData() async {
  print("fetching locations");
  await fetchLocations();
  print("fetching users");
  await fetchUsers();
  print("fetching times");
  await fetchTimePunches();

  timers = List<UserTimer>();

  // for each location
  Iterator locit = my_locusers.data.keys.iterator;
  while(locit.moveNext()) {
    var loc = locit.current;
    var locusers = my_locusers.data[loc];

    // foreach user
    Iterator usrit = locusers.data.keys.iterator;
    while(usrit.moveNext()) {
      var userid = usrit.current;
      var usr = locusers.data[userid];

      UserTimer pocessedUser = UserTimer();
      pocessedUser.process(usr, my_timePunches, my_locations.data[loc]);

      timers.add(pocessedUser);
    }
  }
  print("Done");
  return timers;
}
