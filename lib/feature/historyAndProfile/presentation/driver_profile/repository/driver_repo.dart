
import '../../../../../helpers/remote/data/api_client.dart';
import '../../../../auth/repositories/auth_repository.dart';


class DriverRepository {
  final ApiClient apiClient;
  final AuthRepository authRepository;

  DriverRepository({required this.apiClient, required this.authRepository});

  Future<void> getDriverProfile() async {
    try {

      final token = authRepository.getUserToken();
      print("🔑 Token: $token");

      // GET API call
      final response = await apiClient.getData(
    '/api/driver/profile',
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("Status Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("✅ Driver Profile fetched successfully!");
        print("Profile Data: ${response.body}");
      } else {
        print("❌ Failed to fetch profile: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error fetching driver profile: $e");
    }
  }
}
