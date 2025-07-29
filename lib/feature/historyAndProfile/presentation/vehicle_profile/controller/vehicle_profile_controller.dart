import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class VehicleController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();

  // Controllers
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final yearController = TextEditingController();
  final colorController = TextEditingController();
  final licensePlateController = TextEditingController();
  final vinController = TextEditingController();
  final insuranceProviderController = TextEditingController();
  final policyNumberController = TextEditingController();
  final expiryDateController = TextEditingController();

  // Focus Nodes
  final makeFocus = FocusNode();
  final modelFocus = FocusNode();
  final yearFocus = FocusNode();
  final colorFocus = FocusNode();
  final licensePlateFocus = FocusNode();
  final vinFocus = FocusNode();
  final insuranceProviderFocus = FocusNode();
  final policyNumberFocus = FocusNode();
  final expiryDateFocus = FocusNode();

  // Observable variables
  var isLoading = false.obs;
  var vehicleImage = Rx<File?>(null);
  var vehicleImageUrl = '/placeholder.svg?height=150&width=300'.obs;

  // Reactive text values
  var make = 'Toyota'.obs;
  var model = 'Camry'.obs;
  var year = '2019'.obs;
  var color = 'Silver'.obs;
  var licensePlate = 'ABC1234'.obs;
  var vin = '1HGCM82633A123456'.obs;
  var insuranceProvider = 'AllState Insurance'.obs;
  var policyNumber = 'POL-123456789'.obs;
  var expiryDate = '2027-12-31'.obs;

  @override
  void onInit() {
    super.onInit();
    loadVehicleData();
    setupTextListeners();
  }

  @override
  void onClose() {
    // Dispose controllers
    makeController.dispose();
    modelController.dispose();
    yearController.dispose();
    colorController.dispose();
    licensePlateController.dispose();
    vinController.dispose();
    insuranceProviderController.dispose();
    policyNumberController.dispose();
    expiryDateController.dispose();

    // Dispose focus nodes
    makeFocus.dispose();
    modelFocus.dispose();
    yearFocus.dispose();
    colorFocus.dispose();
    licensePlateFocus.dispose();
    vinFocus.dispose();
    insuranceProviderFocus.dispose();
    policyNumberFocus.dispose();
    expiryDateFocus.dispose();

    super.onClose();
  }

  void loadVehicleData() {
    // Load data into controllers
    makeController.text = make.value;
    modelController.text = model.value;
    yearController.text = year.value;
    colorController.text = color.value;
    licensePlateController.text = licensePlate.value;
    vinController.text = vin.value;
    insuranceProviderController.text = insuranceProvider.value;
    policyNumberController.text = policyNumber.value;
    expiryDateController.text = expiryDate.value;
  }

  void setupTextListeners() {
    // Listen to text changes and update reactive variables
    makeController.addListener(() => make.value = makeController.text);
    modelController.addListener(() => model.value = modelController.text);
    yearController.addListener(() => year.value = yearController.text);
    colorController.addListener(() => color.value = colorController.text);
    licensePlateController.addListener(
      () => licensePlate.value = licensePlateController.text,
    );
    vinController.addListener(() => vin.value = vinController.text);
    insuranceProviderController.addListener(
      () => insuranceProvider.value = insuranceProviderController.text,
    );
    policyNumberController.addListener(
      () => policyNumber.value = policyNumberController.text,
    );
    expiryDateController.addListener(
      () => expiryDate.value = expiryDateController.text,
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2027, 12, 31),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
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
      expiryDateController.text = formattedDate;
      expiryDate.value = formattedDate;
    }
  }

  Future<void> pickVehicleImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (image != null) {
        vehicleImage.value = File(image.path);
        Get.snackbar(
          'Success',
          'Vehicle image selected successfully!',
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

  Future<void> saveVehicle() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 2));

        Get.snackbar(
          'Success',
          'Vehicle details updated successfully!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.back();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to update vehicle: $e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }
}
