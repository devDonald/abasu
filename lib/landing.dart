import 'dart:async';

import 'package:abasu/bottom_navigation/order_history.dart';
import 'package:abasu/src/construction/construction_materials.dart';
import 'package:abasu/src/manpower/artisan_requests.dart';
import 'package:abasu/src/manpower/manpower.dart';
import 'package:abasu/src/screens/text_content.dart';
import 'package:abasu/src/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'bottom_navigation/home.dart';
import 'bottom_navigation/orders.dart';
import 'main.dart';

final root = FirebaseFirestore.instance;
final activityFeedRef = root.collection('feeds');
final usersRef = root.collection('users');
final driverRef = FirebaseFirestore.instance.collection('drivers');
NumberFormat format = NumberFormat('#,###,###');
final materialsRef = root.collection('categories');
final productRef = root.collection('products');
final manpowerRef = root.collection('workersCategory');
final adminRef = FirebaseFirestore.instance.collection('Admins');
final artisanRequests = root.collection('artisanRequests');
final requestFeed = root.collection('requestFeed');
final adminFeed = root.collection('AdminFeed');
final ordersRef = root.collection('orders');

final timestamp = DateTime.now().toUtc().toString();

List<String> categories = [];
List<String> subCategories = [];
double longitude = 8.865601999999999;
double latitude = 9.8364317;
final String naira = '₦';

class Landing extends StatefulWidget {
  static const String id = 'Landing';
  final bool isMyQuestions;
  final String uid;
  Landing({this.isMyQuestions, this.uid});
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin {
  TabController _tabController;
  final StreamController<DocumentSnapshot> _streamController =
      StreamController<DocumentSnapshot>();

  int _activeTabIndex;
  void _setActiveTabIndex() {
    _activeTabIndex = _tabController.index;
  }

  //All Screens in nav
  List<Widget> myScreens = <Widget>[
    Home(),
    ConstructionMaterials(),
    Manpower(),
    ArtisanRequests(),
    MyOrders(),
    OrderHistory()
  ];
  List<Tab> myNavItems = <Tab>[
    //1:home
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.home,
          size: 30,
        ),
      ),
    ),

    //2:Construction Materials
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.construction,
          size: 22,
        ),
      ),
    ),
    //3:Artisans
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.home_work_outlined,
          size: 22,
        ),
      ),
    ),
    //4:Artisan Requests
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.people_alt,
          size: 22,
        ),
      ),
    ),
    //5:My Product Order
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.reorder,
          size: 22,
        ),
      ),
    ),

    //6. My Order History
    Tab(
      child: Align(
        alignment: Alignment.center,
        child: Icon(
          Icons.history,
          size: 22,
        ),
      ),
    ),
  ];

  @override
  void initState() {
    onScreenCheck(0);
    _tabController = new TabController(
      vsync: this,
      length: myNavItems.length,
    );
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> myAppBarAction = [];
  Widget pageTitle;
  bool isOnHomeScreen = false;
  onScreenCheck(int pageIndex) {
    //1:Home
    if (pageIndex == 0) {
      setState(() {
        isOnHomeScreen = true;
        myAppBarAction = [
          //Nottification

          // AppBarIcon(
          //   icon: Icon(
          //     Icons.search,
          //     color: Colors.black,
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushNamed('/myProfile');
          //   },
          // ),
          AppBarIcon(
            icon: Icon(
              Icons.info,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/about');
            },
          ),
          AppBarIcon(
            icon: Icon(
              Icons.person,
              color: Colors.black,
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/myProfile');
            },
          ),
          StreamBuilder<QuerySnapshot>(
              stream: activityFeedRef
                  .doc(authId.userId)
                  .collection('requests')
                  .where("seen", isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                int notiCount = 0;
                if (snapshot.hasData) {
                  notiCount = snapshot.data.docs.length;
                }

                return NotificationsCounter(
                  count: notiCount,
                  onTap: () {
                    Navigator.of(context).pushNamed('/notification');
                  },
                );
              }),
        ];
        pageTitle = AbasuNavBrand();
      });
    }
    //2:Construction Material
    if (pageIndex == 1) {
      setState(() {
        isOnHomeScreen = false;

        myAppBarAction = [];
        pageTitle = PageTitle(
          title: 'Construction Materials',
        );
      });
    }
    //3:Manpower
    if (pageIndex == 2) {
      setState(() {
        isOnHomeScreen = false;

        myAppBarAction = [
          // AppBarIcon(
          //   icon: Icon(
          //     Icons.search,
          //     color: Colors.black,
          //   ),
          //   onTap: () {},
          // ),
        ];

        pageTitle = PageTitle(
          title: 'Artisans/Manpower',
        );
      });
    }
    //4 My Requested Artisans
    if (pageIndex == 3) {
      setState(() {
        isOnHomeScreen = false;

        myAppBarAction = [
          // AppBarIcon(
          //     icon: Icon(
          //   Icons.search,
          // ))
        ];
        pageTitle = PageTitle(
          title: 'My Requested Artisans',
        );
      });
    }
    //5:My product Orders
    if (pageIndex == 4) {
      setState(() {
        isOnHomeScreen = false;

        myAppBarAction = [];

        pageTitle = PageTitle(
          title: 'My Product Order',
        );
      });
    }
    //6:Videos
    if (pageIndex == 5) {
      setState(() {
        isOnHomeScreen = false;

        myAppBarAction = [
          Container(), //nothing here
        ];

        pageTitle = PageTitle(
          title: 'My Order History',
        );
      });
    } else {
      setState(() {
        // myAppBarAction = [];
      });
    }
    print(pageIndex);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: isOnHomeScreen
      //     ? Drawer(
      //         child: MenuDrawer(),
      //       )
      //     : null,
      appBar: AppBar(
        titleSpacing: 20,
        elevation: 3.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: pageTitle,
        actions: myAppBarAction,
        bottom: TabBar(
          onTap: (index) {
            onScreenCheck(index);
          },
          controller: _tabController,
          labelColor: Colors.green,
          unselectedLabelColor: Colors.black,
          tabs: myNavItems,
        ),
      ),

      //
      body: TabBarView(
        controller: _tabController,
        children: myScreens,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
