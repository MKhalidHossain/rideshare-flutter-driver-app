import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/wide_custom_button.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  // Focus Nodes
  final FocusNode _currentPasswordFocus = FocusNode();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

  // Password visibility
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordFocus.dispose();
    _newPasswordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          'Account Security',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Change Password Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _buildPasswordField(
                      'Current Password',
                      _currentPasswordController,
                      _currentPasswordFocus,
                      _newPasswordFocus,
                      _obscureCurrentPassword,
                      () => setState(
                        () =>
                            _obscureCurrentPassword = !_obscureCurrentPassword,
                      ),
                      (value) => value?.isEmpty == true
                          ? 'Current password is required'
                          : null,
                    ),

                    _buildPasswordField(
                      'New Password',
                      _newPasswordController,
                      _newPasswordFocus,
                      _confirmPasswordFocus,
                      _obscureNewPassword,
                      () => setState(
                        () => _obscureNewPassword = !_obscureNewPassword,
                      ),
                      (value) {
                        if (value?.isEmpty == true)
                          return 'New password is required';
                        if (value!.length < 6)
                          return 'Password must be at least 6 characters';
                        return null;
                      },
                    ),

                    _buildPasswordField(
                      'Confirm New Password',
                      _confirmPasswordController,
                      _confirmPasswordFocus,
                      null,
                      _obscureConfirmPassword,
                      () => setState(
                        () =>
                            _obscureConfirmPassword = !_obscureConfirmPassword,
                      ),
                      (value) {
                        if (value?.isEmpty == true)
                          return 'Please confirm your password';
                        if (value != _newPasswordController.text)
                          return 'Passwords do not match';
                        return null;
                      },
                    ),

                    const SizedBox(height: 24),

                    WideCustomButton(
                      text: 'Update Password',
                      onPressed: _updatePassword,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Login Devices Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Login Devices',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildDeviceItem(
                    'iPhone 13',
                    'San Francisco, CA',
                    'IP: 192.168.1.1',
                    'Current session',
                    true,
                    null,
                  ),

                  _buildDeviceItem(
                    'iPhone 13',
                    'San Francisco, CA',
                    'IP: 192.168.1.1',
                    '2 days ago',
                    false,
                    () => _logoutDevice('iPhone 13 - 2 days ago'),
                  ),

                  _buildDeviceItem(
                    'iPhone 13',
                    'San Francisco, CA',
                    'IP: 192.168.1.1',
                    '1 week ago',
                    false,
                    () => _logoutDevice('iPhone 13 - 1 week ago'),
                  ),

                  const SizedBox(height: 20),

                  // Log Out of All Devices Button
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(color: Color(0xFFEA0001), width: 2),
                    ),
                    child: TextButton(
                      onPressed: _logoutAllDevices,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: Image.asset("assets/icons/logout_icon.png"),
                          ),
                          // Icon(
                          //   Icons.logout,
                          //   color: Color(0xFFEA0001),
                          //   size: 20,
                          // ),
                          const SizedBox(width: 8),
                          Text(
                            'Log Out of All Devices',
                            style: TextStyle(
                              color: Color(0xFFEA0001),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    String label,
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocusNode,
    bool obscureText,
    VoidCallback toggleVisibility,
    String? Function(String?) validator,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          obscureText: obscureText,
          validator: validator,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(context).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(context).unfocus();
            }
          },
          cursorColor: Colors.grey,
          style: TextStyle(
            color: AppColors.context(context).textColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: toggleVisibility,
            ),
            hintText: label,
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: Colors.grey.withOpacity(0.1),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF626671),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF626671),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDeviceItem(
    String deviceName,
    String location,
    String ipAddress,
    String timeInfo,
    bool isCurrent,
    VoidCallback? onLogout,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Device Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.phone_iphone,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Device Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  deviceName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  ipAddress,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Status/Action
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeInfo,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 4),
              if (isCurrent)
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color(0xFF305A3D),
                  ),
                  padding: EdgeInsets.all(4),
                  child: const Text(
                    'Current',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else if (onLogout != null)
                GestureDetector(
                  onTap: onLogout,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xFF56434E),
                    ),
                    padding: EdgeInsets.all(4),
                    child: const Text(
                      'Log out',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _updatePassword() {
    if (_formKey.currentState!.validate()) {
      // Handle password update logic here
      Get.snackbar(
        'Success',
        'Password updated successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Clear form
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    }
  }

  void _logoutDevice(String deviceInfo) {
    Get.snackbar(
      'Device Logged Out',
      'Successfully logged out from $deviceInfo',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
    );
  }

  void _logoutAllDevices() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2C2C2C),
        title: const Text(
          'Log Out All Devices',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to log out from all devices? You will need to log in again on all devices.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                'Logged out from all devices successfully!',
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            },
            child: const Text(
              'Log Out All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
