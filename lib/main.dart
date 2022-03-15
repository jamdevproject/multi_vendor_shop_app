import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_vendor_shop_app/screens/main_screen.dart';
import 'package:multi_vendor_shop_app/screens/on_boarding_screen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';




void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //remove banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //for time being will keep theme color as orange
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Lato'
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>const SplashScreen(),
        OnBoardingScreen.id : (context)=>const OnBoardingScreen(),
        MainScreen.id : (context)=>const MainScreen(),
      },
    );
  }
}


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String id ='splash-screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final store = GetStorage();
  @override
  void initState() {
    Timer(const Duration(
      seconds: 3 //first 3 seconds will show app logo and will move to on board screen
    ),(){
      //first while starting app, app will check weather this user already seen onBoarding screen or not
      //for that it should read getStorage
      //this is actually same use of shared preference
      //right 'onBoarding' value is nulll
      bool? _boarding = store.read('onBoarding');
      _boarding == null ? Navigator.pushReplacementNamed(context, OnBoardingScreen.id) :
      _boarding == true ?  Navigator.pushReplacementNamed(context, MainScreen.id) :
      //if false
      Navigator.pushReplacementNamed(context, OnBoardingScreen.id);
    },);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge,overlays: []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}

//now lets setup firebase.
//if font didnt change in your app, you can close and run again
//I will do that after firebase setup.
//and also
//now open flutterfire
//before re

//before restart app, lets add firestore too








