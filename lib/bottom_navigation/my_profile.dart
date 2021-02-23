import 'dart:io';

import 'package:abasu/bottom_navigation/my_work_request.dart';
import 'package:abasu/src/manpower/artisan_review.dart';
import 'package:abasu/src/manpower/my_previous_works.dart';
import 'package:abasu/src/screens/edit_profile.dart';
import 'package:abasu/src/widgets/button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

import '../landing.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  bool isHired = false, hasPreviusWork = false;
  String image, fullName, gender, specialty, address, profiling, userId, city;
  int charge;
  String email, phone, state, experience;
  bool isVerified = false, asArtisan = false;

  void getHasPreviousWork() async {}
  void getIsHired() async {}
  void getUserData() async {
    try {
      User _currentUser = FirebaseAuth.instance.currentUser;
      String authid = _currentUser.uid;
      root.collection('users').doc('$authid').get().then((ds) {
        if (ds.exists) {
          setState(() {
            userId = ds.data()['userId'];
            image = ds.data()['imageUrl'];
            fullName = ds.data()['fullName'];
            gender = ds.data()['gender'];
            experience = ds.data()['experience'];
            specialty = ds.data()['skill'];
            address = ds.data()['address'];
            profiling = ds.data()['profiling'];
            email = ds.data()['email'];
            phone = ds.data()['phone'];
            isVerified = ds.data()['isVerified'];
            city = ds.data()['city'];
            state = ds.data()['state'];
            charge = ds.data()['charge'];
            asArtisan = ds.data()['asArtisan'];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Profile'),
          backgroundColor: Colors.green,
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            UserProfileInfo(
              name: fullName,
              profileImage: image,
              category: specialty,
              isVerified: isVerified,
              asArtisan: asArtisan,
              gender: gender,
              experience: '$experience',
              specialty: specialty,
              isHired: isHired,
              hasPreviousWork: hasPreviusWork,
              phone: phone,
              userId: userId,
              email: email,
              charge: charge,
              address: address,
              city: city,
              state: state,
            ),
            OverViewBioCard(
              gender: gender,
              photo: image,
              experience: '$experience',
              specialty: specialty,
              isHired: isHired,
              hasPreviousWork: hasPreviusWork,
              asArtisan: asArtisan,
              phone: phone,
              userId: userId,
              name: fullName,
              email: email,
              charge: charge,
              location: '$address $city',
            ),
          ],
        ));
  }
}

class OverViewBioCard extends StatelessWidget {
  const OverViewBioCard({
    Key key,
    this.gender,
    this.experience,
    this.specialty,
    this.location,
    this.userId,
    this.phone,
    this.email,
    this.isHired,
    this.hasPreviousWork,
    this.asArtisan,
    this.charge,
    this.photo,
    this.name,
  }) : super(key: key);
  final String gender,
      experience,
      specialty,
      location,
      userId,
      phone,
      email,
      name,
      photo;
  final bool isHired, hasPreviousWork, asArtisan;
  final int charge;
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
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
            email ?? '',
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
            phone ?? '',
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
            gender ?? '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 15.0),
          asArtisan
              ? Text(
                  'Experience',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : Container(),
          SizedBox(height: 8.0),
          asArtisan
              ? Text(
                  '$experience Years',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                )
              : Container(),
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
            location ?? '',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          asArtisan
              ? Text(
                  'Average Charge Per Day',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              : Container(),
          SizedBox(height: 8.0),
          asArtisan
              ? Text(
                  '₦${format.format(charge)}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                )
              : Container(),
          SizedBox(height: 15.0),
          asArtisan
              ? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AppButton(
                        buttonText: 'My Previous Works',
                        buttonType: ButtonType.DarkGreen,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPreviousWorks(
                                        userId: userId,
                                      )));
                        },
                      ),
                      AppButton(
                        buttonText: 'My Work Requests',
                        buttonType: ButtonType.DarkGreen,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyWorkRequests()));
                        },
                      ),
                      AppButton(
                        buttonText: 'My Reviews',
                        buttonType: ButtonType.DarkGreen,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ArtisanReviews(
                                        userId: userId,
                                        photo: photo,
                                        userName: name,
                                      )));
                        },
                      ),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}

