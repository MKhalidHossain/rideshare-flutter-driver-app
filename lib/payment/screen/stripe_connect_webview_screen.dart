import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StripeConnectWebViewScreen extends StatefulWidget {
  final String initialUrl;

  const StripeConnectWebViewScreen({super.key, required this.initialUrl});

  @override
  State<StripeConnectWebViewScreen> createState() =>
      _StripeConnectWebViewScreenState();
}

class _StripeConnectWebViewScreenState
    extends State<StripeConnectWebViewScreen> {
  late final WebViewController _controller;
  double _progress = 0;
  String? _errorMessage;
  Uri? _successCallback;
  Uri? _cancelCallback;
  String? _lastUrl;

  @override
  void initState() {
    super.initState();
    final initialUri = Uri.parse(widget.initialUrl);
    _successCallback = _extractCallback(initialUri, [
      'return_url',
      'success_url',
    ]);
    _cancelCallback = _extractCallback(initialUri, [
      'refresh_url',
      'cancel_url',
    ]);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) {
            setState(() {
              _progress = progress / 100;
            });
          },
          onNavigationRequest: (request) async {
            debugPrint("Navigating to: ${request.url}");
            if (request.url.contains("driver/onboarding/success")) {
              await Get.showSnackbar(
                const GetSnackBar(
                  title: 'Success',
                  message: 'Stripe onboarding completed successfully.',
                  duration: Duration(seconds: 3),
                ),
              );
              Navigator.of(context).pop(true);
              return NavigationDecision.prevent;
            }
            _lastUrl = request.url;
            final handled = _maybeHandleCallback(Uri.parse(request.url));
            return handled
                ? NavigationDecision.prevent
                : NavigationDecision.navigate;
          },
          onPageFinished: (url) {
            _lastUrl = url;
            _maybeHandleCallback(Uri.parse(url));
          },
          onWebResourceError: (error) {
            final failingUrl = _lastUrl;
            if (failingUrl != null &&
                _maybeHandleCallback(Uri.parse(failingUrl))) {
              return;
            }
            setState(() {
              _errorMessage = error.description;
            });
          },
        ),
      )
      ..loadRequest(initialUri);
    _lastUrl = widget.initialUrl;
  }

  Uri? _extractCallback(Uri uri, List<String> keys) {
    for (final key in keys) {
      final value = uri.queryParameters[key];
      if (value != null && value.isNotEmpty) {
        return Uri.tryParse(value);
      }
    }
    return null;
  }

  bool _maybeHandleCallback(Uri uri) {
    if (_successCallback != null && _matchesCallback(uri, _successCallback!)) {
      _complete(true);
      return true;
    }
    if (_cancelCallback != null && _matchesCallback(uri, _cancelCallback!)) {
      _complete(false);
      return true;
    }
    return false;
  }

  bool _matchesCallback(Uri target, Uri expected) {
    if (target.scheme == expected.scheme &&
        target.host == expected.host &&
        target.port == expected.port) {
      final targetPath = target.path.replaceAll(RegExp(r'/+'), '/');
      final expectedPath = expected.path.replaceAll(RegExp(r'/+'), '/');
      return targetPath.startsWith(expectedPath);
    }
    final normalizedTarget = target.toString();
    final normalizedExpected = expected.toString();
    return normalizedTarget.startsWith(normalizedExpected);
  }

  void _complete(bool success) {
    if (!mounted) return;
    Navigator.of(context).pop(success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stripe Onboarding')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_progress < 1 && _errorMessage == null)
            LinearProgressIndicator(value: _progress),
          // if (_errorMessage != null)
          //   Center(
          //     child: Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Text(
          //         _errorMessage!,
          //         textAlign: TextAlign.center,
          //         style: Theme.of(context)
          //             .textTheme
          //             .bodyMedium
          //             ?.copyWith(color: Theme.of(context).colorScheme.error),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
