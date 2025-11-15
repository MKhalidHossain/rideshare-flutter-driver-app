import 'package:get/get_connect/http/src/response/response.dart';
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
  Future<Response> getNearbyVehicles(String serviceId, String latitude, String longitude, String radius) async{
    return await apiClient.getData(
        Urls.getNearbyVehicles + '?serviceId=$serviceId&latitude=$latitude&longitude=$longitude&radius=$radius');
  }
  
  @override
  Future<Response> getServiceById(String serviceId) async{
    return await apiClient.getData(Urls.getServiceById + serviceId);
  }
  
  @override
  Future<Response> getVehicleByService(String serviceId) async{
    return await apiClient.getData(Urls.getVehicleByService + serviceId);
  }
  
}
