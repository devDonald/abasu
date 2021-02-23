import 'package:abasu/landing.dart';
import 'package:abasu/src/models/constants.dart';
import 'package:abasu/src/screens/card.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class ProductReviews extends StatefulWidget {
  final String productId;
  final String productName, photo;
  ProductReviews({Key key, this.productId, this.productName, this.photo})
      : super(key: key);

  @override
  _ProductReviewsState createState() => _ProductReviewsState();
}

class _ProductReviewsState extends State<ProductReviews> {
  String senderName, senderPhoto, senderId;

  void fetchUser() async {
    try {
      User _currentUser = FirebaseAuth.instance.currentUser;
      String authid = _currentUser.uid;

      usersRef.doc(authid).get().then((ds) {
        if (ds.exists) {
          if (mounted) {
            setState(() {
              senderName = ds.data()['fullName'];
              senderPhoto = ds.data()['imageUrl'];
              senderId = ds.data()['userId'];
            });
          }
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('${widget.productName}\'s Reviews',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: -5.0,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.5,
          bottom: 10.0,
        ),
        padding: EdgeInsets.only(
          left: 10.5,
          right: 23.5,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.grey, offset: Offset(0.0, 2.5)),
          ],
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                margin: EdgeInsets.only(
                  top: 10.5,
                  bottom: 10.0,
                ),
                padding: EdgeInsets.only(
                  left: 2,
                  right: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, offset: Offset(0.0, 2.5)),
                  ],
                ),
                width: double.infinity,
                child: StreamBuilder<QuerySnapshot>(
                    stream: productRef
                        .doc(widget.productId)
                        .collection('reviews')
                        .orderBy('timestamp', descending: false)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text("Loading...");
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading...");
                      }
                      return StickyGroupedListView<dynamic, String>(
                        floatingHeader: true,
                        scrollDirection: Axis.vertical,
                        stickyHeaderBackgroundColor: Colors.grey,
                        physics: BouncingScrollPhysics(),
                        elements: snapshot.data.docs,
                        groupBy: (element) => element['date'],
                        itemScrollController: GroupedItemScrollController(),
                        order: StickyGroupedListOrder.DESC,
                        reverse: false,
                        groupSeparatorBuilder: (dynamic element) => Container(
                          height: 50,
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  element['date'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        itemBuilder: (c, element) {
                          return BirthdayMessageBox(
                            messageContent: element['review'],
                            timeOfMessage: element['time'],
                            senderName: element['senderName'],
                            senderPhoto: element['senderPhoto'],
                          );
                        },
                      );
                    }),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.comment,
          color: Colors.white,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return CommentDialog(
                  senderPhoto: senderPhoto,
                  senderName: senderName,
                  senderId: senderId,
                  productId: widget.productId,
                  photo: widget.photo,
                  productName: widget.productName,
                );
              });
        },
      ),
    );
  }
}

class BirthdayMessageBox extends StatelessWidget {
  BirthdayMessageBox({
    Key key,
    this.senderName,
    this.senderPhoto,
    this.messageContent,
    this.timeOfMessage,
  }) : super(key: key);
  final String senderName, senderPhoto, timeOfMessage, messageContent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 70.5,
        left: 13.9,
        top: 10.0,
        bottom: 10.5,
      ),
      padding: EdgeInsets.only(
        right: 11.5,
        left: 19.6,
        top: 5.5,
        bottom: 5.5,
      ),
      decoration: BoxDecoration(
        color: Colors.white, //for now
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(0.0),
          topRight: Radius.circular(10.0),
          bottomRight: Radius.circular(10.0),
          bottomLeft: Radius.circular(10.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 7.5,
            offset: Offset(0.0, 2.5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  ProfilePicture(
                    image: CachedNetworkImageProvider(
                      '$senderPhoto',
                    ),
                    width: 30.0,
                    height: 29.5,
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    '$senderName',
                    style: TextStyle(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    '$timeOfMessage',
                    style: TextStyle(
                      fontSize: 9.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.0),
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '$messageContent',
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

class CommentDialog extends StatefulWidget {
  final String productName, productId, senderName, senderPhoto, senderId, photo;

  const CommentDialog({
    Key key,
    this.productName,
    this.productId,
    this.senderName,
    this.senderPhoto,
    this.senderId,
    this.photo,
  }) : super(key: key);

  @override
  _CommentDialogState createState() => _CommentDialogState();
}

class _CommentDialogState extends State<CommentDialog> {
  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: ListView(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Text(
                widget.productName,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              Card(
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _message,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Type a review',
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'message cannot be empty';
                    }
                    return null;
                  },
                ),
              ),
              PrimaryButton(
                  height: 45.0,
                  width: double.infinity,
                  color: Colors.lightGreen,
                  buttonTitle: 'Send',
                  blurRadius: 7.0,
                  roundedEdge: 2.5,
                  onTap: () async {
                    if (_message.text != '') {
                      final DateTime now = DateTime.now();
                      final DateFormat formatter = DateFormat('yyyy-MM-dd');
                      final String formatted = formatter.format(now);
                      DocumentReference _docRef = await productRef
                          .doc(widget.productId)
                          .collection('reviews')
                          .doc();
                      _docRef.set({
                        'senderId': widget.senderId,
                        'review': _message.text,
                        'productId': widget.productId,
                        'senderPhoto': widget.senderPhoto,
                        'senderName': widget.senderName,
                        'type': 'reviews',
                        'date': formatted,
                        'timestamp': timestamp,
                        'time':
                            "${new DateFormat.jm().format(new DateTime.now())}",
                      }).then((value) async {
                        if (widget.senderId != widget.productId) {
                          await adminFeed.doc(_docRef.id).set({
                            'senderId': widget.senderId,
                            'senderName': widget.senderName,
                            'review': _message.text,
                            'type': 'review',
                            'seen': false,
                            'timestamp': timestamp,
                            'receiverId': widget.productId,
                            'productName': widget.productName
                          });
                          Navigator.pop(context);
                        }
                        Fluttertoast.showToast(
                            msg: "review Sent",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      });
                    }
                  }),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: CachedNetworkImage(
                  imageUrl: widget.photo,
                )),
          ),
        ),
      ],
    );
  }
}
