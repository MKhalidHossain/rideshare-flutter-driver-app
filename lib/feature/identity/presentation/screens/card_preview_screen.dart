import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/core/widgets/wide_custom_button.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';
import '../../../../app.dart';
import '../widgets/show_modal_bottom_sheet.dart';
import 'take_photo_screen.dart';


class CardPreviewScreen extends StatefulWidget {
  final String governmentId;
  final String driveingLicence;
  final String selfiePhoto;
  final String whichImage;
  

  const CardPreviewScreen({
    super.key,
    this.governmentId = 'No Government ID',
    this.driveingLicence = 'No Driving Licence',
    this.selfiePhoto = 'No Selfie Photo',
    required this.whichImage,
  });

  @override
  State<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends State<CardPreviewScreen> {
  late AuthController authController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {

// Debug print showing all four values
debugPrint(
  'CardPreview values -> Government ID: ${widget.governmentId}, '
  'Driving Licence: ${widget.driveingLicence}, '
  'Selfie Photo: ${widget.selfiePhoto}, '
  'Which Image: ${widget.whichImage}',
);
// Read values from authController and print them with labels
String name = authController.name ?? '';
String userEmail = authController.email ?? '';
String phoneNumber = authController.phoneNumber ?? '';
String drivingLicenceNumber = authController.drivingLicenceNumber ?? '';
String nationalIdNumber = authController.nationalIdNumber ?? '';
String serviceType = authController.serviceType ?? '';
String password = authController.password ?? '';
String role = authController.role ?? 'driver';

// files from controller (kept as dynamic to avoid requiring XFile import here)
final license = authController.license;
final nid = authController.nid;
final selfie = authController.selfie;

debugPrint('AuthController values -> '
  'Name: $name, '
  'Email: $userEmail, '
  'Phone: $phoneNumber, '
  'Driving Licence No: $drivingLicenceNumber, '
  'National ID No: $nationalIdNumber, '
  'Service Type: $serviceType, '
  'Password: ${password.isNotEmpty ? '****' : '(empty)'}, '
  'Role: $role, '
  'License file: ${license?.path ?? license?.toString() ?? 'null'}, '
  'NID file: ${nid?.path ?? nid?.toString() ?? 'null'}, '
  'Selfie file: ${selfie?.path ?? selfie?.toString() ?? 'null'}');
    return Scaffold(
      // backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// ---------------- HEADER ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(color: Colors.white, onPressed: () => showBlurredBottomSheet(context),),
                    const Text(
                      "Check Card Quality",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),

                const SizedBox(height: 25),

                /// ---------------- MAIN IMAGE TITLE ----------------
                Text(
                  widget.whichImage != 'Selfie Photo'
                      ? 'Cropped Image'
                      : '${widget.whichImage} Image',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 15),



                const SizedBox(height: 30),

                /// ---------------- GOVERNMENT ID ----------------
                _buildImageBlock(
                  title: "Government ID",
                  path: widget.governmentId,
                  retakeOnTap: () {
                    Get.to(TakePhotoScreen(whichImage: 'Government ID'));
                  },
                ),

                const SizedBox(height: 30),

                /// ---------------- DRIVING LICENCE ----------------
                _buildImageBlock(
                  title: "Driving Licence",
                  path: widget.driveingLicence,
                  retakeOnTap: () {
                    Get.to(TakePhotoScreen(whichImage: 'Driving Licence'));
                  },
                ),

                const SizedBox(height: 30),

                /// ---------------- SELFIE PHOTO ----------------
                _buildImageBlock(
                  title: "Selfie Photo",
                  path: widget.selfiePhoto,
                  retakeOnTap: () {
                    Get.to(TakePhotoScreen(whichImage: 'Selfie Photo'));
                  },
                ),

                const SizedBox(height: 30),

                /// ---------------- RETAKE MAIN BUTTON ----------------
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Retake Main Photo"),
                ),

                const SizedBox(height: 30),

                /// ---------------- QUALITY CHECK BOX ----------------
                _buildQualityBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ============================================================
  /// IMAGE BLOCK WITH RETAKE BUTTON
  /// ============================================================
  Widget _buildImageBlock({
    required String title,
    required String path,
    required VoidCallback retakeOnTap,
  }) {
    bool hasImage = path != 'No Image' &&
        path != 'No Government ID' &&
        path != 'No Driving Licence' &&
        path != 'No Selfie Photo';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// ---- HEADING ----
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          /// ---- IMAGE ----
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: 220,
              color: Colors.white10,
              child: hasImage
                  ? Image.file(File(path), fit: BoxFit.cover)
                  : _buildShimmer(),
            ),
          ),

          const SizedBox(height: 12),

          /// ---- RETAKE BUTTON ----
          GestureDetector(
            onTap: retakeOnTap,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Retake",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// SHIMMER PLACEHOLDER
  /// ============================================================
  Widget _buildShimmer() {
    return Container(
      alignment: Alignment.center,
      child: Text(
        "Image not found",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }

  /// ============================================================
  /// QUALITY CHECK BOX
  /// ============================================================
  Widget _buildQualityBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        children: [
          Image.asset('assets/images/checkQuality.png', height: 90),

          "Check Quality".text24White(),
          "Make sure all 4 corners are visible clearly.".text14White(),

          const SizedBox(height: 20),

          WideCustomButton(
            text: "Continue",
            onPressed: () => Get.to(AppMain()),
          ),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt_outlined,
                  color: Color(0xff2563EB), size: 24),
              SizedBox(width: 8),
              Text(
                'Take another image',
                style: TextStyle(
                  color: Color(0xff2563EB),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
// import 'package:ridetohealthdriver/core/widgets/wide_custom_button.dart';

// import '../../../../app.dart';

// class CardPreviewScreen extends StatefulWidget {
//   final String imagePath;
//   final String governmentId;
//   final String driveingLicence;
//   final String selfiePhoto;
//   final String whichImage;

//   const CardPreviewScreen({
//     super.key,
//       this.imagePath = 'No Image', 
//        this.governmentId ='No Government ID', 
//         this.driveingLicence = 'No Driving Licence', 
//          this.selfiePhoto = 'No Selfie Photo',
//           required this.whichImage});

//   @override
//   State<CardPreviewScreen> createState() => _CardPreviewScreenState();
// }

// class _CardPreviewScreenState extends State<CardPreviewScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // backgroundColor: Colors.black,
//       body: Center(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       BackButton(color: Colors.white),
//                       Text(
//                         "Check Card Quality ",
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                       SizedBox(width: 50),
//                     ],
//                   ),
//                   const SizedBox(height: 40),
//                    Text(
//                    widget.whichImage != 'Selfie Photo' ? 'Cropped Image': '${widget.whichImage} Image',
//                     style: TextStyle(color: Colors.white, fontSize: 16),
//                   ),
//                   const SizedBox(height: 20),
//                   Image.file(File(widget.imagePath)),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Retake Photo"),
//                   ),
//                   const SizedBox(height: 20),
//                   Container(
//                     width: double.infinity,
//                     //margin: EdgeInsets.all(16),
//                     padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
//                     decoration: BoxDecoration(
//                       color: Colors.white10,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: Colors.white70, width: 1),
//                     ),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 90,
//                           width: 140,

//                           child: Image.asset(
//                             'assets/images/checkQuality.png',
//                             height: 90,
//                           ),
//                         ),
//                         "Check Quality".text24White(),
//                         "Please  make sure all 4 corner in the frame to read clearly"
//                             .text14White(),
//                         const SizedBox(height: 20),
//                         WideCustomButton(
//                           text: "Continue",
//                           onPressed: () {
//                             Get.to(AppMain());
//                           },
//                         ),
//                         const SizedBox(height: 20),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 12.0,
//                             horizontal: 32.0,
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.camera_alt_outlined,
//                                 color: Color(0xff2563EB),
//                                 size: 24,
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 'Take a image',
//                                 style: TextStyle(
//                                   color: Color(0xff2563EB),
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
