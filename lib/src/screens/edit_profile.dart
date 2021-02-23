import 'dart:io';

import 'package:abasu/src/models/application_user.dart';
import 'package:abasu/src/models/constants.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:abasu/src/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final String name,
      userId,
      address,
      email,
      specialty,
      phone,
      city,
      state,
      category,
      gender;
  final String experience, charge;
  final bool asArtisan;

  EditProfile(
      {Key key,
      this.name,
      this.address,
      this.email,
      this.specialty,
      this.phone,
      this.city,
      this.state,
      this.category,
      this.gender,
      this.experience,
      this.charge,
      this.asArtisan,
      this.userId})
      : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File addedImage;
  final _picker = ImagePicker();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _experience = TextEditingController();
  final _city = TextEditingController();
  final _charge = TextEditingController();

  bool asArtisan = false;
  ProgressDialog pr;
  String error = "";

  String genderValue;
  String specialty, state;

  @override
  void initState() {
    _name.text = widget.name;
    genderValue = widget.gender;
    _experience.text = widget.experience;
    specialty = widget.specialty;
    _address.text = widget.address;
    _email.text = widget.email;
    _phone.text = widget.phone;
    _city.text = widget.city;
    asArtisan = widget.asArtisan;
    state = widget.state;
    _charge.text = widget.charge;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, Updating Profile');

    // dateOfBirth = '${selectedDate.toLocal()}'.split(' ')[0];

    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.red[100],
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: Colors.green,
        title: Text('Update Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            )),
        titleSpacing: -5.0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.only(top: 15),
          width: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 10,
                    bottom: 50,
                  ),
                  padding: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0.0, 2.5),
                        blurRadius: 5,
                        color: Colors.red[100],
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            left: 8,
                            right: 8,
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.name,
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  labelText: 'Full Name',
                                ),
                              ),
                              SizedBox(height: 5),

                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _address,
                                decoration: InputDecoration(
                                  labelText: 'Home Address',
                                ),
                              ),
                              SizedBox(height: 15),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: _city,
                                maxLines: 1,
                                maxLength: 100,
                                decoration: InputDecoration(
                                  labelText: 'City',
                                ),
                              ),
                              SizedBox(height: 15),

                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('State'),
                                    SizedBox(height: 15),
                                    DropdownButtonFormField<String>(
                                      hint: Text('State'),
                                      value: state,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 25.0,
                                      elevation: 0,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          state = newValue;
                                          print(state);
                                        });
                                      },
                                      items: states
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              //Gender
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Gender'),
                                    SizedBox(height: 15),
                                    DropdownButtonFormField<String>(
                                      hint: Text('Gender'),
                                      value: genderValue,
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 25.0,
                                      elevation: 0,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(),
                                      onChanged: (String newValue) {
                                        setState(() {
                                          genderValue = newValue;
                                          print(genderValue);
                                        });
                                      },
                                      items: gender
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 15),
                                  ],
                                ),
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.none,
                                keyboardType: TextInputType.emailAddress,
                                controller: _email,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                ),
                              ),
                              TextFormField(
                                textCapitalization: TextCapitalization.none,
                                keyboardType: TextInputType.phone,
                                controller: _phone,
                                decoration: InputDecoration(
                                  labelText: 'Phone',
                                ),
                              ),
                              asArtisan
                                  ? TextFormField(
                                      textCapitalization:
                                          TextCapitalization.none,
                                      controller: _experience,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Years of Experience',
                                      ),
                                    )
                                  : new Container(),

                              asArtisan
                                  ? TextFormField(
                                      textCapitalization:
                                          TextCapitalization.none,
                                      controller: _charge,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'Average Charge Per Day',
                                      ),
                                    )
                                  : new Container(),
                              //
                              asArtisan
                                  ? Column(
                                      children: [
                                        SizedBox(height: 10),
                                        DropdownButtonFormField<String>(
                                          hint: Text('Skill Category'),
                                          value: specialty,
                                          icon: Icon(Icons.arrow_drop_down),
                                          iconSize: 25.0,
                                          elevation: 0,
                                          style: TextStyle(color: Colors.black),
                                          decoration: InputDecoration(),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              specialty = newValue;
                                              print('$specialty');
                                            });
                                          },
                                          items: artisanCategory
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(height: 15),
                                      ],
                                    )
                                  : Container(),
                              SizedBox(height: 15),

                              Align(
                                alignment: Alignment.bottomRight,
                                child: PrimaryButton(
                                  color: Colors.green,
                                  roundedEdge: 5,
                                  blurRadius: 3,
                                  buttonTitle: 'Update Profile',
                                  width: 150.0,
                                  height: 40.0,
                                  onTap: () async {
                                    if (asArtisan) {
                                      if (_name.text != '' &&
                                          _address.text != '' &&
                                          _phone.text != '' &&
                                          _city.text != '' &&
                                          _email.text != '' &&
                                          genderValue != null &&
                                          specialty != null &&
                                          _experience.text != '' &&
                                          state != null &&
                                          _charge.text != '') {
                                        UsersModel user = UsersModel(
                                            fullName: _name.text,
                                            address: _address.text,
                                            phone: _phone.text,
                                            city: _city.text,
                                            email: _email.text,
                                            gender: genderValue,
                                            skill: specialty,
                                            state: state,
                                            userId: widget.userId,
                                            experience: _experience.text,
                                            charge: int.parse(_charge.text));
                                        await auth
                                            .updateUserData(user)
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: "update successful",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          Navigator.pop(context);
                                        }).catchError((error) {
                                          Fluttertoast.showToast(
                                              msg: "failed, try again",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        setState(() {
                                          error = 'please complete every field';
                                        });
                                      }
                                    } else {
                                      if (_name.text != '' &&
                                          _address.text != '' &&
                                          _phone.text != '' &&
                                          _city.text != '' &&
                                          _email.text != '' &&
                                          genderValue != null &&
                                          state != null) {
                                        UsersModel user = UsersModel(
                                          fullName: _name.text,
                                          address: _address.text,
                                          phone: _phone.text,
                                          city: _city.text,
                                          email: _email.text,
                                          gender: genderValue,
                                          state: state,
                                          userId: widget.userId,
                                        );
                                        await auth
                                            .updateUserData(user)
                                            .then((value) {
                                          Fluttertoast.showToast(
                                              msg: "update successful",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.green,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          Navigator.pop(context);
                                        }).catchError((error) {
                                          Fluttertoast.showToast(
                                              msg: "failed, try again",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                          Navigator.pop(context);
                                        });
                                      } else {
                                        setState(() {
                                          error = 'please complete every field';
                                        });
                                      }
                                    }
                                  },
                                ),
                              ),
                              SizedBox(height: 15),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
