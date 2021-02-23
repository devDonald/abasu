import 'dart:io';

import 'package:abasu/landing.dart';
import 'package:abasu/location/calculate_destination_map.dart';
import 'package:abasu/main.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BuyProduct extends StatefulWidget {
  final int amount;
  final String productName;
  final int productQuantity;

  const BuyProduct(
      {Key key, this.amount, this.productName, this.productQuantity})
      : super(key: key);

  @override
  _BuyProductState createState() => _BuyProductState();
}

// Pay public key
class _BuyProductState extends State<BuyProduct> {
  final _fullNmame = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  bool checkedValue = false;

  double lat, long;

  @override
  void initState() {
    PaystackPlugin.initialize(
        publicKey: "pk_test_24d274e8118113d38f28ad822cc54ad5c02c0875");
    super.initState();
  }

  Dialog successDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              Text("processed.", style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
    );
  }

  void _showDialog() {
    // flutter defined function

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return successDialog(context);
      },
    );
  }

  showCompleteDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = FlatButton(
      child: Text("Okay"),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Transaction Successful"),
      content: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.check_box,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Payment has successfully',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'been made',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Your payment has been successfully",
                style: TextStyle(fontSize: 13),
              ),
              Text("processed.", style: TextStyle(fontSize: 13)),
            ],
          ),
        ),
      ),
      actions: [
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

  Dialog errorDialog(context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0)), //this right here
      child: Container(
        height: 350.0,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.cancel,
                color: Colors.red,
                size: 90,
              ),
              SizedBox(height: 15),
              Text(
                'Failed to process payment',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              Text(
                "Error in processing payment, please try again",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return errorDialog(context);
      },
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  chargeCard(int amount, String email, bool withDelivery) async {
    Charge charge = Charge()
      ..amount = amount * 100
      ..reference = _getReference()
      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = email;
    CheckoutResponse response = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    if (response.status == true) {
      DocumentReference _docRef = ordersRef.doc();
      await _docRef.set({
        'ownerId': authId.userId,
        'ownerName': _fullNmame.text,
        'orderId': _docRef.id,
        'ownerPhone': _phone.text,
        'driverPhone': '',
        'deliveryAddress': _address.text,
        'deliveryLatitude': orderDestination.destinationLatitude ?? 0.0,
        'deliveryLongitude': orderDestination.destinationLongitude ?? 0.0,
        'driverId': '',
        'driverName': '',
        "adminApproved": false,
        'withDelivery': withDelivery,
        'distance': orderDestination.distance,
        'timestamp': timestamp,
        'price': amount,
        'status': 'Processing',
        'driverAccepted': false,
        'isDelivered': false,
        'isEnroute': false,
        'orderTitle': "${widget.productQuantity} ${widget.productName}",
      }).then((value) async {
        await adminFeed.doc().set({
          'seen': false,
          'ownerName': _fullNmame.text,
          'ownerId': authId.userId,
          'title': "${widget.productQuantity} ${widget.productName}",
          'type': 'order',
          'sub': 'newOrder',
          'timestamp': timestamp,
        });
      });
      showCompleteDialog(context);
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Confirm Charging of Card",
        ),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Card(
              elevation: 10.0,
              color: Colors.white,
              shadowColor: Colors.green,
              margin: EdgeInsets.all(5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        'Confirm Your Order Details',
                        style: TextStyle(
                            fontSize: 25,
                            decorationStyle: TextDecorationStyle.dashed,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('${widget.productQuantity}',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                decorationStyle: TextDecorationStyle.solid,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text('${widget.productName}',
                              style: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                                decorationStyle: TextDecorationStyle.solid,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text('₦${format.format(widget.amount)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 18,
                              decorationStyle: TextDecorationStyle.solid,
                              backgroundColor: Colors.green,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Full Name: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _fullNmame,
                      decoration: InputDecoration(
                        hintText: 'your answer',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Email: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: 'your answer',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Delivery Address: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _address,
                      decoration: InputDecoration(
                        hintText: 'your answer',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.streetAddress,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'home address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Phone Number: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _phone,
                      maxLength: 11,
                      decoration: InputDecoration(
                        hintText: 'your answer',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.phone,
                      textCapitalization: TextCapitalization.none,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: CheckboxListTile(
                        title: Text("Add delivery cost"),
                        value: checkedValue,
                        onChanged: (newValue) {
                          setState(() {
                            checkedValue = newValue;
                            if (checkedValue == true) {
                              orderDestination.withDelivery = true;
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CalculateDestination()));
                            } else {
                              orderDestination.withDelivery = false;
                            }
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, //  <-- leading Checkbox
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      height: 45.0,
                      width: double.infinity,
                      color: Colors.green,
                      buttonTitle: 'Charge Card',
                      blurRadius: 7.0,
                      roundedEdge: 2.5,
                      onTap: () async {
                        if (_email.text != '' &&
                            _fullNmame.text != '' &&
                            _address.text != '') {
                          if (checkedValue == true) {
                            chargeCard(widget.amount + orderDestination.price,
                                _email.text, checkedValue);
                          } else {
                            chargeCard(
                                widget.amount, _email.text, checkedValue);
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please complete all fields",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
