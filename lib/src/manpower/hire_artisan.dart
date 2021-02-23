import 'package:abasu/landing.dart';
import 'package:abasu/src/models/hireartisan_model.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:abasu/src/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class HireArtisan extends StatelessWidget {
  final String artisanName, artisanId;

  HireArtisan({Key key, this.artisanName, this.artisanId}) : super(key: key);

  final _name = TextEditingController();
  final _address = TextEditingController();
  final _title = TextEditingController();
  final _description = TextEditingController();
  final _date = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          "Hire $artisanName",
        ),
        centerTitle: false,
        elevation: 5,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Card(
              elevation: 10.0,
              color: Colors.white,
              shadowColor: Colors.green,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Text(
                        'Project Details',
                        style: TextStyle(
                            fontSize: 25,
                            decorationStyle: TextDecorationStyle.dashed,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Full Name: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _name,
                      decoration: InputDecoration(
                        hintText: 'your answer',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'enter full name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Site Address: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _address,
                      decoration: InputDecoration(
                        hintText: 'your answer',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.streetAddress,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'site address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Title of Project: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _title,
                      decoration: InputDecoration(
                        hintText: 'your answer',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'title of project';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Project Description: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _description,
                      decoration: InputDecoration(
                        hintText: 'Describe your project here',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'description of project';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Project Starting Date: ',
                      style: TextStyle(
                        fontSize: 15,
                        decorationStyle: TextDecorationStyle.dashed,
                        fontWeight: FontWeight.w400,
                        color: Colors.green,
                      ),
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _date,
                      decoration: InputDecoration(
                        hintText: '25-11-2021',
                        border: OutlineInputBorder(borderSide: BorderSide()),
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'starting date';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PrimaryButton(
                      height: 45.0,
                      width: double.infinity,
                      color: Colors.green,
                      buttonTitle: 'Request Artisan',
                      blurRadius: 7.0,
                      roundedEdge: 2.5,
                      onTap: () async {
                        if (_name.text != '' &&
                            _description.text != '' &&
                            _address.text != '' &&
                            _title.text != '' &&
                            _date.text != '') {
                          HireArtisanModel model = HireArtisanModel(
                            artisanId: artisanId,
                            workDescription: _description.text,
                            workTitle: _title.text,
                            ownerName: _name.text,
                            timestamp: timestamp,
                            startDate: _date.text,
                            address: _address.text,
                            isComplete: false,
                            isApproved: false,
                            hasAgreed: false,
                            seen: false,
                            artisanName: artisanName,
                            price: 0,
                            status: 'Artisan Haven\'t responded',
                          );
                          auth.requestArtisan(model).then((value) async {
                            await activityFeedRef
                                .doc(artisanId)
                                .collection('requests')
                                .doc()
                                .set({
                              'seen': false,
                              'ownerName': _name.text,
                              'artisanId': artisanId,
                              'ownerId': auth.userId,
                              'title': _title.text,
                              'type': 'request',
                              'sub': 'requested',
                              'artisanName': artisanName,
                              'timestamp': timestamp,
                            });
                            await adminFeed.doc().set({
                              'seen': false,
                              'ownerName': _name.text,
                              'ownerId': auth.userId,
                              'title': _title.text,
                              'artisanId': artisanId,
                              'artisanName': artisanName,
                              'type': 'request',
                              'sub': 'requested',
                              'timestamp': timestamp,
                            });
                            Navigator.pop(context);
                          });
                        } else {
                          Fluttertoast.showToast(
                              msg: "Pls complete all fields",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
