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


import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customPrint(String message) {
  if (kDebugMode) print(message);
}

OverlayEntry? _activeSnackBarEntry;
Timer? _activeSnackBarTimer;

Future<void> showCustomSnackBar(
  String message, {
  bool isError = false,
  int seconds = 2,
  String? subMessage,
  SnackPosition snackPosition = SnackPosition.TOP,
  Color? backgroundColor,
  Color? textColor,
  EdgeInsets? margin,
}) async {
  // Close existing snackbar (if any).
  _activeSnackBarTimer?.cancel();
  _activeSnackBarTimer = null;
  _activeSnackBarEntry?.remove();
  _activeSnackBarEntry = null;

  final Color effectiveBackgroundColor =
      backgroundColor ?? (isError ? Colors.red : Colors.white);
  final Brightness backgroundBrightness =
      ThemeData.estimateBrightnessForColor(effectiveBackgroundColor);
  final Color effectiveTextColor = textColor ??
      (backgroundBrightness == Brightness.dark
          ? Colors.white
          : Colors.black);
  final EdgeInsets effectiveMargin = margin ?? const EdgeInsets.all(10);

  // Wait for GetX overlay to be available (important during navigation)
  const int maxTries = 120; // ~120 frames ≈ 2s
  for (int i = 0; i < maxTries; i++) {
    final overlay = Get.key.currentState?.overlay;
    if (overlay != null && overlay.mounted) {
      // Always show on next frame to avoid "during build" / transition issues
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentOverlay = Get.key.currentState?.overlay;
        if (currentOverlay == null || !currentOverlay.mounted) {
          debugPrint('⚠️ Snackbar skipped: overlay lost during frame.');
          return;
        }

        final entry = OverlayEntry(
          builder: (context) {
            return Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: effectiveMargin,
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 200),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: child,
                      );
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: GestureDetector(
                            onTap: () {
                              _activeSnackBarTimer?.cancel();
                              _activeSnackBarTimer = null;
                              _activeSnackBarEntry?.remove();
                              _activeSnackBarEntry = null;
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: effectiveBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          message,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: effectiveTextColor,
                                          ),
                                        ),
                                        if (subMessage != null) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            subMessage,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: effectiveTextColor,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );

        _activeSnackBarEntry?.remove();
        _activeSnackBarEntry = entry;
        currentOverlay.insert(entry);
        _activeSnackBarTimer = Timer(Duration(seconds: seconds), () {
          _activeSnackBarEntry?.remove();
          _activeSnackBarEntry = null;
          _activeSnackBarTimer = null;
        });
      });
      return;
    }
    await Future.delayed(const Duration(milliseconds: 16)); // ~1 frame
  }

  debugPrint('⚠️ Snackbar skipped: overlay not ready.');
}

Future<void> showAppSnackBar(
  String title,
  String message, {
  bool isError = true,
  int seconds = 2,
  SnackPosition snackPosition = SnackPosition.TOP,
  Color? backgroundColor,
  Color? colorText,
  EdgeInsets? margin,
}) async {
  final String trimmedTitle = title.trim();
  final String header = trimmedTitle.isEmpty ? message : trimmedTitle;
  final String? detail = trimmedTitle.isEmpty ? null : message;

  await showCustomSnackBar(
    header,
    isError: isError,
    seconds: seconds,
    subMessage: detail,
    snackPosition: snackPosition,
    backgroundColor: backgroundColor,
    textColor: colorText,
    margin: margin,
  );
}
