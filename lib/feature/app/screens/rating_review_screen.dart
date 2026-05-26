import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ridetohealthdriver/core/widgets/loading_shimmer.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../controller/rating_controller.dart';

class RatingsReviewsScreen extends StatelessWidget {
  const RatingsReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.put(ReviewController());
    return AppScaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,

        title: const Text(
          'Ratings & Reviews',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),

      body: Obx(() {
        final isLoading = reviewController.isLoading.value;
        final reviewData = reviewController.reviewData.value;
        final error = reviewController.errorMessage.value;

        // 🔥 1. Loading State
        if (isLoading) {
          return const Center(child: LoadingShimmer());
        }

        // 🔥 2. Error State
        if (error.isNotEmpty) {
          return Center(
            child: Text(error, style: TextStyle(color: Colors.white)),
          );
        }

        if (reviewData == null) {
          return const Center(
            child: Text("No Data Found", style: TextStyle(color: Colors.white)),
          );
        }

        // 🔥 4. Data Found → Show UI
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Overall Rating Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 32),
                        const SizedBox(width: 8),
                        Text(
                          '${reviewData.averageRating}',
                          style: TextStyle(
                            color: AppColors.context(context).textColor,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),
                    Text(
                      '${reviewData.pagination.totalReviews} Rating',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    // Rating Breakdown
                    _buildRatingBar(
                      '5 stars',
                      reviewData.starPercentages.fiveStar.toInt(),
                      843,
                    ),
                    _buildRatingBar(
                      '4 stars',
                      reviewData.starPercentages.fourStar.toInt(),
                      843,
                    ),
                    _buildRatingBar(
                      '3 stars',
                      reviewData.starPercentages.threeStar.toInt(),
                      843,
                    ),
                    _buildRatingBar(
                      '2 stars',
                      reviewData.starPercentages.twoStar.toInt(),
                      843,
                    ),
                    _buildRatingBar(
                      '1 stars',
                      reviewData.starPercentages.oneStar.toInt(),
                      843,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Reviews List
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: reviewData.reviews.length,
                itemBuilder: (_, index) {
                  final review = reviewData.reviews[index];
                  final reviewerName = review.customer.name;
                  final reviewComment = review.comment;
                  return _buildReviewCard(
                    reviewerName.isEmpty ? "Unknown" : reviewerName,
                    review.ratedAt != null
                        ? reviewController.timeAgo(review.ratedAt!)
                        : "Unknown",
                    review.rating.toInt(),
                    reviewComment == null || reviewComment.isEmpty
                        ? "No Comment"
                        : reviewComment,
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRatingBar(String label, int count, int total) {
    double percentage = count / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 30,
            child: Text(
              count.toString(),
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(String name, String time, int rating, String review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with name, time, and rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              // Star Rating
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 16,
                    color: index < rating ? Colors.amber : Colors.grey,
                  );
                }),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Review Text
          Text(
            review,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
