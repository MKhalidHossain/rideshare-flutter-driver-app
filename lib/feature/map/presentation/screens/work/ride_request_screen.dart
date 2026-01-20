import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controllers/app_controller.dart';
import '../../../controllers/booking_controller.dart';
import '../../../controllers/locaion_controller.dart';

class RideRequestScreen extends StatefulWidget {
  const RideRequestScreen({super.key});

  @override
  State<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends State<RideRequestScreen> {
 final LocationController locationController = Get.find<LocationController>();
  final BookingController bookingController = Get.find<BookingController>();
  final AppController appController = Get.find<AppController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(
      23.707306,
      90.415482,
    ), // Default to San Francisco if no location
    zoom: 14.0,
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                locationController.setMapController(controller);
                // Move camera to current location if available
                if (locationController.currentLocation.value != null) {
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(
                      locationController.currentLocation.value!,
                      14.0,
                    ),
                  );
                }
              },
              initialCameraPosition: _initialPosition,
              markers: locationController.markers,
              polylines: locationController.polylines, // Display polyline
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onTap: (LatLng position) {
                // Allow changing destination by tapping on the map
                // locationController.setDestinationLocation(position);
                // locationController
                //     .generatePolyline(); // Regenerate polyline on destination change
              },
            ),

            // Back button and other controls (as seen in the image - top left)
            Positioned(
              top: 50,
              left: 0,
              child: Container(
                width: size.width * 0.90,
                margin: const EdgeInsets.all(24),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E38), // Dark grey from the image
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border(
                    left: BorderSide(color: Color(0xff7B0100), width: 5),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Driver Status',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Switch(
                          activeColor: Color(0xff7B0100).withOpacity(0.08),
                          value: true,
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      'New requests will appear here',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(width: 15),
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            // Red target icon in the middle right
            // Positioned(
            //   top:
            //       MediaQuery.of(context).size.height *
            //       0.45, // Approximately center vertically
            //   right: 20,
            //   child: GestureDetector(
            //     onTap: () {
            //       // This is a static icon from the screenshot, no specific action implied.
            //       // You might want to assign a function to recenter the map on the destination.
            //     },
            //     child: Container(
            //       width: 50,
            //       height: 50,
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         shape: BoxShape.circle,
            //       ),
            //       child: Icon(
            //         Icons.my_location,
            //         color: Colors.white,
            //         size: 30,
            //       ), // Example icon, adjust as needed
            //     ),
            //   ),
            // ),

            // Bottom Sheet
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                width: size.width * 0.90,
                margin: const EdgeInsets.only(left: 24, right: 24, bottom: 36),
                padding: EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E38), // Dark grey from the image
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  border: Border(
                    left: BorderSide(color: Color(0xff7B0100), width: 5),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // SizedBox(height: 20),
                    Text(
                      'No ride requests at the moment',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'New requests will appear here',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    // Row(
                    //   children: [
                    //     SizedBox(width: 15),
                    //     Expanded(
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [],
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            // Loading overlay
            if (appController.isLoading.value)
              Container(
                color: Colors.black54,
                child: Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
