
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:permission_handler/permission_handler.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';

import '../../../../utils/app_constants.dart';
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

      final isSelfie = widget.whichImage == AppConstants.kSelfie;
      final preferredDirection =
          isSelfie ? CameraLensDirection.front : CameraLensDirection.back;
      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == preferredDirection,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        selectedCamera,
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

    // ---------- SELFIE PHOTO ----------
    if (widget.whichImage == AppConstants.kSelfie) {
      final xfile = XFile(file.path);
      authController.selfie = xfile;
      authController.setRegistrationData(selfieFile: xfile);
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CardPreviewScreen(
            selfiePhoto: file.path,
            whichImage: AppConstants.kSelfie,
          ),
        ),
      );
      return;
    }

    // ---------- CROPPING FOR GOV ID / DRIVING LICENCE ----------
    final bytes = await File(file.path).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) return;

    final renderBox = _cameraKey.currentContext!.findRenderObject() as RenderBox;
    final overlaySize = renderBox.size;

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

    final croppedFile = await File('${file.path}_cropped.jpg')
        .writeAsBytes(img.encodeJpg(cropped));

    // ---------- ASSIGN TO CORRECT FIELD ----------
    if (widget.whichImage == AppConstants.kGovId) {
      final xfile = XFile(croppedFile.path);
      authController.nid = xfile;
      authController.setRegistrationData(nidFile: xfile);
    } else if (widget.whichImage == AppConstants.kDriving) {
      final xfile = XFile(croppedFile.path);
      authController.license = xfile; // ✅ fixed assignment
      authController.setRegistrationData(licenseFile: xfile);
    }

    debugPrint('nid: ${authController.nid?.path}');
    debugPrint('license: ${authController.license?.path}');
    debugPrint('selfie: ${authController.selfie?.path}');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => CardPreviewScreen(
          governmentId: widget.whichImage == AppConstants.kGovId
              ? croppedFile.path
              : 'No Government ID',
          driveingLicence: widget.whichImage == AppConstants.kDriving
              ? croppedFile.path
              : 'No Driving Licence',
          whichImage: widget.whichImage ?? 'No type found',
        ),
      ),
      (route) => !route.isCurrent,
    );
  } catch (e) {
    debugPrint("Capture or crop error: $e");
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Failed: $e")));
  }
}


  // void _capturePhoto() async {
  //   if (!_isCardAligned || !_cameraController!.value.isInitialized) return;

  //   try {
  //     final file = await _cameraController!.takePicture();

  //     // If Selfie Photo → skip cropping
  //     if (widget.whichImage == 'Selfie Photo') {
  //       debugPrint('For Selfie Photos Picture saved to ${file.path}');
  //       if (!mounted) return;

  //       final xfile = XFile(file.path);

  //       authController.setRegistrationData(selfieFile: xfile);
  //       authController.selfie = xfile;

  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (_) => CardPreviewScreen(
  //             selfiePhoto: file.path,
  //             whichImage: widget.whichImage ?? 'No Selfie Photo',
  //           ),
  //         ),
  //       );
  //       return;
  //     }

  //     final bytes = await File(file.path).readAsBytes();
  //     final image = img.decodeImage(bytes);

  //     if (image == null) return;

  //     // 🖼️ Get screen size of camera preview overlay
  //     final renderBox =
  //         _cameraKey.currentContext!.findRenderObject() as RenderBox;
  //     final overlaySize = renderBox.size;

  //     // 🔁 Define the same proportions used in _buildOverlay()
  //     const cardWidth = 345.0;
  //     const cardHeight = 230.0;
  //     final screenW = overlaySize.width;
  //     final screenH = overlaySize.height;
  //     final scale = screenW / cardWidth;
  //     final overlayW = cardWidth * scale;
  //     final overlayH = cardHeight * scale;
  //     final left = (screenW - overlayW) / 2;
  //     final top = (screenH - overlayH) / 2;

  //     final imageW = image.width;
  //     final imageH = image.height;

  //     // Map overlay rect to image dimensions
  //     final cropX = (left / screenW * imageW).toInt();
  //     final cropY = (top / screenH * imageH).toInt();
  //     final cropW = (overlayW / screenW * imageW).toInt();
  //     final cropH = (overlayH / screenH * imageH).toInt();

  //     final cropped = img.copyCrop(
  //       image,
  //       x: cropX,
  //       y: cropY,
  //       width: cropW,
  //       height: cropH,
  //     );
  //     final croppedFile = await File(
  //       '${file.path}_cropped.jpg',
  //     ).writeAsBytes(img.encodeJpg(cropped));

  //     if (!mounted) return;
  //     debugPrint(
  //       'Cropped Image Picture saved to ${file.path} and the image type is ${widget.whichImage}',
  //     );

  //     debugPrint(
  //       'Cropped Image Picture saved to ${croppedFile.path} and the image type is ${widget.whichImage}',
  //     );
  //     if (widget.whichImage == AppConstants.kGovId) {
  //       final xfile = XFile(croppedFile.path);
  //       authController.nid = xfile;
  //     } else if (widget.whichImage == AppConstants.kDriving) {
  //       final xfile = XFile(croppedFile.path);
  //       authController.selfie = xfile;
  //     }
  //     // if (widget.whichImage == 'Government ID') {
  //     //     final xfile = XFile(croppedFile.path);
  //     //     authController.nid =
  //     //     authController.nid =xfile;
  //     //   } else if (widget.whichImage == 'Driveing Licence') {
  //     //     final xfile = XFile(croppedFile.path);
  //     //     authController.selfie= xfile;
  //     //   }
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (_) => CardPreviewScreen(
  //           governmentId: widget.whichImage == AppConstants.contactUs
  //               ? croppedFile.path
  //               : 'No Government ID',
  //           driveingLicence: widget.whichImage == AppConstants. kDriving
  //               ? croppedFile.path
  //               : 'No Driving Licence',
  //           whichImage: widget.whichImage ?? 'No type found',
  //         ),
  //         //AdjustCropScreen(imagePath: croppedFile.path, whichImage: widget.whichImage ?? 'No type found',),
  //       ),
  //     );
  //   } catch (e) {
  //     debugPrint("Capture or crop error: $e");
  //     if (!mounted) return;
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text("Failed: $e")));
  //   }
  // }

  
  
  
  
  
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
                widget.whichImage != AppConstants.kSelfie
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
