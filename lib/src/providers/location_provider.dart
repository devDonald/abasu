import 'package:flutter/foundation.dart';

class LocationProvider with ChangeNotifier {
  int price = 0;
  double destinationLatitude, destinationLongitude;
  bool withDelivery = false;
  String distance;
}
