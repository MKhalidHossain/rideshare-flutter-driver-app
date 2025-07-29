import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/controller.dart';

class EarningsScreen extends StatelessWidget {
  final EarningsController controller = Get.put(EarningsController());

  EarningsScreen({super.key});

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
              padding: EdgeInsets.symmetric(horizontal: 16),
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
          Row(
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
                  Obx(
                    () => Text(
                      '\$${controller.todayEarnings.value.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      'Rides Completed\n${controller.ridesCompleted.value}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () => controller.withdrawEarnings(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF79262C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    //vertical: 6,
                  ),
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
          ),
        ],
      ),
    );
  }

  Widget _buildRideHistorySection() {
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
            decoration: BoxDecoration(color: const Color(0xFF454A57)),
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
          // Table Rows
          Expanded(
            child: ListView.builder(
              itemCount: controller.rideHistory.length,
              itemBuilder: (context, index) {
                final ride = controller.rideHistory[index];
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 0.2),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceAround, // <-- Added here
                    children: [
                      Flexible(
                        flex: 1,
                        child: Text(
                          ride['day'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          ride['date'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          ride['rides'].toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: Text(
                          '\$${ride['earnings'].toStringAsFixed(2)}',
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
            ),
          ),
        ],
      ),
    );
  }
}
