import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/wide_custom_button.dart';
import '../../../model/driver_profile_model.dart';
import '../../../model/update_profile_request_model.dart';
import '../controller/driver_profile_controller.dart';

class DriverProfileEditScreen extends StatelessWidget {
  const DriverProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DriverProfileController>();

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Personal Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: controller.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Profile Card
                Column(
                  children: [
                    // Profile Picture
                    Obx(
                      () => Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.red, width: 3),
                            ),
                            child: ClipOval(
                              child: controller.profileImage.value != null
                                  ? Image.file(
                                      controller.profileImage.value!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      controller.profileImageUrl.value,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.person_outline,
                                                size: 40,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                            ),
                          ),
                          if (controller.isUploadingImage.value)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: controller.pickImage,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Name - Updates in real-time
                    Obx(
                      () => Text(
                        controller.fullName.value.isNotEmpty
                            ? controller.fullName.value
                            : '',
                        style: TextStyle(
                          color: AppColors.context(context).textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Email
                    Obx(
                      () => Text(
                        controller.email.value,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Contact Information Section
                _buildSectionTitle('Contact Information'),
                const SizedBox(height: 16),
                

                _buildCustomTextField(
                  title: 'Full Name',
                  
                  controller: controller.fullNameController,
                  focusNode: controller.fullNameFocus,
                  nextFocusNode: controller.phoneFocus,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Full name is required' : null,
                ),

                _buildCustomTextField(
                  title: 'Phone Number',
                  controller: controller.phoneController,
                  focusNode: controller.phoneFocus,
                  nextFocusNode: controller.streetAddressFocus,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value?.isEmpty == true
                      ? 'Phone number is required'
                      : null,
                ),

                _buildCustomTextField(
                  title: 'Street Address',
                  controller: controller.streetAddressController,
                  focusNode: controller.streetAddressFocus,
                  nextFocusNode: controller.cityFocus,
                  validator: (value) => value?.isEmpty == true
                      ? 'Street address is required'
                      : null,
                ),

                // City and State Row
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildCustomTextField(
                        title: 'City',
                        controller: controller.cityController,
                        focusNode: controller.cityFocus,
                        nextFocusNode: controller.stateFocus,
                        validator: (value) =>
                            value?.isEmpty == true ? 'City is required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: _buildCustomTextField(
                        title: 'State',
                        controller: controller.stateController,
                        focusNode: controller.stateFocus,
                        nextFocusNode: controller.zipCodeFocus,
                        validator: (value) =>
                            value?.isEmpty == true ? 'State is required' : null,
                      ),
                    ),
                  ],
                ),

                _buildCustomTextField(
                  title: 'Zip Code',
                  controller: controller.zipCodeController,
                  focusNode: controller.zipCodeFocus,
                  nextFocusNode: controller.dateOfBirthFocus,
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty == true ? 'Zip code is required' : null,
                ),

                const SizedBox(height: 32),

                // Personal Details Section
                _buildSectionTitle('Personal Details'),
                const SizedBox(height: 16),

                _buildCustomTextField(
                  title: 'Date of Birth',
                  controller: controller.dateOfBirthController,
                  focusNode: controller.dateOfBirthFocus,
                  nextFocusNode: controller.emergencyNameFocus,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.grey),
                    onPressed: () => controller.selectDate(context),
                  ),
                  validator: (value) => value?.isEmpty == true
                      ? 'Date of birth is required'
                      : null,
                ),

                const SizedBox(height: 32),

                // Emergency Contact Section
                _buildSectionTitle('Emergency Contact'),
                const SizedBox(height: 16),

                _buildCustomTextField(
                  title: 'Name',
                  controller: controller.emergencyNameController,
                  focusNode: controller.emergencyNameFocus,
                  nextFocusNode: controller.emergencyPhoneFocus,
                  validator: (value) => value?.isEmpty == true
                      ? 'Emergency contact name is required'
                      : null,
                ),

                _buildCustomTextField(
                  title: 'Phone Number',
                  controller: controller.emergencyPhoneController,
                  focusNode: controller.emergencyPhoneFocus,
                  nextFocusNode: null,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value?.isEmpty == true
                      ? 'Emergency contact phone is required'
                      : null,
                ),

                const SizedBox(height: 40),

                // Action Buttons
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: TextButton(
                            onPressed: controller.isLoading.value
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: WideCustomButton(
                          text: controller.isLoading.value
                              ? 'Saving...'
                              : 'Save Changes',
                          onPressed: controller.isLoading.value
                              ? () {}
                              : () async {
                                  await controller.updateDriverProfile(
                                    UpdateProfileRequestModel(
                                      fullName:
                                          controller.fullNameController.text,
                                      phoneNumber:
                                          controller.phoneController.text,
                                      streetAddress: controller
                                          .streetAddressController.text,
                                      city: controller.cityController.text,
                                      state: controller.stateController.text,
                                      zipcode: controller.zipCodeController.text,
                                      dateOfBirth:
                                          controller.dateOfBirthController.text,
                                      emergencyContact: EmergencyContact(
                                        name: controller
                                            .emergencyNameController.text,
                                        phoneNumber: controller
                                            .emergencyPhoneController.text,
                                      ),
                                    ),
                                  );
                                },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /*   Widget _buildCustomTextField({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocusNode,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(Get.context!).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(Get.context!).unfocus();
            }
          },
          cursorColor: Colors.grey,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: title,
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
        const SizedBox(height: 24),
      ],
    );
  } */

  Widget _buildCustomTextField({
    required String title,
    required TextEditingController controller,
    required FocusNode focusNode,
    required FocusNode? nextFocusNode,
    TextInputType keyboardType = TextInputType.text,
    required String? Function(String?) validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          validator: validator,
          obscureText: obscureText,
          textInputAction: nextFocusNode != null
              ? TextInputAction.next
              : TextInputAction.done,
          onChanged: (value) {
            // TextField value update Rx variable
            switch (title) {
              case 'Full Name':
                Get.find<DriverProfileController>().fullName.value = value;
                break;
              case 'Phone Number':
                // Emergency contact phone and main phone নাম একই, তাই একটু চেক করতে হবে
                if (focusNode ==
                    Get.find<DriverProfileController>().phoneFocus) {
                  Get.find<DriverProfileController>().phone.value = value;
                } else {
                  Get.find<DriverProfileController>().emergencyPhone.value =
                      value;
                }
                break;
              case 'Street Address':
                Get.find<DriverProfileController>().streetAddress.value = value;
                break;
              case 'City':
                Get.find<DriverProfileController>().city.value = value;
                break;
              case 'State':
                Get.find<DriverProfileController>().state.value = value;
                break;
              case 'Zip Code':
                Get.find<DriverProfileController>().zipCode.value = value;
                break;
              case 'Date of Birth':
                Get.find<DriverProfileController>().dateOfBirth.value = value;
                break;
              case 'Name': // Emergency Contact Name
                Get.find<DriverProfileController>().emergencyName.value = value;
                break;
            }
          },
          onFieldSubmitted: (_) {
            if (nextFocusNode != null) {
              FocusScope.of(Get.context!).requestFocus(nextFocusNode);
            } else {
              FocusScope.of(Get.context!).unfocus();
            }
          },
          cursorColor: Colors.grey,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            hintText: title,
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
        const SizedBox(height: 24),
      ],
    );
  }
}
