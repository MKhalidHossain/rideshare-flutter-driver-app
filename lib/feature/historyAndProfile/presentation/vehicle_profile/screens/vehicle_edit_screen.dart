import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/wide_custom_button.dart';
import '../controller/vehicle_profile_controller.dart';

class VehicleEditScreen extends StatelessWidget {
  const VehicleEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          'Vehicle Details',
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
                // Vehicle Information Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vehicle Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Vehicle Image with Edit Icon
                    Obx(
                      () => Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red, width: 2),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: controller.vehicleImage.value != null
                                  ? Image.file(
                                      controller.vehicleImage.value!,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      controller
                                              .vehicleData
                                              .value
                                              ?.service
                                              .serviceImage ??
                                          '',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.directions_car,
                                                size: 60,
                                                color: Colors.grey,
                                              ),
                                            );
                                          },
                                    ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: controller.pickVehicleImage,
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

                    // Vehicle Details Form Fields
                    Row(
                      children: [
                        Expanded(
                          child: _buildCustomTextField(
                            title: 'Make',
                            controller: controller.makeController,
                            focusNode: controller.makeFocus,
                            nextFocusNode: controller.modelFocus,
                            validator: (value) => value?.isEmpty == true
                                ? 'Make is required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCustomTextField(
                            title: 'Model',
                            controller: controller.modelController,
                            focusNode: controller.modelFocus,
                            nextFocusNode: controller.yearFocus,
                            validator: (value) => value?.isEmpty == true
                                ? 'Model is required'
                                : null,
                          ),
                        ),
                      ],
                    ),

                    Row(
                      children: [
                        Expanded(
                          child: _buildCustomTextField(
                            title: 'Year',
                            controller: controller.yearController,
                            focusNode: controller.yearFocus,
                            nextFocusNode: controller.colorFocus,
                            keyboardType: TextInputType.number,
                            validator: (value) => value?.isEmpty == true
                                ? 'Year is required'
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildCustomTextField(
                            title: 'Color',
                            controller: controller.colorController,
                            focusNode: controller.colorFocus,
                            nextFocusNode: controller.licensePlateFocus,
                            validator: (value) => value?.isEmpty == true
                                ? 'Color is required'
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                _buildCustomTextField(
                  title: 'License Plate',
                  controller: controller.licensePlateController,
                  focusNode: controller.licensePlateFocus,
                  nextFocusNode: controller.vinFocus,
                  validator: (value) => value?.isEmpty == true
                      ? 'License plate is required'
                      : null,
                ),

                _buildCustomTextField(
                  title: 'VIN',
                  controller: controller.vinController,
                  focusNode: controller.vinFocus,
                  nextFocusNode: controller.insuranceProviderFocus,
                  validator: (value) =>
                      value?.isEmpty == true ? 'VIN is required' : null,
                ),

                const SizedBox(height: 32),

                // Insurance Information Section
                _buildSectionTitle('Insurance Information'),
                const SizedBox(height: 16),

                _buildCustomTextField(
                  title: 'Insurance Provider',
                  controller: controller.insuranceProviderController,
                  focusNode: controller.insuranceProviderFocus,
                  nextFocusNode: controller.policyNumberFocus,
                  validator: (value) => value?.isEmpty == true
                      ? 'Insurance provider is required'
                      : null,
                ),

                _buildCustomTextField(
                  title: 'Policy Number',
                  controller: controller.policyNumberController,
                  focusNode: controller.policyNumberFocus,
                  nextFocusNode: controller.expiryDateFocus,
                  validator: (value) => value?.isEmpty == true
                      ? 'Policy number is required'
                      : null,
                ),

                /* 
                _buildCustomTextField(
                  title: 'Expiry Date',
                  controller: controller.expiryDateController,
                  focusNode: controller.expiryDateFocus,
                  nextFocusNode: null,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today, color: Colors.grey),
                   // onPressed: () => controller.selectDate(context),
                  ),
                  validator: (value) =>
                      value?.isEmpty == true ? 'Expiry date is required' : null,
                ), */
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
                                  await controller.saveVehicle();
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
