import 'dart:async';

import 'package:flutter/material.dart';

class WideCustomButton extends StatefulWidget {
  final String text;
  final FutureOr<void> Function() onPressed;
  final bool showIcon;
  final IconData? sufixIcon;
  final double? height;

  const WideCustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.showIcon = false,
    this.sufixIcon,
    this.height = 50,
  });

  @override
  State<WideCustomButton> createState() => _WideCustomButtonState();
}

class _WideCustomButtonState extends State<WideCustomButton> {
  bool _isProcessing = false;

  Future<void> _handleTap() async {
    if (_isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Allow the UI to rebuild before running potentially heavy work.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.sync(widget.onPressed);
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
 

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: _isProcessing,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: _handleTap,
        child: Container(
          height: widget.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            // Make it red like in your design
            gradient: LinearGradient(
              stops: [0.0, 0.4, 9.0],
              colors: [
                Color(0xff7B0100).withOpacity(0.8),
                Color(0xFFCE0000),
                Color(0xff7B0100).withOpacity(0.8),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isProcessing ? 'Processing...' : widget.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!_isProcessing &&
                  widget.showIcon &&
                  widget.sufixIcon != null) ...[
                const SizedBox(width: 5),
                Icon(widget.sufixIcon, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
