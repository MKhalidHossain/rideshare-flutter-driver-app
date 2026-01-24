import 'package:flutter/material.dart';
import 'package:ridetohealthdriver/core/widgets/loading_shimmer.dart';
import 'package:get/get.dart';
import '../../../../../core/widgets/app_scaffold.dart';
import '../controller/vehicle_profile_controller.dart';

class VehicleDetailsScreen extends StatelessWidget {
  const VehicleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VehicleController());
    debugPrint(
      '============================///////****controller.vehicleData.value: ${controller.vehicleData.value}',
    );

    return AppScaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: const Text(
          'Vehicle Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: LoadingShimmer());
        }

        final vehicleData = controller.vehicleData.value;

        if (vehicleData == null) {
          return const Center(
            child: Text(
              'No vehicle data found',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final vehicle = vehicleData.vehicle;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Vehicle Information Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Vehicle Information',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Vehicle Image
                GestureDetector(
                  onTap: controller.pickVehicleImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red, width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: controller.vehicleImage.value != null
                          ? Image.file(
                              controller.vehicleImage.value!,
                              fit: BoxFit.cover,
                            )
                          : Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Image.network(
                                vehicleData.service.serviceImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return const Center(
                                    child: Icon(
                                      Icons.directions_car,
                                      size: 60,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Vehicle Details Grid
                Row(
                  children: [
                    Expanded(
                      child: _buildVehicleInfoItem('Make', vehicle.taxiName),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildVehicleInfoItem('Model', vehicle.model),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildVehicleInfoItem(
                        'Year',
                        vehicle.year.toString(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildVehicleInfoItem('Color', vehicle.color),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildVehicleInfoItem(
                        'License Plate',
                        vehicle.plateNumber,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(child: _buildVehicleInfoItem('VIN', vehicle.vin)),
                  ],
                ),

                //const Divider(color: Colors.grey, thickness: 1),
                SizedBox(height: 16),
                Text(
                  "Service Information",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildVehicleInfoItem(
                        'Service Name',
                        vehicleData.service.name,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildVehicleInfoItem(
                        'Base Fee',
                        vehicleData.service.baseFare.toString(),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildVehicleInfoItem(
                          'Per Mile Rate',
                          vehicleData.service.perKmRate.toString(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildVehicleInfoItem(
                          'Per Miniute Rate',
                          vehicleData.service.perMinuteRate.toString(),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildVehicleInfoItem(
                          'Canclelation Fee',
                          vehicleData.service.cancellationFee.toString(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildVehicleInfoItem(
                          'Capacity',
                          vehicleData.service.capacity.toString(),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildVehicleInfoItem(
                          'Minimum Fare',
                          vehicleData.service.minimumFare.toString(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildVehicleInfoItem(
                          'Per Miniute Rate',
                          vehicleData.service.perMinuteRate.toString(),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "Status",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  vehicleData.service.isActive ?? false ? 'Active' : 'Inactive',
                  style: TextStyle(
                    color: vehicleData.service.isActive ?? false
                        ? Colors.green
                        : Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),
                Text(
                  "Discription",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "${vehicleData.service.description}",
                  style: TextStyle(color: Colors.white),
                ),

                //* / License Information Section
                /*  _buildSectionTitle('License Information'),
                const SizedBox(height: 16),
                _buildInfoItem('License Number', vehicleData.licenseNumber),
                const SizedBox(height: 32),
                _buildInfoItem('Service ID', vehicleData.licenseNumber), */

                // Vehicle Documents Section
                // _buildSectionTitle('Vehicle Documents'),
                // const SizedBox(height: 16),
                /*          _buildDocumentItem(
                  'Vehicle Registration',
                  'Expires: 2027-11-15',
                  () {
                    Get.snackbar(
                      'Document',
                      'Opening Vehicle Registration...',
                      backgroundColor: Colors.blue,
                      colorText: Colors.white,
                    );
                  },
                ), */
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildVehicleInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentItem(String title, String subtitle, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child: const Text(
              'View',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
