import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_nearby_vehicles_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_service_by_id_response_model.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_vehicle_by_service_response_model.dart';

abstract class HomeRepositoryInterface {
  Future<Response> getAllServices();
  Future<Response> getServiceById(String serviceId);
  Future<Response> getVehicleByService(String serviceId);
  Future<Response> connectStripeAccount();
}
