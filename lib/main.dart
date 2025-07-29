import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app.dart';
import 'feature/identity/presentation/screens/verify_identity_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF303644),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home:
      VerifyIdentityScreen(),
          //MapScreenTest(),
          // SearchDestinationScreen(),
         //08i AppMain(),
      // SplashScreen(nextScreen: Onboarding1()),
    );
  }
}
