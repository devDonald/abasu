import 'dart:io';

import 'package:abasu/landing.dart';
import 'package:abasu/src/manpower/all_manpower.dart';
import 'package:abasu/src/screens/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Manpower extends StatefulWidget {
  @override
  _ManpowerState createState() => _ManpowerState();
}

class _ManpowerState extends State<Manpower> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[50],
      body: StreamBuilder<QuerySnapshot>(
          stream: manpowerRef.orderBy('item', descending: false).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: (Platform.isIOS)
                    ? CupertinoActivityIndicator()
                    : CircularProgressIndicator(),
              );
            return ListView.builder(
              itemCount: snapshot.data.size,
              itemBuilder: (BuildContext context, int index) {
                DocumentSnapshot snap = snapshot.data.docs[index];
                return ItemsCard(
                  item: snap['item'],
                  icon: Icons.group_work,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AllManpower(category: snap['item']),
                        ));
                  },
                );
              },
            );
          }),
    );
  }
}
