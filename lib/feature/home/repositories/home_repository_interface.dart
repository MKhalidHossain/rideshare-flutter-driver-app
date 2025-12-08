import 'package:get/get_connect/http/src/response/response.dart';

abstract class HomeRepositoryInterface {
  Future<Response> getAllServices();
  Future<Response> getServiceById(String serviceId);
  Future<Response> getVehicleByService(String serviceId);

  Future<Response> connectStripeAccount();
  
  Future<Response> updateDriverLocation();
  Future<Response> toggleOnlineStatus({required bool isOnline});

//ride
  Future<Response> acceptRide(rideId);
  Future<Response> cancelRide(rideId);

}
