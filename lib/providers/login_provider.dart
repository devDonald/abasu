import 'package:flutter/material.dart';

class CheckLoginAs extends ChangeNotifier {
  bool asArtisan = false;

  isAsArtisan() {
    asArtisan = true;
    print('is an artisan is : $asArtisan ');
    notifyListeners();
  }

  isAsBuyer() {
    asArtisan = false;
    print('is an artisan is : $asArtisan ');
    notifyListeners();
  }
}