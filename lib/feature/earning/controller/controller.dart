import 'package:get/get.dart';
import 'package:ridetohealthdriver/helpers/custom_snackbar.dart';

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
  void withdrawEarnings([double? amount]) {
    final value = amount ?? todayEarnings.value;
    showAppSnackBar(
      'Withdraw',
      'Withdrawing \$${value.toStringAsFixed(2)} to ${selectedPaymentMethod.value}',
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
