import 'package:country_code_picker/country_localizations.dart';
import 'package:flutter/material.dart';
import 'package:food_court/notifier/cart_notifier.dart';
import 'package:food_court/notifier/item_notifier.dart';
import 'package:food_court/notifier/shop_notifier.dart';
import 'package:food_court/screens/registration_screen.dart';
import 'screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// import 'package:google_fonts/google_fonts.dart';
// pod 'Firebase/Analytics'

// import UIKit
// import Firebase

// @UIApplicationMain
// class AppDelegate: UIResponder, UIApplicationDelegate {

//   var window: UIWindow?

//   func application(_ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions:
//       [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//     FirebaseApp.configure()

//     return true
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ItemNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => ShopNotifier(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartNotifier(),
        )
      ],
      child: FoodCourt(),
    ),
  );
}

class FoodCourt extends StatelessWidget {
  final Future<FirebaseApp> _firebaseApp = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sri Shakthi Food Court',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      supportedLocales: [Locale('en', 'US')],
      localizationsDelegates: [CountryLocalizations.delegate],
      home: FutureBuilder(
        future: _firebaseApp,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              heightFactor: 1,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            print('You have an error ${snapshot.error.toString()}');
            return Text('Oops! Something went wrong!');
          } else if (snapshot.hasData) {
            return RegistrationScreen();
            // return HomePage(title: 'Sri Shakthi Food Court');
          } else {
            return Center(
              heightFactor: 1,
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
