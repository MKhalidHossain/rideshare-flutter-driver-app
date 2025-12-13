import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ridetohealthdriver/feature/home/domain/request_model/request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/urls.dart';
import '../../../helpers/remote/data/api_client.dart';
import 'home_repository_interface.dart';

class HomeRepository
    implements HomeRepositoryInterface {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  HomeRepository(this.apiClient, this.sharedPreferences);
  
  @override
  Future<Response> getAllServices() async{
    return await apiClient.getData(Urls.getAllServices);
  }
  

  
  @override
  Future<Response> getServiceById(String serviceId) async{
    return await apiClient.getData(Urls.getServiceById + serviceId);
  }
  
  @override
  Future<Response> getVehicleByService(String serviceId) async{
    return await apiClient.getData(Urls.getVehicleByService + serviceId);
  }

    @override
  Future<Response<dynamic>> connectStripeAccount() async{
    return apiClient.postData(Urls.connectStripeAccount, {});
  }

    
  @override
  Future<Response> toggleOnlineStatus({required bool isOnline})async {
    return await apiClient.putData(Urls.toggleOnlineStatus, {
      "isOnline": isOnline,
    });
  }
  
  @override
  Future<Response> updateDriverLocation() async{
    return await apiClient.putData(Urls.updateDriverLocation, {});
  }
  
  @override
  Future<Response> acceptRide(String rideId)async {
    return await apiClient.postData(Urls.acceptRide+rideId+"/accept", {});
  }
  
  @override
  Future<Response> cancelRide(String rideId) async{
    return await apiClient.postData(Urls.cancelRide+rideId+"/cancel", {});
  }

  @override
  Future<Response> getTripHistory() async{
    return await apiClient.getData(Urls.getTripHistory);
  }

  @override
  Future<Response> getEarnings() async{
    return await apiClient.getData(Urls.getEarnings);
  }

  @override
  Future<Response> sendMessage(SentMessageBody sentMessageBody) async{
    return await apiClient.postData(Urls.sendMessage, sentMessageBody.toJson());
  }
  

  
}
 
 
