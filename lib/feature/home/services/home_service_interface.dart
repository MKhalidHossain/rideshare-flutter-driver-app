import 'package:get/get_connect/http/src/response/response.dart';

abstract class HomeServiceInterface {
  Future<Response> getAllServices();
  Future<Response> getServiceById(String serviceId);
  Future<Response> getNearbyVehicles(String serviceId, String latitude, String longitude, String radius);
  Future<Response> getVehicleByService(String serviceId);
}
