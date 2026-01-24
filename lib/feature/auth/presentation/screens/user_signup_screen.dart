import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import 'package:ridetohealthdriver/feature/identity/presentation/screens/verify_identity_screen.dart';
import 'package:ridetohealthdriver/helpers/custom_snackbar.dart';
import 'package:ridetohealthdriver/core/widgets/loading_shimmer.dart';
import '../../../../core/validation/validators.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/widgets/wide_custom_button.dart';
import '../../../../helpers/input_formatters/drivig_license_formatter.dart';
import '../../../../helpers/input_formatters/us_nid_formatter.dart';
import '../../../../helpers/input_formatters/us_phone_num_formatter.dart';
import '../../controllers/auth_controller.dart';
import 'user_login_screen.dart';

class UserSignupScreen extends StatefulWidget {
  const UserSignupScreen({super.key});

  @override
  State<UserSignupScreen> createState() => UserSignupScreenState();
}

class UserSignupScreenState extends State<UserSignupScreen> {
  late AuthController authController;
  late HomeController homeController;

  bool value = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _drivingLicenceFocus = FocusNode();
  final FocusNode _nationalIdFocus = FocusNode();
  final FocusNode _serviceType = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();

final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _drivingLicenceController = TextEditingController();
  final TextEditingController _nationalIdController = TextEditingController();
  final TextEditingController _serviceTypeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? selectedServiceType;

