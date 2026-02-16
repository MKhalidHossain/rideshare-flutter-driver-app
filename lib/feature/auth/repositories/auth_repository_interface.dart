import 'package:image_picker/image_picker.dart';

abstract class AuthRepositoryInterface {
  Future<dynamic> register(
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
    
  );
  Future<dynamic> login(
    String emailOrPhone,
    String password,
    Map<String, dynamic> deviceInfo,
  );
  Future<dynamic> verifyOtp(String email, String otp, String type);
  Future<dynamic> forgetPassword(String? emailOrPhone);
  Future<dynamic> resetPassword(String emailOrPhone, String newPassword);
  Future<dynamic> changePassword(String currentPassword, String newPassword);
  Future<dynamic> getLoginHistory();
  Future<dynamic> logoutAllDevices();

  Future<dynamic> accessAndRefreshToken(String refreshToken);

  bool isLoggedIn();
  Future<dynamic> saveLogin(String token);
  Future<dynamic> logout();

  Future<bool> clearUserCredentials();
  bool clearSharedAddress();
  String getUserToken();
  String getUserId();
  String getUserEmail();

  Future<dynamic> updateToken();
  Future<bool?> saveUserToken(String token, String refreshToken);
  Future<bool?> saveUserId(String userId);
  Future<bool?> saveUserEmail(String email);
  Future<dynamic> updateAccessAndRefreshToken();

  bool isFirstTimeInstall();
  void setFirstTimeInstall();
}
