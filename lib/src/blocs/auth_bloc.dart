
import 'dart:async';


import 'package:abasu/providers/login_provider.dart';
import 'package:abasu/src/models/application_user.dart';
import 'package:abasu/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthBloc {
  final _email = BehaviorSubject<String>();
  final _password = BehaviorSubject<String>();
  final _fullName = BehaviorSubject<String>();
  final _address = BehaviorSubject<String>();
  final _city = BehaviorSubject<String>();
  final _state = BehaviorSubject<String>();
  final _phone = BehaviorSubject<String>();
  final _gender = BehaviorSubject<String>();
  final _country = BehaviorSubject<String>();
  final _skill = BehaviorSubject<String>();
  final _experience = BehaviorSubject<String>();
  final _user = BehaviorSubject<UsersModel>();
  final _userType =  CheckLoginAs();
  final _errorMessage = BehaviorSubject<String>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final AuthService _firestoreService = AuthService();

  //Get Data
  Stream<String> get email => _email.stream.transform(validateEmail);
  Stream<String> get password => _password.stream.transform(validatePassword);
  Stream<String> get fullName => _fullName.stream.transform(validateFullName);
  Stream<String> get address => _address.stream.transform(validateAddress);
  Stream<String> get city => _city.stream.transform(validateCity);
  Stream<String> get state => _state.stream;
  Stream<String> get phone => _phone.stream.transform(validatePhone);
  Stream<String> get skill => _skill.stream;
  Stream<int> get experience => _experience.stream.transform(validateExperience);
  Stream<String> get gender => _gender.stream;
  Stream<String> get country => _country.stream;


  Stream<bool> get isValid => CombineLatestStream.combine9(email, password,fullName,city,address,state,
      country,gender,phone, (email,password,fullName,city,address,state,country,gender,phone)=> true);

  Stream<bool> get isLoginValid => CombineLatestStream.combine2(email, password,(email,password)=> true);

  Stream<UsersModel> get user => _user.stream;
  Stream<String> get errorMessage => _errorMessage.stream;
  String get userId => _user.value.userId;

  //Set Data
  Function(String) get changeEmail => _email.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(String) get changeFullName => _fullName.sink.add;
  Function(String) get changeCity => _city.sink.add;
  Function(String) get changeAddress => _address.sink.add;
  Function(String) get changeState => _state.sink.add;
  Function(String) get changeCountry => _country.sink.add;
  Function(String) get changeGender => _gender.sink.add;
  Function(String) get changePhone => _phone.sink.add;
  Function(String) get changeSkill => _skill.sink.add;
  Function(String) get changeExperience => _experience.sink.add;

  dispose(){
    _email.close();
    _password.close();
    _user.close();
    _errorMessage.close();
    _skill.close();
    _experience.close();
    _country.close();
    _city.close();
    _phone.close();
    _fullName.close();
    _address.close();
    _state.close();
    _gender.close();
  }

  //Transformers
  final validateEmail = StreamTransformer<String,String>.fromHandlers(handleData: (email, sink){
    if (regExpEmail.hasMatch(email.trim())){
      sink.add(email.trim());
    }else {
      sink.addError('Must Be Valid Email Address');
    }
  });

    final validatePassword = StreamTransformer<String,String>.fromHandlers(handleData: (password, sink){
    if (password.length >= 8){
      sink.add(password.trim());
    }else {
      sink.addError('8 Character Minimum');
    }
  });
  final validateFullName = StreamTransformer<String, String>.fromHandlers(
      handleData: (fullName, sink) {
        if (fullName != null) {
          sink.add(fullName.trim());
        } else{
          sink.addError('full name must not be empty');
        }
      });

  final validateAddress = StreamTransformer<String, String>.fromHandlers(
      handleData: (address, sink) {
        if (address != null) {
          sink.add(address.trim());
        } else{
          sink.addError('address must not be empty');
        }
      });

  final validateCity = StreamTransformer<String, String>.fromHandlers(
      handleData: (city, sink) {
        if (city != null) {
          sink.add(city.trim());
        }else{
          sink.addError('City must not be empty');
        }
      });

  final validateExperience = StreamTransformer<String, int>.fromHandlers(
      handleData: (experience, sink) {
        if (experience != null) {
          sink.add(int.parse(experience));
        }else{
          sink.addError('Years of experience must not be empty');
        }
      });

  //validate phone number
  final validatePhone = StreamTransformer<String, String>.fromHandlers(
      handleData: (phone, sink) {
        if (phone != null) {
          if (phone.length >= 11) {
            sink.add(phone.trim());
          } else{
            sink.addError('Phone Number must be 11 characters');
          }
        } else{
          sink.addError('Phone Number must not be empty');
        }
      });
  

  //Functions
  signupEmail() async{
    try{
      UserCredential authResult = await _auth.createUserWithEmailAndPassword(email: _email.value.trim(), password: _password.value.trim()).catchError((onError){
        _errorMessage.sink.add(onError.toString());

      });
      var user = UsersModel(userId: authResult.user.uid, email: _email.value.trim(),
          address: _address.value.trim(),
          fullName: _fullName.value.trim(),
          country: _country.value,
          state: _state.value,
          gender: _gender.value,
          city: _city.value.trim(),
          phone: _phone.value.trim(),
          isVerified: false,
          experience: _experience.value,
          skill: _skill.value,
          imageUrl: 'https://i.postimg.cc/BvdKN5M8/image.png',
          asArtisan: _userType.asArtisan);
      await _firestoreService.addUser(user);
      _user.sink.add(user);
    } on PlatformException catch (error){
      print(error);
      _errorMessage.sink.add(error.message);
    }
  }

    loginEmail() async{
    try{
      UserCredential authResult = await _auth.signInWithEmailAndPassword(email: _email.value.trim(), password: _password.value.trim());
      var user = await _firestoreService.fetchUser(authResult.user.uid);
      _user.sink.add(user);
    } on PlatformException catch (error){
      print(error);
      _errorMessage.sink.add(error.message);
    }
  }

  Future<bool> isLoggedIn() async {
    var firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return false;

    var user = await _firestoreService.fetchUser(firebaseUser.uid);
    if (user == null) return false;

    _user.sink.add(user);
    return true;
  }

  logout() async {
    await _auth.signOut();
    _user.sink.add(null);
  }

  clearErrorMessage(){
    _errorMessage.sink.add('');
  }

}