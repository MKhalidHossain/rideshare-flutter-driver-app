import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/core/widgets/normal_custom_button.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/accept_ride_response_model.dart';
import 'package:ridetohealthdriver/feature/map/presentation/screens/work/home_screen_driver.dart';
import '../../../../../core/widgets/normal_custom_icon_button.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/booking_controller.dart';
import '../../../controllers/locaion_controller.dart';
import 'confirm_location_map_screen.dart';
import '../location_confirmation_screen.dart';
import '../chat_screen.dart';
import '../call_screen.dart';
import '../payment_screen.dart';
import 'finding_your_driver_screen.dart';

class PickUpOfferDriverScreen extends StatefulWidget {
  const PickUpOfferDriverScreen({
    super.key,
    this.rideRequest,
    this.acceptedRideData,
  });

  final IncomingRideRequest? rideRequest;
  final AcceptRideData? acceptedRideData;
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(
      23.707306,
      90.415482,
    ), // Default to San Francisco if no location
    zoom: 14.0,
  );

  @override
  State<PickUpOfferDriverScreen> createState() =>
      _PickUpOfferDriverScreenState();
}

class _PickUpOfferDriverScreenState extends State<PickUpOfferDriverScreen> {
  late bool _showFirstWidget;

  //
  // late final Timer _timer;
  // bool hasContainers = true; // You control this flag
  //
  final LocationController locationController = Get.find<LocationController>();

  final BookingController bookingController = Get.find<BookingController>();

  final AppController appController = Get.find<AppController>();

  @override
  void initState() {
    super.initState();

    _showFirstWidget =
        widget.rideRequest == null && widget.acceptedRideData == null;

    // Delay for 3 seconds and then switch widgets
    if (_showFirstWidget) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showFirstWidget = false;
          });
        }
      });
    }
  }

  String get _pickupAddress {
    final pickupAddress = widget.acceptedRideData?.customerInfo.pickup.address;
    if (pickupAddress != null && pickupAddress.isNotEmpty) {
      return pickupAddress;
    }

    final ridePickup = widget.rideRequest?.pickupAddress;
    if (ridePickup != null && ridePickup.isNotEmpty) {
      return ridePickup;
    }

    final controllerPickup = locationController.pickupAddress.value;
    if (controllerPickup.isNotEmpty) {
      return controllerPickup;
    }
    return '123 Main St, San Francisco, CA';
  }

  String get _destinationAddress {
    final destination =
        widget.acceptedRideData?.customerInfo.dropoff.address ?? '';
    if (destination.isNotEmpty) {
      return destination;
    }

    final rideDestination = widget.rideRequest?.dropoffAddress;
    if (rideDestination != null && rideDestination.isNotEmpty) {
      return rideDestination;
    }

    final controllerDestination = locationController.destinationAddress.value;
    if (controllerDestination.isNotEmpty) {
      return controllerDestination;
    }
    return '456 Market St, San Francisco, CA';
  }

  String get _fareText {
    final fareFromRide = widget.rideRequest?.fareText;
    if (fareFromRide != null && fareFromRide.isNotEmpty) {
      return fareFromRide;
    }
    return '\$18.50';
  }

  String? get _distanceText {
    final distanceFromRide = widget.rideRequest?.distanceText;
    if (distanceFromRide != null && distanceFromRide.isNotEmpty) {
      return distanceFromRide;
    }

    final distance = locationController.distance.value;
    if (distance > 0) {
      return '${distance.toStringAsFixed(1)}km';
    }
    return null;
  }

  String get _riderName {
    final name = widget.acceptedRideData?.customerInfo.driverName;
    if (name != null && name.isNotEmpty) {
      return name;
    }
    final requestedName = widget.rideRequest?.customerName;
    if (requestedName != null && requestedName.isNotEmpty) {
      return requestedName;
    }
    return 'Rider';
  }

  String get _riderPhone {
    final phone = widget.acceptedRideData?.customerInfo.driverPhone;
    if (phone != null && phone.isNotEmpty) {
      return phone;
    }
    return '--';
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
              initialCameraPosition: PickUpOfferDriverScreen._initialPosition,
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
                          value: false,
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
                            "You're currently offline",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Go online to receive ride requests',
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
                      // margin: const EdgeInsets.only(
                      //   left: 24,
                      //   right: 24,
                      //   bottom: 36,
                      // ),
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFF2E2E38,
                        ), // Dark grey from the image
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        // border: Border(
                        //   left: BorderSide(color: Color(0xff7B0100), width: 5),
                        // ),
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
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey,
                                    child: ClipOval(
                                      child: Image.asset(
                                        "assets/images/user6.png",

                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _riderName.text16White500(),
                                      const SizedBox(height: 4),
                                      _riderPhone.text12Grey(),
                                    ],
                                  ),
                                ],
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
                                _fareText,
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

                                          Text(
                                            _pickupAddress,
                                            style: TextStyle(
                                              color: Color(0xffB5B5B5),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
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

                                            Text(
                                              _destinationAddress,
                                              style: TextStyle(
                                                color: Color(0xffB5B5B5),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (_distanceText != null)
                                        Text(
                                          _distanceText!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Divider(
                            height: 1,
                            indent: 5,
                            endIndent: 5,
                            thickness: 0.1,
                            color: Color(0xffD8D8D8),
                          ),

                          Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              //color: const Color(0xFF3B3B42),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "Total".text16White500(),
                                // Text(
                                //   'Total',
                                //   style: TextStyle(
                                //     color: AppColors.context(context).textColor,
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                _fareText.text16White500(),
                                // Text(
                                //   '\$32.50',
                                //   style: TextStyle(
                                //     color: Colors.white,
                                //     fontSize: 16,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),

                          // NormalCustomIconButton(
                          //   icon: Icons.call_outlined,
                          //   iconSize: 30,
                          //   onPressed: () {
                          //     Get.to(CallScreen());
                          //   },
                          // ),

                          // Bottom Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                flex: 1,
                                child: NormalCustomIconButton(
                                  icon: Icons.call_outlined,
                                  iconSize: 28,
                                  onPressed: () {
                                    Get.to(CallScreen());
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: NormalCustomIconButton(
                                  icon: Icons.messenger_outline,
                                  iconSize: 28,
                                  onPressed: () {
                                    Get.to(ChatScreen());
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: NormalCustomButton(
                                  height: 51,
                                  fontSize: 18,
                                  circularRadious: 30,
                                  text: "Cencel Ride",
                                  onPressed: () {
                                    // Get.to();
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
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
