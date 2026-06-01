import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ridetohealthdriver/app.dart';
import 'package:ridetohealthdriver/core/onboarding/presentation/screens/constantSpashScreen.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/user_signup_screen.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/verify_otp_screen.dart';
import 'package:ridetohealthdriver/payment/screen/stripe_connect_screen.dart';
import 'package:ridetohealthdriver/utils/app_constants.dart';

import 'feature/map/bindings/initial_binding.dart';
import 'helpers/dependency_injection.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await initDI();
  runApp( MyApp());
}


class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthController authController = Get.find<AuthController>();
  Future<Widget>? _startScreen;

  @override
  void initState() {
    super.initState();
    _startScreen = _determineStartScreen();
  }

  Future<Widget> _determineStartScreen() async {
    final isFirstTime = await authController.isFirstTimeInstall();
    if (isFirstTime) return const UserSignupScreen();
    if (authController.isLoggedIn()) {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(AppConstants.stripePending) == true) {
        return const StripeConnectScreen();
      }
      return AppMain();
    }

    final savedStage = await authController.getSavedRegistrationStage();
    if (savedStage == 'verify_otp') {
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString(AppConstants.regOtpEmail) ?? '';
      if (email.isNotEmpty) {
        return VerifyOtpScreen(email: email, otpVerifyType: 'email_verification');
      }
    } else if (savedStage == 'verify_identity' || savedStage == 'signup_form') {
      await authController.restoreFromSavedProgress();
      return const UserSignupScreen();
    }

    return UserLoginScreen();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      title: 'RidezToHealth',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF303644),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Widget>(
        future: _startScreen,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return ConstantSplashScreen();
          return snapshot.data!;
        },
      ),
    );
  }
}

