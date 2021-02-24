import 'package:abasu/src/manpower/view_artisan.dart';
import 'package:abasu/src/models/all_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../landing.dart';

class AllManpower extends StatefulWidget {
  final String category;

  const AllManpower({Key key, this.category}) : super(key: key);

  @override
  _AllManpowerState createState() => _AllManpowerState();
}

class _AllManpowerState extends State<AllManpower> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: root
              .collection('users')
              .where('asArtisan', isEqualTo: true)
              .where('skill', isEqualTo: widget.category)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: noDataFound(),
              );
            } else if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.size,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot snap = snapshot.data.docs[index];

                  return ArtisanCard(
                    fullName: snap['fullName'],
                    image: snap['imageUrl'],
                    gender: snap['gender'],
                    experience: '${snap['experience']} Year(s) Experience',
                    specialty: snap['skill'],
                    location: '${snap['address']} ${snap['city']}',
                    isVerified: snap['isVerified'],
                    charge: '₦${format.format(snap['charge'])} per day',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewArtisanProfile(
                                    fullName: snap['fullName'],
                                    image: snap['imageUrl'],
                                    gender: snap['gender'],
                                    experience:
                                        '${snap['experience']} Year(s) Experience',
                                    specialty: snap['skill'],
                                    location:
                                        '${snap['address']} ${snap['city']}',
                                    isVerified: snap['isVerified'],
                                    isHired: snap['isHired'],
                                    hasWorks: snap['hasWorks'],
                                    userId: snap['userId'],
                                    charge: snap['charge'],
                                  )));
                    },
                  );
                },
              );
            } else {
              return Text('loading');
            }
          }),
    );
  }

  Widget noDataFound() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.find_in_page, color: Colors.black38, size: 80.0),
            Text("No Artisans within this category yet",
                style: TextStyle(color: Colors.black45, fontSize: 20.0)),
            Text("Please check back later",
                style: TextStyle(color: Colors.red, fontSize: 14.0))
          ],
        ),
      ),
    );
  }
}
