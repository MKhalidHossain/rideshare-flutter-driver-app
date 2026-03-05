import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<DriverProfileController>()) {
      final controller = Get.find<DriverProfileController>();
      final email = controller.email.value.trim();
      final phone = controller.phone.value.trim();
      if (email.isNotEmpty) {
        _emailController.text = email;
      } else if (phone.isNotEmpty) {
        _emailController.text = phone;
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
    super.dispose();
  }

  String? _validateEmailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or phone is required';
    }

    final trimmed = value.trim();
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(trimmed);
    if (trimmed.contains('@') || hasLetters) {
      return Validators.email(trimmed);
    }

    return Validators.phone(trimmed);
  }

  Future<void> _submitDeleteAccount() async {
    if (!_formKey.currentState!.validate()) return;

    if (!Get.isRegistered<AuthController>()) {
      showAppSnackBar(
        'Error',
        'Account service is not available. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return;
    }

    final emailOrPhone = _emailController.text.trim();
    await Get.find<AuthController>().deleteAccount(emailOrPhone);
  }

  Future<void> _confirmDeleteAccount() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2E3442),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Account',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to delete your account? This action cannot be undone.',
            style: TextStyle(color: Colors.white70, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB10706),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Yes, Delete',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await _submitDeleteAccount();
    } else {
      if (mounted) {
        Navigator.of(context).maybePop();
      }
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
          return GetBuilder<AuthController>(
            builder: (controller) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Delete your account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Enter the email address or phone number linked to your account. '
                          'This action is permanent and cannot be undone.',
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
                                  textInputAction: TextInputAction.done,
                                  validator: _validateEmailOrPhone,
                                  autofillHints: const [
                                    AutofillHints.email,
                                    AutofillHints.telephoneNumber,
                                  ],
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                    labelText: 'Email or Phone',
                                    labelStyle: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                    hintText: 'name@example.com',
                                    hintStyle: const TextStyle(
                                      color: Colors.white54,
                                    ),
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
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      backgroundColor: const Color(0xFFB10706),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: controller.deleteAccountLoading
                                        ? null
                                        : _confirmDeleteAccount,
                                    child: controller.deleteAccountLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            'Delete Account',
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
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
