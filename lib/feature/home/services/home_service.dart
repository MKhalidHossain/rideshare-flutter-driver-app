import 'package:get/get_connect/http/src/response/response.dart';
import 'package:ridetohealthdriver/feature/home/repositories/home_repository_interface.dart';
import 'home_service_interface.dart';

class HomeService implements HomeServiceInterface {
  final HomeRepositoryInterface
  historyAndProfileRepositoryInterface;

  HomeService(this.historyAndProfileRepositoryInterface);
  
  @override
  Future<Response> getAllServices() async{
    return await historyAndProfileRepositoryInterface.getAllServices();
  }
  
  @override
  Future<Response> getNearbyVehicles(String serviceId, String latitude, String longitude, String radius) async{
    return await historyAndProfileRepositoryInterface.getNearbyVehicles(serviceId, latitude, longitude, radius);
  }
  
  @override
  Future<Response> getServiceById(String serviceId) async{
    return await historyAndProfileRepositoryInterface.getServiceById(serviceId);
  }
  
  @override
  Future<Response> getVehicleByService(String serviceId)async {
    return await historyAndProfileRepositoryInterface.getVehicleByService(serviceId);
  }

}
