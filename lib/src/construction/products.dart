import 'package:abasu/landing.dart';
import 'package:abasu/src/construction/product_details.dart';
import 'package:abasu/src/models/all_cards.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Products extends StatelessWidget {
  final String subCategory;

  const Products({Key key, this.subCategory}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(subCategory),
          backgroundColor: Colors.green),
      backgroundColor: Colors.red[100],
      body: StreamBuilder<QuerySnapshot>(
          stream: root
              .collection('products')
              .where('category', isEqualTo: subCategory)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return noDataFound();
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            return Column(
              children: <Widget>[
                Expanded(
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      primary: false,
                      physics: BouncingScrollPhysics(),
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 5,
                              childAspectRatio: 3 / 3.55,
                              crossAxisCount: 2),
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var product = snapshot.data.docs[index];
                        return ProductCard(
                          productName: product['productName'],
                          price: product['unitPrice'],
                          productCategory: product['subCategory'],
                          productImage: product['imageUrl'],
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                          itemDescription:
                                              product['description'] ??
                                                  'Awesome Product to purchase',
                                          itemImage: product['imageUrl'],
                                          itemName: product['productName'],
                                          itemPrice: product['unitPrice'],
                                          itemQuantity:
                                              '${product['availableUnits']}',
                                          itemSubCategory:
                                              product['subCategory'],
                                          itemId: product['productId'],
                                          itemType: product['category'],
                                        )));
                          },
                        );
                      }),
                ),
              ],
            );
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
            Text("No Products available yet",
                style: TextStyle(color: Colors.black45, fontSize: 20.0)),
            Text("Please check back later",
                style: TextStyle(color: Colors.red, fontSize: 14.0))
          ],
        ),
      ),
    );
  }
}
