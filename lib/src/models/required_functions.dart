import 'package:flutter/material.dart';

class RequiredFunctions{

  int getLikeCount(likes) {
    // if no likes, return 0
    if (likes == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }
  int getViews(views) {
    // if no likes, return 0
    if (views == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    views.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  int getCommentCount(comments) {
    // if no likes, return 0
    if (comments == null) {
      return 0;
    }
    int count = 0;
    // if the key is explicitly set to true, add a like
    comments.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  String getCount(int count){
    String _stPosts = "0";
    double _dbPosts=0.0;

    if(count<1000){
      _stPosts = count.toString()+" ";

    } else if(count>=1000 && count<1000000){
      _dbPosts=count/1000;
      _stPosts = _dbPosts.toStringAsFixed(1)+"K";

    } else if (count>=1000000 && count<1000000000){
      _dbPosts=count/1000000;
      _stPosts = _dbPosts.toStringAsFixed(1)+"M";

    } else{
      _dbPosts= count/1000000000;
      _stPosts = _dbPosts.toStringAsFixed(1)+"B";

    }
    return _stPosts;
  }

  Map<int, String> splitString (String tags){
    final split = tags.split(',');
    final Map<int, String> values = {
      for (int i = 0; i < split.length; i++)
        i: split[i]
    };

    return values;
    // final value1 = values[0];
    // final value2 = values[1];
    // final value3 = values[2];
  }
  TimeOfDay timeConvert(String normTime) {
    int hour;
    int minute;
    String ampm = normTime.substring(normTime.length - 2);
    String result = normTime.substring(0, normTime.indexOf(' '));
    if (ampm == 'AM' && int.parse(result.split(":")[1]) != 12) {
      hour = int.parse(result.split(':')[0]);
      if (hour == 12) hour = 0;
      minute = int.parse(result.split(":")[1]);
    } else {
      hour = int.parse(result.split(':')[0]) - 12;
      if (hour <= 0) {
        hour = 24 + hour;
      }
      minute = int.parse(result.split(":")[1]);
    }
    return TimeOfDay(hour: hour, minute: minute);
  }
}