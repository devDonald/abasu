import 'package:abasu/landing.dart';
import 'package:abasu/src/manpower/artisan_review.dart';
import 'package:abasu/src/manpower/hire_artisan.dart';
import 'package:abasu/src/manpower/view_artisan_works.dart';
import 'package:abasu/src/widgets/button.dart';
import 'package:flutter/material.dart';

class ViewArtisanProfile extends StatefulWidget {
  final String image, fullName, gender, experience, specialty, location, userId;
  final int charge;
  final bool isVerified, isHired, hasWorks;

  const ViewArtisanProfile({
    Key key,
    this.image,
    this.fullName,
    this.gender,
    this.experience,
    this.specialty,
    this.location,
    this.userId,
    this.isVerified,
    this.charge,
    this.isHired,
    this.hasWorks,
  }) : super(key: key);

  @override
  _ViewArtisanProfileState createState() => _ViewArtisanProfileState();
}

class _ViewArtisanProfileState extends State<ViewArtisanProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              pinned: true,
              floating: false,
              iconTheme: IconThemeData(color: Colors.green),
              backgroundColor: Colors.red[100],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 15),
                    UserProfileInfo(
                      name: widget.fullName,
                      profileImage: widget.image,
                      category: widget.specialty,
                      isVerified: widget.isVerified,
                    ),
                  ],
                ),
              ),
              expandedHeight: MediaQuery.of(context).size.height / 3.5,
            )
          ];
        },
        body: OverViewBioCard(
          gender: widget.gender,
          experience: widget.experience,
          specialty: widget.specialty,
          isHired: widget.isHired,
          hasPreviousWork: widget.isVerified,
          location: widget.location,
          photo: widget.image,
          name: widget.fullName,
          isVerified: widget.isVerified,
          charge: widget.charge,
          artisanId: widget.userId,
        ),
      ),
    );
  }
}

class OverViewBioCard extends StatelessWidget {
  const OverViewBioCard({
    Key key,
    this.gender,
    this.experience,
    this.specialty,
    this.location,
    this.artisanId,
    this.isHired,
    this.hasPreviousWork,
    this.name,
    this.charge,
    this.isVerified,
    this.photo,
  }) : super(key: key);
  final String gender, experience, specialty, location, artisanId, name, photo;
  final int charge;
  final bool isHired, hasPreviousWork, isVerified;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(9),
      margin: EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 15,
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            blurRadius: 8.0,
            offset: Offset(
              0.0,
              4.0,
            ),
            color: Colors.black12,
          )
        ],
      ),
      child: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        primary: false,
        children: [
          Text(
            'Email',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Not Allowed',
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Phone',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Not Allowed',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Gender',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            gender,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Experience',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            experience,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 15.0),
          Text(
            'Location',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            location,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Average Charge Per Day',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            '₦${format.format(charge)}',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 8.0),
          Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Availability Status',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 8.0),
                isHired == true
                    ? Text(
                        'Hired',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                        ),
                      )
                    : Text(
                        'Available',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
              ]),
          SizedBox(height: 15.0),
          AppButton(
            buttonText: 'View Previous Work',
            buttonType:
                hasPreviousWork ? ButtonType.DarkGreen : ButtonType.Disabled,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewArtisanWorks(
                            name: name,
                            userId: artisanId,
                          )));
            },
          ),
          AppButton(
            buttonText: 'Hire Me',
            buttonType:
                isHired == false ? ButtonType.DarkGreen : ButtonType.Disabled,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HireArtisan(
                            artisanName: name,
                            artisanId: artisanId,
                          )));
            },
          ),
          AppButton(
            buttonText: 'Leave a Review',
            buttonType:
                isVerified == true ? ButtonType.DarkGreen : ButtonType.Disabled,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArtisanReviews(
                            userName: name,
                            userId: artisanId,
                            photo: photo,
                          )));
            },
          ),
        ],
      ),
    );
  }
}

class UserProfileInfo extends StatelessWidget {
  const UserProfileInfo({
    Key key,
    this.name,
    this.profileImage,
    this.category,
    this.isVerified,
  }) : super(key: key);
  final String name, profileImage, category;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  profileImage,
                  height: 115.0,
                  width: 115.0,
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Artisan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TempDot(),
                  Text(
                    '$category',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff333333),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  TempDot(),
                  isVerified
                      ? TextBody1(
                          colors: Colors.green,
                          icon: Icons.verified,
                        )
                      : TextBody1(
                          colors: Colors.red,
                          icon: Icons.close,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TempDot extends StatelessWidget {
  const TempDot({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 5),
      width: 5,
      height: 5,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.black12,
      ),
    );
  }
}

class TextBody1 extends StatelessWidget {
  final Color colors;
  final IconData icon;

  const TextBody1({Key key, this.colors, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: Icon(
                icon,
                size: 20,
                color: colors,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
