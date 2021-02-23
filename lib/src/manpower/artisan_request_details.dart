import 'package:abasu/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../landing.dart';

class ArtisanRequestDetails extends StatelessWidget {
  const ArtisanRequestDetails({
    Key key,
    this.ownerName,
    this.projectTitle,
    this.projectDescription,
    this.location,
    this.artisanId,
    this.isComplete,
    this.hasAgreed,
    this.artisanName,
    this.projectId,
    this.ownerId,
    this.startDate,
    this.requestDate,
    this.isApproved,
    this.inDays,
    this.status,
  }) : super(key: key);
  final String ownerName,
      projectTitle,
      projectDescription,
      location,
      artisanId,
      projectId,
      ownerId,
      startDate,
      requestDate,
      status,
      artisanName;
  final int inDays;
  final bool isComplete, hasAgreed, isApproved;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: EdgeInsets.all(9),
        margin: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: 15,
        ),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              offset: Offset(
                0.0,
                4.0,
              ),
              color: Colors.black12,
            )
          ],
        ),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          primary: false,
          children: [
            Text(
              'Project Title',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              projectTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Description',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              projectDescription,
              maxLines: 10,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Location',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              location,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Start Date',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              startDate,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Owner',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              ownerName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Requested Artisan',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              artisanName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Project Status',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    status,
                    style: TextStyle(
                      color: Colors.white,
                      backgroundColor: Colors.lightBlueAccent,
                      fontSize: 20.0,
                    ),
                  )
                ]),
            SizedBox(height: 15.0),
            AppButton(
              buttonText: 'Delete Request',
              buttonType: hasAgreed == false && inDays >= 1
                  ? ButtonType.DarkGreen
                  : ButtonType.Disabled,
              onPressed: () async {
                showDeleteDialog(context, projectId);
              },
            ),
            AppButton(
              buttonText: 'Set Project Complete Status',
              buttonType: isApproved == true
                  ? ButtonType.DarkGreen
                  : ButtonType.Disabled,
              onPressed: () {
                showCompleteDialog(context, projectId);
              },
            ),
          ],
        ),
      ),
    );
  }

  showCompleteDialog(BuildContext context, String requestId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("yes"),
      onPressed: () async {
        await artisanRequests
            .doc(requestId)
            .update({"isComplete": true, "status": "Project Completed"}).then(
                (value) async {
          await adminFeed.doc().set({
            'seen': false,
            'ownerName': ownerName,
            'ownerId': ownerId,
            'title': projectTitle,
            'artisanId': artisanId,
            'artisanName': artisanName,
            'type': 'request',
            'sub': 'projectComplete',
            'timestamp': timestamp,
          });
          await activityFeedRef
              .doc(artisanId)
              .collection('requests')
              .doc()
              .set({
            'seen': false,
            'ownerName': ownerName,
            'ownerId': ownerId,
            'title': projectTitle,
            'sub': 'completed',
            'artisanId': artisanId,
            'artisanName': artisanName,
            'type': 'request',
            'timestamp': timestamp,
          });
          Fluttertoast.showToast(
              msg: "project complete status set",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Update Project Complete Status"),
      content: Text("Would you like to set this project as Completed?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeleteDialog(BuildContext context, String requestId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("yes"),
      onPressed: () async {
        await artisanRequests.doc(requestId).get().then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        }).then((value) async {
          Fluttertoast.showToast(
              msg: "Request Deleted",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Artisan Request"),
      content: Text("Would you like to remove this Request?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