  @override
  void initState() { 
      
    WidgetsBinding.instance.addPostFrameCallback((_) {
      authController = Get.find<AuthController>();
      homeController = Get.find<HomeController>();
      homeController.getAllServices();

      // _nameController = TextEditingController();
      // _emailController = TextEditingController();
      // _phoneController = TextEditingController();
      // _drivingLicenceController = TextEditingController();
      // _nationalIdController = TextEditingController();
      // _serviceTypeController = TextEditingController();
      // _passwordController = TextEditingController();
      // _confirmPasswordController = TextEditingController();
    });

    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _drivingLicenceController.dispose();
    _nationalIdController.dispose();
    _serviceTypeController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const String otpVerifyType = "email_verification";
    const String userRole = "driver";

    return GetBuilder<HomeController>(
      builder: (homeController) {
        return GetBuilder<AuthController>(
          builder: (authController) {
            final serviceTypes =
                homeController.getAllServicesResponseModel.data;
            print("Service Types: ${serviceTypes?.first.name}");
            return authController.isLoading || homeController.isLoading
                ? const Center(child: LoadingShimmer())
                : AppScaffold(
                    body: SafeArea(
                      bottom: false,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minHeight: size.height,
                                    ),
                                    child: IntrinsicHeight(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 32),
                                          Center(
                                            child: Text(
                                              'Create Your Account',
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.context(
                                                  context,
                                                ).textColor,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 24),

                                          _buildCustomTextField(
                                            title: 'Name',
                                            context: context,
                                            label: 'Enter your Full Name',
                                            controller: _nameController,
                                            icon: Icons.person_outline,
                                            focusNode: _nameFocus,
                                            nextFocusNode: _emailFocus,
                                            validator: Validators.name,
                                          ),

                                          _buildCustomTextField(
                                            title: 'Email',
                                            context: context,
                                            label: 'Enter your Email',
                                            controller: _emailController,
                                            icon: Icons.email_outlined,
                                            focusNode: _emailFocus,
                                            nextFocusNode: _phoneFocus,
                                            validator: Validators.email,
                                          ),

                                          _buildCustomTextField(
                                            title: 'Phone Number',
                                            context: context,
                                            label: 'Enter your Phone Number',
                                            keyboardType: TextInputType.phone,
                                            controller: _phoneController,
                                            icon: Icons.phone_outlined,
                                            focusNode: _phoneFocus,
                                            nextFocusNode: _drivingLicenceFocus,
                                            validator: (value) =>
                                                Validators.phone(
                                                  value,
                                                  countryCode: 'US',
                                                ),
                                            inputFormatters: [
                                              UsPhoneInputFormatter(),
                                            ],
                                          ),

                                          _buildCustomTextField(
                                            title: 'Licence Number',
                                            context: context,
                                            label:
                                                'Enter your Driving Licence Number',
                                            controller:
                                                _drivingLicenceController,
                                            // icon: Icons.credit_card,
                                            icon: FontAwesomeIcons.idCard,
                                            focusNode: _drivingLicenceFocus,
                                            nextFocusNode: _nationalIdFocus,
                                            validator: Validators.licenceNumber,
                                           inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')), // only letters & numbers
                                              LicenseInputFormatter(maxLength: 18),
                                            ],

                                          ),

                                          _buildCustomTextField(
                                            title: 'National ID Number',
                                            context: context,
                                            label:
                                                'Enter your National ID Number',
                                            keyboardType: TextInputType.number,
                                            controller: _nationalIdController,
                                            icon: FontAwesomeIcons.solidIdCard,
                                            focusNode: _nationalIdFocus,
                                            nextFocusNode: _serviceType,
                                            validator: Validators.usNationalId,
                                            inputFormatters: [
                                              UsNidInputFormatter(),
                                            ],
                                          ),

                                          _buildDropdown(
                                            label: 'Service Type',
                                            value: selectedServiceType,
                                            // items: ['Economy Car', 'Economy Bike', 'Economy Bike2'],
                                            items: serviceTypes != null
                                                ? serviceTypes
                                                      .map(
                                                        (service) =>
                                                            service.name,
                                                      )
                                                      .toList()
                                                : [],
                                            onChanged: (val) => setState(() {
                                              selectedServiceType = val;
                                              _serviceTypeController.text =
                                                  val ?? '';
                                            }),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please select service type';
                                              }
                                              return null;
                                            },
                                          ),

                                          _buildCustomTextField(
                                            title: 'Password',
                                            context: context,
                                            label: 'Create a Password',
                                            controller: _passwordController,
                                            icon: Icons.lock_outline,
                                            focusNode: _passwordFocus,
                                            nextFocusNode:
                                                _confirmPasswordFocus,
                                            validator: Validators.password,
                                            obscureText: _obscurePassword,
                                            toggleObscureText: () {
                                              setState(() {
                                                _obscurePassword =
                                                    !_obscurePassword;
                                              });
                                            },
                                          ),

                                          _buildCustomTextField(
                                            title: 'Confirm Password',
                                            context: context,
                                            label: 'Confirm your Password',
                                            controller:
                                                _confirmPasswordController,
                                            icon: Icons.lock_outline,
                                            focusNode: _confirmPasswordFocus,
                                            nextFocusNode: _nameFocus,
                                            validator: Validators.password,
                                            obscureText:
                                                _obscureConfirmPassword,
                                            toggleObscureText: () {
                                              setState(() {
                                                _obscureConfirmPassword =
                                                    !_obscureConfirmPassword;
                                              });
                                            },
                                          ),

                                          Row(
                                            children: [
                                              Checkbox(
                                                value: value,
                                                onChanged: (bool? newValue) {
                                                  setState(() {
                                                    value = newValue ?? false;
                                                  });
                                                },
                                              ),
                                              Expanded(
                                                child: RichText(
                                                  maxLines: 3,
                                                  text: TextSpan(
                                                    text:
                                                        'By Registration, You agree to the',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                    children: const [
                                                      TextSpan(
                                                        text:
                                                            ' term of services ',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: ' and ',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ' privacy policy. ',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),

                                          WideCustomButton(
                                            text: 'Sign Up',

                                            onPressed: () {
                                              FocusScope.of(
                                                context,
                                              ).unfocus(); // close keyboard

                                              // Form Validation
                                              if (!_formKey.currentState!
                                                  .validate()) {
                                                showAppSnackBar(
                                                  'Error',
                                                  'Please fill all required fields correctly',
                                                  snackPosition:
                                                      SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white,
                                                );
                                                return;
                                              }

                                              // Checkbox validation
                                              if (!value) {
                                                showCustomSnackBar(
                                                  'Error',
                                                  subMessage:
                                                      'You must agree to the terms & privacy policy',
                                                  isError: true,
                                                );
                                                // Get.snackbar(
                                                //   'Error',
                                                //   'You must agree to the terms & privacy policy',
                                                //   snackPosition:
                                                //       SnackPosition.BOTTOM,
                                                //   backgroundColor: Colors.red,
                                                //   colorText: Colors.white,
                                                // );
                                                return;
                                              }

                                              // Password match check
                                              if (_passwordController.text !=
                                                  _confirmPasswordController
                                                      .text) {
                                                
                                                (
                                                  'Error',
                                                  subMessage:
                                                      'Passwords do not match',
                                                  isError: true,
                                                );
                                                // Get.snackbar(
                                                //   'Error',
                                                //   'Passwords do not match',
                                                //   snackPosition:
                                                //       SnackPosition.BOTTOM,
                                                //   backgroundColor: Colors.red,
                                                //   colorText: Colors.white,
                                                // );
                                                return;
                                              }

                                              // Everything OK
                                              authController.setRegistrationData(
                                                name: _nameController.text
                                                    .trim(),
                                                userEmail: _emailController.text
                                                    .trim(),
                                                phoneNumber: _phoneController
                                                    .text
                                                    .trim(),
                                                drivingLicenceNumber:
                                                    _drivingLicenceController
                                                        .text
                                                        .trim(),
                                                nationalIdNumber:
                                                    _nationalIdController.text
                                                        .trim(),
                                                serviceType:
                                                    selectedServiceType ?? "",
                                                password:
                                                    _passwordController.text,
                                              );

                                              Get.to(
                                                () => VerifyIdentityScreen(),
                                              );
                                            },

                                            // onPressed: () {

                                            //   FocusScope.of(context).unfocus();
                                            //  if (_passwordController.text == _confirmPasswordController.text) {
                                            //      authController.setRegistrationData(
                                            //       name : _nameController.text,
                                            //       userEmail : _emailController.text,
                                            //       phoneNumber:  _phoneController.text,
                                            //       drivingLicenceNumber: _drivingLicenceController.text,
                                            //       nationalIdNumber: _nationalIdController.text,
                                            //       serviceType: _serviceTypeController.text,
                                            //       password : _passwordController.text,

                                            //   );
                                            //   Get.to(()=>VerifyIdentityScreen());
                                            //   }else{
                                            //     Get.snackbar('Error', 'Passwords do not match',
                                            //     snackPosition: SnackPosition.BOTTOM,
                                            //     backgroundColor: Colors.red,
                                            //     colorText: Colors.white,
                                            //     );
                                            //   }
                                            // },
                                          ),

                                          const SizedBox(height: 16),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 16,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Already have an account? ",
                                                  style: TextStyle(
                                                    color: AppColors.context(
                                                      context,
                                                    ).popupBackgroundColor,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    Get.to(UserLoginScreen());
                                                  },
                                                  child: Text(
                                                    'Sign in',
                                                    style: TextStyle(
                                                      color: AppColors.context(
                                                        context,
                                                      ).primaryColor,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 16),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 16,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Your Profile helps us customize your experience",
                                                  style: TextStyle(
                                                    color: AppColors.context(
                                                      context,
                                                    ).textColor,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/lockk.png',
                                                      height: 16,
                                                    ),
                                                    Text(
                                                      "Your data is secure and private",
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.context(
                                                              context,
                                                            ).textColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 50),
                                          const SizedBox(height: 16),
                                        ],
                                      ),
                                    ),
                                  ),
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
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: AppColors.context(context).textColor,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            children: const [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Theme(
          data: Theme.of(context).copyWith(
            hintColor: AppColors.context(
              context,
            ).textColor, // <— forces hint color
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.withOpacity(0.1),
              hintText: 'Select $label',
              hintStyle: TextStyle(color: AppColors.context(context).textColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            dropdownColor: Color(0xff303644).withOpacity(0.9),
            style: TextStyle(
              color: AppColors.context(context).textColor,
              fontSize: 16,
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        item,
                        style: TextStyle(
                          color: AppColors.context(context).textColor,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}



class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}


Widget _buildCustomTextField({
  required String title,
  required BuildContext context,
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required FocusNode focusNode,
  required FocusNode? nextFocusNode,
  TextInputType keyboardType = TextInputType.text,
  required String? Function(String?) validator,
  bool obscureText = false,
  VoidCallback? toggleObscureText,
  List<TextInputFormatter>? inputFormatters,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // RichText(
      //   text: TextSpan(
      //     text: title,
      //     style: const TextStyle(
      //       color: Colors.white,
      //       fontSize: 16,
      //       fontWeight: FontWeight.w400,
      //     ),
      //   ),
      // ),
      RichText(
        text: TextSpan(
          text: title,
          style: TextStyle(
            color: AppColors.context(context).textColor,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],

          
        ),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        validator: validator,
        obscureText: obscureText,
        inputFormatters: inputFormatters,
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
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(icon, color: Colors.grey, size: 24),
          ),
          suffixIcon: obscureText && toggleObscureText != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: toggleObscureText,
                )
              : null,
          hintText: label,
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green[800]!, width: 1.5),
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
      const SizedBox(height: 24),
    ],
  );
}

// Widget _buildCustomTextField({
//   required String title,
//   required BuildContext context,
//   required String label,
//   required TextEditingController controller,
//   required IconData icon,
//   required FocusNode focusNode,
//   TextInputType keyboardType = TextInputType.text,
//   required String? Function(String?) validator,
// }) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       RichText(
//         text: TextSpan(
//           text: title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w400,
//           ),
//           children: const [
//             TextSpan(
//               text: ' *',
//               style: TextStyle(
//                 color: Colors.red,
//                 fontWeight: FontWeight.w700,
//                 fontSize: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//       const SizedBox(height: 8),
//       TextFormField(
//         controller: controller,
//         focusNode: focusNode,
//         keyboardType: keyboardType,
//         validator: validator,
//         cursorColor: Colors.grey,
//         decoration: InputDecoration(
//           prefixIcon: Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Icon(icon, color: Colors.grey, size: 24),

//             // Image.asset(
//             //   iconPath,
//             //   fit: BoxFit.contain,
//             //   width: 24,
//             //   height: 24,
//             //   color: Colors.grey,
//             // ),
//           ),
//           hintText: label,
//           hintStyle: TextStyle(color: Colors.grey),
//           filled: true,
//           fillColor: Colors.grey.withOpacity(0.1),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide.none,
//           ),
//         ),
//         onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(focusNode),
//         style: TextStyle(
//           color: AppColors.context(context).textColor,
//           fontSize: 16,
//           fontWeight: FontWeight.w400,
//         ),
//       ),
//       const SizedBox(height: 24),
//     ],
//   );
// }
