import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Punch.dart';
import 'User.dart';
import 'Location.dart';


// the search of times could be improved using a map form userid to list of time entries;
// or we could invert the process iterating over the time and creating users or everything needed, but it is more complex.

class UserTimer {
  User user;

  // monthly map of total work in a month. key is month, value is time
  Map<int,int> regularTime;

  // overtime per month. key is month, value is time
  Map<int,int> daylyOverTime;

  UserTimer({this.user,this.regularTime,this.daylyOverTime});

  void process(User user, TimePunches times, Location loc) {
    this.regularTime = Map<int,int>();
    this.daylyOverTime = Map<int,int>();
    this.user = user;

    Iterator it = times.data.keys.iterator;
    while(it.moveNext()) {
      var punch = times.data[it.current];
      if(punch.userId == user.id){
        // check for  month entry
        if(!this.daylyOverTime.containsKey(punch.clockedIn.month))
          this.daylyOverTime[punch.clockedIn.month] = 0;
        if(!this.regularTime.containsKey(punch.clockedIn.month))
          this.regularTime[punch.clockedIn.month] = 0;

        // calculate
        var workedMins = punch.clockedOut.difference(punch.clockedIn).inMinutes;
        if(workedMins > loc.labourSettings.dailyOvertimeThreshold)
        {
          this.daylyOverTime[punch.clockedIn.month] = this.daylyOverTime[punch.clockedIn.month] + workedMins - loc.labourSettings.dailyOvertimeThreshold;
          this.regularTime[punch.clockedIn.month] = this.regularTime[punch.clockedIn.month] + loc.labourSettings.dailyOvertimeThreshold;
        }
        else
          this.regularTime[punch.clockedIn.month] += workedMins;
      }
    }
  }
}



