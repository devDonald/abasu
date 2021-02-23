import 'dart:convert';
import 'dart:math' show cos, sqrt, asin;

import 'package:abasu/main.dart';
import 'package:abasu/src/models/secrets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../landing.dart';

class CalculateDestination extends StatefulWidget {
  @override
  _CalculateDestinationState createState() => _CalculateDestinationState();
}

class _CalculateDestinationState extends State<CalculateDestination> {
  CameraPosition _initialLocation =
      CameraPosition(target: LatLng(latitude, longitude));
  GoogleMapController mapController;

  Position _currentPosition;
  int _price = 0;
  String _currentAddress, _distance;
  final Set<Polyline> _polyline = {};

  final _destinationAddressController = TextEditingController();

  final destinationAddressFocusNode = FocusNode();
  //final desrinationAddressFocusNode = FocusNode();

  String _destinationAddress = '',
      _startingAddress = 'Building Materials Market, Jos South';
  //String _destinationAddress = '';
  double destinationLat, destinationLong;

  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        _destinationAddressController.text = _currentAddress;
        _destinationAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark =
          await locationFromAddress(_startingAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      if (destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position destinationCoordinates = _destinationAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude)
            : Position(
                latitude: destinationPlacemark[0].latitude,
                longitude: destinationPlacemark[0].longitude);

        Position startingCoordinates =
            Position(latitude: latitude, longitude: longitude);

        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startingCoordinates'),
          position: LatLng(
            latitude,
            longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startingAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$_destinationAddress'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startingCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny =
            (startingCoordinates.latitude <= destinationCoordinates.latitude)
                ? startingCoordinates.latitude
                : destinationCoordinates.latitude;
        double minx =
            (startingCoordinates.longitude <= destinationCoordinates.longitude)
                ? startingCoordinates.longitude
                : destinationCoordinates.longitude;
        double maxy =
            (startingCoordinates.latitude <= destinationCoordinates.latitude)
                ? destinationCoordinates.latitude
                : startingCoordinates.latitude;
        double maxx =
            (startingCoordinates.longitude <= destinationCoordinates.longitude)
                ? destinationCoordinates.longitude
                : startingCoordinates.longitude;

        _southwestCoordinates = Position(latitude: miny, longitude: minx);
        _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        //Calculating the distance between the start and the end positions
        //with a straight path, without considering any route
        // double distanceInMeters = await Geolocator.distanceBetween(
        //   startingCoordinates.latitude,
        //   startingCoordinates.longitude,
        //   destinationCoordinates.latitude,
        //   destinationCoordinates.longitude,
        // );

        //print('Dist $distanceInMeters');
        await _getPolyLine(
            LatLng(
              startingCoordinates.latitude,
              startingCoordinates.longitude,
            ),
            LatLng(destinationCoordinates.latitude,
                destinationCoordinates.longitude));
        //await _createPolylines(startingCoordinates, destinationCoordinates);

        // double totalDistance = 0.0;
        //
        // // Calculating the total distance by adding the distance
        // // between small segments
        // for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        //   totalDistance += _coordinateDistance(
        //     polylineCoordinates[i].latitude,
        //     polylineCoordinates[i].longitude,
        //     polylineCoordinates[i + 1].latitude,
        //     polylineCoordinates[i + 1].longitude,
        //   );
        // }
        //
        // setState(() {
        //   _placeDistance = totalDistance.toStringAsFixed(2);
        //   print('DISTANCE: $_placeDistance km');
        //   print('DISTANCE 2: $totalDistance km');
        // });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Create the polylines for showing the route between two places
  _createPolylines(Position start, Position destination) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    print('Polines: $polylineCoordinates');
    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height,
      width: width,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Calculate Distance'),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
        ),
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: markers != null ? Set<Marker>.from(markers) : null,
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.add),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomIn(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue[100], // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    width: width * 0.9,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'Places',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          SizedBox(height: 10),
                          _textField(
                              label: 'Destination',
                              hint: 'Choose Destination point',
                              prefixIcon: Icon(Icons.location_on),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.my_location),
                                onPressed: () {
                                  _destinationAddressController.text =
                                      _currentAddress;
                                  _destinationAddress = _currentAddress;
                                },
                              ),
                              controller: _destinationAddressController,
                              focusNode: destinationAddressFocusNode,
                              width: width,
                              locationCallback: (String value) {
                                setState(() {
                                  _destinationAddress = value;
                                });
                              }),
                          SizedBox(height: 10),
                          Visibility(
                            visible: _distance == null ? false : true,
                            child: Text(
                              'DISTANCE: $_distance',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Visibility(
                            visible: _distance == null ? false : true,
                            child: Text(
                              'Price: $naira$_price',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          RaisedButton(
                            onPressed: (_destinationAddress != '')
                                ? () async {
                                    destinationAddressFocusNode.unfocus();
                                    setState(() {
                                      if (markers.isNotEmpty) markers.clear();
                                      if (polylines.isNotEmpty)
                                        polylines.clear();
                                      if (polylineCoordinates.isNotEmpty)
                                        polylineCoordinates.clear();
                                    });

                                    _calculateDistance().then((isCalculated) {
                                      orderDestination.price = _price;
                                      orderDestination.distance = _distance;
                                      orderDestination.destinationLatitude =
                                          destinationLat;
                                      orderDestination.destinationLongitude =
                                          destinationLong;
                                      if (isCalculated) {
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   SnackBar(
                                        //     content: Text(
                                        //         'Distance Calculated Sucessfully'),
                                        //   ),
                                        // );
                                      } else {
                                        // ScaffoldMessenger.of(context)
                                        //     .showSnackBar(
                                        //   SnackBar(
                                        //     content: Text(
                                        //         'Error Calculating Distance'),
                                        //   ),
                                        // );
                                      }
                                    });
                                  }
                                : null,
                            color: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Show Route'.toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Show current location button
            SafeArea(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                  child: ClipOval(
                    child: Material(
                      color: Colors.orange[100], // button color
                      child: InkWell(
                        splashColor: Colors.orange, // inkwell color
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(Icons.my_location),
                        ),
                        onTap: () {
                          mapController.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: LatLng(
                                  _currentPosition.latitude,
                                  _currentPosition.longitude,
                                ),
                                zoom: 18.0,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Steps> parseSteps(final responseBody) {
    var list =
        responseBody.map<Steps>((json) => new Steps.fromJson(json)).toList();
    return list;
  }

  Future<dynamic> _getPolyLine(
      LatLng sourceLatLong, LatLng destinationLatLong) {
    final JsonDecoder _decoder = JsonDecoder();

    destinationLat = destinationLatLong.latitude;
    destinationLong = destinationLatLong.longitude;
    final BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?" +
        "origin=" +
        sourceLatLong.latitude.toString() +
        "," +
        sourceLatLong.longitude.toString() +
        "&destination=" +
        destinationLatLong.latitude.toString() +
        "," +
        destinationLatLong.longitude.toString() +
        "&key=${Secrets.API_KEY}";

    print(BASE_URL);
    return http.get(BASE_URL).then((http.Response response) {
      String res = response.body;
      int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        res = "{\"status\":" +
            statusCode.toString() +
            ",\"message\":\"error\",\"response\":" +
            res +
            "}";
        throw new Exception(res);
      }

      try {
        _distance = _decoder
                .convert(res)["routes"][0]["legs"][0]["distance"]['text']
                .toString() ??
            'No Dispaly';
        _price = int.parse(_distance.replaceAll(RegExp('[^0-9]'), '')) * 50;

        print('Distance 1: $_distance');
      } catch (e) {
        throw new Exception(res);
      }

      List<Steps> steps;
      try {
        steps =
            parseSteps(_decoder.convert(res)["routes"][0]["legs"][0]["steps"]);

        List<LatLng> _listOfLatLongs = [];

        for (final i in steps) {
          _listOfLatLongs.add(i.startLocation);
          _listOfLatLongs.add(i.endLocation);
        }

        Future.delayed(Duration(seconds: 1), () {
          setState(() {
            _polyline.add(Polyline(
              polylineId: PolylineId("2"),
              visible: true,
              width: 8,
              points: _listOfLatLongs,
              color: Colors.blue,
            ));
          });
        });
      } catch (e) {
        throw new Exception(res);
      }

      return steps;
    });
  }
}

class Steps {
  LatLng startLocation;
  LatLng endLocation;
  Steps({this.startLocation, this.endLocation});
  factory Steps.fromJson(Map<String, dynamic> json) {
    return new Steps(
        startLocation: new LatLng(
            json["start_location"]["lat"], json["start_location"]["lng"]),
        endLocation: new LatLng(
            json["end_location"]["lat"], json["end_location"]["lng"]));
  }
}
