import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constants/urls.dart';
import '../../../../../utils/app_constants.dart';
import '../../../model/driver_profile_model.dart';
import '../screens/driver_profile_info_screen.dart';

class DriverProfileController extends GetxController {
  // ------------------------- FORM & CONTROLLERS -------------------------
  final formKey = GlobalKey<FormState>();

  // Text Controllers
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

  // ------------------------- OBSERVABLE VARIABLES -------------------------
  var driverProfile = Rxn<DriverProfileResponse>();
  var isLoading = false.obs;

  var profileImage = Rx<File?>(null);
  var profileImageUrl = ''.obs;

  var fullName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var streetAddress = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var zipCode = ''.obs;
  var dateOfBirth = ''.obs;
  var emergencyName = ''.obs;
  var emergencyPhone = ''.obs;

  // Full Address Getter
  String get fullAddress =>
      '${streetAddress.value}, ${city.value}, ${state.value} ${zipCode.value}';

  // ------------------------- INIT -------------------------
  @override
  void onInit() {
    super.onInit();
    getDriverProfile();
  }

  // ------------------------- GET PROFILE -------------------------
  Future<void> getDriverProfile() async {
    const String url = Urls.baseUrl + Urls.getDriverProfile;
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.token);

      if (token == null || token.isEmpty) {
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        driverProfile.value = DriverProfileResponse.fromJson(data);

        final profile = driverProfile.value?.profileData;

        print("======== PROFILE  RESPONSE: $profile");
        if (profile != null) {
          // SET VARIABLES + TEXT CONTROLLERS
          fullName.value = profile.fullName;
          fullNameController.text = profile.fullName;

          email.value = profile.email;

          phone.value = profile.phoneNumber;
          phoneController.text = profile.phoneNumber;

          dateOfBirth.value = profile.dateOfBirth ?? '';
          dateOfBirthController.text = profile.dateOfBirth ?? '';

          profileImageUrl.value = profile.profileImage ?? '';

          emergencyName.value = profile.emergencyContact?.name ?? '';
          emergencyNameController.text = profile.emergencyContact?.name ?? '';

          emergencyPhone.value = profile.emergencyContact?.phoneNumber ?? '';
          emergencyPhoneController.text =
              profile.emergencyContact?.phoneNumber ?? '';

          streetAddress.value = profile.streetAddress ?? '';
          streetAddressController.text = profile.streetAddress ?? '';

          city.value = profile.city ?? '';
          cityController.text = profile.city ?? '';

          state.value = profile.state ?? '';
          stateController.text = profile.state ?? '';

          zipCode.value = profile.zipcode ?? '';
          zipCodeController.text = profile.zipcode ?? '';
        }
      } else {
        print(
          "=============================        Failed to fetch profile: ${response.body}",
        );
      }
    } catch (e) {
      print("====================   Error fetching profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ------------------------- PICK IMAGE -------------------------
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
      }
    } catch (e) {
      print("Failed to pick image: $e");
    }
  }

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

  Future<void> updateDriverProfile({
    required String fullName,
    required String phone,
    required String streetAddress,
    required String city,
    required String state,
    required String zipcode,
    required String dateOfBirth,
    required String emergencyName,
    required String emergencyPhone,
  }) async {
    const String url = Urls.baseUrl + Urls.updateDriverProfile;
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.token);

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      var request = http.MultipartRequest('PUT', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['full_name'] = fullName;
      request.fields['phone_number'] = phone;
      request.fields['street_address'] = streetAddress;
      request.fields['city'] = city;
      request.fields['state'] = state;
      request.fields['zipcode'] = zipcode;
      request.fields['date_of_birth'] = dateOfBirth;
      request.fields['emergency_contact_name'] = emergencyName;
      request.fields['emergency_contact_phone'] = emergencyPhone;

      if (profileImage.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'profile_image',
            profileImage.value!.path,
          ),
        );
      }

      print("========= SENDING PROFILE UPDATE REQUEST =========");

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      print("========= UPDATE RESPONSE =========");
      print("Status Code: ${streamedResponse.statusCode}");
      print("Body: $responseBody");

      if (streamedResponse.statusCode == 200) {
        print(
          "--------------------------------------*********---------------Profile updated successfully!",
        );
        await getDriverProfile();
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          backgroundColor: Colors.green,
        );
        Get.to(() => DriverProfileInfoScreen());
      } else {
        print("Failed to update profile");
      }
    } catch (e) {
      print("Error updating profile: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
