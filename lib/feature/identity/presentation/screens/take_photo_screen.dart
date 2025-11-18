// // take_photo_screen.dart
// import 'dart:io';
// import 'dart:math' as math;
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image/image.dart' as img;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';

// import 'card_preview_screen.dart';

// // Canonical labels to avoid typos
// const kSelfie = 'Selfie Photo';
// const kGovId = 'Government ID';
// const kDriving = 'Driving Licence';

// class TakePhotoScreen extends StatefulWidget {
//   final String whichImage; // <- not nullable; you always pass it

//   const TakePhotoScreen({super.key, required this.whichImage});

//   @override
//   State<TakePhotoScreen> createState() => _TakePhotoScreenState();
// }

// class _TakePhotoScreenState extends State<TakePhotoScreen> {
//   CameraController? _cameraController;
//   late AuthController authController;
//   bool _isCameraInitialized = false;
//   bool _cameraError = false;
//   double _currentZoomLevel = 1.0;
//   bool _isCardAligned = false;

//   bool get _needsAlignment => widget.whichImage != kSelfie;

//   @override
//   void initState() {
//     super.initState();
//     authController = Get.find<AuthController>();
//     _initializeCamera();
//     if (_needsAlignment) {
//       _simulateCardDetection(); // simulate ONCE, not per build
//     } else {
//       _isCardAligned = true; // selfies shouldn't be gated
//     }
//   }

//   Future<void> _initializeCamera() async {
//     final status = await Permission.camera.request();
//     if (!status.isGranted) {
//       if (status.isPermanentlyDenied) {
//         await openAppSettings();
//       }
//       setState(() => _cameraError = true);
//       return;
//     }

//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) {
//         setState(() => _cameraError = true);
//         return;
//       }

//       final back = _findCamera(cameras, CameraLensDirection.back) ?? cameras.first;
//       final front = _findCamera(cameras, CameraLensDirection.front) ?? back;
//       final selected = (widget.whichImage == kSelfie) ? front : back;

//       _cameraController = CameraController(
//         selected,
//         ResolutionPreset.max,
//         enableAudio: false,
//         imageFormatGroup: ImageFormatGroup.jpeg,
//       );

//       await _cameraController!.initialize();
//       // Clamp initial zoom to supported range
//       final minZ = await _cameraController!.getMinZoomLevel();
//       final maxZ = await _cameraController!.getMaxZoomLevel();
//       _currentZoomLevel = _currentZoomLevel.clamp(minZ, maxZ);
//       await _cameraController!.setZoomLevel(_currentZoomLevel);

//       if (mounted) setState(() => _isCameraInitialized = true);
//     } catch (_) {
//       if (mounted) setState(() => _cameraError = true);
//     }
//   }

//   CameraDescription? _findCamera(
//     List<CameraDescription> cams,
//     CameraLensDirection dir,
//   ) {
//     for (final c in cams) {
//       if (c.lensDirection == dir) return c;
//     }
//     return null;
//   }

//   @override
//   void dispose() {
//     _cameraController?.dispose();
//     super.dispose();
//   }

//   void _simulateCardDetection() {
//     Future.delayed(const Duration(seconds: 2), () {
//       if (mounted) setState(() => _isCardAligned = true);
//     });
//   }

//   Future<void> _capturePhoto() async {
//     final ctrl = _cameraController;
//     if (ctrl == null || !ctrl.value.isInitialized) return;
//     if (_needsAlignment && !_isCardAligned) return;

//     try {
//       final xfile = await ctrl.takePicture();

//       // ---- Selfie: no cropping ----
//       if (widget.whichImage == kSelfie) {
//         authController.setRegistrationData(selfieFile: xfile);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => CardPreviewScreen(
//               selfiePhoto: xfile.path,
//               whichImage: widget.whichImage,
//             ),
//           ),
//         );
//         return;
//       }

//       // ---- Card types: crop to overlay rect ----
//       final screenSize = MediaQuery.of(context).size;
//       final cropped = await _cropToOverlay(xfile.path, screenSize);

