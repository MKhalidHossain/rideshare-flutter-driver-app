import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/accept_ride_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/cancel_ride_response_model.dart';
import 'package:ridetohealthdriver/payment/domain/connect_stripe_account_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_all_services_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_nearby_vehicles_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_service_by_id_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_vehicle_by_service_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/toggle_online_status_response_model.dart';
import 'package:ridetohealthdriver/feature/home/services/home_service_interface.dart';

import '../domain/response_model/update_driver_location_respones_model.dart';

class HomeController extends GetxController {
  final HomeServiceInterface homeServiceInterface;
  HomeController(this.homeServiceInterface);

  bool isLoading = false;
  bool isDriverOnline = false;
  bool isDriverAvailable = false;
  bool isTogglingStatus = false;

  //service
  GetAllServicesResponseModel getAllServicesResponseModel =
      GetAllServicesResponseModel();
  GetServiceByIdResponseModel getServiceByIdResponseModel =
      GetServiceByIdResponseModel();
  GetNearbyVehiclesResponseModel getNearbyVehiclesResponseModel =
      GetNearbyVehiclesResponseModel();
  GetVehicleByServiceResponseModel getVehicleByServiceResponseModel =
      GetVehicleByServiceResponseModel();
  ConnectStripeAccountResponseModel? connectStripeAccountResponseModel;

  UpdateDriverLocationResponesModel updateDriverLocationResponesModel = UpdateDriverLocationResponesModel();
  ToggleOnlineStatusResponseModel toggleOnlineStatusResponseModel = ToggleOnlineStatusResponseModel();

  AcceptRideResponseModel acceptRideResponseModel = AcceptRideResponseModel();
  CancelRideResponseModel cancelRideResponseModel = CancelRideResponseModel();

  Future<void> getAllServices() async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.getAllServices();

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Body Type: ${response.body.runtimeType}");
      debugPrint(" Response Body fp: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        getAllServicesResponseModel =
            GetAllServicesResponseModel.fromJson(decoded);

        print("✅ getAllServices : for HomeController fetched successfully");
      } else {
        final decoded = response.body is String
            ? jsonDecode(response.body)
            : response.body;

        getAllServicesResponseModel =
            GetAllServicesResponseModel.fromJson(decoded);
      }
    } catch (e) {
      debugPrint("⚠️ Error fetching HomeController : getAllServices : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }

  
  
  
  Future<void> getNearbyVehicles() async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.getAllServices();

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

       if (response.statusCode == 200) {
        print("✅ getNearbyVehicles : for HomeController fetched successfully \n");
        getServiceByIdResponseModel = GetServiceByIdResponseModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
             getServiceByIdResponseModel = GetServiceByIdResponseModel.fromJson(
          response.body,
        );
      }

    }catch (e) {
      debugPrint("⚠️ Error fetching HomeController : getNearbyVehicles : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }
  
  
  Future<void> getVehicleByService() async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.getAllServices();

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

       if (response.statusCode == 200) {
        print("✅ getVehicleByService : for HomeController fetched successfully \n");
        getVehicleByServiceResponseModel = GetVehicleByServiceResponseModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
            getVehicleByServiceResponseModel = GetVehicleByServiceResponseModel.fromJson(
          response.body,
        );
      }

    }catch (e) {
      debugPrint("⚠️ Error fetching HomeController : getVehicleByService : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }


Future<ConnectStripeAccountResponseModel> connectStripeAccount() async {
    try {
      final response = await homeServiceInterface.connectStripeAccount();

      final dynamic body = response.body;
      late final Map<String, dynamic> decoded;

      if (body is String) {
        final parsed = jsonDecode(body);
        if (parsed is! Map<String, dynamic>) {
          throw Exception('Invalid response format from Stripe connect API');
        }
        decoded = parsed;
      } else if (body is Map<String, dynamic>) {
        decoded = body;
      } else {
        throw Exception('Invalid response format from Stripe connect API');
      }

      final result = ConnectStripeAccountResponseModel.fromJson(decoded);
      connectStripeAccountResponseModel = result;

      if (!result.success || (result.url?.isEmpty ?? true)) {
        throw Exception(result.message ?? 'Unable to start Stripe onboarding');
      }

      debugPrint('✅ Stripe connect link fetched: ${result.url}\n');
      return result;
    } catch (e) {
      debugPrint('⚠️ Error fetching Stripe connect link: $e\n');
      rethrow;
    }
  }



  Future<void> updateDriverLocation() async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.updateDriverLocation();

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

       if (response.statusCode == 200) {
        print("✅ updateDriverLocation : for HomeController fetched successfully \n");
        updateDriverLocationResponesModel = UpdateDriverLocationResponesModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
          updateDriverLocationResponesModel = UpdateDriverLocationResponesModel.fromJson(
          response.body,
        );
      }

    }catch (e) {
      debugPrint("⚠️ Error fetching HomeController : updateDriverLocation : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> toggleOnlineStatus(bool desiredStatus) async {
    if (isTogglingStatus) return;

    final previousOnline = isDriverOnline;
    final previousAvailable = isDriverAvailable;

    isTogglingStatus = true;
    isDriverOnline = desiredStatus;
    try {
      update();

      final response = await homeServiceInterface.toggleOnlineStatus(
        isOnline: desiredStatus,
      );

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

      final dynamic body = response.body;
      final decoded = body is String ? jsonDecode(body) : body;

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid toggle online status response');
      }

      toggleOnlineStatusResponseModel =
          ToggleOnlineStatusResponseModel.fromJson(decoded);

      if (response.statusCode == 200 &&
          (toggleOnlineStatusResponseModel.success ?? false)) {
        isDriverOnline =
            toggleOnlineStatusResponseModel.data?.isOnline ?? desiredStatus;
        isDriverAvailable =
            toggleOnlineStatusResponseModel.data?.isAvailable ??
                previousAvailable;
        debugPrint(
          "✅ toggleOnlineStatus : HomeController updated (online: $isDriverOnline, available: $isDriverAvailable)\n",
        );
      } else {
        isDriverOnline = previousOnline;
        isDriverAvailable = previousAvailable;
      }

    }catch (e) {
      debugPrint("⚠️ Error fetching HomeController : toggleOnlineStatus : $e\n");
      isDriverOnline = previousOnline;
      isDriverAvailable = previousAvailable;
    } finally {
      isTogglingStatus = false;
      update();
    }
  }

    Future<void> acceptRide(rideId) async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.acceptRide(rideId);

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response Body: acceptRide : ${response.body}");

       if (response.statusCode == 200) {
        print("✅ acceptRide : for HomeController fetched successfully \n");
        acceptRideResponseModel = AcceptRideResponseModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
         acceptRideResponseModel = AcceptRideResponseModel.fromJson(
          response.body,
        );
      }

    }catch (e) {
      debugPrint("⚠️ Error fetching HomeController : acceptRide : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  } 
  
  
   Future<void> cancelRide(rideId) async {
    try {
      isLoading = true;
      update();
      

      final response = await homeServiceInterface.cancelRide(rideId);

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Response Body: ${response.body}");

       if (response.statusCode == 200) {
        print("✅ cancelRide : for HomeController fetched successfully \n");
        cancelRideResponseModel = CancelRideResponseModel.fromJson(
          response.body,
        );

        isLoading = false;
        update();
      } else {
           cancelRideResponseModel = CancelRideResponseModel.fromJson(
          response.body,
        );
      }

    }catch (e) {
      debugPrint("⚠️ Error fetching HomeController : cancelRide : $e\n");
    } finally {
      isLoading = false;
      update();
    }
  }



}
