import 'package:abasu/providers/login_provider.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:abasu/src/screens/text_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class LogInAs extends StatefulWidget {
  static const String id = 'LogInAs';
  const LogInAs({Key key}) : super(key: key);

  @override
  _LogInAsState createState() => _LogInAsState();
}

class _LogInAsState extends State<LogInAs> {
  //pass value to use

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 40.4,
                    ),
                    Container(
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 130,
                        height: 130,
                      ),
                    ),
                    SizedBox(
                      height: 30.5,
                    ),
                    Container(
                      child: Column(
                        children: <Widget>[
                          Text(
                            'How do you want to use',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Colors.grey,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              AbasuText(
                                fontSize: 18.0,
                              ),
                              Text(
                                '?',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    LogInAsButton(
                      title: 'As a Buyer',
                      onTap: () {
                        Provider.of<CheckLoginAs>(context, listen: false)
                            .isAsArtisan();
                        //
                        Provider.of<CheckLoginAs>(context, listen: false)
                            .asArtisan = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login(
                                      asArtisan: false,
                                    )));
                      },
                    ),
                    LogInAsButton(
                      title: 'As an Artisan',
                      onTap: () {
                        Provider.of<CheckLoginAs>(context, listen: false)
                            .isAsArtisan();
                        //
                        Provider.of<CheckLoginAs>(context, listen: false)
                            .asArtisan = true;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login(asArtisan: true)));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LogInAsButton extends StatelessWidget {
  const LogInAsButton({
    Key key,
    this.title,
    this.onTap,
  }) : super(key: key);
  final String title;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 80.4,
        margin: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          bottom: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(
            10.0,
          ),
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 5.0),
              blurRadius: 15.0,
              color: Colors.lightGreen,
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              left: 1,
              right: 1,
              bottom: -30,
              child: SvgPicture.asset('images/buttonDesign.svg'),
            ),
            Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
