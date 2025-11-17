// lib/feature/identity/presentation/screens/card_preview_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../auth/controllers/auth_controller.dart';
import 'take_photo_screen.dart';

/// Canonical labels to avoid string typos across the app.
/// (If you already have a shared constants file, you can remove these
/// and import your constants instead.)
const String kSelfie  = 'Selfie Photo';
const String kGovId   = 'Government ID';
const String kDriving = 'Driving Licence';

class CardPreviewScreen extends StatefulWidget {
  /// Fallbacks from navigation args (legacy). The screen will prefer values
  /// saved in AuthController, but will use these if controller paths are null.
  final String governmentId;
  final String driveingLicence; // legacy param name kept for compatibility
  final String selfiePhoto;

  /// Which image flow we came from (Selfie / Government ID / Driving Licence)
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
    super.initState();
    authController = Get.find<AuthController>();
  }

  @override
  Widget build(BuildContext context) {
    // Files from controller (preferred source of truth)
    final license = authController.license; // Driving Licence image (XFile?)
    final nid     = authController.nid;     // Government ID image (XFile?)
    final selfie  = authController.selfie;  // Selfie image (XFile?)

    final titleStyle = const TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );

    return Scaffold(
      backgroundColor: Colors.black, // dark bg → better contrast for white text
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ---------------- HEADER ----------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      "Check Card Quality",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(width: 50),
                  ],
                ),

                const SizedBox(height: 25),

                // ---------------- MAIN TITLE ----------------
                Text(
                  widget.whichImage != kSelfie
                      ? 'Cropped Image'
                      : '${widget.whichImage} Image',
                  style: titleStyle,
                ),

                const SizedBox(height: 30),

                // ---------------- GOVERNMENT ID ----------------
                _buildImageBlock(
                  title: "Government ID",
                  // Prefer controller.nid, fall back to navigation argument
                  path: nid?.path ?? widget.governmentId,
                  retakeOnTap: () {
                    Get.to(() => const TakePhotoScreen(whichImage: kGovId));
                  },
                ),

                const SizedBox(height: 30),

                // ---------------- DRIVING LICENCE ----------------
                _buildImageBlock(
                  title: "Driving Licence",
                  // Prefer controller.license, fall back to navigation argument
                  path: license?.path ?? widget.driveingLicence,
                  retakeOnTap: () {
                    Get.to(() => const TakePhotoScreen(whichImage: kDriving));
                  },
                ),

                const SizedBox(height: 30),

                // ---------------- SELFIE PHOTO ----------------
                _buildImageBlock(
                  title: "Selfie Photo",
                  // Prefer controller.selfie, fall back to navigation argument
                  path: selfie?.path ?? widget.selfiePhoto,
                  retakeOnTap: () {
                    Get.to(() => const TakePhotoScreen(whichImage: kSelfie));
                  },
                ),

                const SizedBox(height: 30),

                // ---------------- RETAKE MAIN BUTTON ----------------
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text("Retake Main Photo"),
                ),

                const SizedBox(height: 30),

                // ---------------- QUALITY & CONTINUE ----------------
                _buildQualityBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // IMAGE BLOCK WITH RETAKE BUTTON
  // ============================================================
  Widget _buildImageBlock({
    required String title,
    required String path,
    required VoidCallback retakeOnTap,
  }) {
    final hasImage = _fileLooksValid(path);

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
          // ---- HEADING ----
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          // ---- IMAGE ----
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

          // ---- RETAKE BUTTON ----
          GestureDetector(
            onTap: retakeOnTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Retake",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SHIMMER PLACEHOLDER (simple)
  // ============================================================
  Widget _buildShimmer() {
    return const Center(
      child: Text(
        "Image not found",
        style: TextStyle(color: Colors.white54),
      ),
    );
  }

  // ============================================================
  // QUALITY CHECK BOX + CONTINUE
  // ============================================================
  Widget _buildQualityBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white70),
      ),
      child: Column(
        children: [
          const Icon(Icons.verified, color: Colors.white, size: 44),
          const SizedBox(height: 8),
          const Text(
            "Check Quality",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          const Text(
            "Make sure all 4 corners are visible clearly.",
            style: TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // ---- CONTINUE → triggers registration using controller fields ----
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _submitRegistration,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              child: const Text(
                "Continue",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ---- Optional helper row ----
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.camera_alt_outlined, color: Color(0xff2563EB), size: 20),
              SizedBox(width: 8),
              Text(
                'Take another image',
                style: TextStyle(
                  color: Color(0xff2563EB),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Submit: validate controller fields and call register()
  // ============================================================
  Future<void> _submitRegistration() async {
    // Pull everything from controller; these should have been filled earlier
    // via UserSignupScreen.setRegistrationData(...) and TakePhotoScreen.
    final name   = authController.name.trim();
    final email  = authController.userEmail.trim(); // use userEmail (not email)
    final phone  = authController.phoneNumber.trim();
    final dlNo   = authController.drivingLicenceNumber.trim();
    final nidNo  = authController.nationalIdNumber.trim();
    final srv    = authController.serviceType.trim();
    final pass   = authController.password;
    final role   = (authController.role.isNotEmpty ? authController.role : 'driver');

    final license = authController.license;
    final nid     = authController.nid;
    final selfie  = authController.selfie;

    // Basic validation (client-side)
    String? err;
    if (name.isEmpty) err = 'Full name is required';
    else if (email.isEmpty) err = 'Email is required';
    else if (phone.isEmpty) err = 'Phone number is required';
    else if (dlNo.isEmpty) err = 'Driving licence number is required';
    else if (nidNo.isEmpty) err = 'National ID number is required';
    else if (srv.isEmpty) err = 'Service type is required';
    else if (pass.isEmpty) err = 'Password is required';
    else if (license == null) err = 'Driving Licence photo is required';
    else if (nid == null) err = 'Government ID photo is required';
    else if (selfie == null) err = 'Selfie photo is required';

    if (err != null) {
      Get.snackbar(
        'Missing information',
        err,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
      return;
    }

    // Call your existing controller.register(...)
    try {
      await authController.register(
        'email_verification', // otpVerifyType
        name,
        email,
        phone,
        dlNo,
        nidNo,
        srv,
        pass,
        role,
        license!, // null-checked above
        nid!,
        selfie!,
      );
      // On success, your controller navigates to VerifyOtpScreen.
    } catch (e) {
      Get.snackbar(
        'Registration failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(12),
      );
    }
  }

  // Small helper: avoid false positives from "No X" placeholders
  bool _fileLooksValid(String path) {
    if (path.isEmpty) return false;
    if (path == 'No Government ID' ||
        path == 'No Driving Licence' ||
        path == 'No Selfie Photo' ||
        path == 'No Image') {
      return false;
    }
    return File(path).existsSync();
  }
}




// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
// import 'package:ridetohealthdriver/core/widgets/wide_custom_button.dart';
// import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';
// import '../../../../app.dart';
// import '../widgets/show_modal_bottom_sheet.dart';
// import 'take_photo_screen.dart';


// class CardPreviewScreen extends StatefulWidget {
//   final String governmentId;
//   final String driveingLicence;
//   final String selfiePhoto;
//   final String whichImage;
  

//   const CardPreviewScreen({
//     super.key,
//     this.governmentId = 'No Government ID',
//     this.driveingLicence = 'No Driving Licence',
//     this.selfiePhoto = 'No Selfie Photo',
//     required this.whichImage,
//   });

//   @override
//   State<CardPreviewScreen> createState() => _CardPreviewScreenState();
// }

// class _CardPreviewScreenState extends State<CardPreviewScreen> {
//   late AuthController authController;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     authController = Get.find<AuthController>();
//   }

//   @override
//   Widget build(BuildContext context) {

// // Debug print showing all four values
// debugPrint(
//   'CardPreview values -> Government ID: ${widget.governmentId}, '
//   'Driving Licence: ${widget.driveingLicence}, '
//   'Selfie Photo: ${widget.selfiePhoto}, '
//   'Which Image: ${widget.whichImage}',
// );
// // Read values from authController and print them with labels
// String name = authController.name ?? '';
// String userEmail = authController.email ?? '';
// String phoneNumber = authController.phoneNumber ?? '';
// String drivingLicenceNumber = authController.drivingLicenceNumber ?? '';
// String nationalIdNumber = authController.nationalIdNumber ?? '';
// String serviceType = authController.serviceType ?? '';
// String password = authController.password ?? '';
// String role = authController.role ?? 'driver';

// // files from controller (kept as dynamic to avoid requiring XFile import here)
// final license = authController.license;
// final nid = authController.nid;
// final selfie = authController.selfie;

// debugPrint('AuthController values -> '
//   'Name: $name, '
//   'Email: $userEmail, '
//   'Phone: $phoneNumber, '
//   'Driving Licence No: $drivingLicenceNumber, '
//   'National ID No: $nationalIdNumber, '
//   'Service Type: $serviceType, '
//   'Password: ${password.isNotEmpty ? '****' : '(empty)'}, '
//   'Role: $role, '
//   'License file: ${license?.path ?? license?.toString() ?? 'null'}, '
//   'NID file: ${nid?.path ?? nid?.toString() ?? 'null'}, '
//   'Selfie file: ${selfie?.path ?? selfie?.toString() ?? 'null'}');
//     return Scaffold(
//       // backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 /// ---------------- HEADER ----------------
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     BackButton(color: Colors.white, onPressed: () => showBlurredBottomSheet(context),),
//                     const Text(
//                       "Check Card Quality",
//                       style: TextStyle(color: Colors.white, fontSize: 18),
//                     ),
//                     const SizedBox(width: 50),
//                   ],
//                 ),

//                 const SizedBox(height: 25),

//                 /// ---------------- MAIN IMAGE TITLE ----------------
//                 Text(
//                   widget.whichImage != 'Selfie Photo'
//                       ? 'Cropped Image'
//                       : '${widget.whichImage} Image',
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),

//                 const SizedBox(height: 15),



//                 const SizedBox(height: 30),

//                 /// ---------------- GOVERNMENT ID ----------------
//                 _buildImageBlock(
//                   title: "Government ID",
//                   // path: widget.governmentId,
//                   path: license?.path ?? 'No Government ID',
//                   retakeOnTap: () {
//                     Get.to(TakePhotoScreen(whichImage: 'Government ID'));
//                   },
//                 ),

//                 const SizedBox(height: 30),

//                 /// ---------------- DRIVING LICENCE ----------------
//                 _buildImageBlock(
//                   title: "Driving Licence",
//                   path: widget.driveingLicence,
//                   retakeOnTap: () {
//                     Get.to(TakePhotoScreen(whichImage: 'Driving Licence'));
//                   },
//                 ),

//                 const SizedBox(height: 30),

//                 /// ---------------- SELFIE PHOTO ----------------
//                 _buildImageBlock(
//                   title: "Selfie Photo",
//                   path: widget.selfiePhoto,
//                   retakeOnTap: () {
//                     Get.to(TakePhotoScreen(whichImage: 'Selfie Photo'));
//                   },
//                 ),

//                 const SizedBox(height: 30),

//                 /// ---------------- RETAKE MAIN BUTTON ----------------
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: Colors.black,
//                   ),
//                   child: const Text("Retake Main Photo"),
//                 ),

//                 const SizedBox(height: 30),

//                 /// ---------------- QUALITY CHECK BOX ----------------
//                 _buildQualityBox(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   /// ============================================================
//   /// IMAGE BLOCK WITH RETAKE BUTTON
//   /// ============================================================
//   Widget _buildImageBlock({
//     required String title,
//     required String path,
//     required VoidCallback retakeOnTap,
//   }) {
//     bool hasImage = path != 'No Image' &&
//         path != 'No Government ID' &&
//         path != 'No Driving Licence' &&
//         path != 'No Selfie Photo';

//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white12,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white24),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           /// ---- HEADING ----
//           Text(
//             title,
//             style: const TextStyle(
//               color: Colors.white,
//               fontSize: 17,
//               fontWeight: FontWeight.w600,
//             ),
//           ),

//           const SizedBox(height: 12),

//           /// ---- IMAGE ----
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Container(
//               width: double.infinity,
//               height: 220,
//               color: Colors.white10,
//               child: hasImage
//                   ? Image.file(File(path), fit: BoxFit.cover)
//                   : _buildShimmer(),
//             ),
//           ),

//           const SizedBox(height: 12),

//           /// ---- RETAKE BUTTON ----
//           GestureDetector(
//             onTap: retakeOnTap,
//             child: Container(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               decoration: BoxDecoration(
//                 color: Colors.white24,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 "Retake",
//                 style: TextStyle(
//                     color: Colors.white, fontWeight: FontWeight.w500),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// ============================================================
//   /// SHIMMER PLACEHOLDER
//   /// ============================================================
//   Widget _buildShimmer() {
//     return Container(
//       alignment: Alignment.center,
//       child: Text(
//         "Image not found",
//         style: TextStyle(color: Colors.white54),
//       ),
//     );
//   }

//   /// ============================================================
//   /// QUALITY CHECK BOX
//   /// ============================================================
//   Widget _buildQualityBox() {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
//       decoration: BoxDecoration(
//         color: Colors.white10,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white70),
//       ),
//       child: Column(
//         children: [
//           Image.asset('assets/images/checkQuality.png', height: 90),

//           "Check Quality".text24White(),
//           "Make sure all 4 corners are visible clearly.".text14White(),

//           const SizedBox(height: 20),

//           WideCustomButton(
//             text: "Continue",
//             onPressed: () => Get.to(AppMain()),
//           ),

//           const SizedBox(height: 20),

//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: const [
//               Icon(Icons.camera_alt_outlined,
//                   color: Color(0xff2563EB), size: 24),
//               SizedBox(width: 8),
//               Text(
//                 'Take another image',
//                 style: TextStyle(
//                   color: Color(0xff2563EB),
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

