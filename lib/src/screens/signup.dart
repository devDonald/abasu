import 'package:abasu/src/models/application_user.dart';
import 'package:abasu/src/models/constants.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:abasu/src/services/firestore_service.dart';
import 'package:abasu/src/styles/colors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  final bool asArtisan;

  static const String id = 'RegisterScreen';

  const Signup({Key key, this.asArtisan}) : super(key: key);

  @override
  _SignupState createState() => _SignupState(asArtisan: asArtisan);
}

var isLargeScreen = false;

class _SignupState extends State<Signup> {
  bool asArtisan;
  _SignupState({this.asArtisan});

  final _formKey = GlobalKey<FormState>();
  //final AuthService _authService = AuthService();
  bool loading = false;
  //final DialogService _dialogService = locator<DialogService>();
  ProgressDialog pr;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  final TextEditingController _fullName = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _experience = TextEditingController();
  final TextEditingController _charge = TextEditingController();

  String selectedState, selectedGender, category;

  String error = '';

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    pr = new ProgressDialog(context);
    pr.style(message: 'Please wait, Creating new User');

    final deviceWidth = MediaQuery.of(context).size.width;
    final deviceHeight = MediaQuery.of(context).size.height;

    if (deviceHeight >= 800.0) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    if (deviceWidth >= 420.0) {
      isLargeScreen = true;
    } else {
      isLargeScreen = false;
    }
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              //height: deviceHeight,
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 72.1),
                        ScreenTitleIndicator(
                          title: 'Register',
                        ),
                        SizedBox(
                          height: 20.9,
                        ),
                        Form(
                          key: _formKey,
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                AuthTextFeildLabel(
                                  label: 'Full Name ',
                                ),
                                AuthTextField(
                                  width: double.infinity,
                                  formField: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _fullName,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Email Address ',
                              ),
                              AuthTextField(
                                width: double.infinity,
                                formField: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _email,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (val) => val.trim().isEmpty
                                      ? 'Enter Email Address'
                                      : !val.trim().contains('@') ||
                                              !val.trim().contains('.')
                                          ? 'enter a valid email address'
                                          : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'Password ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _password,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        obscureText: true,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return '8 or more characters';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'Retype Password ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _confirmPassword,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please confirm password';
                                          } else if (value != _password.text) {
                                            return 'password mismatch';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // address

                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Home Address ',
                              ),
                              AuthTextField(
                                width: double.infinity,
                                formField: TextFormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    controller: _address,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                    ),
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    validator: (val) {
                                      if (val.isEmpty) {
                                        return 'enter address';
                                      }
                                      return null;
                                    }),
                              ),
                            ],
                          ),
                        ),
                        // City and State
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'City ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _city,
                                        textCapitalization:
                                            TextCapitalization.sentences,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'city cannot be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //State
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'State',
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      child: DropdownButtonFormField<String>(
                                        hint: Text('Select State'),
                                        value: selectedState,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 25.0,
                                        elevation: 0,
                                        style: TextStyle(color: kBlackColor),
                                        decoration: InputDecoration(),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            selectedState = newValue;
                                            print(selectedState);
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        //Date of Birth and Gender
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'Date of Birth ',
                                    ),
                                    AuthTextField(
                                      width: MediaQuery.of(context).size.width /
                                              2.3 +
                                          1,
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _dob,
                                        keyboardType: TextInputType.datetime,
                                        textCapitalization:
                                            TextCapitalization.none,
                                        decoration: InputDecoration(
                                          hintText: '19-12-1990',
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'D.O.B cannot be empty';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //State
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    AuthTextFeildLabel(
                                      label: 'Gender',
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.3,
                                      child: DropdownButtonFormField<String>(
                                        hint: Text('Select Gender'),
                                        value: selectedGender,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 25.0,
                                        elevation: 0,
                                        style: TextStyle(color: kBlackColor),
                                        decoration: InputDecoration(),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            selectedGender = newValue;
                                            print(selectedGender);
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        //as an artisan
                        asArtisan
                            ? Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                AuthTextFeildLabel(
                                                  label: 'Years of Experience',
                                                ),
                                                AuthTextField(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  formField: TextFormField(
                                                    autovalidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    controller: _experience,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    textCapitalization:
                                                        TextCapitalization.none,
                                                    decoration: InputDecoration(
                                                      hintText: '3',
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none),
                                                    ),
                                                    validator: (value) {
                                                      if (value.isEmpty) {
                                                        return 'experience cannot be empty';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          //State
                                          Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                AuthTextFeildLabel(
                                                  label: 'Skill Category',
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.1,
                                                  child:
                                                      DropdownButtonFormField<
                                                          String>(
                                                    hint: Text(
                                                        'Select your Skill'),
                                                    value: category,
                                                    icon: Icon(
                                                        Icons.arrow_drop_down),
                                                    iconSize: 25.0,
                                                    elevation: 0,
                                                    style: TextStyle(
                                                        color: kBlackColor),
                                                    decoration:
                                                        InputDecoration(),
                                                    onChanged:
                                                        (String newValue) {
                                                      setState(() {
                                                        category = newValue;
                                                        print(category);
                                                      });
                                                    },
                                                    items: artisanCategory.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          AuthTextFeildLabel(
                                            label: 'Average Charge Per Work ',
                                          ),
                                          AuthTextField(
                                            width: double.infinity,
                                            formField: TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                controller: _charge,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide.none),
                                                ),
                                                keyboardType:
                                                    TextInputType.text,
                                                textCapitalization:
                                                    TextCapitalization
                                                        .sentences,
                                                validator: (val) {
                                                  if (val.isEmpty) {
                                                    return 'enter charge per work';
                                                  }
                                                  return null;
                                                }),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : new Container(),

                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AuthTextFeildLabel(
                                label: 'Phone Number ',
                              ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    flex: 4,
                                    child: AuthTextField(
                                      formField: TextFormField(
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        controller: _phoneNumber,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none),
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter phone number';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 25.0),
                              PrimaryButton(
                                height: 45.0,
                                width: double.infinity,
                                color: Colors.green,
                                buttonTitle: 'Create an account',
                                blurRadius: 7.0,
                                roundedEdge: 2.5,
                                onTap: () async {
                                  if (asArtisan) {
                                    if (_formKey.currentState.validate()) {
                                      if (_phoneNumber.text != '' &&
                                          _fullName.text != '' &&
                                          _email.text != '' &&
                                          _confirmPassword.text != '' &&
                                          _charge.text != '' &&
                                          _password.text != '') {
                                        if (_password.text ==
                                            _confirmPassword.text) {
                                          pr.show();
                                          UsersModel user = UsersModel(
                                              email: _email.text,
                                              phone: _phoneNumber.text,
                                              gender: selectedGender,
                                              country: 'Nigeria',
                                              isVerified: false,
                                              address: _address.text,
                                              charge: int.parse(_charge.text),
                                              skill: category,
                                              experience: _experience.text,
                                              asArtisan: asArtisan,
                                              isHired: false,
                                              hasWorks: false,
                                              state: selectedState,
                                              city: _city.text,
                                              dob: _dob.text,
                                              fullName: _fullName.text,
                                              imageUrl: dummyProfilePic);
                                          await auth
                                              .createAccount(_email.text,
                                                  _password.text, user)
                                              .then((value) async {
                                            pr.hide();

                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/landing',
                                                (r) => false);
                                          }).catchError((onError) {});
                                        } else {
                                          setState(() {
                                            error = 'password mismatch';
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          error = 'PLEASE COMPLETE ALL FIELDS';
                                        });
                                      }
                                    }
                                  } else {
                                    if (_formKey.currentState.validate()) {
                                      if (_phoneNumber.text != '' &&
                                          _fullName.text != '' &&
                                          _email.text != '' &&
                                          _confirmPassword.text != '' &&
                                          _password.text != '') {
                                        if (_password.text ==
                                            _confirmPassword.text) {
                                          pr.show();
                                          UsersModel user = UsersModel(
                                              email: _email.text,
                                              phone: _phoneNumber.text,
                                              gender: selectedGender,
                                              country: 'Nigeria',
                                              isVerified: false,
                                              asArtisan: asArtisan,
                                              state: selectedState,
                                              address: _address.text,
                                              city: _city.text,
                                              dob: _dob.text,
                                              fullName: _fullName.text,
                                              imageUrl: dummyProfilePic);
                                          await auth
                                              .createAccount(_email.text,
                                                  _password.text, user)
                                              .then((value) async {
                                            pr.hide();

                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                '/landing',
                                                (r) => false);
                                          }).catchError((onError) {});
                                        } else {
                                          setState(() {
                                            error = 'password mismatch';
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          error = 'PLEASE COMPLETE ALL FIELDS';
                                        });
                                      }
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 25.0),
                              Center(
                                child: Text(
                                  error,
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),

                              SizedBox(height: 15.0),
                              //
                              SizedBox(height: 15.0),
                              Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Login(),
                                        ));
                                  },
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Have an Account? ',
                                      style: TextStyle(
                                        color: kBlackColor,
                                        fontFamily: 'Nunito',
                                        fontSize: 15.0,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: 'Login',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontFamily: 'Nunito',
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 23.5,
                              ),
                              Center(
                                child: Container(
                                  width: 288.0,
                                  child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      text:
                                          'By creating an account you agree to AbasuMobile’s ',
                                      style: TextStyle(
                                        fontSize: 13.0,
                                        color: kBlackColor,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                setState(() {
                                                  Navigator.pushNamed(context,
                                                      '/termsOfService');
                                                });
                                              },
                                            text: 'Terms of Service ',
                                            style: TextStyle(
                                              fontWeight: kBold,
                                              color: kButtonsOrange,
                                              fontSize: 13.0,
                                            )),
                                        TextSpan(text: 'and '),
                                        TextSpan(
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              setState(() {
                                                Navigator.pushNamed(context,
                                                    '/privacyAndPolicy');
                                              });
                                            },
                                          text: 'Privacy Policy. ',
                                          style: TextStyle(
                                            fontWeight: kBold,
                                            fontSize: 13.0,
                                            color: Colors.green,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
