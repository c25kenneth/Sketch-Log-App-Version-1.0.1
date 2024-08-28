import 'package:canvas_vault/HomeScreen.dart';
import 'package:canvas_vault/auth/Welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedInStatus = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(homeWidget: loggedInStatus == true ? HomeScreen(uid: prefs.getString('uid')!) : const Welcome()));
}

class MyApp extends StatelessWidget {
  final Widget homeWidget; 
  const MyApp({super.key, required this.homeWidget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: homeWidget,
    );
  }
}

