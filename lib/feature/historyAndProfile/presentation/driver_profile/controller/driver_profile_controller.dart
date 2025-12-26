import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ridetohealthdriver/helpers/custom_snackbar.dart';

import '../../../../../core/constants/urls.dart';
import '../../../../../utils/app_constants.dart';
import '../../../../../helpers/remote/data/api_client.dart';
import '../../../model/driver_profile_model.dart';
import '../../../model/update_profile_request_model.dart';
import '../../../model/update_profile_response_model.dart';
import '../screens/driver_profile_info_screen.dart';

class DriverProfileController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();
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
  var isUploadingImage = false.obs;

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
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.accessToken);

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      apiClient.updateHeader(token);
      final response = await apiClient.getData(Urls.getDriverProfile);

      if (response.statusCode == 200) {
        final dynamic body = response.body;
        final decoded = body is String ? json.decode(body) : body;
        driverProfile.value = DriverProfileResponse.fromJson(decoded);

        final profile = driverProfile.value?.profileData;

        print("======== PROFILE  RESPONSE: $profile");
        if (profile != null) {
          // SET VARIABLES + TEXT CONTROLLERS
          fullName.value = profile.fullName ?? '';
          fullNameController.text = profile.fullName ?? '';

          email.value = profile.email ?? '';

          phone.value = profile.phoneNumber ?? '';
          phoneController.text = profile.phoneNumber ?? '';

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
        await uploadProfileImage(image);
      }
    } catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<void> uploadProfileImage(XFile image) async {
    if (isUploadingImage.value) return;
    isUploadingImage.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.accessToken);

      if (token != null && token.isNotEmpty) {
        apiClient.updateHeader(token);
      }

      final response = await apiClient.uploadProfileImage(
        Urls.uploadProfileImage,
        image,
        fileFieldName: 'image',
      );

      final success =
          response.statusCode == 200 || response.statusCode == 201;

      String? remoteImageUrl;
      final body = response.body;
      if (body is Map) {
        final data = body['data'];
        if (data is Map && data['profileImage'] is String) {
          remoteImageUrl = data['profileImage'] as String;
        } else if (body['profileImage'] is String) {
          remoteImageUrl = body['profileImage'] as String;
        } else if (body['image'] is String) {
          remoteImageUrl = body['image'] as String;
        }
      }

      if (remoteImageUrl != null && remoteImageUrl.isNotEmpty) {
        profileImageUrl.value = remoteImageUrl;
      }

      if (success) {
        await getDriverProfile();
        showAppSnackBar(
          'Success',
          'Profile image uploaded successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        showAppSnackBar(
          'Error',
          response.statusText ?? 'Failed to upload profile image',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      showAppSnackBar(
        'Error',
        'Failed to upload profile image',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      print("Failed to upload image: $e");
    } finally {
      isUploadingImage.value = false;
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

  Future<void> updateDriverProfile(UpdateProfileRequestModel requestModel) async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.accessToken);

      if (token == null || token.isEmpty) {
        isLoading.value = false;
        return;
      }

      apiClient.updateHeader(token);

      final body = requestModel.toJson()..removeWhere((key, value) => value == null);
      final response = await apiClient.putData(Urls.updateDriverProfile, body);

      if (response.statusCode == 200 && (response.body != null)) {
        final decoded =
            response.body is String ? json.decode(response.body) : response.body;
        final parsed = decoded is Map<String, dynamic>
            ? UpdateProfileResponseModel.fromJson(decoded)
            : null;

        if (parsed?.data != null) {
          driverProfile.value = DriverProfileResponse(
            success: parsed?.success,
            profileData: ProfileData.fromJson(parsed!.data!.toJson()),
            driverData: driverProfile.value?.driverData,
          );
        }
        await getDriverProfile();
        final ctx = Get.context;
        if (ctx != null) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(parsed?.message ?? 'Profile updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
        Get.off(() => const DriverProfileInfoScreen());
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
