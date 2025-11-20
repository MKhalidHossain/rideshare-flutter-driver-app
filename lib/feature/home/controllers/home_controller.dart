import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_all_services_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_nearby_vehicles_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_service_by_id_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_vehicle_by_service_response_model.dart';
import 'package:ridetohealthdriver/feature/home/services/home_service_interface.dart';

class HomeController extends GetxController {
  final HomeServiceInterface homeServiceInterface;
  HomeController(this.homeServiceInterface);

  bool isLoading = false;

  //service
  GetAllServicesResponseModel getAllServicesResponseModel =
      GetAllServicesResponseModel();
  GetServiceByIdResponseModel getServiceByIdResponseModel =
      GetServiceByIdResponseModel();
  GetNearbyVehiclesResponseModel getNearbyVehiclesResponseModel =
      GetNearbyVehiclesResponseModel();
  GetVehicleByServiceResponseModel getVehicleByServiceResponseModel =
      GetVehicleByServiceResponseModel();


  Future<void> getAllServices() async {
    try {
      isLoading = true;
      update();

      final response = await homeServiceInterface.getAllServices();

      debugPrint(" Status Code: ${response.statusCode}");
      debugPrint(" Body Type: ${response.body.runtimeType}");
      debugPrint(" Response Body: ${response.body}");

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
}
