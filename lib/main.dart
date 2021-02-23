import 'package:abasu/bottom_navigation/home.dart';
import 'package:abasu/bottom_navigation/my_profile.dart';
import 'package:abasu/bottom_navigation/notifications.dart';
import 'package:abasu/landing.dart';
import 'package:abasu/providers/login_provider.dart';
import 'package:abasu/src/construction/buy_product.dart';
import 'package:abasu/src/construction/construction_materials.dart';
import 'package:abasu/src/providers/location_provider.dart';
import 'package:abasu/src/screens/edit_profile.dart';
import 'package:abasu/src/screens/login.dart';
import 'package:abasu/src/screens/privacy_policy.dart';
import 'package:abasu/src/screens/signup.dart';
import 'package:abasu/src/screens/splash_screen.dart';
import 'package:abasu/src/screens/terms_of_services.dart';
import 'package:abasu/src/screens/user_type.dart';
import 'package:abasu/src/services/all_services.dart';
import 'package:abasu/src/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'bottom_navigation/about_us.dart';

final authId = AuthService();
final loginType = CheckLoginAs();
final orderDestination = LocationProvider();
final allServices = AllServices();
//final authBloc = AuthBloc();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => authId),
        ChangeNotifierProvider(create: (context) => orderDestination),
        ChangeNotifierProvider(create: (context) => loginType),
        ChangeNotifierProvider(create: (context) => allServices),
        StreamProvider<User>.value(
          value: FirebaseAuth.instance.authStateChanges(),
        ),
        // See implementation details in next sections
      ],
      child: MyApp(),
    ),
  );

  @override
  void dispose() {
    authId.dispose();
    loginType.dispose();
    orderDestination.dispose();
    allServices.dispose();
  }
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //final deviceWidth = MediaQuery.of(context).size.width;
    //final deviceHeight = MediaQuery.of(context).size.height;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //default theme

      initialRoute: '/splash',
      routes: {
        '/landing': (context) => Landing(),
        '/splash': (context) => SplashScreen(),
        '/login': (context) => Login(),
        '/loginAs': (context) => LogInAs(),
        '/register': (context) => Signup(),
        '/myProfile': (context) => MyProfile(),
        '/editProfile': (context) => EditProfile(),
        '/termsOfService': (context) => TermsOfService(),
        '/privacyAndPolicy': (context) => PrivacyAndPolicy(),
        '/about': (context) => AboutUs(),
        '/home': (context) => Home(),
        '/buyProduct': (context) => BuyProduct(),
        '/construction': (context) => ConstructionMaterials(),
        '/notification': (context) => NotificationCenter(),
      },
    );
  }
}
