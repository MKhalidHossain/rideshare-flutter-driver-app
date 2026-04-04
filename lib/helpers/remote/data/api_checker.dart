import 'package:get/get.dart';
import '../../custom_snackbar.dart';
import 'auth_expiry_handler.dart';
import 'error_response.dart';

class ApiChecker {
  static void checkApi(Response response) {
    if (response.statusCode == 401) {
      final message = AuthExpiryHandler.extractMessage(response.body);
      AuthExpiryHandler.redirectToLogin(message: message);
    } else if (response.statusCode == 403) {
      ErrorResponse errorResponse;
      errorResponse = ErrorResponse.fromJson(response.body);
      if (errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
        showCustomSnackBar(errorResponse.errors![0].message!);
      } else {
        showCustomSnackBar(response.body['message']!);
      }
    } else {
      //showCustomSnackBar(response.statusText! + 'Khalid this is Status Code');
      showCustomSnackBar(response.statusText!);
    }
  }
}