//       final croppedX = XFile(cropped.path);

//       // Put files in the correct controller fields
//       if (widget.whichImage == kGovId) {
//         authController.setRegistrationData(nidFile: croppedX);
//       } else if (widget.whichImage == kDriving) {
//         authController.setRegistrationData(licenseFile: croppedX);
//       }

//       if (!mounted) return;

//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => CardPreviewScreen(
//             governmentId: widget.whichImage == kGovId ? cropped.path : 'No Government ID',
//             // keep existing param name "driveingLicence" but pass correct value
//             driveingLicence: widget.whichImage == kDriving ? cropped.path : 'No Driving Licence',
//             whichImage: widget.whichImage,
//           ),
//         ),
//       );
//     } catch (e) {
//       if (!mounted) return;
//       debugPrint("Capture or crop error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Failed: $e")),
//       );
//     }
//   }

//   // --- Geometry helpers ------------------------------------------------------

//   // Where the preview actually sits on screen when using AspectRatio
//   Rect _previewRect(Size screen) {
//     final ctrl = _cameraController!;
//     final previewAspect = ctrl.value.aspectRatio; // width/height in landscape terms
//     final previewHeight = screen.width / previewAspect;
//     final top = (screen.height - previewHeight) / 2.0;
//     return Rect.fromLTWH(0, top, screen.width, previewHeight);
//   }

//   // Target overlay inside the preview (ID-1 card aspect ≈ 1.586)
//   static const double _idAspect = 85.60 / 53.98;

//   RRect _overlayRRect(Size screen) {
//     final preview = _previewRect(screen);
//     final cardWidth = preview.width * 0.90; // 90% of preview width
//     final cardHeight = cardWidth / _idAspect;
//     final left = (screen.width - cardWidth) / 2.0;
//     final top = preview.top + (preview.height - cardHeight) / 2.0;
//     return RRect.fromLTRBR(
//       left,
//       top,
//       left + cardWidth,
//       top + cardHeight,
//       const Radius.circular(12),
//     );
//   }

//   Future<File> _cropToOverlay(String imagePath, Size screen) async {
//     final bytes = await File(imagePath).readAsBytes();
//     var decoded = img.decodeImage(bytes);
//     if (decoded == null) throw Exception('Unable to decode image');

//     // Normalize orientation so width/height match what the user saw
//     try {
//       decoded = img.bakeOrientation(decoded); // available on image ^4.x
//     } catch (_) {
//       // If using older image versions, skip or manually rotate if needed.
//     }

//     final overlay = _overlayRRect(screen).outerRect;
//     final preview = _previewRect(screen);

//     // Map overlay (screen space) -> preview (normalized) -> image pixels
//     final nx = ((overlay.left - preview.left) / preview.width).clamp(0.0, 1.0);
//     final ny = ((overlay.top - preview.top) / preview.height).clamp(0.0, 1.0);
//     final nw = (overlay.width / preview.width).clamp(0.0, 1.0);
//     final nh = (overlay.height / preview.height).clamp(0.0, 1.0);

//     final cropX = (nx * decoded!.width).round();
//     final cropY = (ny * decoded.height).round();
//     final cropW = math.max(1, (nw * decoded.width).round());
//     final cropH = math.max(1, (nh * decoded.height).round());

//     final cropped = img.copyCrop(
//       decoded,
//       x: cropX,
//       y: cropY,
//       width: math.min(cropW, decoded.width - cropX),
//       height: math.min(cropH, decoded.height - cropY),
//     );

//     final out = File('${imagePath}_cropped.jpg');
//     await out.writeAsBytes(img.encodeJpg(cropped, quality: 95));
//     return out;
//   }

//   Future<void> _setZoom(double zoom) async {
//     if (_cameraController == null) return;
//     final minZ = await _cameraController!.getMinZoomLevel();
//     final maxZ = await _cameraController!.getMaxZoomLevel();
//     final clamped = zoom.clamp(minZ, maxZ);
//     await _cameraController!.setZoomLevel(clamped);
//     if (mounted) setState(() => _currentZoomLevel = clamped);
//   }

