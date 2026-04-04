import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/user_login_screen.dart';

import '../../../utils/app_constants.dart';
import '../../custom_snackbar.dart';
import 'socket_client.dart';

class AuthExpiryHandler {
  static bool _isRedirectingToLogin = false;

  static bool isTokenExpiredMessage(String? message) {
    if (message == null || message.trim().isEmpty) {
      return false;
    }

    final normalized = message.toLowerCase();
    return normalized.contains('invalid token') ||
        normalized.contains('token expired') ||
        normalized.contains('expired token') ||
        normalized.contains('jwt expired') ||
        normalized.contains('unauthorized') ||
        normalized.contains('not authorized');
  }

  static String? extractMessage(dynamic body) {
    if (body is Map && body['message'] is String) {
      return body['message'] as String;
    }
    if (body is String && body.trim().isNotEmpty) {
      return body;
    }
    return null;
  }

  static Future<void> redirectToLogin({String? message}) async {
    if (_isRedirectingToLogin) return;
    _isRedirectingToLogin = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      await _clearAuthData(prefs);

      final socket = SocketClient();
      socket.disconnect();
      socket.dispose();

      final authMessage = (message != null && message.trim().isNotEmpty)
          ? message.trim()
          : 'Session expired. Please login again.';

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => UserLoginScreen());
        showCustomSnackBar(authMessage, isError: true);
      });
    } finally {
      Future.delayed(const Duration(milliseconds: 700), () {
        _isRedirectingToLogin = false;
      });
    }
  }

  static Future<void> _clearAuthData(SharedPreferences prefs) async {
    await prefs.remove(AppConstants.accessToken);
    await prefs.remove(AppConstants.refreshToken);
    await prefs.remove(AppConstants.userId);
    await prefs.remove(AppConstants.userEmail);
    await prefs.remove('IsLoggedIn');
  }
}
