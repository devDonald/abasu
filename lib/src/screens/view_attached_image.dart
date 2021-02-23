import 'package:abasu/landing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';

import '../../main.dart';

class ViewAttachedImage extends StatefulWidget {
  static const String id = 'ViewAttachedImage';
  ViewAttachedImage({
    Key key,
    this.image,
    this.text,
    this.postId,
  }) : super(key: key);
  final String text, postId;
  final ImageProvider image;
  @override
  _ViewAttachedImageState createState() => _ViewAttachedImageState();
}

class _ViewAttachedImageState extends State<ViewAttachedImage> {
  bool isShowText = true;

  // String generateRandomString(int len) {
  //   var r = Random();
  //   const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  //   return List.generate(len, (index) => _chars[r.nextInt(_chars.length)]).join();
  // }

  // shareFile() async {
  //   var dio = Dio();
  //   String code = '';
  //   String ext = '.jpg';
  //
  //   if(mounted){
  //     setState(() {
  //       code = generateRandomString(10);
  //
  //     });
  //   }
  //
  //   final String dir =  (await getApplicationDocumentsDirectory()).path;
  //   String path = '$dir/$code$ext';
  //
  //   // await download2(dio, '${widget.url}', path).then((value){
  //   //
  //   //   ShareExtend.share(path, 'image',);
  //   //
  //   // });
  //
  // }
  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isShowText = !isShowText;
                  });
                },
                child: PhotoView(
                  loadFailedChild: CircularProgressIndicator(),
                  imageProvider: widget.image ??
                      CachedNetworkImageProvider(
                        'https://www.google.com/url?sa=i&url=https%3A%2F%2Fbitsofco.de%2Fhandling-broken-images-with-service-worker%2F&psig=AOvVaw2D0w00IWnhTJMNlT7r3t_x&ust=1601150393153000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCMCd15iMhewCFQAAAAAdAAAAABAD',
                      ),
                  minScale: PhotoViewComputedScale.contained * 1.0,
                  maxScale: PhotoViewComputedScale.contained * 2.5,
                  initialScale: PhotoViewComputedScale.contained * 1.0,
                ),
              ),
            ),
            Positioned(
              top: 5.0,
              left: 5.0,
              child: Material(
                shape: CircleBorder(),
                clipBehavior: Clip.hardEdge,
                color: Colors.black.withOpacity(0.05),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 36.5,
                    height: 36.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ),
            ),
            widget.postId != null
                ? Positioned(
                    top: 5.0,
                    right: 5.0,
                    child: Material(
                      shape: CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      color: Colors.black.withOpacity(0.05),
                      child: InkWell(
                        onTap: () {
                          showDeleteDialog(context, widget.postId);
                        },
                        child: Container(
                          width: 36.5,
                          height: 36.5,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 30.0,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),
            isShowText
                ? Positioned(
                    bottom: 0.0,
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 15.0,
                        right: 10.0,
                        bottom: 15.0,
                        left: 10.0,
                      ),
                      width: deviceWidth,
                      color: Colors.black.withOpacity(0.15),
                      child: Text(
                        widget.text ?? '',
                        style: TextStyle(color: Colors.white, fontSize: 15.0),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  showDeleteDialog(BuildContext context, String eventId) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("yes"),
      onPressed: () async {
        await usersRef
            .doc(authId.userId)
            .collection('previousWorks')
            .doc(eventId)
            .get()
            .then((doc) {
          if (doc.exists) {
            doc.reference.delete();
          }
        }).then((value) async {
          Fluttertoast.showToast(
              msg: "Work Image removed",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0);
          Navigator.pop(context);
        });
      },
    );
    Widget continueButton = FlatButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Delete Work Image"),
      content: Text("Would you like to remove this image?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
