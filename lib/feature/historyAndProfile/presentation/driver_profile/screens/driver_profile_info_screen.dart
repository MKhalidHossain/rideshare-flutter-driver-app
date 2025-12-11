import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../../../../../core/widgets/wide_custom_button.dart';
import '../controller/driver_profile_controller.dart';

import 'driver_profile_edit_screen.dart';

class DriverProfileInfoScreen extends StatelessWidget {
  const DriverProfileInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverProfileController());

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          //'${controller.email}',
          'Personal Information',

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
                                    errorBuilder: (context, error, stackTrace) {
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
                      controller.fullName.value.isEmpty
                          ? controller.fullName.value
                          : '${controller.fullName}',
                      style: TextStyle(
                        color: AppColors.context(context).textColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
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

              Obx(() => _buildInfoItem('Phone Number', controller.phone.value)),
              Obx(
                () => _buildInfoItem('Email Address', controller.email.value),
              ),
              Obx(() => _buildInfoItem('Home Address', controller.fullAddress)),

              const SizedBox(height: 32),

              // Personal Details Section
              _buildSectionTitle('Personal Details'),
              const SizedBox(height: 16),

              Obx(
                () => _buildInfoItem(
                  'Date of Birth',
                  controller.dateOfBirth.value,
                ),
              ),

              const SizedBox(height: 32),

              // Emergency Contact Section
              _buildSectionTitle('Emergency Contact'),
              const SizedBox(height: 16),

              Obx(() => _buildInfoItem('Name', controller.emergencyName.value)),
              Obx(
                () => _buildInfoItem(
                  'Phone Number',
                  controller.emergencyPhone.value,
                ),
              ),

              const SizedBox(height: 40),

              // Edit Button
              WideCustomButton(
                text: 'Edit Information',
                onPressed: () {
                  Get.to(() => const DriverProfileEditScreen());
                },
              ),

              const SizedBox(height: 20),
            ],
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
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
