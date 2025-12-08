import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/core/widgets/normal_custom_button.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import 'package:ridetohealthdriver/helpers/remote/data/socket_client.dart';
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
  final SocketClient socketClient = SocketClient();
  late final AuthController authController;
  IncomingRideRequest? _incomingRide;
  bool _isProcessingAction = false;

  final LocationController locationController = Get.find<LocationController>();
  final BookingController bookingController = Get.find<BookingController>();
  final AppController appController = Get.find<AppController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();

    authController = Get.find<AuthController>();
    _listenForRideRequests();
  }

  void _listenForRideRequests() {
    final driverId = authController.logInResponseModel?.data?.user?.id;
     print("socekt  from here ======= $driverId");
    
    // if (driverId != null && driverId.isNotEmpty) {



    //   // socketClient.emit('join', {
    //   //     'senderId': logInResponseModel!.data!.user!.id,  // ei key ta backend expect korche
    //   //       });
    //   socketClient.emit('ride_request', {
    //     'receiverId:$driverId'
    //     });
    //   print("socekt emit join from here =======");
    // }

    // socketClient.off('ride_request');
    socketClient.on('ride_request', (data) {
      print("socekt emit join from here =======");
      print('🚗 Incoming ride request: $data');
      try {
        final request = IncomingRideRequest.fromSocket(data);
        if (!mounted) return;
        setState(() {
          _incomingRide = request;
        });
      } catch (e) {
        print('⚠️ Failed to parse ride_request payload: $e');
      }
    });
    print("✅ Listening for ride_request events");
  }

  @override
  void dispose() {
    socketClient.off('ride_request');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final hasRideRequest = _incomingRide != null;
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
                  color: const Color(0xff303644), // Dark grey from the image
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
                                  : (value) =>
                                      controller.toggleOnlineStatus(value),
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
              child: GetBuilder<HomeController>(
                init: homeController,
                builder: (controller) {
                  if (!controller.isDriverOnline) {
                    return _buildIdleCard(
                      size,
                      isOnline: false,
                    );
                  }
                  return hasRideRequest
                      ? _buildRideRequestCard(size)
                      : _buildIdleCard(
                          size,
                          isOnline: true,
                        );
                },
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

  Future<void> _handleDeclineRide(IncomingRideRequest ride) async {
    if (_isProcessingAction) return;

    setState(() {
      _isProcessingAction = true;
    });
    appController.showLoading();

    try {
      await homeController.cancelRide(ride.rideId);

      final response = homeController.cancelRideResponseModel;
      final success = response.success ?? false;
      final message =
          (response.message ?? '').isNotEmpty ? response.message! : 'Ride declined';

      if (success) {
        setState(() {
          _incomingRide = null;
        });
        appController.showSuccessSnackbar(message);
      } else {
        appController.showErrorSnackbar(message);
      }
    } catch (e) {
      appController.showErrorSnackbar('Failed to decline ride');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingAction = false;
        });
      }
      appController.hideLoading();
    }
  }

  Future<void> _handleAcceptRide(IncomingRideRequest ride) async {
    if (_isProcessingAction) return;

    setState(() {
      _isProcessingAction = true;
    });
    appController.showLoading();

    try {
      await homeController.acceptRide(ride.rideId);
      final response = homeController.acceptRideResponseModel;
      final success = response.success ?? false;
      final message =
          (response.message ?? '').isNotEmpty ? response.message! : 'Ride accepted';

      if (success) {
        final acceptedData = response.data;
        final rideToSend = _incomingRide;
        setState(() {
          _incomingRide = null;
        });
        appController.showSuccessSnackbar(message);
        Get.to(
          () => PickUpOfferDriverScreen(
            rideRequest: rideToSend,
            acceptedRideData: acceptedData,
          ),
        );
      } else {
        appController.showErrorSnackbar(message);
      }
    } catch (e) {
      appController.showErrorSnackbar('Failed to accept ride');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingAction = false;
        });
      }
      appController.hideLoading();
    }
  }

  Widget _buildIdleCard(Size size, {required bool isOnline}) {
    return Container(
      width: size.width * 0.90,
      margin: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 36,
      ),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xff303644),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        border: Border(
          left: BorderSide(color: Color(0xff7B0100), width: 5),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isOnline ? 'No ride requests at the moment' : "You're currently offline",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isOnline
                ? 'New requests will appear here'
                : 'Go online to receive ride requests',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildRideRequestCard(Size size) {
    final ride = _incomingRide;
    if (ride == null) {
      return _buildIdleCard(
        size,
        isOnline: homeController.isDriverOnline,
      );
    }

    return Container(
      width: size.width * 0.90,
      margin: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 36,
      ),
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF2E2E38),
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
              const Text(
                'New Ride Request',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _incomingRide = null;
                  });
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Now',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                ride.fareText.isEmpty ? '--' : ride.fareText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 25,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "Pickup:".text14White500(),
                          Text(
                            ride.pickupAddress,
                            style: const TextStyle(
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
                const SizedBox(height: 5),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            "Destination:".text14White500(),
                            Text(
                              ride.dropoffAddress,
                              style: const TextStyle(
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
                      if (ride.distanceText != null)
                        Text(
                          ride.distanceText!,
                          style: const TextStyle(
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.access_time,
                    color: Colors.white,
                    size: 16,
                  ),
                  SizedBox(width: 6),
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
                ride.fareText.isEmpty ? '--' : ride.fareText,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (ride.distanceText != null)
                Text(
                  ride.distanceText!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SmallSemiTranparentButton(
                height: 41,
                weight: size.width * 0.35,
                fillColor: Colors.white,
                textColor: Colors.black,
                text: "Decline",
                onPressed: () {
                  if (_incomingRide != null) {
                    _handleDeclineRide(ride);
                  }
                },
              ),
              NormalCustomButton(
                weight: size.width * 0.35,
                fillColor: Colors.green,
                text: "Accept",
                onPressed: () {
                  if (_incomingRide != null) {
                    _handleAcceptRide(ride);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}



class IncomingRideRequest {
  final String rideId;
  final String pickupAddress;
  final String dropoffAddress;
  final double? totalFare;
  final double? distanceKm;
  final String? customerName;

  IncomingRideRequest({
    required this.rideId,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.totalFare,
    this.distanceKm,
    this.customerName,
  });

  String get fareText =>
      totalFare != null ? '\$${totalFare!.toStringAsFixed(2)}' : '';

  String? get distanceText =>
      distanceKm != null ? '${distanceKm!.toStringAsFixed(1)} km' : null;

  factory IncomingRideRequest.fromSocket(dynamic raw) {
    Map<String, dynamic> data;
    if (raw is String) {
      data = Map<String, dynamic>.from(jsonDecode(raw));
    } else if (raw is Map<String, dynamic>) {
      data = Map<String, dynamic>.from(raw);
    } else if (raw is Map) {
      data = raw.map((key, value) => MapEntry(key.toString(), value));
    } else {
      throw Exception('Unsupported ride_request payload type: ${raw.runtimeType}');
    }

    final pickup = data['pickup'] is Map
        ? Map<String, dynamic>.from(data['pickup'])
        : <String, dynamic>{};
    final dropoff = data['dropoff'] is Map
        ? Map<String, dynamic>.from(data['dropoff'])
        : <String, dynamic>{};

    final rawFare = data['totalFare'];
    final rawDistance = data['distance'];

    return IncomingRideRequest(
      rideId: data['rideId']?.toString() ?? '',
      pickupAddress:
          pickup['address']?.toString() ?? pickup['name']?.toString() ?? 'Pickup location',
      dropoffAddress:
          dropoff['address']?.toString() ?? dropoff['name']?.toString() ?? 'Destination',
      totalFare: rawFare != null ? double.tryParse(rawFare.toString()) : null,
      distanceKm:
          rawDistance != null ? double.tryParse(rawDistance.toString()) : null,
      customerName: data['customerName']?.toString(),
    );
  }
}
