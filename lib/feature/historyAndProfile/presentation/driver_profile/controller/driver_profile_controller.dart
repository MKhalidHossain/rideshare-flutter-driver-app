import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DriverProfileController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers
  final fullNameController = TextEditingController();
  final phoneController = TextEditingController();
  final streetAddressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final emergencyNameController = TextEditingController();
  final emergencyPhoneController = TextEditingController();

  // Focus Nodes
  final fullNameFocus = FocusNode();
  final phoneFocus = FocusNode();
  final streetAddressFocus = FocusNode();
  final cityFocus = FocusNode();
  final stateFocus = FocusNode();
  final zipCodeFocus = FocusNode();
  final dateOfBirthFocus = FocusNode();
  final emergencyNameFocus = FocusNode();
  final emergencyPhoneFocus = FocusNode();

  // Observable variables
  var isLoading = false.obs;
  var profileImage = Rx<File?>(null);
  var profileImageUrl = 'assets/images/user5.png'.obs;

  // Reactive text values
  var fullName = 'Alex Johnson'.obs;
  var phone = '(555) 123-4567'.obs;
  var streetAddress = '123 Main Street'.obs;
  var city = 'San Francisco'.obs;
  var state = 'CA'.obs;
  var zipCode = '94105'.obs;
  var dateOfBirth = '1985-06-15'.obs;
  var emergencyName = 'Mary Smith'.obs;
  var emergencyPhone = '(555) 987-6543'.obs;
  var email = 'john.smith@example.com'.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
    setupTextListeners();
  }

  @override
  void onClose() {
    // Dispose controllers
    fullNameController.dispose();
    phoneController.dispose();
    streetAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    dateOfBirthController.dispose();
    emergencyNameController.dispose();
    emergencyPhoneController.dispose();

    // Dispose focus nodes
    fullNameFocus.dispose();
    phoneFocus.dispose();
    streetAddressFocus.dispose();
    cityFocus.dispose();
    stateFocus.dispose();
    zipCodeFocus.dispose();
    dateOfBirthFocus.dispose();
    emergencyNameFocus.dispose();
    emergencyPhoneFocus.dispose();

    super.onClose();
  }

  void loadProfileData() {
    // Load data into controllers
    fullNameController.text = fullName.value;
    phoneController.text = phone.value;
    streetAddressController.text = streetAddress.value;
    cityController.text = city.value;
    stateController.text = state.value;
    zipCodeController.text = zipCode.value;
    dateOfBirthController.text = dateOfBirth.value;
    emergencyNameController.text = emergencyName.value;
    emergencyPhoneController.text = emergencyPhone.value;
  }

  void setupTextListeners() {
    // Listen to text changes and update reactive variables
    fullNameController.addListener(
      () => fullName.value = fullNameController.text,
    );
    phoneController.addListener(() => phone.value = phoneController.text);
    streetAddressController.addListener(
      () => streetAddress.value = streetAddressController.text,
    );
    cityController.addListener(() => city.value = cityController.text);
    stateController.addListener(() => state.value = stateController.text);
    zipCodeController.addListener(() => zipCode.value = zipCodeController.text);
    dateOfBirthController.addListener(
      () => dateOfBirth.value = dateOfBirthController.text,
    );
    emergencyNameController.addListener(
      () => emergencyName.value = emergencyNameController.text,
    );
    emergencyPhoneController.addListener(
      () => emergencyPhone.value = emergencyPhoneController.text,
    );
  }

  String get fullAddress =>
      '${streetAddress.value} ${city.value}, ${state.value} ${zipCode.value}';

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1985, 6, 15),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.red,
              onPrimary: Colors.white,
              surface: Color(0xFF2C2C2C),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedDate =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      dateOfBirthController.text = formattedDate;
      dateOfBirth.value = formattedDate;
    }
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );

      if (image != null) {
        profileImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Profile image selected successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick image: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> saveProfile() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update profile: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
