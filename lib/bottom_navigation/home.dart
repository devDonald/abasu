import 'package:abasu/main.dart';
import 'package:abasu/src/construction/product_details.dart';
import 'package:abasu/src/manpower/view_artisan.dart';
import 'package:abasu/src/models/all_cards.dart';
import 'package:abasu/src/services/all_services.dart';
import 'package:abasu/src/services/firestore_service.dart';
import 'package:abasu/src/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../landing.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<List<DocumentSnapshot>> getArtisan() async {
    QuerySnapshot qn = await root
        .collection('users')
        .where('asArtisan', isEqualTo: true)
        .where('isTop', isEqualTo: true)
        .get();
    return qn.docs;
  }

  Future<List<DocumentSnapshot>> getProducts() async {
    QuerySnapshot qn =
        await root.collection('products').where('isTop', isEqualTo: true).get();
    return qn.docs;
  }

  @override
  void initState() {
    if (authId.userId == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
    }
    getArtisan();
    getProducts();
    super.initState();
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    var authBloc = Provider.of<AuthService>(context, listen: false);
    final productProvider = Provider.of<AllServices>(context);

    void choiceAction(String choice) {
      if (choice == HomeMenu.logout) {
        authBloc.signOutUser();
      }
    }

    return Scaffold(
        body: Container(
      child: ListView(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Row(
            children: [
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: HomeView(
                  category: 'Data Services',
                  image: 'assets/images/data.jpg',
                  comingSoon: 'COMING SOON',
                ),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: HomeView(
                  category: 'Hospitality',
                  image: 'assets/images/hospitality.png',
                  comingSoon: 'COMING SOON',
                ),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 17.5, left: 7.0, right: 7.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: EventButton(
                icon: Icons.construction,
                title: 'Top Products',
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  top: 17.5, bottom: 5.0, left: 7.0, right: 7.0),
              //padding: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 2.5),
                    blurRadius: 10.5,
                  ),
                ],
              ),
              child: Container(
                child: Center(
                  child: SizedBox(
                    height: 210, // card height
                    child: FutureBuilder(
                        future: getProducts(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return PageView.builder(
                              itemCount: snapshot.data.length,
                              controller: PageController(viewportFraction: 0.5),
                              onPageChanged: (int index) =>
                                  setState(() => _index = index),
                              itemBuilder: (_, i) {
                                var product = snapshot.data[i];
                                return ProductCard(
                                  productName: product['productName'],
                                  price: product['unitPrice'],
                                  productCategory: product['subCategory'],
                                  productImage: product['imageUrl'],
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetails(
                                                  itemDescription: product[
                                                          'description'] ??
                                                      'Awesome Product to purchase',
                                                  itemImage:
                                                      product['imageUrl'],
                                                  itemName:
                                                      product['productName'],
                                                  itemPrice:
                                                      product['unitPrice'],
                                                  itemQuantity:
                                                      '${product['availableUnits']}',
                                                  itemSubCategory:
                                                      product['subCategory'],
                                                  itemId: product['productId'],
                                                  itemType: product['category'],
                                                )));
                                  },
                                );
                              },
                            );
                          } else {
                            return Text('loading');
                          }
                        }),
                  ),
                ),
              )),
          SizedBox(
            height: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 17.5, left: 7.0, right: 7.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: EventButton(
                icon: Icons.precision_manufacturing_outlined,
                title: 'Top Artisans',
              ),
            ),
          ),
          Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(
                  top: 17.5, bottom: 5.0, left: 7.0, right: 7.0),
              //padding: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 2.5),
                    blurRadius: 10.5,
                  ),
                ],
              ),
              child: Container(
                child: Center(
                  child: SizedBox(
                    height: 200, // card height
                    child: FutureBuilder(
                        future: getArtisan(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return PageView.builder(
                              itemCount: snapshot.data.length,
                              controller: PageController(viewportFraction: 0.6),
                              onPageChanged: (int index) =>
                                  setState(() => _index = index),
                              itemBuilder: (_, i) {
                                DocumentSnapshot snap = snapshot.data[i];

                                return TopArtisanCard(
                                  fullName: snap['fullName'],
                                  image: snap['imageUrl'],
                                  experience:
                                      '${snap['experience']} Year(s) Experience',
                                  specialty: snap['skill'],
                                  location:
                                      '${snap['address']} ${snap['city']}',
                                  isVerified: snap['isVerified'],
                                  charge:
                                      '₦${format.format(snap['charge'])} per day',
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewArtisanProfile(
                                                  fullName: snap['fullName'],
                                                  image: snap['imageUrl'],
                                                  gender: snap['gender'],
                                                  experience:
                                                      '${snap['experience']} Year(s) Experience',
                                                  specialty: snap['skill'],
                                                  location:
                                                      '${snap['address']} ${snap['city']}',
                                                  isVerified:
                                                      snap['isVerified'],
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
                  ),
                ),
              )),
        ],
      ),
    ));
  }
}

class HomeView extends StatelessWidget {
  final String category;
  final String image, comingSoon;

  const HomeView({Key key, this.category, this.image, this.comingSoon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.45,
      height: MediaQuery.of(context).size.height * 0.25,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(
              0.0,
              2.5,
            ),
            color: Colors.black12,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 7,
              top: 7,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(5),
                topRight: Radius.circular(5),
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Container(
              height: 100.0,
              padding: EdgeInsets.only(
                top: 8,
                left: 9,
                right: 9,
              ),
              child: Image(
                image: AssetImage(image),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              comingSoon ?? '',
              style: TextStyle(
                fontSize: 10,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class HomeMenu {
  static const String logout = 'Logout';

  static const List<String> choices = <String>[logout];
}