//   // --- UI --------------------------------------------------------------------

//   @override
//   Widget build(BuildContext context) {
//     if (_cameraError) return _buildErrorMessage();

//     if (!_isCameraInitialized) {
//       return const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     final ctrl = _cameraController!;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           final screen = Size(constraints.maxWidth, constraints.maxHeight);
//           return Stack(
//             children: [
//               // Keep aspect ratio to avoid stretch; center vertically
//               Positioned.fill(
//                 child: Center(
//                   child: AspectRatio(
//                     aspectRatio: ctrl.value.aspectRatio,
//                     child: CameraPreview(ctrl),
//                   ),
//                 ),
//               ),
//               if (_needsAlignment) _buildOverlay(screen),
//               _buildHeader(),
//               _buildBottomControls(),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildOverlay(Size screen) {
//     final rrect = _overlayRRect(screen);
//     return IgnorePointer(
//       child: CustomPaint(
//         size: Size(screen.width, screen.height),
//         painter: _HolePainter(
//           rrect: rrect,
//           maskColor: Colors.black.withOpacity(0.55),
//           borderColor: _isCardAligned ? Colors.green : Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.all(12),
//         child: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => Navigator.pop(context),
//             ),
//             Text(
//               'Take ${widget.whichImage} Photo',
//               style: const TextStyle(color: Colors.white, fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomControls() {
//     return Column(
//       children: [
//         const Spacer(),
//         _buildZoomOptions(),
//         const SizedBox(height: 20),
//         _buildCaptureButton(),
//         const SizedBox(height: 30),
//       ],
//     );
//   }

//   Widget _buildZoomOptions() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _zoomOption(".7x", 0.7),
//         _zoomOption("1x", 1.0),
//         _zoomOption("2x", 2.0),
//       ],
//     );
//   }

