import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void customPrint(String message) {
  if (kDebugMode) {
    print(message);
  }
}

void showCustomSnackBar(
  String message, {
  bool isError = true,
  int seconds = 3,
  String? subMessage,
}) {
  Get.closeCurrentSnackbar();
  final context = Get.context ?? Get.overlayContext;
  final fallbackColor = Colors.grey.shade800;
  final backgroundColor = Get.isDarkMode
      ? fallbackColor
      : (context != null
          ? Theme.of(context).textTheme.titleMedium?.color ?? fallbackColor
          : fallbackColor);

  final snackBar = GetSnackBar(
    dismissDirection: DismissDirection.horizontal,
    margin: const EdgeInsets.all(10).copyWith(right: 18),
    duration: Duration(seconds: seconds),
    backgroundColor: backgroundColor,
    borderRadius: 10,
    messageText: Row(
      children: [
        const SizedBox(width: 20),
        Expanded(
          child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                subMessage != null
                    ? Text(
                        subMessage,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  if (Get.overlayContext == null) {
    debugPrint('⚠️ Snackbar skipped: no overlay context yet.');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.overlayContext != null) {
        Get.showSnackbar(snackBar);
      } else {
        debugPrint('⚠️ Snackbar skipped: overlay still unavailable.');
      }
    });
    return;
  }

  Get.showSnackbar(snackBar);
}
