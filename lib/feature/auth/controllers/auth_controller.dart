import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ridetohealthdriver/payment/screen/stripe_connect_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app.dart';
import '../../../helpers/custom_snackbar.dart';
import '../../../helpers/remote/data/api_checker.dart';
import '../../../helpers/remote/data/api_client.dart';
import '../../../helpers/remote/data/socket_client.dart';
import '../domain/model/change_password_request_model.dart';
import '../domain/model/change_password_response_model.dart';
import '../domain/model/get_login_history_response_model.dart';
import '../domain/model/login_user_response_model.dart';
import '../domain/model/registration_user_response_model.dart';
import '../domain/model/request_password_reset_response_model.dart';
import '../domain/model/reset_password_with_otp_response_model.dart';
import '../domain/model/verify_otp_response_model.dart';
import '../presentation/screens/reset_password_screen.dart';
import '../presentation/screens/user_login_screen.dart';
import '../presentation/screens/user_signup_screen.dart';
import '../presentation/screens/verify_otp_screen.dart';
import '../sevices/auth_service_interface.dart';
import '../../historyAndProfile/presentation/screens/profile_screen.dart';

class AuthController extends GetxController implements GetxService {
  final AuthServiceInterface authServiceInterface;

  AuthController({required this.authServiceInterface});

  bool changePasswordIsLoading = false;

  bool? isFirstTime;
  bool _isLoading = false;
  bool _acceptTerms = false;
  bool get isLoading => _isLoading;
  bool get acceptTerms => _acceptTerms;
  final String _mobileNumber = '';

  Future<Map<String, dynamic>> _buildDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final deviceInfo = DeviceInfoPlugin();

    String name = 'Unknown device';
    String os = 'Unknown OS';

    if (kIsWeb) {
      final webInfo = await deviceInfo.webBrowserInfo;
      name = webInfo.userAgent ?? 'Web';
      os = webInfo.platform ?? 'Web';
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          final androidInfo = await deviceInfo.androidInfo;
          name = '${androidInfo.brand} ${androidInfo.model}';
          os = 'Android ${androidInfo.version.release}';
          break;
        case TargetPlatform.iOS:
          final iosInfo = await deviceInfo.iosInfo;
          name = (iosInfo.name != null && iosInfo.name!.isNotEmpty)
              ? iosInfo.name!
              : (iosInfo.model ?? 'iOS device');
          os = 'iOS ${iosInfo.systemVersion}';
          break;
        case TargetPlatform.macOS:
          final macInfo = await deviceInfo.macOsInfo;
          name = macInfo.computerName;
          os = 'macOS ${macInfo.osRelease}';
          break;
        case TargetPlatform.windows:
          final windowsInfo = await deviceInfo.windowsInfo;
          name = windowsInfo.computerName;
          os = 'Windows ${windowsInfo.displayVersion}';
          break;
        case TargetPlatform.linux:
          final linuxInfo = await deviceInfo.linuxInfo;
          name = linuxInfo.name;
          os = 'Linux ${linuxInfo.version}';
          break;
        default:
          break;
      }
    }

    return {
      'name': name,
      'os': os,
      'appVersion': packageInfo.version,
    };
  }
  String get mobileNumber => _mobileNumber;
  XFile? _pickedProfileFile;
  XFile? get pickedProfileFile => _pickedProfileFile;
  XFile identityImage = XFile('');
  List<XFile> identityImages = [];
  List<MultipartBody> multipartList = [];
  String countryDialCode = '+880';
  String email = '';
  final socketClient = SocketClient();



  // for register 
  // info taken from text fields and photos 

  // simple variables to hold registration input values (from screens)
  String name = '';
  String userEmail = ''; // avoids conflict with existing `email` field
  String phoneNumber = '';
  String drivingLicenceNumber = '';
  String nationalIdNumber = '';
  String serviceType = '';
  String password = '';
  String role = 'driver';
  String? _pendingLoginEmail;
  String? _pendingLoginPassword;

