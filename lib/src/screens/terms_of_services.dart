import 'package:abasu/src/screens/text_content.dart';
import 'package:abasu/src/styles/colors.dart';
import 'package:flutter/material.dart';

class TermsOfService extends StatefulWidget {
  TermsOfService({Key key}) : super(key: key);

  @override
  _TermsOfServiceState createState() => _TermsOfServiceState();
}

class _TermsOfServiceState extends State<TermsOfService> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor2,
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('Terms of Service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: kBold,
            )),
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
              height: 15.5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Text(
                termsAndCondition,
                style: TextStyle(color: kGreyColor, fontSize: 16.0),
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
