// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// void customPrint(String message) {
//   if (kDebugMode) {
//     print(message);
//   }
// }

// void showCustomSnackBar(
//   String message, {
//   bool isError = true,
//   int seconds = 2,
//   String? subMessage,
// }) {
//   if (Get.isSnackbarOpen ?? false) {
//     Get.closeCurrentSnackbar();
//   }
//   Get.showSnackbar(
//     GetSnackBar(
//       dismissDirection: DismissDirection.horizontal,
//       margin: const EdgeInsets.all(10).copyWith(right: 10),
//       duration: Duration(seconds: seconds),
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.white,
//       borderRadius: 10,
//       messageText: Row(
//         children: [
//           const SizedBox(width: 10),
//           Expanded(
//             child: SizedBox(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message,
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.black,
//                     ),
//                   ),
//                   subMessage != null
//                       ? Text(
//                           subMessage,
//                           style: TextStyle(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.black,
//                           ),
//                         )
//                       : const SizedBox(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customPrint(String message) {
  if (kDebugMode) print(message);
}

Future<void> showCustomSnackBar(
  String message, {
  bool isError = true,
  int seconds = 2,
  String? subMessage,
}) async {
  // Close existing snackbar (optional)
  if (Get.isSnackbarOpen == true) {
    Get.closeCurrentSnackbar();
  }

  final snackBar = GetSnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: const EdgeInsets.all(10),
    duration: Duration(seconds: seconds),
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.white,
    borderRadius: 10,
    messageText: Row(
      children: [
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              if (subMessage != null) ...[
                const SizedBox(height: 4),
                Text(
                  subMessage,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );

  // Wait for GetX overlay to be available (important during navigation)
  const int maxTries = 20; // ~20 frames ≈ 300ms
  for (int i = 0; i < maxTries; i++) {
    if (Get.overlayContext != null) {
      // Always show on next frame to avoid "during build" / transition issues
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Get.overlayContext != null) {
          try {
            Get.showSnackbar(snackBar);
          } catch (e) {
            debugPrint('⚠️ Snackbar failed: $e');
          }
        } else {
          debugPrint('⚠️ Snackbar skipped: overlay lost during frame.');
        }
      });
      return;
    }
    await Future.delayed(const Duration(milliseconds: 16)); // ~1 frame
  }

  debugPrint('⚠️ Snackbar skipped: overlay not ready.');
}
