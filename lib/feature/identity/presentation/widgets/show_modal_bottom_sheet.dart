import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../screens/take_photo_screen.dart';

void showBlurredBottomSheet(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'BottomSheet',
    barrierColor: Colors.black.withOpacity(
      0.3,
    ), // Optional semi-transparent overlay
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, anim1, anim2) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Apply blur
          child: FractionallySizedBox(
            heightFactor: 0.40,
            widthFactor: 1, // 40% height
            child: Material(
              color: Color(0xff303644),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // const SizedBox(height: 20),
                    Row(
                      children: [
                        BackButton(color: Colors.white),
                        // const SizedBox(width: 8),
                        const Text(
                          'Take Picture of Your Documents',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        // Container(
                        //   height: 5,
                        //   width: 50,
                        //   margin: const EdgeInsets.only(bottom: 16),
                        //   decoration: BoxDecoration(
                        //     color: Colors.red,
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        // ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.to(TakePhotoScreen(whichImage: 'Government ID' ,));
                                },
                                child: Container(
                                  height: 65,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/governmentId.png',
                                            fit: BoxFit.cover,
                                        height: 60,
                                        width: 60,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Government ID'
                                        ,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(TakePhotoScreen(whichImage: 'Driveing Licence'));
                                },
                                child: Container(
                                  height: 65,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                          'assets/images/driving_licence.png',
                                          fit: BoxFit.cover,
                                        height: 60,
                                        width: 60,
                                      ),
                                        const SizedBox(width: 12),
                                      Text(
                                        'Driveing Licence',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              InkWell(
                                onTap: () {
                                  Get.to(TakePhotoScreen(whichImage: 'Selfie Photo',));
                                },
                                child: Container(
                                  height: 65,
                                  width: double.infinity,
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white10,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                            'assets/images/selfiePhoto.png',
                                                fit: BoxFit.contain,
                                        height: 60,
                                        width: 60,
                                      ),
                                      Text(
                                        'Selfie Photo',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(anim1),
        child: child,
      );
    },
  );
}
