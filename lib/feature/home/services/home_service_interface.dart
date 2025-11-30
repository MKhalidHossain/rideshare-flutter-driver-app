import 'package:get/get_connect/http/src/response/response.dart';

abstract class HomeServiceInterface {
  Future<Response> getAllServices();
  Future<Response> getServiceById(String serviceId);
  Future<Response> getVehicleByService(String serviceId);


  Future<Response> updateDriverLocation();
  Future<Response> toggleOnlineStatus();
}
