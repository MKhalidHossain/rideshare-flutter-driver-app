import 'package:get/get.dart';

class EarningsController extends GetxController {
  // Observable for tracking selected payment method
  var selectedPaymentMethod = 'Wallet'.obs;
  
  // Observable for earnings data
  var todayEarnings = 745.50.obs;
  var ridesCompleted = 32.obs;
  
  // Method to switch payment method
  void switchPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }
  
  // Method to withdraw earnings
  void withdrawEarnings() {
    Get.snackbar(
      'Withdraw',
      'Withdrawing \$${todayEarnings.value} to ${selectedPaymentMethod.value}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  // Sample ride history data
  List<Map<String, dynamic>> get rideHistory => [
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
    {'day': 'Mon', 'date': 'June 28', 'rides': 888, 'earnings': 1500.75},
  ];
}