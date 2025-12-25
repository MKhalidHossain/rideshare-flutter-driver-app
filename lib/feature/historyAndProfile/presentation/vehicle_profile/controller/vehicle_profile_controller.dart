import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constants/urls.dart';
import '../../../../../utils/app_constants.dart';
import '../model/vehicle_model.dart';

class VehicleController extends GetxController {
  // Form key
  final formKey = GlobalKey<FormState>();
  var vehicleData = Rxn<VehicleData>();

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


  @override
  void onInit() {
    super.onInit();
    //loadVehicleData();
    getVehicleDetails();
    //setupTextListeners();
  }

  @override

  //============= get vehicle details====================
  Future<void> getVehicleDetails() async {
    const String url = Urls.baseUrl + Urls.getVehiclesDetails;
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.accessToken);

      if (token == null || token.isEmpty) {
        print("⚠️ No token found in SharedPreferences!");
        isLoading.value = false;
        return;
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("============Status Code: ${response.statusCode}");

      /*  if (response.statusCode == 200) {
        final data = json.decode(response.body);

        print(
          "======================✅ API Response: vehicle details*********** $data",
        );
        vehicleData.value = VehicleData.fromJson(data['data']);
        print("=====================✅ Profile fetched successfully!");
        setVehicleData(vehicleData.value);
      } */

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
          "======================✅ API Response: vehicle details*********** $data",
        );

        // Old: vehicleData.value = VehicleData.fromJson(data['data']);

        vehicleData.value = VehicleData.fromJson(data['data']);

        print("=====================✅ Profile fetched successfully!");
        //  setVehicleData(vehicleData.value);
      } else {
        print("❌ Failed to fetch profile: ${response.body}");
      }
    } catch (e) {
      print(
        "==========================⚠️ Error fetching  API Response: vehicle details: $e",
      );
    } finally {
      isLoading.value = false;
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
