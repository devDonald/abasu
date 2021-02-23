import 'package:abasu/src/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../landing.dart';

class OrderDetails extends StatelessWidget {
  const OrderDetails({
    Key key,
    this.ownerName,
    this.orderTitle,
    this.deliveryAddress,
    this.driverId,
    this.isEnroute,
    this.driverName,
    this.ownerId,
    this.price,
    this.requestDate,
    this.status,
    this.orderId,
    this.phone,
    this.distance,
    this.driverAccepted,
    this.withDelivery,
  }) : super(key: key);
  final String ownerName,
      orderTitle,
      deliveryAddress,
      driverId,
      ownerId,
      price,
      orderId,
      phone,
      requestDate,
      status,
      distance,
      driverName;
  final bool isEnroute, driverAccepted, withDelivery;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Order Details'),
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
              'Delivery Tag',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              orderTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Delivery Address',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              deliveryAddress,
              maxLines: 10,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Price',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              '$naira $price',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Total Distance',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              distance ?? "No Delivery",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Project Owner',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              ownerName,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Assigned Driver',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              driverName ?? 'non assigned',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 15.0),
            Text(
              'Driver Phone No',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              phone ?? 'not available',
              style: TextStyle(
                color: Colors.black,
                fontSize: 15.0,
              ),
            ),
            SizedBox(height: 8.0),
            Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivery Status',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
              buttonText: 'Set Delivery Successful Status',
              buttonType: driverAccepted == true
                  ? ButtonType.DarkGreen
                  : ButtonType.Disabled,
              onPressed: () {
                showCompleteDialog(context, orderId);
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
        await ordersRef.doc(requestId).update({
          "isDelivered": true,
          "status": "Order Delivery Successful"
        }).then((value) async {
          await adminFeed.doc().set({
            'seen': false,
            'ownerName': ownerName,
            'ownerId': ownerId,
            'title': orderTitle,
            'artisanId': driverId,
            'artisanName': driverName,
            'type': 'order',
            'sub': 'orderSuccessful',
            'timestamp': timestamp,
          });
          await activityFeedRef.doc(driverId).collection('requests').doc().set({
            'seen': false,
            'ownerName': ownerName,
            'ownerId': ownerId,
            'title': orderTitle,
            'artisanId': driverId,
            'artisanName': driverName,
            'type': 'order',
            'sub': 'orderSuccessful',
            'timestamp': timestamp,
          });
          Fluttertoast.showToast(
              msg: "Order Delivered status set",
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
      title: Text("Update Delivery Successful Status"),
      content: Text("Would you like to set this order as Delivered?"),
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
