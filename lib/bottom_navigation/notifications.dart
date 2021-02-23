import 'package:abasu/landing.dart';
import 'package:abasu/main.dart';
import 'package:abasu/src/screens/card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationCenter extends StatefulWidget {
  static const String id = 'NotificationCenter';
  NotificationCenter({Key key}) : super(key: key);

  @override
  _NotificationCenterState createState() => _NotificationCenterState();
}

class _NotificationCenterState extends State<NotificationCenter> {
  String activityItemText;
  String type; // 'like', 'follow', 'comment'
  String mediaUrl;
  String request = 'requested', approved = 'approved';

  String timestamp, time;
  String _currentUserId, receiverId, groupId, _name, _photo;
  dynamic likes;
  dynamic comments;
  dynamic views;

  String postLikes1, videoUrl, caption;

  void updateNotificationCount() async {
    User _currentUser = FirebaseAuth.instance.currentUser;
    String authid = _currentUser.uid;
    var snapshots =
        activityFeedRef.doc(authid).collection('requests').snapshots();
    try {
      await snapshots.forEach((snapshot) async {
        List<DocumentSnapshot> documents = snapshot.docs;

        for (var document in documents) {
          await document.reference.update(<String, dynamic>{
            'seen': true,
          });
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }
  //
  // void toBirthday() {
  //   setState(() {
  //     // Navigator.pushNamed(context, '/videoScreen');
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => BirthdayComments(
  //             userId: _currentUserId,
  //             name: _name,
  //             photo: _photo,
  //           ),
  //         ));
  //   });
  // }
  //
  // void toGroup(
  //   String groupId,
  //   String groupName,
  // ) {
  //   setState(() {
  //     // Navigator.pushNamed(context, '/videoScreen');
  //     Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => GroupChat(
  //             groupId: groupId,
  //             groupName: groupName,
  //           ),
  //         ));
  //   });
  // }

  // void _fetchUserData() async {
  //   try {
  //     User _currentUser = await FirebaseAuth.instance.currentUser;
  //     String authid = _currentUser.uid;
  //     root.collection('users').doc(authid).get().then((ds) {
  //       if (ds.exists) {
  //         setState(() {
  //           _currentUserId = ds.data()['userId'];
  //           _name = ds.data()['name'];
  //           _photo = ds.data()['photo'];
  //         });
  //       }
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    updateNotificationCount();
    // _fetchUserData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('Notifications',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: -5.0,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: activityFeedRef
                .doc(authId.userId)
                .collection('requests')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Text("Loading..."),
                );
              } else if (!snapshot.hasData) {
                return Center(
                  child: Text("Loading..."),
                );
              }
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot snap = snapshot.data.docs[index];
                  type = snap['sub'];
                  timestamp = '${snap['timestamp']}';

                  if (type == "driverAccepted") {
                    activityItemText =
                        "Hello User, Driver Accepted your Order assigned to him";
                  } else if (type == "artisanAccepted") {
                    activityItemText =
                        "Hello User, Artisan Accepted his Project Request";
                  } else if (type == "driverAssigned") {
                    activityItemText =
                        "Hello User, Admin assigned a Driver to your Order";
                  } else if (type == "requested") {
                    activityItemText =
                        "Hello Artisan, a User Requested your service. go to your profile and accept the request";
                  } else if (type == "projectInProgress") {
                    activityItemText =
                        "Hello User, Artisan Marked Project as in Progress";
                  }

                  return GestureDetector(
                    onTap: () {},
                    child: DisplayNotification(
                      time: '${getChatTime('${snap['timestamp']}'.toString())}',
                      body: activityItemText,
                    ),
                  );
                },
              );
            }),
      ),
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

class DisplayNotification extends StatelessWidget {
  final String body, time;
  final Function onTap;

  const DisplayNotification({Key key, this.body, this.time, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: screenSize.width,
        height: 60.0,
        margin: EdgeInsets.only(top: 2.5, bottom: 2.0, left: 7.0, right: 7.0),
        //padding: EdgeInsets.only(left: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0.0, 2.5),
              blurRadius: 10.5,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              child: ProfilePicture(
                image: AssetImage(
                  'assets/images/notification.png',
                ),
                height: 40.0,
                width: 40.0,
              ),
            ),
            SizedBox(
              width: 6,
              height: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    body,
                    style: TextStyle(),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 4,
                    softWrap: false,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      time,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
