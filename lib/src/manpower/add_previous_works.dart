import 'dart:io';

import 'package:abasu/landing.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:abasu/src/widgets/button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:progress_dialog/progress_dialog.dart';

class AddPreviousWorks extends StatefulWidget {
  static const String id = 'AddPreviousWorks';
  AddPreviousWorks({Key key}) : super(key: key);

  @override
  _AddPreviousWorksState createState() => _AddPreviousWorksState();
}

class _AddPreviousWorksState extends State<AddPreviousWorks> {
  String _uploadedImageURL = '', error = '', _postID;
  ProgressDialog pr;
  bool profileImage = false;

  File pickedImage;

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

  void _uploadEvent() async {
    try {
      User _currentUser = await FirebaseAuth.instance.currentUser;
      String uid = _currentUser.uid;
      if (pickedImage != null) {
        pr.show();
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('works/$uid/${Path.basename(pickedImage.path)}}');
        UploadTask uploadTask = storageReference.putFile(pickedImage);
        await uploadTask;
        print('File Uploaded');
        storageReference.getDownloadURL().then((fileURL) async {
          _uploadedImageURL = fileURL;
          DocumentReference _docRef =
              usersRef.doc(uid).collection('previousWorks').doc();
          await _docRef.set({
            'postId': _docRef.id,
            'imageUrl': _uploadedImageURL,
            'timestamp': DateTime.now().toUtc(),
          }).then((doc) async {
            usersRef.doc(uid).update({
              'hasWorks': true,
            });
            pr.hide();
            Fluttertoast.showToast(
                msg: "Image Added",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blue,
                textColor: Colors.white,
                fontSize: 16.0);
            Navigator.of(context);
          }).catchError((onError) async {
            pr.hide();
            Fluttertoast.showToast(
                msg: "Image upload Failed",
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
    //bodyValue.clear();
    setState(() {
      pickedImage = null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, Uploading Images');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 3.0,
        titleSpacing: -3.0,
        title: Text(
          'Add Previous Works Images',
          style: TextStyle(
              color: Colors.black,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat'),
        ),
      ),
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.all(15.0),
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 5.0,
              offset: Offset(0.0, 2.5),
            ),
          ],
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DiscussOutlineButton(
                onTap: () {
                  getImageFile(ImageSource.gallery);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Add Photo',
                      style: TextStyle(color: Colors.green, fontSize: 13.0),
                    ),
                    Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.5),
              pickedImage != null
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Image Picked',
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Image empty',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
              SizedBox(height: 16.5),
              Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: PrimaryButton(
                  width: 81.5,
                  height: 36.5,
                  blurRadius: 3.0,
                  roundedEdge: 5.0,
                  color: Colors.green,
                  buttonTitle: 'Post',
                  onTap: () {
                    if (pickedImage != null) {
                      _uploadEvent();
                    } else {
                      setState(() {
                        error = 'No image picked';
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
