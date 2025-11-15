import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import '../screens/card_preview_screen.dart';

class AdjustCropScreen extends StatefulWidget {
  final String imagePath;
  final String whichImage;
  const AdjustCropScreen({super.key, required this.imagePath, required this.whichImage});

  @override
  State<AdjustCropScreen> createState() => _AdjustCropScreenState();
}

class _AdjustCropScreenState extends State<AdjustCropScreen> {
  late Rect cropRect;
  Offset? dragStart;
  Offset? rectStartPosition;

  // Fixed ratio H:W = 230:345
  static const double ratioH = 230;
  static const double ratioW = 345;

  Size? imageWidgetSize;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final screenSize = MediaQuery.of(context).size;
      final width = screenSize.width - 32; // 16 px padding each side
      final height = width * (ratioH / ratioW);

      final left = 16.0;
      final top = (screenSize.height - height) / 2;

      setState(() {
        cropRect = Rect.fromLTWH(left, top, width, height);
      });
    });
  }

  void _onPanStart(DragStartDetails details) {
    if (cropRect.contains(details.localPosition)) {
      dragStart = details.localPosition;
      rectStartPosition = Offset(cropRect.left, cropRect.top);
    } else {
      dragStart = null;
      rectStartPosition = null;
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (dragStart == null ||
        rectStartPosition == null ||
        imageWidgetSize == null)
      return;

    final delta = details.localPosition - dragStart!;
    double newLeft = rectStartPosition!.dx + delta.dx;
    double newTop = rectStartPosition!.dy + delta.dy;

    // Clamp within imageWidgetSize boundaries (with 16px padding left/right)
    final maxLeft = imageWidgetSize!.width - cropRect.width;
    final maxTop = imageWidgetSize!.height - cropRect.height;

    if (newLeft < 0) newLeft = 0;
    if (newLeft > maxLeft) newLeft = maxLeft;

    if (newTop < 0) newTop = 0;
    if (newTop > maxTop) newTop = maxTop;

    setState(() {
      cropRect = Rect.fromLTWH(
        newLeft,
        newTop,
        cropRect.width,
        cropRect.height,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    dragStart = null;
    rectStartPosition = null;
  }

  Future<void> _cropImage() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null || imageWidgetSize == null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final widgetSize = imageWidgetSize!;

    // Map cropRect (widget coords) to image pixel coords
    final scaleX = image.width / widgetSize.width;
    final scaleY = image.height / widgetSize.height;

    final cropX = (cropRect.left * scaleX).clamp(0, image.width - 1).toInt();
    final cropY = (cropRect.top * scaleY).clamp(0, image.height - 1).toInt();
    final cropW = (cropRect.width * scaleX)
        .clamp(0, image.width - cropX)
        .toInt();
    final cropH = (cropRect.height * scaleY)
        .clamp(0, image.height - cropY)
        .toInt();

    final cropped = img.copyCrop(
      image,
      x: cropX,
      y: cropY,
      width: cropW,
      height: cropH,
    );

    final croppedFile = await File(
      '${widget.imagePath}_cropped.jpg',
    ).writeAsBytes(img.encodeJpg(cropped));

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CardPreviewScreen(imagePath: croppedFile.path,  whichImage: widget.whichImage ?? 'No Image',),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adjust Crop")),
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Image displayed with BoxFit.contain and measure actual display size
              Center(
                child: Image.file(
                  File(widget.imagePath),
                  fit: BoxFit.contain,
                  // Use a key to measure size after build
                  key: GlobalKey(),
                  // Wrap in LayoutBuilder to get actual size after layout
                  // We measure size via a widget size getter below
                ),
              ),

              // Overlay blur & darken except cropRect inside image displayed area
              // if (cropRect != null)
              //   Positioned.fill(
              //     child: CustomPaint(
              //       painter: _BlurOutsideCropPainter(cropRect),
              //     ),
              //   ),

              // Draggable crop box positioned relative to image
              // if (cropRect != null)
              //   Positioned(
              //     left: cropRect.left,
              //     top: cropRect.top,
              //     width: cropRect.width,
              //     height: cropRect.height,
              //     child: GestureDetector(
              //       onPanStart: _onPanStart,
              //       onPanUpdate: _onPanUpdate,
              //       onPanEnd: _onPanEnd,
              //       child: Container(
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.green, width: 3),
              //           borderRadius: BorderRadius.circular(12),
              //           color: Colors.transparent,
              //         ),
              //       ),
              //     ),
              //   ),

              // Crop button aligned bottom center
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(CardPreviewScreen(imagePath: widget.imagePath ,  whichImage: widget.whichImage ?? 'No Image',));
                  },
                  // onPressed: _cropImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text("Crop Card"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// class _BlurOutsideCropPainter extends CustomPainter {
//   final Rect cropRect;
//   _BlurOutsideCropPainter(this.cropRect);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black.withOpacity(0.6)
//       ..style = PaintingStyle.fill;

//     final fullRect = Offset.zero & size;

//     final outerPath = Path()..addRect(fullRect);
//     final innerPath = Path()
//       ..addRRect(RRect.fromRectAndRadius(cropRect, const Radius.circular(12)));

//     final combined = Path.combine(
//       PathOperation.difference,
//       outerPath,
//       innerPath,
//     );

//     canvas.drawPath(combined, paint);
//   }

//   @override
//   bool shouldRepaint(covariant _BlurOutsideCropPainter oldDelegate) {
//     return oldDelegate.cropRect != cropRect;
//   }
// }

// class CroppedPreviewScreen extends StatelessWidget {
//   final String imagePath;
//   const CroppedPreviewScreen({super.key, required this.imagePath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Cropped Card Preview")),
//       backgroundColor: Colors.black,
//       body: Center(
//         child: Image.file(File(imagePath)),
//       ),
//     );
//   }
// }
