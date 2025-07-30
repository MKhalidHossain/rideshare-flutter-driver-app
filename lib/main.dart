import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/app.dart';

import 'core/onboarding/presentation/screens/onboarding1.dart';
import 'feature/map/bindings/initial_binding.dart';
import 'core/onboarding/presentation/screens/spashScreen.dart';

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
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      home:
          // VerifyIdentityScreen(),
          //MapScreenTest(),
          // SearchDestinationScreen(),
          AppMain(),

      //SplashScreen(nextScreen: Onboarding1()),
    );
  }
}