// iamge 

  XFile? license;
  XFile? nid;
  XFile? selfie;


  // Populate registration fields explicitly (call this when you have values ready).
  // Example usage from a screen:
  // controller.setRegistrationData(
  //   name: '${controller.fNameController.text} ${controller.lNameController.text}',
  //   userEmail: controller.emailController.text,
  //   phoneNumber: controller.phoneController.text,
  //   drivingLicenceNumber: controller.identityNumberController.text, // if used for DL
  //   nationalIdNumber: controller.identityNumberController.text,    // or another field
  //   serviceType: 'driver', // or obtained from a dropdown
  //   password: controller.passwordController.text,
  //   licenseFile: controller.license, // XFile picked earlier
  //   nidFile: controller.nid,
  //   selfieFile: controller.selfie,
  // );
void setRegistrationData({
  String? name,
  String? userEmail,
  String? phoneNumber,
  String? drivingLicenceNumber,
  String? nationalIdNumber,
  String? serviceType,
  String? password,
  XFile? licenseFile,
  XFile? nidFile,
  XFile? selfieFile,
}) {
  this.name = name ?? this.name;
  this.userEmail = userEmail ?? this.userEmail;
  this.phoneNumber = phoneNumber ?? this.phoneNumber;
  this.drivingLicenceNumber = drivingLicenceNumber ?? this.drivingLicenceNumber;
  this.nationalIdNumber = nationalIdNumber ?? this.nationalIdNumber;
  this.serviceType = serviceType ?? this.serviceType;
  this.password = password ?? this.password;

  if (licenseFile != null) {
    this.license = licenseFile; // ✅ correct assignment
  }
  if (nidFile != null) {
    this.nid = nidFile; // ✅
  }
  if (selfieFile != null) {
    this.selfie = selfieFile; // ✅
  }

  update();
}


  

  // Convenience: read directly from controllers and current picked files.
  // Call this from the sign up screen when user taps register.
  void populateRegistrationFromControllers({String role = 'driver'}) {
    // Combine first & last name controllers into single name field:
    final combinedName =
        '${fNameController.text.trim()} ${lNameController.text.trim()}'.trim();

    setRegistrationData(
      name: combinedName.isEmpty ? null : combinedName,
      userEmail: emailController.text.trim().isEmpty
          ? null
          : emailController.text.trim(),
      phoneNumber:
          phoneController.text.trim().isEmpty ? null : phoneController.text.trim(),
      // If you have separate controllers for DL and NID, map them here.
      drivingLicenceNumber: identityNumberController.text.trim().isEmpty
          ? null
          : identityNumberController.text.trim(),
      nationalIdNumber: identityNumberController.text.trim().isEmpty
          ? null
          : identityNumberController.text.trim(),
      serviceType: serviceType.isEmpty ? role : serviceType,
      password: passwordController.text.isEmpty ? null : passwordController.text,
      licenseFile: license,
      nidFile: nid,
      selfieFile: selfie,
    );
  }

  // Optional: clear stored registration inputs (call after successful registration).
  // Example: controller.clearRegistrationData();
  void clearRegistrationData() {
    name = '';
    userEmail = '';
    phoneNumber = '';
    drivingLicenceNumber = '';
    nationalIdNumber = '';
    serviceType = '';
    password = '';

    license = null;
    nid = null;
    selfie = null;

    // also clear UI controllers if desired:
    fNameController.clear();
    lNameController.clear();
    emailController.clear();
    phoneController.clear();
    identityNumberController.clear();
    passwordController.clear();
    confirmPasswordController.clear();

    update();
  }

  void setCountryCode(String code) {
    countryDialCode = code;
    update();
  }

  TextEditingController fNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController identityNumberController = TextEditingController();

  FocusNode fNameNode = FocusNode();
  FocusNode lNameNode = FocusNode();
  FocusNode phoneNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  FocusNode emailNode = FocusNode();
  FocusNode addressNode = FocusNode();
  FocusNode identityNumberNode = FocusNode();

  RegistrationResponseModel? registrationResponseModel;
  LogInResponseModel? logInResponseModel;
  ChangePasswordResponseModel? changePasswordResponseModel;
  GetLoginHistoryResponseModel? getLoginHistoryResponseModel;
  RequestPasswordResetResponseModel? requestPasswordResetResponseModel;
  ResetPasswordWithOtpResponseModel? resetPasswordWithOtpResponseModel;
  VerifyOtpResponseModel? verifyOtpResponseModel;
  // VerifyCodeResponseModel? verifyCodeResponseModel;
  // ChangePasswordResponseModel? changePasswordResponseModel;
  // ForgetPasswordResponseModel? forgetPasswordResponseModel;

  void addImageAndRemoveMultiParseData() {
    multipartList.clear();
    identityImages.clear();
    update();
  }

  void pickImage(bool isBack, bool isProfile) async {
    if (isProfile) {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _pickedProfileFile = pickedFile;
      }
    } else {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        identityImage = pickedFile;
        identityImages.add(identityImage);
        multipartList.add(MultipartBody('identity_images[]', identityImage));
      }
    }
    update();
  }

  void removeImage(int index) {
    identityImages.removeAt(index);
    multipartList.removeAt(index);
    update();
  }

  final List<String> _identityTypeList = ['passport', 'driving_license', 'nid'];
  List<String> get identityTypeList => _identityTypeList;
  String _identityType = '';
  String get identityType => _identityType;

  void setIdentityType(String setValue) {
    _identityType = setValue;
    update();
  }

  Future<void> register(
  String otpVerifyType,
  String fullName,
  String email,
  String phoneNumber,
  String drivingLicenceNumber,
  String nationalIdNumber,
  String serviceType,
  String password,
  String role,
  XFile license,
  XFile nid,
  XFile selfie,
  // XFile vehicleImage,
) async {
  _isLoading = true;
  update();

  userEmail = email;
  this.password = password;
  _pendingLoginEmail = email;
  _pendingLoginPassword = password;

  print(
    "REGISTER API BODY: {fullName: $fullName, email: $email, password: $password, role: $role}",
  );

  try {
    Response response = await authServiceInterface.register(
      fullName,
      email,
      phoneNumber,
      drivingLicenceNumber,
      nationalIdNumber,
      serviceType,
      password,
      role,
      license,
      nid,
      selfie,
      // vehicleImage,
    );
     print("RAW RESPONSE: ${response.body}");
          print("STATUS CODE: ${response.statusCode}");
          print("HEADERS: ${response.headers}");

    if (response.statusCode == 201) {
      registrationResponseModel =
          RegistrationResponseModel.fromJson(response.body);
         
      _isLoading = false;
      update();

      Get.off(() => VerifyOtpScreen(
            email: email,
            otpVerifyType: otpVerifyType,
          ));

      showCustomSnackBar(response.body['message'] ??
          'Registration successful! Please verify your email.');
      // showCustomSnackBar('Check your email to verify your account.');

    } else {
      _isLoading = false;

      showCustomSnackBar(
        response.body['message'] ?? 'Registration failed.',
        isError: true,
      );

      print('❌ Registration failed: ${response.statusCode} ${response.body}');
    }
  } catch (e) {
    _isLoading = false;
    print("❌ Error during registration: $e");

    showCustomSnackBar(
      "Something went wrong. Please try again later.",
      isError: true,
    );
  }
}


  // Future<void> register(
  //   String otpVerifyType,
  //   String fullName,
  //   String email,
  //   String phoneNumber,
  //   String drivingLicenceNumber,
  //   String nationalIdNumber,
  //   String serviceType,
  //   String password,
  //   String role,
  // ) async {
  //   _isLoading = true;
  //   update();

  //   print(
  //     "REGISTER API BODY: {fullNmae: $fullName, email: $email, password: $password, role: $role}",
  //   );

  //   try {
  //     Response? response = await authServiceInterface.register(
  //       fullName,
  //       email,
  //       phoneNumber,
  //       drivingLicenceNumber,
  //       nationalIdNumber,
  //       serviceType,
  //       password,
  //       role,
  //     );
  //     if (response!.statusCode == 201) {
  //       registrationResponseModel = RegistrationResponseModel.fromJson(
  //         response.body,
  //       );

  //       print(
  //         "REGISTER API BODY: {fullNmae: $fullName, email: $email, password: $password, role: $role}",
  //       );
  //       print('\nemail: $email , otpVerifyType: $otpVerifyType\n');
  //       _isLoading = false;
  //       update();
  //       Get.off(
  //         () => VerifyOtpScreen(email: email, otpVerifyType: otpVerifyType),
  //       );

  //       showCustomSnackBar(
  //         response.body['message'] ??
  //             'Registration success Now need to email verification',
  //       );
  //       showCustomSnackBar('please check your email to verify your account');
  //       // Get.off(() => UserLoginScreen());
  //       // showCustomSnackBar('Welcome you have successfully Registered');
  //     } else {
  //       _isLoading = false;
  //       if (response.statusCode == 400) {
  //         showCustomSnackBar(
  //           response.body['message'] ?? 'Something went wrong',
  //           isError: true,
  //         );
  //       } else {
  //         showCustomSnackBar(
  //           response.body['message'] ??
  //               'Registration failed. Please try again.',
  //           isError: true,
  //         );
  //       }

  //       print(
  //         ' ❌ Registration failed: ${response.statusCode} ${response.body} ',
  //       );
  //     }
  //     update();
  //   } catch (e) {
  //     _isLoading = false;
  //     print("❌ Error during registration: $e");
  //     showCustomSnackBar(
  //       "Something went wrong. Please try again later.",
  //       isError: true,
  //     );
  //   }
  // }

  Future<void> login(String emailOrPhone, String password) async {
    _isLoading = true;
    update();

    // Response? response = Response();

    final deviceInfo = await _buildDeviceInfo();
    Response? response = await authServiceInterface.login(
      emailOrPhone,
      password,
      deviceInfo,
    );

    if (response == null) {
      print("No response found");
    }
    if (response!.statusCode == 200) {
      Map map = response.body;
      String accessToken = '';
      String refreshToken = '';
      String userId = '';

      print(accessToken.toString());

      logInResponseModel = LogInResponseModel.fromJson(response.body);

      refreshToken = logInResponseModel!.data!.refreshToken!;
      accessToken = logInResponseModel!.data!.accessToken!;
      userId = logInResponseModel!.data!.user!.id!;
      print(
        'accessToken ${logInResponseModel!.data!.accessToken}} NOW Iwalker',
      );
      print('refreshToken $refreshToken NOW Iwalker');
      print(
        'User Token $accessToken  ================================== from comtroller ',
      );

      await setUserId(userId);
      await setUserToken(accessToken, refreshToken);

      socketClient.emit('join-driver', {
          'driverId': logInResponseModel!.data!.user!.id,  // ei key ta backend expect korche
            });


            
      print("Join room with id mahbub: ${logInResponseModel!.data!.user!.id}");

      Get.offAll(() => AppMain());


      //Get.offAll(BottomNavbar());

      showCustomSnackBar('Welcome you have successfully Logged In');

      _isLoading = false;
    } else if (response.statusCode == 202) {
      if (response.body['data']['is_phone_verified'] == 0) {}
    } else if (response.statusCode == 400) {
      showCustomSnackBar('Sorry you have no account, please create a account');
      Get.offAll(()=>UserSignupScreen());
      
    }
    else if (response.statusCode == 401) { 
    showCustomSnackBar(
      'Login Failed',
      subMessage: 'The email or password you entered is incorrect. Please try again.',
    );
      Get.offAll(()=>UserSignupScreen());


    }
    
     else {
      _isLoading = false;
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> logOut() async {
    logging = true;
    update();
    Response? response = await authServiceInterface.logout();

    if (isLoggedIn() == false) {
      if (response!.statusCode == 200) {
        Get.offAll(() => UserLoginScreen());
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomSnackBar('You have logout Successfully');
        });
      } else {
        logging = false;
        ApiChecker.checkApi(response);
        print(response.body['message'] + ' for logout from controller');
        showAppSnackBar('Error', response.body['message']);
        Get.offAll(() => UserLoginScreen());
      }
    } else {
      print(response.toString() + ' from controller');
    }
    update();
  }

  bool isLoggedIn() {
    return authServiceInterface.isLoggedIn();
  }

  Future<bool> isFirstTimeInstall() async {
    _isLoading = true;
    update();
    final prefs = await SharedPreferences.getInstance();

    isFirstTime = prefs.getBool('firstTimeInstall') ?? true;

    if (isFirstTime!) {
      await prefs.setBool('firstTimeInstall', false);
      _isLoading = false;
      update();
      return true; // means first time
    } else {
      _isLoading = false;
      update();
      return false; // not first time
    }
  }

  bool logging = false;

  // Future<void> logOut() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   logging = true;
  //   update();
  //   Response? response = await authServiceInterface.logout();

  //   if (isLoggedIn() == true) {
  //     if (response!.statusCode == 200) {
  //       await preferences.setString(AppConstants.token, '');
  //       await preferences.setString(AppConstants.refreshToken, '');

  //       showCustomSnackBar('You have logout Successfully');
  //     } else {
  //       logging = false;
  //       ApiChecker.checkApi(response);
  //     }
  //   } else {
  //     print('object fucked up');
  //   }
  //   update();
  // }

  Future<void> permanentDelete() async {
    logging = true;

    update();
  }

  Future<void> verifyOtp(String email, String otp, String type) async {
    _isLoading = true;
    update();
    Response? response = await authServiceInterface.verifyOtp(email, otp, type);

    print(response!.body);

    if (response.body['success'] == true) {
      verifyOtpResponseModel = VerifyOtpResponseModel.fromJson(response.body);
      showCustomSnackBar('Otp verification has been successful');

      if (type == 'password_reset') {
        Get.to(ResetChangePassword(userEmail: email));
      } else if (type == 'email_verification') {
        showCustomSnackBar('Email verification has been successful');
        await _autoLoginAfterEmailVerification();
        Get.offAll(() => const StripeConnectScreen());
      } else if (type == 'password_reset') {
        showCustomSnackBar('Password Change Successfully');
        Get.offAll(() => UserSignupScreen());
      } else {
        showCustomSnackBar('Otp type is not valid');
        Get.offAll(() => UserSignupScreen());
      }

      // Get.to(ResetChangePassword(userEmail: email));
    } else {
      showCustomSnackBar(
        'Otp is not valid, Please try again',
        subMessage: response.body['message'],
        isError: true,
      );
      // Get.find<AuthController>().logOut();
    }
    _isLoading = false;
    update();
  }

  // Future<void> resendOtp(String email) async {
  //   _isLoading = true;
  //   update();
  //   Response? response = await authServiceInterface.resendOtp(email);
  //   if (response!.body['status'] == true) {
  //     showCustomSnackBar('Otp has been successful to your mail');

  //     Get.to(VerifyOtpScreen(email: email));
  //   }

  //   update();
  // }

  Future<void> forgetPassword(String emailOrPhone, String otpVerifyType) async {
    _isLoading = true;
    update();

    Response? response = await authServiceInterface.forgetPassword(
      emailOrPhone,
    );
    print(response!.body);

    if (response.statusCode == 200) {
      _isLoading = false;
      showCustomSnackBar('successfully sent otp');
      print('\neamil $emailOrPhone , otpVerifyType $otpVerifyType\n');
      Get.to(
        () =>
            VerifyOtpScreen(email: emailOrPhone, otpVerifyType: otpVerifyType),
      );
    } else {
      _isLoading = false;
      showCustomSnackBar('invalid mail');
    }
    update();
  }

  // Future<void> resetPassword(String email, String newPassword) async {
  //   _isLoading = true;

  //   update();

  //   Response? response = await authServiceInterface.resetPassword(
  //     email,
  //     newPassword,
  //   );
  //   if (response!.statusCode == 200) {
  //     // SnackBarWidget('password_change_successfully'.tr, isError: false);
  //     showCustomSnackBar('Password Change Successfully');
  //     Get.offAll(() => const SignInScreen());
  //   } else {
  //     showCustomSnackBar('Password Change was  Unsuccessfully');
  //     ApiChecker.checkApi(response);
  //   }

  //   _isLoading = false;

  //   update();
  // }

  Future<void> resetPassword(String email, String newPassword) async {
    _isLoading = true;
    update();

    Response? response = await authServiceInterface.resetPassword(
      email,
      newPassword,
    );
    if (response!.statusCode == 200) {
      showCustomSnackBar('Password Change Successfully');
      // logOut();
      // Get.to(UserLoginScreen());
      Get.offAll(() => UserLoginScreen());
    } else {
      showCustomSnackBar(response.body['message'] ?? 'Something went wrong');
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> changePassword(ChangePasswordRequestModel request) async {
    changePasswordIsLoading = true;
    update();

    try {
      Response? response = await authServiceInterface.changePassword(
        request.currentPassword,
        request.newPassword,
      );

      print("Check the response data-> ${response}");

      if (response != null && response.statusCode == 200) {
        final body = response.body;
        final success = body is Map<String, dynamic>
            ? (body['success'] as bool?) ?? false
            : false;
        final message = body is Map<String, dynamic> ? body['message'] : null;

        if (success) {
          showCustomSnackBar(
            message ?? 'Password changed successfully',
            isError: false,
          );
          Get.offAll(() => ProfileScreen());
        } else {
          showCustomSnackBar(
            message ?? 'Invalid credentials. Please check your current password.',
            isError: true,
          );
        }
      } else if (response != null) {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      print("❌ Error changing password: $e");
      showCustomSnackBar(
        "Something went wrong. Please try again later.",
        isError: true,
      );
    }

    changePasswordIsLoading = false;
    update();
  }

  /// Fetch login history
  bool isLoginHistoryLoading = false;
  String? loginHistoryError;

  Future<void> fetchLoginHistory() async {
    isLoginHistoryLoading = true;
    loginHistoryError = null;
    update();

    try {
      final response = await authServiceInterface.getLoginHistory();
      if (response == null) {
        loginHistoryError = 'Unable to fetch login history';
        return;
      }

      final body = response.body;
      final decoded = body is String ? jsonDecode(body) : body;
      if (response.statusCode == 200 && decoded is Map<String, dynamic>) {
        getLoginHistoryResponseModel =
            GetLoginHistoryResponseModel.fromJson(decoded);
        final list = getLoginHistoryResponseModel?.loginHistory ?? [];
        if (list.isEmpty) {
          loginHistoryError = 'No login history found';
        }
      } else {
        loginHistoryError =
            decoded is Map<String, dynamic> ? (decoded['message'] ?? 'Unable to fetch login history') : 'Unable to fetch login history';
      }
    } catch (e) {
      loginHistoryError = e.toString();
    } finally {
      isLoginHistoryLoading = false;
      update();
    }
  }

  Future<void> logoutAllDevices() async {
    try {
      final response = await authServiceInterface.logoutAllDevices();
      if (response != null && response.statusCode == 200) {
        showCustomSnackBar(
          response.body?['message'] ?? 'Logged out from all devices',
          isError: false,
        );
      } else {
        showCustomSnackBar(
          response?.body?['message'] ?? 'Could not log out from all devices',
          isError: true,
        );
      }
    } catch (e) {
      showCustomSnackBar(
        'Could not log out from all devices',
        isError: true,
      );
    }
  }

  bool updateFcm = false;

  Future<void> updateAccessAndRefreshToken() async {
    Response? response = await authServiceInterface
        .updateAccessAndRefreshToken();
    if (response?.statusCode == 200) {
      String token = response!.body['accessToken'];
      String refreshToken = response.body['refreshToken'];

      print('accessToken $token NOWW');
      print('refreshToken $refreshToken');

      setUserToken(token, refreshToken);
      updateFcm = false;
    } else {
      updateFcm = false;
      ApiChecker.checkApi(response!);
    }

    update();
  }

  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if (_verificationCode.isNotEmpty) {
      _otp = _verificationCode;
    }
    update();
  }

  void clearVerificationCode() {
    updateVerificationCode('');
    _verificationCode = '';
    update();
  }

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  void setRememberMe() {
    _isActiveRememberMe = true;
  }

  String getUserToken() {
    return authServiceInterface.getUserToken();
  }

 String getUserId() {
    return authServiceInterface.getUserId();
  }


  Future<void> setUserToken(String token, String refreshToken) async {
    await authServiceInterface.saveUserToken(token, refreshToken);
  }

      Future<void> setUserId(String userId) async {
    await authServiceInterface.saveUserId(userId);
  }


  Future<bool> getFirsTimeInstall() async {
    return authServiceInterface.isFirstTimeInstall();
  }

  void setFirstTimeInstall() {
    return authServiceInterface.setFirstTimeInstall();
  }

  Future<void> _autoLoginAfterEmailVerification() async {
    final email = _pendingLoginEmail ?? userEmail;
    final password = _pendingLoginPassword ?? this.password;

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    try {
      final deviceInfo = await _buildDeviceInfo();
      final Response? response = await authServiceInterface.login(
        email,
        password,
        deviceInfo,
      );
      if (response != null && response.statusCode == 200) {
        logInResponseModel = LogInResponseModel.fromJson(response.body);
        final accessToken = logInResponseModel?.data?.accessToken;
        final refreshToken = logInResponseModel?.data?.refreshToken ?? '';

        if (accessToken != null && accessToken.isNotEmpty) {
          await setUserToken(accessToken, refreshToken);
        }
      }
    } catch (e) {
      debugPrint('Auto login failed: $e');
    } finally {
      _pendingLoginEmail = null;
      _pendingLoginPassword = null;
    }
  }



}
