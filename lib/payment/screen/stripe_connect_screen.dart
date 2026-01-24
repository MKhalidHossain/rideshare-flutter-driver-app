import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/payment/screen/stripe_connect_webview_screen.dart';
import 'package:ridetohealthdriver/feature/auth/presentation/screens/user_login_screen.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import 'package:ridetohealthdriver/core/widgets/loading_shimmer.dart';

class StripeConnectScreen extends StatefulWidget {
  const StripeConnectScreen({super.key});

  @override
  State<StripeConnectScreen> createState() => _StripeConnectScreenState();
}

class _StripeConnectScreenState extends State<StripeConnectScreen> {
  late final HomeController _homeController;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _homeController = Get.find<HomeController>();
  }

  Future<void> _startStripeConnectFlow() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _homeController.connectStripeAccount();
      final onboardingUrl = response.url;
      if (onboardingUrl == null || onboardingUrl.isEmpty) {
        throw Exception('No onboarding URL returned from server');
      }

      if (!mounted) return;

      final completed = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => StripeConnectWebViewScreen(
            initialUrl: onboardingUrl,
          ),
        ),
      );

      if (completed == true && mounted) {
        Get.offAll(() => const UserLoginScreen());
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Stripe Connect',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 72,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 24),
            Text(
              'Connect your payout account',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'We use Stripe to securely handle payouts. '
              'Tap the button below to create or connect your Stripe account.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            if (_error != null) ...[
              Text(
                _error!,
                style: TextStyle(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _isLoading ? null : _startStripeConnectFlow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                ),
                icon: _isLoading
                    ? SizedBox(
                        width: 20,
                        height: 40,
                        child: Center(
                          child: LoadingShimmer(
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Icon(Icons.link),
                label: Text(
                  _isLoading ? 'Connecting...' : 'Connect with Stripe',
                ),
              ),
            ),
            const SizedBox(height: 12),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
