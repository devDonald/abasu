import 'package:abasu/src/screens/text_content.dart';
import 'package:abasu/src/styles/colors.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor2,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('About Us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: kBold,
              )),
        ),
        titleSpacing: -5.0,
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: 10.0,
          right: 10.0,
          top: 10.5,
          bottom: 10.0,
        ),
        padding: EdgeInsets.only(
          left: 10.5,
          right: 23.5,
        ),
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: kShadowColor, offset: Offset(0.0, 2.5)),
          ],
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: 2.5,
            ),
            Container(
              width: double.infinity,
              child: Text(
                aboutUs,
                style: TextStyle(color: kGreyColor, fontSize: 20.0),
              ),
            ),
            SizedBox(
              height: 10.5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/termsOfService');
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Our terms and Condition',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10.5,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/privacyAndPolicy');
              },
              child: Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Our Privacy Policy',
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 10.5,
            ),
          ],
        ),
      ),
    );
  }
}
