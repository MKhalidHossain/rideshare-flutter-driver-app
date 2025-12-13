import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/get_ride_history_response_model.dart';

class RideHistoryPage extends StatefulWidget {
  const RideHistoryPage({super.key});

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> {
  late final HomeController _homeController;

  @override
  void initState() {
    super.initState();
    _homeController = Get.find<HomeController>();
    _homeController.getTripHistory();
  }

  Color _statusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return const Color(0xFFD32F2F);
      default:
        return Colors.orangeAccent;
    }
  }

  String _statusLabel(String? status) {
    if (status == null || status.isEmpty) return 'Unknown';
    final lower = status.toLowerCase();
    return lower[0].toUpperCase() + lower.substring(1);
  }

  String _formatDate(String? date) {
    if (date == null) return '--';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '--';
    return DateFormat('MMMM d, y').format(parsed);
  }

  String _formatTime(String? date) {
    if (date == null) return '--';
    final parsed = DateTime.tryParse(date);
    if (parsed == null) return '--';
    return DateFormat('h:mm a').format(parsed);
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

  String _formatFare(num? fare) {
    if (fare == null) return '--';
    return '\$${fare.toDouble().toStringAsFixed(2)}';
  }

  Widget _buildRideCard(Rides ride) {
    return RideCard(
      date: _formatDate(ride.createdAt),
      time: _formatTime(ride.createdAt),
      status: _statusLabel(ride.status),
      statusColor: _statusColor(ride.status),
      price: _formatFare(_fareForRide(ride)),
      pickup: ride.pickupLocation?.address ?? 'Pickup not available',
      dropoff: ride.dropoffLocation?.address ?? 'Dropoff not available',
    );
  }

  Widget _buildError(HomeController controller) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            controller.tripHistoryError ?? 'Something went wrong',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: controller.getTripHistory,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3141),
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (controller) {
            final rides = controller.getTripHistoryResponseModel.data?.rides ?? [];
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ride History",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      filterButton("All Rides", selected: true),
                      const SizedBox(width: 18),
                      filterButton("Completed"),
                      const SizedBox(width: 18),
                      filterButton("Cancelled"),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (controller.isTripHistoryLoading) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }

                        if (controller.tripHistoryError != null) {
                          return _buildError(controller);
                        }

                        if (rides.isEmpty) {
                          return RefreshIndicator(
                            color: Colors.white,
                            backgroundColor: const Color(0xFF3C4356),
                            onRefresh: controller.getTripHistory,
                            child: ListView(
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
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: Colors.white,
                          backgroundColor: const Color(0xFF3C4356),
                          onRefresh: controller.getTripHistory,
                          child: ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: rides.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 12),
                            itemBuilder: (_, index) => _buildRideCard(rides[index]),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget filterButton(String title, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF840B0E) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade500),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: selected ? Colors.white : Colors.grey[300],
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class RideCard extends StatelessWidget {
  final String date;
  final String time;
  final String status;
  final Color statusColor;
  final String price;
  final String pickup;
  final String dropoff;

  const RideCard({
    super.key,
    required this.date,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.price,
    required this.pickup,
    required this.dropoff,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3C4356),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.white),
              const SizedBox(width: 6),
              Text(
                date,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.access_time, size: 16, color: Colors.white),
              const SizedBox(width: 4),
              Text(
                time,
                style: const TextStyle(color: Colors.white),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [
                  const Icon(Icons.radio_button_checked, color: Colors.red),
                  Container(width: 2, height: 20, color: Colors.grey),
                  const Icon(Icons.location_on, color: Colors.green),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Pickup",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      pickup,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Destination",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      dropoff,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                price,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
