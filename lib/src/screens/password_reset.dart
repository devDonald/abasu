import 'package:abasu/src/screens/text_content.dart';
import 'package:abasu/src/styles/buttons.dart';
import 'package:abasu/src/styles/colors.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'ResetPassword';
  final String email;
  ResetPassword({Key key, this.email}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState(email: email);
}

class _ResetPasswordState extends State<ResetPassword> {
  String email;
  _ResetPasswordState({this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(children: <Widget>[
            SizedBox(
              height: 39.8,
            ),
            AbasuLogo(
              width: 101.1,
              height: 92.7,
            ),
            AbasuText(
              fontSize: 35.0,
            ),
            SizedBox(
              height: 123.5,
            ),
            Center(
              child: Container(
                width: 246.0,
                child: Column(
                  children: <Widget>[
                    Text(
                      'Please check your email address:',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kDarkBlueGrey,
                        fontSize: 13.0,
                      ),
                    ),
                    Text(
                      email,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kDarkBlueGrey,
                        fontSize: 13.0,
                        fontWeight: kBold,
                      ),
                    ),
                    Text(
                      'You should receive an email in a few minutes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kDarkBlueGrey,
                        fontSize: 13.0,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 223.0,
            ),
            PrimaryButton(
                color: Colors.green,
                buttonTitle: 'Back',
                blurRadius: 7.0,
                roundedEdge: 2.5,
                onTap: () {
                  setState(() {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/signIn', (r) => false);
                  });

                }),
          ]),
        ),
      ),
    );
  }
}
