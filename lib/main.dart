import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/user_login_screen.dart';
import 'feature/map/bindings/initial_binding.dart';
import 'helpers/dependency_injection.dart';
// import 'package:ridetohealthdriver/feature/earning/presentation/screen/ride_history_screen.dart';

// import 'app.dart';
// import 'feature/earning/presentation/screen/earning_screen.dart';
// import 'feature/identity/presentation/screens/verify_identity_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
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
          // AppMain(),
          UserLoginScreen()

      //SplashScreen(nextScreen: Onboarding1()),

      //  RideHistoryPage(),
      //MapScreenTest(),
      // SearchDestinationScreen(),
      //08i AppMain(),

      // SplashScreen(nextScreen: Onboarding1()), 

    );
  }
}
