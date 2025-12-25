import 'package:get/get_connect/http/src/response/response.dart';

import '../domain/request_model/sent_message_body.dart';
import '../domain/request_model/update_driver_location_request_model.dart';

abstract class HomeRepositoryInterface {
  Future<Response> getAllServices();
  Future<Response> getServiceById(String serviceId);
  Future<Response> getVehicleByService(String serviceId);

  Future<Response> connectStripeAccount();
  
  Future<Response> updateDriverLocation(UpdateDriverLocationRequestModel request);
  Future<Response> toggleOnlineStatus({required bool isOnline});

//ride
  Future<Response> acceptRide(String rideId);
  Future<Response> cancelRide(String rideId);

  Future<Response> getTripHistory();
  Future<Response> getEarnings();
  Future<Response> getNotifications();
//messsage
  Future<Response> sendMessage(SentMessageBody sentMessageBody);
}
