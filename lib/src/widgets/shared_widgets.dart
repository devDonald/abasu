import 'package:flutter/material.dart';

Widget noDataFound() {
  return Center(
    child: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.find_in_page, color: Colors.black38, size: 80.0),
          Text("No Products available yet",
              style: TextStyle(color: Colors.black45, fontSize: 20.0)),
          Text("Please check back later",
              style: TextStyle(color: Colors.red, fontSize: 14.0))
        ],
      ),
    ),
  );
}
