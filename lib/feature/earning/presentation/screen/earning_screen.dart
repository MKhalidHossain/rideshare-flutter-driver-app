import 'package:flutter/material.dart';
import 'package:ridetohealthdriver/core/widgets/loading_shimmer.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_ride_history_response_model.dart';
import '../../controller/controller.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  final EarningsController controller = Get.put(EarningsController());
  late final HomeController homeController;

  @override
  void initState() {
    super.initState();
    homeController = Get.find<HomeController>();
    homeController.getTripHistory();
    homeController.getEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF303644),
      appBar: AppBar(
        backgroundColor: const Color(0xFF303644),
        elevation: 0,
        automaticallyImplyLeading: false, // optional: remove back button
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Earnings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF34495E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(
                () => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.selectedPaymentMethod.value,
                    dropdownColor: const Color(0xFF34495E),
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    items: ['Wallet', 'Cash']
                        .map(
                          (method) => DropdownMenuItem<String>(
                            value: method,
                            child: Text(method),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.switchPaymentMethod(value);
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          // Earnings Summary Card
          _buildEarningsSummaryCard(),
          Container(
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(16),
            child: const Text(
              'Ride History',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          // Ride History Section
          Expanded(child: _buildRideHistorySection()),
        ],
      ),
    );
  }

  Widget _buildEarningsSummaryCard() {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        final earningsData = homeController.getEarningsResponseModel.data;
        final summary = earningsData != null && earningsData.isNotEmpty ? earningsData.first : null;
        final totalEarnings = (summary?.totalEstimatedFare ?? 0).toDouble();
        final ridesCompleted = summary?.totalRides ?? 0;

        Widget content;
        if (homeController.isEarningsLoading) {
          content = const Center(
            child: LoadingShimmer(color: Colors.white),
          );
        } else if (homeController.earningsError != null) {
          content = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                homeController.earningsError ?? 'Unable to fetch earnings',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: homeController.getEarnings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF79262C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        } else {
          content = Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${totalEarnings.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rides Completed\n$ridesCompleted',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => controller.withdrawEarnings(totalEarnings),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF79262C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text(
                  'Withdraw',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          );
        }

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF454A57),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Earnings Summary',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              content,
            ],
          ),
        );
      },
    );
  }

  Widget _buildRideHistorySection() {
    return GetBuilder<HomeController>(
      builder: (homeController) {
        final rides = homeController.getTripHistoryResponseModel.data?.rides ?? [];
        final summaries = _groupRidesByDay(rides);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF595E69),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(color: Color(0xFF454A57)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Day',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        'Date',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: Text(
                        'Rides',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Text(
                        'Earnings',
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.white,
                  backgroundColor: const Color(0xFF3C4356),
                  onRefresh: homeController.getTripHistory,
                  child: Builder(
                    builder: (_) {
                      if (homeController.isTripHistoryLoading) {
                        return const Center(
                          child: LoadingShimmer(color: Colors.white),
                        );
                      }

                      if (homeController.tripHistoryError != null) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            const SizedBox(height: 80),
                            Center(
                              child: Text(
                                homeController.tripHistoryError ?? 'Something went wrong',
                                style: const TextStyle(color: Colors.white70),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }

                      if (summaries.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [
                            SizedBox(height: 80),
                            Center(
                              child: Text(
                                'No rides found yet',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: summaries.length,
                        separatorBuilder: (_, __) => const Divider(
                          color: Colors.grey,
                          height: 0.2,
                        ),
                        itemBuilder: (context, index) {
                          final summary = summaries[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    summary.dayLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    summary.dateLabel,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    summary.rideCount.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    '\$${summary.earnings.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<_DaySummary> _groupRidesByDay(List<Rides> rides) {
    final Map<String, _DaySummary> grouped = {};

    for (final ride in rides) {
      final dateString = ride.createdAt;
      if (dateString == null) continue;

      final parsed = DateTime.tryParse(dateString);
      if (parsed == null) continue;

      final key = DateFormat('yyyy-MM-dd').format(parsed.toUtc());
      final fare = _fareForRide(ride) ?? 0;

      final existing = grouped[key];
      if (existing != null) {
        grouped[key] = existing.copyWith(
          rideCount: existing.rideCount + 1,
          earnings: existing.earnings + fare,
        );
      } else {
        grouped[key] = _DaySummary(
          date: parsed.toLocal(),
          rideCount: 1,
          earnings: fare,
        );
      }
    }

    final list = grouped.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return list;
  }

  double? _fareForRide(Rides ride) {
    final finalFare = ride.finalFare;
    if (finalFare != null && finalFare > 0) {
      return finalFare.toDouble();
    }

    final totalFare = ride.totalFare;
    if (totalFare != null && totalFare > 0) {
      return totalFare.toDouble();
    }

    return (finalFare ?? totalFare)?.toDouble();
  }
}

class _DaySummary {
  final DateTime date;
  final int rideCount;
  final double earnings;

  const _DaySummary({
    required this.date,
    required this.rideCount,
    required this.earnings,
  });

  String get dayLabel => DateFormat('EEE').format(date);
  String get dateLabel => DateFormat('MMM d').format(date);

  _DaySummary copyWith({
    DateTime? date,
    int? rideCount,
    double? earnings,
  }) {
    return _DaySummary(
      date: date ?? this.date,
      rideCount: rideCount ?? this.rideCount,
      earnings: earnings ?? this.earnings,
    );
  }
}
