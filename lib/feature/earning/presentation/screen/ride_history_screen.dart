import 'package:flutter/material.dart';


class RideHistoryPage extends StatelessWidget {
  const RideHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3141),
      body: SafeArea(
        child: Padding(
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
                  SizedBox(width: 18),
                  filterButton("Completed"),
                  SizedBox(width: 18),
                  filterButton("Cancelled"),
                ],
              ),
              const SizedBox(height: 40),
              RideCard(
                date: "June 27, 2025",
                time: "2:30 PM",
                status: "Completed",
                statusColor: Colors.green,
                price: "\$18.50",
              ),
              const SizedBox(height: 12),
              RideCard(
                date: "June 27, 2025",
                time: "2:30 PM",
                status: "Cancelled",
                statusColor: Color(0xFFD32F2F),
                price: "\$18.50",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget filterButton(String title, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? Color(0xFF840B0E) : Colors.transparent,
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

  const RideCard({
    super.key,
    required this.date,
    required this.time,
    required this.status,
    required this.statusColor,
    required this.price,
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
          SizedBox(height: 20),
          //const Divider(color: Colors.grey, height: 20),
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
                  children: const [
                    Text(
                      "Pickup",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "123 Main St, San Francisco, CA",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Destination",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "456 Market St, San Francisco, CA",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
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
