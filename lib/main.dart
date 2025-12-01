import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/payment/screen/stripe_connect_screen.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/user_login_screen.dart';
import 'core/onboarding/presentation/screens/constantSpashScreen.dart';
import 'core/onboarding/presentation/screens/onboarding1.dart';
import 'feature/auth/controllers/auth_controller.dart';
import 'feature/map/bindings/initial_binding.dart';
import 'helpers/dependency_injection.dart';
// import 'package:ridetohealthdriver/feature/earning/presentation/screen/ride_history_screen.dart';

// import 'app.dart';
// import 'feature/earning/presentation/screen/earning_screen.dart';
// import 'feature/identity/presentation/screens/verify_identity_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initDI();
  // socket();
  runApp( MyApp());
}

// void socket() {
//   SocketClient().connect(
//     url: 'http://10.10.5.85:5001',
//     autoConnect: true,
//   );
// }




// class MyApp extends StatefulWidget {
//   MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final AuthController authController = Get.find<AuthController>();
//   Future<bool>? _isFirstTimeInstaled;
//   @override
//   void initState() {
//     super.initState();
//     _isFirstTimeInstaled = authController.isFirstTimeInstall();
//   }

//   // isFirstTimeInstall() async {
//   //   isFirstTimeInstaled = await authController.isFirstTimeInstall();
//   //   print("form mainScreen isFirstTimeInstaled $isFirstTimeInstaled");
//   //   return isFirstTimeInstaled;
//   // }

//   whichPageToNext(bool isFirstTimeInstaled) {
//     // if (isFirstTimeInstaled) {
//     //   return SplashScreen(nextScreen: Onboarding1());
//     // } else 
//     if (authController.isLoggedIn()) {
//       return AppMain();
//     } else {
//       return UserLoginScreen();
//     }
//   }

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'RidezToHealth',
//       theme: ThemeData(
//         scaffoldBackgroundColor: const Color(
//           0xFF303644,
//         ), // background color here
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

//         //background: const Color(0xFF303644), // Optional: sets default background in color scheme
//       ),
//       // initialBinding: InitialBinding(),
//       initialBinding: InitialBinding(),
//       debugShowCheckedModeBanner: false,
//       home: FutureBuilder<bool>(
//         future: _isFirstTimeInstaled,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) {
//             return ConstantSplashScreen();
//           } else {
//             return whichPageToNext(snapshot.data!);
//           }
//         },
//       ),

//       // whichPageToNext(),
//       //MapScreenTest(),
//       // SearchDestinationScreen(),
//       // RideConfirmedScreen(),
//       // AppMain(),
//       // SplashScreen(nextScreen: Onboarding1()),
//     );
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      // StripeConnectScreen(),

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
