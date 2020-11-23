import 'package:abasu/src/routes.dart';
import 'package:abasu/src/screens/landing.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:abasu/src/screens/user_type.dart';
import 'package:abasu/src/services/firestore_service.dart';
import 'package:abasu/src/styles/colors.dart';
import 'package:abasu/src/styles/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import 'blocs/auth_bloc.dart';
import 'blocs/customer_bloc.dart';
import 'blocs/product_bloc.dart';
import 'blocs/vendor_bloc.dart';
final authBloc = AuthBloc();
final productBloc = ProductBloc();
final customerBloc = CustomerBloc();
final vendorBloc = VendorBloc();
final firestoreService = FirestoreService();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => authBloc),
        Provider(create: (context) => productBloc),
        Provider(create: (context) => customerBloc,),
        Provider(create: (context) => vendorBloc,),
        FutureProvider(create: (context) => authBloc.isLoggedIn()),
        StreamProvider(create: (context) => firestoreService.fetchUnitTypes())
      ],
      child: PlatformApp());
  }

  @override
  void dispose() {
    authBloc.dispose();
    productBloc.dispose();
    customerBloc.dispose();
    vendorBloc.dispose();
    super.dispose();
  }
}

class PlatformApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    var isLoggedIn = Provider.of<bool>(context);

    if (Platform.isIOS) {
      return CupertinoApp(
        home: (isLoggedIn == null) ? loadingScreen(true) : (isLoggedIn == true ) ? Landing() : LogInAs(),
        onGenerateRoute: Routes.cupertinoRoutes,
        theme: CupertinoThemeData(  
          primaryColor: AppColors.green,
          scaffoldBackgroundColor: Colors.white,
          textTheme: CupertinoTextThemeData(  
            tabLabelTextStyle: TextStyles.suggestion
          )
        )
      ); 
    } else {
      return MaterialApp(
        home: (isLoggedIn == null) ? loadingScreen(false) : (isLoggedIn == true ) ? Landing() : LogInAs(),
        onGenerateRoute: Routes.materialRoutes,
        theme: ThemeData(scaffoldBackgroundColor: Colors.white)
      );
    }
  }

  Widget loadingScreen(bool isIOS){
    return (isIOS)
    ? CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator(),),)
    : Scaffold(body: Center(child: CircularProgressIndicator()));
  }

}
