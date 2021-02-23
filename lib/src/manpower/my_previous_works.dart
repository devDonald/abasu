import 'package:abasu/landing.dart';
import 'package:abasu/src/manpower/add_previous_works.dart';
import 'package:abasu/src/screens/view_attached_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyPreviousWorks extends StatefulWidget {
  final String userId;
  MyPreviousWorks({Key key, this.userId}) : super(key: key);

  @override
  _MyPreviousWorksState createState() => _MyPreviousWorksState();
}

class _MyPreviousWorksState extends State<MyPreviousWorks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('My Previous Work',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: -5.0,
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: root
                .collection('users')
                .doc(widget.userId)
                .collection('previousWorks')
                .orderBy('timestamp', descending: false)
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
              return GridView.builder(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  primary: false,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 5,
                      childAspectRatio: 3 / 4,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    DocumentSnapshot snap = snapshot.data.docs[index];

                    return EventList(
                      imageId: snap['postId'],
                      image: snap['imageUrl'],
                      onDeleteTap: () {
                        // showDeleteDialog(context, snap['postId']);
                      },
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewAttachedImage(
                                      image: CachedNetworkImageProvider(
                                          snap['imageUrl']),
                                      text: 'Previous Work',
                                      postId: snap['postId'],
                                    )));
                      },
                    );
                  });
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPreviousWorks(),
                ));
          });
        },
      ),
    );
  }
}

class EventList extends StatelessWidget {
  EventList({
    Key key,
    this.image,
    this.onDeleteTap,
    this.imageId,
    this.onTap,
  }) : super(key: key);
  String image, imageId;
  Function onDeleteTap, onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.3,
            margin: EdgeInsets.only(bottom: 5.0, left: 7.0, right: 7.0),
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

            child: GestureDetector(
              onTap: onTap,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.3,
                        imageUrl: image,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// showDeleteDialog(BuildContext context, String eventId) {
//   // set up the buttons
//   Widget cancelButton = FlatButton(
//     child: Text("yes"),
//     onPressed: () async {
//       await root.collection('events').doc(eventId).get().then((doc) {
//         if (doc.exists) {
//           doc.reference.delete();
//         }
//       }).then((value) async {
//         Fluttertoast.showToast(
//             msg: "Event removed",
//             toastLength: Toast.LENGTH_SHORT,
//             gravity: ToastGravity.CENTER,
//             timeInSecForIosWeb: 1,
//             backgroundColor: Colors.green,
//             textColor: Colors.white,
//             fontSize: 16.0);
//         Navigator.pop(context);
//       });
//     },
//   );
//   Widget continueButton = FlatButton(
//     child: Text("No"),
//     onPressed: () {
//       Navigator.pop(context);
//     },
//   );
//
//   // set up the AlertDialog
//   AlertDialog alert = AlertDialog(
//     title: Text("Delete Event"),
//     content: Text("Would you like to remove this Event?"),
//     actions: [
//       cancelButton,
//       continueButton,
//     ],
//   );
//
//   // show the dialog
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return alert;
//     },
//   );
// }
