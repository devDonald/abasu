import 'package:abasu/landing.dart';
import 'package:abasu/src/construction/buy_product.dart';
import 'package:abasu/src/construction/products_reviews.dart';
import 'package:abasu/src/models/required_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProductDetails extends StatefulWidget {
  final String itemName, itemId;
  final String itemImage;
  final String itemSubCategory;
  final String itemDescription;
  final int itemPrice;
  final String itemQuantity;
  final String itemType;
  final double itemRating;
  // bool isfavorited;

  ProductDetails(
      {this.itemName,
      this.itemImage,
      this.itemSubCategory,
      this.itemDescription,
      this.itemPrice,
      this.itemQuantity,
      this.itemType,
      this.itemRating,
      this.itemId});

  @override
  State<StatefulWidget> createState() {
    return _ProductDetailsState();
  }
}

class _ProductDetailsState extends State<ProductDetails> {
  int flag = 0;
  String favorite = "true";
  var response2;
  final Set<dynamic> _saved = Set<dynamic>();
  String accountName = "";
  int iquantity = 0, reviewCount = 0;
  String getQuantity;
  final quantity = TextEditingController();
  var carttCount;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool alreadySaved;
  RequiredFunctions f = RequiredFunctions();

  int length;

  Future getcommentCount() async {
    try {
      QuerySnapshot snapshot = await productRef
          .doc(widget.itemId)
          .collection('reviews')
          .orderBy('timestamp', descending: true)
          .get();
      setState(() {
        reviewCount = snapshot.docs.length;
      });
    } catch (e) {}
  }

  @override
  void initState() {
    getcommentCount();
    super.initState();
    // appMethods.getCartCount().then((result){
    //   setState(() {
    //     carttCount = result;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    alreadySaved = _saved.contains(widget.itemName);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Details'),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SingleChildScrollView(
            padding: const EdgeInsets.all(0.0),
            child: Column(children: <Widget>[
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 300.0,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(widget.itemImage),
                              fit: BoxFit.fitHeight),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(120.0),
                            bottomLeft: Radius.circular(120.0),
                          )),
                    ),
                  ],
                ),
              ),
              Card(
                child: Container(
                  width: screenSize.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(widget.itemName,
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.w700)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Text(
                          widget.itemSubCategory,
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Icon(Icons.star,
                                    color: Colors.blue, size: 20.0),
                                Text("0.0"),
                              ],
                            ),
                            SizedBox(height: 20.0),
                            Row(children: <Widget>[
                              SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "₦${format.format(widget.itemPrice)}",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0,
                                ),
                              )
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 20.0,
                        )
                      ]),
                ),
              ),
              Card(
                  child: Container(
                      width: screenSize.width,
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10.0,
                          ),
                          Text('Description',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.w700)),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(widget.itemDescription,
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              )),
                          SizedBox(
                            height: 10.0,
                          ),
                        ],
                      ))),
              Card(
                child: Container(
                  width: screenSize.width,
                  margin: EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Quantity Available',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(widget.itemQuantity),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('Category',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(widget.itemType),
                              SizedBox(height: 10.0),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text('Quantity to Purchase',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          )),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => _decrementCounter(),
                            ),
                          ),
                          Container(
                            width: 50.0,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              controller: quantity,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          CircleAvatar(
                            child: IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => _incrementCounter(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50.0,
                      )
                    ],
                  ),
                ),
              )
            ]),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        elevation: 0.0,
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        child: Container(
          height: 70.0,
          decoration: BoxDecoration(
              // color: Theme.of(context).primaryColor
              ),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProductReviews(
                        productId: widget.itemId,
                        productName: widget.itemName,
                        photo: widget.itemImage,
                      )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: (screenSize.width - 20) / 2,
                  child: Text(
                    'REVIEWS(${f.getCount(reviewCount)})',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                    width: (screenSize.width - 100) / 2,
                    child: RaisedButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("ORDER NOW"),
                      onPressed: () {
                        if (quantity.text != '') {
                          int price = widget.itemPrice;
                          int quant = int.parse(quantity.text);
                          int finalPrice = price * quant;

                          print('Final Price: $finalPrice');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => BuyProduct(
                                    productQuantity: quant,
                                    productName: widget.itemName,
                                    amount: finalPrice,
                                  )));
                        } else {
                          Fluttertoast.showToast(
                              msg: "Enter quantity to purchase",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // List<File> images;
  //   String productID  = await appMethods.userCart();
  //   List<String> imageUrl = await appMethods.uploadProductImages(
  //       docID: productID, imageList:itemImages);
  void _incrementCounter() {
    setState(() {
      //iquantity++;
      getQuantity = quantity.text;
      quantity.text = (int.parse(getQuantity) + 1).toString();
    });
  }

  void _decrementCounter() {
    setState(() {
      //iquantity--;
      getQuantity = quantity.text;
      quantity.text = (int.parse(getQuantity) - 1).toString();
    });
  }

  Future _ackAlert(BuildContext context, String message, String header) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(header),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
}