class UserProfileInfo extends StatefulWidget {
  const UserProfileInfo({
    Key key,
    this.name,
    this.profileImage,
    this.category,
    this.isVerified,
    this.asArtisan,
    this.gender,
    this.experience,
    this.specialty,
    this.userId,
    this.phone,
    this.email,
    this.isHired,
    this.hasPreviousWork,
    this.charge,
    this.address,
    this.city,
    this.state,
  }) : super(key: key);
  final String name, profileImage, category;
  final bool isVerified, asArtisan;
  final String gender,
      experience,
      specialty,
      address,
      city,
      state,
      userId,
      phone,
      email;
  final bool isHired, hasPreviousWork;
  final int charge;

  @override
  _UserProfileInfoState createState() => _UserProfileInfoState();
}

class _UserProfileInfoState extends State<UserProfileInfo> {
  File pickedImage;
  String _uploadedImageURL;

  final _picker = ImagePicker();
  getImageFile(ImageSource source) async {
    //Clicking or Picking from Gallery

    var image = await _picker.getImage(source: source);

    //Cropping the image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      maxWidth: 512,
      maxHeight: 512,
    );

    setState(() {
      pickedImage = croppedFile;
      print(pickedImage.lengthSync());
    });
  }

  Future<void> sendImage() async {
    try {
      User _currentUser = await FirebaseAuth.instance.currentUser;
      String uid = _currentUser.uid;
      if (pickedImage != null) {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('users/$uid/${Path.basename(pickedImage.path)}}');
        UploadTask uploadTask = storageReference.putFile(pickedImage);
        await uploadTask;
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) async {
          _uploadedImageURL = fileURL;
          DocumentReference _docRef = usersRef.doc(uid);
          await _docRef.update({
            'imageUrl': _uploadedImageURL,
          }).then((doc) async {
            Fluttertoast.showToast(
                msg: "photo successfully updated",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
          }).catchError((onError) async {
            Fluttertoast.showToast(
                msg: "photo update Failed",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          });
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new Container(
                height: MediaQuery.of(context).size.height * 0.25,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                decoration: new BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: new DecorationImage(
                                    image: widget.profileImage != ''
                                        ? new CachedNetworkImageProvider(
                                            widget.profileImage)
                                        : AssetImage(
                                            'assets/images/profile.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () async {
                                    await getImageFile(ImageSource.gallery);
                                    sendImage();
                                  },
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  widget.name ?? '',
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
          widget.asArtisan
              ? Container(
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
                        '${widget.category}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      TempDot(),
                      widget.isVerified
                          ? TextBody1(
                              colors: Colors.green,
                            )
                          : TextBody1(
                              colors: Colors.red,
                            ),
                    ],
                  ),
                )
              : Container(),
          SizedBox(
            height: 15,
          ),
          FlatButton(
            color: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0)),
            child: new Text('Update Profile'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfile(
                      state: widget.state,
                      specialty: widget.specialty,
                      userId: widget.userId,
                      address: widget.address,
                      name: widget.name,
                      email: widget.email,
                      phone: widget.phone,
                      city: widget.city,
                      category: widget.category,
                      gender: widget.gender,
                      experience: widget.experience,
                      charge: '${widget.charge}',
                      asArtisan: widget.asArtisan,
                    ),
                  ));
            },
          ),
        ],
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

  const TextBody1({Key key, this.colors}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyText1,
        children: [
          WidgetSpan(
            child: Icon(
              Icons.assignment_turned_in,
              size: 20,
              color: colors,
            ),
          ),
        ],
      ),
    );
  }
}
