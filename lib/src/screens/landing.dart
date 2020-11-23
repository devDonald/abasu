import 'package:abasu/bottom_navigation/about_us.dart';
import 'package:abasu/bottom_navigation/home.dart';
import 'package:abasu/bottom_navigation/user_profile.dart';
import 'package:abasu/src/blocs/customer_bloc.dart';
import 'package:abasu/src/models/market.dart';
import 'package:abasu/src/styles/base.dart';
import 'package:abasu/src/styles/colors.dart';
import 'package:abasu/src/styles/text.dart';
import 'package:abasu/src/widgets/list_tile.dart';
import 'package:abasu/src/widgets/sliver_scaffold.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import 'card.dart';

class Landing extends StatefulWidget {

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  int _selectedTabIndex = 0;

  List<Widget> _widgets = [
    Home(),
    AboutUs(),
    UserProfile()
  ];

  _changeIndex(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets[_selectedTabIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onTap: _changeIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home, color: Colors.red,), title: Text("Home")),
          BottomNavigationBarItem(
              icon: Icon(Icons.info,color: Colors.red), title: Text("About Us")),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle,color: Colors.red), title: Text("My Account")),
        ],
      ),
    );
  }

}