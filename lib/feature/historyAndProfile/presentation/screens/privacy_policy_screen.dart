import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            fontSize: 22,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildParagraph(
                'This Privacy Policy explains how the RidezToHealth Driver app collects, '
                'uses, and protects your information when you use the app and related '
                'services. By continuing to use the app, you agree to the practices '
                'described here.',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Information We Collect'),
              _buildParagraph(
                'We collect information that helps provide safe and reliable rides, '
                'including account details, trip activity, device information, and '
                'location data while the app is in use.',
              ),
              _buildBulletList(const [
                'Profile details like name, email, phone number, and driver documents.',
                'Trip data such as pickup, dropoff, route, time, and fare details.',
                'Device data including IP address, model, and app version for support.',
                'Location data for matching, navigation, and safety features.',
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('How We Use Information'),
              _buildParagraph(
                'We use your information to operate the RidezToHealth Driver app, '
                'improve ride quality, prevent fraud, and communicate with you about '
                'account updates and safety issues.',
              ),
              _buildBulletList(const [
                'Verify your identity and eligibility to drive.',
                'Connect you with riders and process trip requests.',
                'Provide customer support and respond to inquiries.',
                'Improve performance, reliability, and safety features.',
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('Sharing of Information'),
              _buildParagraph(
                'We share limited information with riders, service providers, and legal '
                'authorities when required. We do not sell your personal information.',
              ),
              _buildBulletList(const [
                'Riders see your name, vehicle details, rating, and trip updates.',
                'Service providers help with payments, analytics, and support.',
                'Legal or regulatory disclosures may be made when required.',
              ]),
              const SizedBox(height: 20),
              _buildSectionTitle('Permissions and Controls'),
              _buildParagraph(
                'You can manage permissions such as location and notifications in your '
                'device settings. Some features may not work properly without access.',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Data Retention and Security'),
              _buildParagraph(
                'We keep data only as long as needed for operations, legal compliance, '
                'and safety. We use security measures to protect your information, but '
                'no method is 100 percent secure.',
              ),
              const SizedBox(height: 20),
              _buildSectionTitle('Contact Us'),
              _buildParagraph(
                'If you have questions about this Privacy Policy or the RidezToHealth '
                'Driver app, please contact support through the app.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

Widget _buildParagraph(String text) {
  return Text(
    text,
    textAlign: TextAlign.justify,
    style: const TextStyle(
      fontSize: 16,
      fontFamily: 'Poppins',
      color: Colors.white,
      height: 1.6,
      letterSpacing: 0.2,
    ),
  );
}

Widget _buildBulletList(List<String> items) {
  return Padding(
    padding: const EdgeInsets.only(top: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '- ',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    ),
  );
}
