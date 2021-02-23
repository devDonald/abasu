import 'package:abasu/src/models/application_user.dart';
import 'package:abasu/src/models/hireartisan_model.dart';
import 'package:abasu/src/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends ChangeNotifier {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final DateTime timestamp = DateTime.now();
  final usersRef = FirebaseFirestore.instance.collection('users');
  String userId;
  final GoogleSignIn googleSignIn = new GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UsersModel _userFromFirebaseUser(User user) {
    if (user != null) {
      userId = user.uid;
      return UsersModel(userId: user.uid, email: user.email);
    } else {
      return null;
    }
  }

  Future<void> addUser(UsersModel user) {
    return _db.collection('users').doc(user.userId).set(user.toMap());
  }

  Future<UsersModel> fetchUser(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .get()
        .then((snapshot) => UsersModel.fromFirestore(snapshot.data()));
  }

  Stream<List<String>> fetchUnitTypes() {
    return _db.collection('types').doc('units').snapshots().map((snapshot) =>
        snapshot
            .data()['production']
            .map<String>((type) => type.toString())
            .toList());
  }

  Future<void> setProduct(Product product) {
    var options = SetOptions(merge: true);
    return _db
        .collection('products')
        .doc(product.productId)
        .set(product.toMap(), options);
  }

  Future<Product> fetchProduct(String productId) {
    return _db
        .collection('products')
        .doc(productId)
        .get()
        .then((snapshot) => Product.fromFirestore(snapshot.data()));
  }

  Stream<List<Product>> fetchProductsBySubCategory(String subCategory) {
    return _db
        .collection('products')
        .where('subCategory', isEqualTo: subCategory)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
            snapshot.map((doc) => Product.fromFirestore(doc.data())).toList());
  }

  Stream<List<Product>> fetchAvailableProducts() {
    return _db
        .collection('products')
        .where('availableUnits', isGreaterThan: 0)
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
            snapshot.map((doc) => Product.fromFirestore(doc.data())).toList());
  }

  Stream<List<Product>> fetchAllProducts() {
    return _db
        .collection('products')
        .snapshots()
        .map((query) => query.docs)
        .map((snapshot) =>
            snapshot.map((doc) => Product.fromFirestore(doc.data())).toList());
  }

  Future<UsersModel> fetchVendor(String vendorId) {
    return _db
        .collection('vendors')
        .doc(vendorId)
        .get()
        .then((snapshot) => UsersModel.fromFirestore(snapshot.data()));
  }

  Future signInUserWithEmailAndPassword(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      Fluttertoast.showToast(
          msg: "Login successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      //await _populateCurrentUser(result.user);

      return _userFromFirebaseUser(user);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Login Failed",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
  }

  //Sign in with google
  Future signInWithGoogle(bool asArtisan) async {
    try {
      //sign in to use's google account
      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

      UserCredential authResult =
          (await _auth.signInWithCredential(credential));

      User user = authResult.user;
      //updateUserData(user, asArtisan);

      DocumentSnapshot doc = await usersRef.doc(user.uid).get();
      doc = await usersRef.doc(user.uid).get();

      Fluttertoast.showToast(
          msg: "Signed In successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);

      return _userFromFirebaseUser(authResult.user);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<String> updateUserData(UsersModel user) async {
    try {
      DocumentReference ref = _db.collection('users').doc(user.userId);
      ref.update({
        'fullName': user.fullName,
        'email': user.email,
        'phone': user.phone,
        'gender': user.gender,
        'experience': user.experience,
        'charge': user.charge,
        'skill': user.skill,
        'state': user.state,
        'city': user.city,
        'address': user.address
      });

      return ref.id;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return null;
    }
  }

  Future createAccount(
      String email, String password, UsersModel userModel) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = result.user;
      userModel.userId = user.uid;

      usersRef.doc(user.uid).set(userModel.toMap());

      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }

  Future requestArtisan(HireArtisanModel model) async {
    DocumentReference requestRef = _db.collection("artisanRequests").doc();
    //String orderId = requestRef.id;
    model.workId = requestRef.id;
    model.ownerId = userId;

    requestRef.set(model.toJson()).then((value) {
      Fluttertoast.showToast(
          msg: "Request successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Request failed, try again",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email).then((_) {
      Fluttertoast.showToast(
          msg: "Password Reset successful",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }).catchError((error) {
      Fluttertoast.showToast(
          msg: "Password Reset Failed, Please input correct email",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    });
  }

  //Sign out a current user from Firebase, google and facebook.
  Future<Null> signOutUser() async {
    try {
      // Sign out with firebase
      await _auth.signOut().then((value) async {
        if (googleSignIn != null) {
          await googleSignIn.signOut();
        }

        Fluttertoast.showToast(
            msg: "Logged out successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      });
      // Sign out with google

    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