//   Widget _zoomOption(String label, double zoom) {
//     final isSelected = (_currentZoomLevel - zoom).abs() < 0.05;
//     return GestureDetector(
//       onTap: () => _setZoom(zoom),
//       child: Container(
//         margin: const EdgeInsets.symmetric(horizontal: 12),
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white : Colors.black45,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: isSelected ? Colors.black : Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCaptureButton() {
//     final enabled = !_needsAlignment || _isCardAligned;
//     return GestureDetector(
//       onTap: enabled ? _capturePhoto : null,
//       child: Container(
//         width: 80,
//         height: 80,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: enabled ? Colors.green : Colors.grey,
//           border: Border.all(color: Colors.white, width: 2),
//         ),
//         child: const Icon(Icons.camera_alt, size: 32, color: Colors.white),
//       ),
//     );
//   }

//   Widget _buildErrorMessage() => const Scaffold(
//         backgroundColor: Colors.black,
//         body: Center(
//           child: Text(
//             'Camera not available.\nPlease check permissions.',
//             style: TextStyle(color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//         ),
//       );
// }

// // Paint a dark mask with a rounded-rect hole + border
// class _HolePainter extends CustomPainter {
//   final RRect rrect;
//   final Color maskColor;
//   final Color borderColor;

//   _HolePainter({
//     required this.rrect,
//     required this.maskColor,
//     required this.borderColor,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final bg = Path()..addRect(Offset.zero & size);
//     final cut = Path()..addRRect(rrect);
//     final diff = Path.combine(PathOperation.difference, bg, cut);
//     canvas.drawPath(diff, Paint()..color = maskColor);

//     final border = Paint()
//       ..color = borderColor
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke;
//     canvas.drawRRect(rrect, border);
//   }

//   @override
//   bool shouldRepaint(covariant _HolePainter old) =>
//       old.rrect != rrect || old.maskColor != maskColor || old.borderColor != borderColor;
// }



// 📦 Import statements
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';

import '../widgets/adjust_crop_screen.dart';
import 'card_preview_screen.dart';

// 📸 TakePhotoScreen
class TakePhotoScreen extends StatefulWidget {
  final String? whichImage;

  const TakePhotoScreen({super.key, required this.whichImage});

  @override
  State<TakePhotoScreen> createState() => _TakePhotoScreenState();
}

class _TakePhotoScreenState extends State<TakePhotoScreen> {
  CameraController? _cameraController;
  late AuthController authController;
  bool _isCameraInitialized = false;
  bool _cameraError = false;
  double _currentZoomLevel = 1.0;
  bool _isCardAligned = false;
  final GlobalKey _cameraKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    authController = Get.find<AuthController>();
  }

  Future<void> _initializeCamera() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      final cameras = await availableCameras();
      if (cameras.isEmpty) return setState(() => _cameraError = true);

      _cameraController = CameraController(
        widget.whichImage != 'Selfie Photo' ? cameras[0] : cameras[1],
        ResolutionPreset.max,
        enableAudio: false,
      );

      try {
        await _cameraController!.initialize();
        setState(() => _isCameraInitialized = true);
      } catch (_) {
        setState(() => _cameraError = true);
      }
    } else {
      setState(() => _cameraError = true);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _simulateCardDetection() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isCardAligned = true);
    });
  }

  void _capturePhoto() async {
    if (!_isCardAligned || !_cameraController!.value.isInitialized) return;

    try {
      final file = await _cameraController!.takePicture();

      // If Selfie Photo → skip cropping
      if (widget.whichImage == 'Selfie Photo') {
        debugPrint('For Selfie Photos Picture saved to ${file.path}');
        if (!mounted) return;

        final xfile = XFile(file.path);

        authController.setRegistrationData(selfieFile: xfile);
        authController.selfie = xfile;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CardPreviewScreen(
              selfiePhoto: file.path,
              whichImage: widget.whichImage ?? 'No Selfie Photo',
            ),
          ),
        );
        return;
      }

      final bytes = await File(file.path).readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) return;

      // 🖼️ Get screen size of camera preview overlay
      final renderBox =
          _cameraKey.currentContext!.findRenderObject() as RenderBox;
      final overlaySize = renderBox.size;

      // 🔁 Define the same proportions used in _buildOverlay()
      const cardWidth = 345.0;
      const cardHeight = 230.0;
      final screenW = overlaySize.width;
      final screenH = overlaySize.height;
      final scale = screenW / cardWidth;
      final overlayW = cardWidth * scale;
      final overlayH = cardHeight * scale;
      final left = (screenW - overlayW) / 2;
      final top = (screenH - overlayH) / 2;

      final imageW = image.width;
      final imageH = image.height;

      // Map overlay rect to image dimensions
      final cropX = (left / screenW * imageW).toInt();
      final cropY = (top / screenH * imageH).toInt();
      final cropW = (overlayW / screenW * imageW).toInt();
      final cropH = (overlayH / screenH * imageH).toInt();

      final cropped = img.copyCrop(
        image,
        x: cropX,
        y: cropY,
        width: cropW,
        height: cropH,
      );
      final croppedFile = await File(
        '${file.path}_cropped.jpg',
      ).writeAsBytes(img.encodeJpg(cropped));

      if (!mounted) return;
      debugPrint(
        'Cropped Image Picture saved to ${file.path} and the image type is ${widget.whichImage}',
      );

      debugPrint(
        'Cropped Image Picture saved to ${croppedFile.path} and the image type is ${widget.whichImage}',
      );
      if (widget.whichImage == 'Government ID') {
        final xfile = XFile(croppedFile.path);
        authController.nid = xfile;
      } else if (widget.whichImage == 'Driving Licence') {
        final xfile = XFile(croppedFile.path);
        authController.selfie = xfile;
      }
      // if (widget.whichImage == 'Government ID') {
      //     final xfile = XFile(croppedFile.path);
      //     authController.nid =
      //     authController.nid =xfile;
      //   } else if (widget.whichImage == 'Driveing Licence') {
      //     final xfile = XFile(croppedFile.path);
      //     authController.selfie= xfile;
      //   }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CardPreviewScreen(
            governmentId: widget.whichImage == 'Government ID'
                ? croppedFile.path
                : 'No Government ID',
            driveingLicence: widget.whichImage == 'Driveing Licence'
                ? croppedFile.path
                : 'No Driving Licence',
            whichImage: widget.whichImage ?? 'No type found',
          ),
          //AdjustCropScreen(imagePath: croppedFile.path, whichImage: widget.whichImage ?? 'No type found',),
        ),
      );
    } catch (e) {
      debugPrint("Capture or crop error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed: $e")));
    }
  }

  void _setZoom(double zoom) async {
    await _cameraController?.setZoomLevel(zoom);
    setState(() => _currentZoomLevel = zoom);
  }

  @override
  Widget build(BuildContext context) {
    _simulateCardDetection();

    return Scaffold(
      backgroundColor: Colors.black,
      body: _cameraError
          ? _buildErrorMessage()
          : !_isCameraInitialized
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              key: _cameraKey,
              children: [
                CameraPreview(_cameraController!),
                widget.whichImage != 'Selfie Photo'
                    ? _buildOverlay()
                    : SizedBox(),
                _buildHeader(),
                _buildBottomControls(),
              ],
            ),
    );
  }

  Widget _buildOverlay() {
    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          const cardWidth = 345.0;
          const cardHeight = 230.0;
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;
          final scale = screenWidth / cardWidth;
          final overlayWidth = cardWidth * scale;
          final overlayHeight = cardHeight * scale;
          final left = (screenWidth - overlayWidth) / 2;
          final top = (screenHeight - overlayHeight) / 2;

          return Stack(
            children: [
              Container(color: Colors.transparent.withOpacity(0.5)),
              Positioned(
                left: left,
                top: top,
                width: overlayWidth,
                height: overlayHeight,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(color: Colors.transparent),
                ),
              ),
              Positioned(
                left: left,
                top: top,
                width: overlayWidth,
                height: overlayHeight,
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _CardBorderPainter(
                      color: _isCardAligned ? Colors.green : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(12),
        // color: Colors.black.withOpacity(0.5),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Text(
              'Take ${''}${'${widget.whichImage}'} Photo',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Column(
      children: [
        const Spacer(),
        _buildZoomOptions(),
        const SizedBox(height: 20),
        _buildCaptureButton(),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildZoomOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _zoomOption(".7x", 0.7),
        _zoomOption("1x", 1.0),
        _zoomOption("2x", 2.0),
      ],
    );
  }

  Widget _zoomOption(String label, double zoom) {
    final isSelected = (_currentZoomLevel - zoom).abs() < 0.05;
    return GestureDetector(
      onTap: () => _setZoom(zoom),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.black45,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCaptureButton() {
    return GestureDetector(
      onTap: _isCardAligned ? _capturePhoto : null,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _isCardAligned ? Colors.green : Colors.grey,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.camera_alt, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildErrorMessage() => const Center(
    child: Text(
      'Camera not available.\nPlease check permissions.',
      style: TextStyle(color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );
}

class _CardBorderPainter extends CustomPainter {
  final Color color;
  _CardBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    const radius = 16.0;
    const length = 30.0;

    final path = Path();
    path.moveTo(0, radius);
    path.arcToPoint(Offset(radius, 0), radius: Radius.circular(radius));
    path.moveTo(0, length);
    path.lineTo(0, 0);
    path.lineTo(length, 0);

    path.moveTo(size.width - length, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, length);
    path.moveTo(size.width - radius, 0);
    path.arcToPoint(
      Offset(size.width, radius),
      radius: Radius.circular(radius),
    );

    path.moveTo(size.width, size.height - length);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - length, size.height);
    path.moveTo(size.width, size.height - radius);
    path.arcToPoint(
      Offset(size.width - radius, size.height),
      radius: Radius.circular(radius),
    );

    path.moveTo(length, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, size.height - length);
    path.moveTo(radius, size.height);
    path.arcToPoint(
      Offset(0, size.height - radius),
      radius: Radius.circular(radius),
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
