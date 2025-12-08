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
  Future<Response> getServiceById(String serviceId) async{
    return await historyAndProfileRepositoryInterface.getServiceById(serviceId);
  }
  
  @override
  Future<Response> getVehicleByService(String serviceId)async {
    return await historyAndProfileRepositoryInterface.getVehicleByService(serviceId);
  }

    @override
  Future<Response<dynamic>> connectStripeAccount() async {
    return await historyAndProfileRepositoryInterface.connectStripeAccount();
    
  }

    
  @override
  Future<Response> toggleOnlineStatus({required bool isOnline}) async{
    return await historyAndProfileRepositoryInterface.toggleOnlineStatus(isOnline: isOnline);
  }
  
  @override
  Future<Response> updateDriverLocation() async{
    return await historyAndProfileRepositoryInterface.updateDriverLocation();
  }
  
  @override
  Future<Response> acceptRide(rideId) async{
    return await historyAndProfileRepositoryInterface.acceptRide(rideId);
  }
  
  @override
  Future<Response> cancelRide(rideId) async{
    return await historyAndProfileRepositoryInterface.cancelRide(rideId);
  }
 

}
