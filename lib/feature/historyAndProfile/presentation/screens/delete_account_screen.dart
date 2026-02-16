import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ridetohealthdriver/core/validation/validators.dart';
import 'package:ridetohealthdriver/helpers/custom_snackbar.dart';
import 'package:ridetohealthdriver/feature/historyAndProfile/presentation/driver_profile/controller/driver_profile_controller.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _reasonController = TextEditingController(text: 'I lost my phone.');

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<DriverProfileController>()) {
      final controller = Get.find<DriverProfileController>();
      final email = controller.email.value.trim();
      if (email.isNotEmpty) {
        _emailController.text = email;
      }
    }
    if (_emailController.text.trim().isEmpty &&
        Get.isRegistered<AuthController>()) {
      final authController = Get.find<AuthController>();
      final storedEmail = authController.getUserEmail().trim();
      if (storedEmail.isNotEmpty) {
        _emailController.text = storedEmail;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _openDeleteForm() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final reason = _reasonController.text.trim().isEmpty
        ? 'I lost my phone.'
        : _reasonController.text.trim();

    final uri = Uri.https(
      'docs.google.com',
      '/forms/d/e/1FAIpQLSc5oNpo565eiCtZxE1qMTg-IrLe7FrSJQH1ZnWPIqPaaILpuw/viewform',
      {
        'usp': 'pp_url',
        'entry.1643574451': email,
        'entry.1317547186': reason,
      },
    );

    final didLaunch = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!didLaunch) {
      showAppSnackBar(
        'Error',
        'Could not open the delete account form.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3442),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        centerTitle: true,
        title: const Text(
          'Delete Account',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Request account deletion',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Provide the email address for the account you want to delete. '
                      'We will open the official deletion form for you to submit.',
                      style: TextStyle(color: Colors.white70, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: Validators.email,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                hintText: 'name@example.com',
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.black26,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _reasonController,
                              maxLines: 3,
                              textInputAction: TextInputAction.done,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Reason (optional)',
                                labelStyle:
                                    const TextStyle(color: Colors.white70),
                                hintText: 'Reason for deletion',
                                hintStyle:
                                    const TextStyle(color: Colors.white54),
                                filled: true,
                                fillColor: Colors.black26,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: const Color(0xFFB10706),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: _openDeleteForm,
                                child: const Text(
                                  'Submit Delete Request',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'This will open a Google Form in your browser. '
                      'After submitting the form, our team will review your request.',
                      style: TextStyle(color: Colors.white54, height: 1.4),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
