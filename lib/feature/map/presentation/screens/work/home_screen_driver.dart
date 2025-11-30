import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/core/widgets/normal_custom_button.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/booking_controller.dart';
import '../../../controllers/locaion_controller.dart';
import 'confirm_location_map_screen.dart';
import '../location_confirmation_screen.dart';
import '../chat_screen.dart';
import '../call_screen.dart';
import '../payment_screen.dart';
import 'finding_your_driver_screen.dart';
import 'pickup_offer_driver_screen.dart';

class HomeScreenDriver extends StatefulWidget {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(
      23.707306,
      90.415482,
    ), // Default to San Francisco if no location
    zoom: 14.0,
  );

  @override
  State<HomeScreenDriver> createState() => _HomeScreenDriverState();
}

class _HomeScreenDriverState extends State<HomeScreenDriver> {
  bool _showFirstWidget = true;

  //
  // late final Timer _timer;
  // bool hasContainers = true; // You control this flag
  //
  final LocationController locationController = Get.find<LocationController>();

  final BookingController bookingController = Get.find<BookingController>();

  final AppController appController = Get.find<AppController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds and then switch widgets
    Future.delayed(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showFirstWidget = false;
        });
      }
    });
  }

  // @override
  // void initState() {
  //   super.initState();

  //   _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
  //     if (!mounted || !hasContainers) {
  //       _timer.cancel(); // Stop the loop
  //       return;
  //     }

  //     setState(() {
  //       _showFirstWidget = !_showFirstWidget;
  //     });
  //   });
  // }

  // @override
  // void dispose() {
  //   _timer.cancel();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //     // Simulate a condition to stop the loop
    // if (_someList.isEmpty) {
    //   hasContainers = false;
    // }
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
              initialCameraPosition: HomeScreenDriver._initialPosition,
              markers: locationController.markers,
              polylines: locationController.polylines, // Display polyline
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onTap: (LatLng position) {
                // Allow changing destination by tapping on the map
                locationController.setDestinationLocation(position);
                locationController
                    .generatePolyline(); // Regenerate polyline on destination change
              },
            ),

            // Back button and other controls (as seen in the image - top left)
            Positioned(
              top: 50,
              left: 0,
              child: Container(
                width: size.width * 0.90,
                margin: const EdgeInsets.all(24),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E2E38), // Dark grey from the image
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  // border: Border(
                  //   left: BorderSide(color: Color(0xff7B0100), width: 5),
                  // ),
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
                        GetBuilder<HomeController>(
                          init: homeController,
                          builder: (controller) {
                            return Switch(
                              activeColor: Color(0xff7B0100).withOpacity(0.08),
                              value: controller.isDriverOnline,
                              onChanged: controller.isTogglingStatus
                                  ? null
                                  : (_) => controller.toggleOnlineStatus(),
                            );
                          },
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
              child: _showFirstWidget
                  ? Container(
                      width: size.width * 0.90,
                      margin: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 36,
                      ),
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF2E2E38,
                        ), // Dark grey from the image
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
                    )
                  : Container(
                      width: size.width * 0.90,
                      margin: const EdgeInsets.only(
                        left: 24,
                        right: 24,
                        bottom: 36,
                      ),
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF2E2E38,
                        ), // Dark grey from the image
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        border: Border(
                          left: BorderSide(color: Color(0xff7B0100), width: 5),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // GestureDetector(
                              //   onTap: () =>
                              //       Get.back(), // Go back to previous screen
                              //   child: Icon(
                              //     Icons.arrow_back,
                              //     color: Colors.white,
                              //   ),
                              // ),
                              Text(
                                'New Ride Request',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Now',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$18.50',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 0),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              // color: const Color(
                              //   0xFF3B3B42,
                              // ), // Card background color
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                // From: Current Location
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        Container(
                                          width: 2,
                                          height:
                                              25, // Height for the connecting line
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          "Pickup:".text14White500(),

                                          Obx(
                                            () => Text(
                                              locationController
                                                      .pickupAddress
                                                      .value
                                                      .isEmpty
                                                  ? '123 Main St, San Francisco, CA'
                                                  : locationController
                                                        .pickupAddress
                                                        .value,
                                              style: TextStyle(
                                                color: Color(0xffB5B5B5),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 5,
                                ), // Space between From and To
                                // To: Destination Location (Changeable/Editable)
                                GestureDetector(
                                  onTap: () {
                                    //  Get.to(() => DestinationSearchScreen());
                                  },
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            "Destination:".text14White500(),

                                            Obx(
                                              () => Text(
                                                locationController
                                                        .destinationAddress
                                                        .value
                                                        .isEmpty
                                                    ? '456 Market St, San Francisco, CA' // Default text
                                                    : locationController
                                                          .destinationAddress
                                                          .value,
                                                style: TextStyle(
                                                  color: Color(0xffB5B5B5),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Obx(() {
                                        // Only show distance if destination is set and distance is calculated
                                        if (locationController
                                                    .destinationLocation
                                                    .value !=
                                                null &&
                                            locationController.distance.value >
                                                0) {
                                          return Text(
                                            '${locationController.distance.value.toStringAsFixed(1)}km',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                            ),
                                          );
                                        }
                                        return SizedBox.shrink(); // Hide if no destination or distance is zero
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  Text(
                                    'Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '\$18.50',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '3.2 miles',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          // Confirm Location Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SmallSemiTranparentButton(
                                height: 41,
                                weight: size.width * 0.35,
                                fillColor: Colors.white,
                                textColor: Colors.black,

                                text: "Decline",
                                onPressed: () {},
                              ),
                              NormalCustomButton(
                                weight: size.width * 0.35,
                                fillColor: Colors.green,
                                text: "Accept",
                                onPressed: () {
                                  Get.to(() => PickUpOfferDriverScreen());
                                },
                              ),
                            ],
                          ),
                          // Container(
                          //   width: double.infinity,
                          //   child: ElevatedButton(
                          //     onPressed: () {
                          //       // Action for "Confirm Location"
                          //       // For example, navigate to the next screen or trigger booking process
                          //       appController.setCurrentScreen(
                          //         'confirm',
                          //       ); // Your existing logic
                          //       // Get.to(() => LocationConfirmationScreen());
                          //       Get.to(() => FindingYourDriverScreen());
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: const Color(
                          //         0xFFC0392B,
                          //       ), // Red color
                          //       padding: EdgeInsets.symmetric(vertical: 15),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(10),
                          //       ),
                          //     ),
                          //     child: Text(
                          //       'Confirm Location',
                          //       style: TextStyle(
                          //         color: Colors.white,
                          //         fontSize: 16,
                          //         fontWeight: FontWeight.bold,
                          //       ),
                          //     ),
                          //   ),
                          // ),
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
