import 'dart:async';
import 'dart:typed_data';

import 'package:abasu/landing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TrackDelivery extends StatefulWidget {
  TrackDelivery({Key key, this.title, this.orderId}) : super(key: key);

  final String title, orderId;

  @override
  _TrackDeliveryState createState() => _TrackDeliveryState();
}

class _TrackDeliveryState extends State<TrackDelivery> {
  StreamSubscription _locationSubscription;
  //Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  GoogleMapController _controller;

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData =
        await DefaultAssetBundle.of(context).load("images/car.png");
    return byteData.buffer.asUint8List();
  }

  // void updateMarkerAndCircle(double lat, double long, Uint8List imageData) {
  //   LatLng latlng = LatLng(lat, long);
  //   this.setState(() {
  //     marker = Marker(
  //         markerId: MarkerId("home"),
  //         position: latlng,
  //         rotation: 0,
  //         draggable: false,
  //         zIndex: 2,
  //         flat: true,
  //         anchor: Offset(0.5, 0.5),
  //         icon: BitmapDescriptor.fromBytes(imageData));
  //     circle = Circle(
  //         circleId: CircleId("car"),
  //         radius: 0,
  //         zIndex: 1,
  //         strokeColor: Colors.blue,
  //         center: latlng,
  //         fillColor: Colors.blue.withAlpha(70));
  //   });
  // }
  //
  // void getCurrentLocation() async {
  //   try {
  //     Uint8List imageData = await getMarker();
  //     double lat, long;
  //
  //     ordersRef.where("orderId", isEqualTo: widget.orderId)
  //         .snapshots()
  //         .listen((result) {
  //       result.docs.forEach((result) {
  //         print(result.data());
  //         lat = result.data()['latitudePosition'];
  //         long = result.data()['longitudePosition'];
  //       });
  //     });
  //     updateMarkerAndCircle(lat,long, imageData);
  //
  //     if (_locationSubscription != null) {
  //       _locationSubscription.cancel();
  //     }
  //
  //     _locationSubscription =
  //         _locationTracker.onLocationChanged.listen((lat,long) {
  //       if (_controller != null) {
  //         _controller.animateCamera(CameraUpdate.newCameraPosition(
  //             new CameraPosition(
  //                 bearing: 192.8334901395799,
  //                 target: LatLng(newLocalData.latitude, newLocalData.longitude),
  //                 tilt: 0,
  //                 zoom: 18.00)));
  //         updateMarkerAndCircle(newLocalData, imageData);
  //
  //         print('longitude: ${newLocalData.longitude}');
  //         ordersRef.doc(widget.orderId).update({
  //           'deliveryLongitude': newLocalData.longitude,
  //           'deliveryLatitude': newLocalData.latitude
  //         });
  //       }
  //     });
  //   } on PlatformException catch (e) {
  //     if (e.code == 'PERMISSION_DENIED') {
  //       debugPrint("Permission Denied");
  //     }
  //   }
  // }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    ordersRef.doc(widget.orderId).update({
      'isEnroute': true,
    });
    //getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Track Driver'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream:
              ordersRef.where('orderId', isEqualTo: widget.orderId).snapshots(),
          builder: (context, snapshot) {
            DocumentSnapshot snap = snapshot.data.docs.first;
            print(snap['orderId']);
            return GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: initialLocation,
              markers: Set.of((marker != null)
                  ? [
                      Marker(
                          markerId: MarkerId("home"),
                          position: LatLng(snap['latitudePosition'],
                              snap['longitudePosition']),
                          rotation: 0,
                          draggable: false,
                          zIndex: 2,
                          flat: true,
                          anchor: Offset(0.5, 0.5),
                          icon: BitmapDescriptor.defaultMarker)
                    ]
                  : []),
              circles: Set.of((circle != null)
                  ? [
                      circle = Circle(
                          circleId: CircleId("car"),
                          radius: 0,
                          zIndex: 1,
                          strokeColor: Colors.blue,
                          center: LatLng(snap['latitudePosition'],
                              snap['longitudePosition']),
                          fillColor: Colors.blue.withAlpha(70))
                    ]
                  : []),
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
            );
          }),
    );
  }
}
