import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

abstract class ButtonStyles {
  static double get buttonHeight => 50.0;
}

String abasuLogo = 'assets/images/logo.svg';

class AbasuLogo extends StatelessWidget {
  const AbasuLogo({
    this.width,
    this.height,
  });
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      abasuLogo,
      width: width,
      height: height,
      color: Colors.green,
    );
  }
}
