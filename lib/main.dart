import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:vidyalayaapp/Pages/size_config.dart';
import 'package:vidyalayaapp/Pages/splash.dart';
import 'dart:async';

import 'package:vidyalayaapp/dismisskeyboard.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
   await Firebase.initializeApp();
   configLoading();
    runApp(const MyApp());
}

 void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
   return LayoutBuilder(
     builder: (context, constraints) {
       return OrientationBuilder(
         builder:(context, orientation){
           SizeConfig().init(constraints,orientation);
            return DismissKeyboard(
              child: MaterialApp(
              title: 'Vidyalaya',
              theme: ThemeData(
                primarySwatch: Colors.blue,
                visualDensity: VisualDensity.adaptivePlatformDensity,
                errorColor: Colors.orangeAccent
              ),
              debugShowCheckedModeBanner: false,
              home:  const Splash(),
              builder: EasyLoading.init(),
          ),
            );
         },
       );
     }
   );
  }
}
