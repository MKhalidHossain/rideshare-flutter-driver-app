import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/core/widgets/wide_custom_button.dart';

import '../../../../app.dart';

class CardPreviewScreen extends StatefulWidget {
  final String imagePath;
  final String whichImage;

  const CardPreviewScreen({super.key, required this.imagePath, required this.whichImage});

  @override
  State<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends State<CardPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BackButton(color: Colors.white),
                      Text(
                        "Check Card Quality ",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(width: 50),
                    ],
                  ),
                  const SizedBox(height: 40),
                   Text(
                   widget.whichImage != 'Selfie Photo' ? 'Cropped Image': '${widget.whichImage} Image',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  Image.file(File(widget.imagePath)),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Retake Photo"),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    //margin: EdgeInsets.all(16),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white70, width: 1),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 90,
                          width: 140,

                          child: Image.asset(
                            'assets/images/checkQuality.png',
                            height: 90,
                          ),
                        ),
                        "Check Quality".text24White(),
                        "Please  make sure all 4 corner in the frame to read clearly"
                            .text14White(),
                        const SizedBox(height: 20),
                        WideCustomButton(
                          text: "Continue",
                          onPressed: () {
                            Get.to(AppMain());
                          },
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 32.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Color(0xff2563EB),
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Take a image',
                                style: TextStyle(
                                  color: Color(0xff2563EB),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
