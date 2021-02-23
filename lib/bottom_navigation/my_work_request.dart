import 'dart:io';

import 'package:abasu/bottom_navigation/my_request_details.dart';
import 'package:abasu/main.dart';
import 'package:abasu/src/models/all_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../landing.dart';

class MyWorkRequests extends StatefulWidget {
  const MyWorkRequests({
    Key key,
  }) : super(key: key);

  @override
  _MyWorkRequestsState createState() => _MyWorkRequestsState();
}

class _MyWorkRequestsState extends State<MyWorkRequests> {
  int inDays = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Work Requests'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: artisanRequests
              .where('artisanId', isEqualTo: authId.userId)
              .snapshots(),
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

                return RequestedArtisanCard(
                  title: snap['workTitle'],
                  artisanName: snap['artisanName'],
                  status: snap['status'],
                  hasAgreed: snap['hasAgreed'],
                  timestamp: getChatTime(snap['timestamp']),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyRequestDetails(
                                  ownerName: snap['ownerName'],
                                  projectTitle: snap['workTitle'],
                                  projectDescription: snap['workDescription'],
                                  location: snap['address'],
                                  isApproved: snap['isApproved'],
                                  isComplete: snap['isComplete'],
                                  ownerId: snap['ownerId'],
                                  hasAgreed: snap['hasAgreed'],
                                  requestDate: getChatTime(snap['timestamp']),
                                  startDate: snap['startDate'],
                                  status: snap['status'],
                                  inDays: inDays,
                                  projectId: snap['workId'],
                                  artisanName: snap['artisanName'],
                                  artisanId: snap['artisanId'],
                                )));
                  },
                );
              },
            );
          }),
    );
  }

  String getChatTime(String date) {
    if (date == null || date.isEmpty) {
      return '';
    }
    String msg = '';
    var dt = DateTime.parse(date).toLocal();

    if (DateTime.now().toLocal().isBefore(dt)) {
      return DateFormat.jm().format(DateTime.parse(date).toLocal()).toString();
    }

    var dur = DateTime.now().toLocal().difference(dt);
    inDays = dur.inDays;
    if (dur.inDays > 0) {
      msg = '${dur.inDays} d ago';
      return dur.inDays == 1 ? '1d ago' : DateFormat("dd MMM").format(dt);
    } else if (dur.inHours > 0) {
      msg = '${dur.inHours} h ago';
    } else if (dur.inMinutes > 0) {
      msg = '${dur.inMinutes} m ago';
    } else if (dur.inSeconds > 0) {
      msg = '${dur.inSeconds} s ago';
    } else {
      msg = 'now';
    }
    return msg;
  }
}
