import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../core/constants/urls.dart';
import '../../../utils/app_constants.dart';
import '../model/rating_model.dart';


class ReviewController extends GetxController {
  // Observable variables
  var isLoading = true.obs;
  var reviewData = Rxn<ReviewRatingModel>();
  var errorMessage = ''.obs;

  // API endpoint


  @override
  void onInit() {
    super.onInit();
    fetchReviews();
  }

  // Fetch reviews from API
  Future<void> fetchReviews() async {
    const String url = Urls.baseUrl+Urls.getReviews;
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(AppConstants.accessToken);
      isLoading(true);
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        reviewData.value = ReviewRatingModel.fromJson(jsonData['data']);

       // print("=================review data ===== = = =  ***********${reviewData}");
       // print("Review Data: ${reviewData.value.jsonData()}");


        reviewData.value = ReviewRatingModel.fromJson(jsonData['data']);

        print("======= Review Data ======= ${reviewData.value?.toJson()}");

      } else {
        errorMessage.value =
        'Failed to fetch data: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
      print('====================== reating error ========= ${errorMessage}');

    } finally {
      isLoading(false);
    }
  }




String timeAgo(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';

  // If older than a week, show date
  return '${date.day}/${date.month}/${date.year}';
}


}
