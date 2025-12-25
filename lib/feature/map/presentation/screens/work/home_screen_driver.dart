import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridetohealthdriver/feature/auth/controllers/auth_controller.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/core/widgets/normal_custom_button.dart';
import 'package:ridetohealthdriver/feature/home/controllers/home_controller.dart';
import 'package:ridetohealthdriver/feature/home/domain/request_model/update_driver_location_request_model.dart';
import 'package:ridetohealthdriver/helpers/remote/data/socket_client.dart';
import '../../../../home/domain/request_model/incoming_ride_request.dart';
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
  bool _isUpdatingLocation = false;
  Timer? _locationUpdateTimer;
  String? _activeRideId;

  final LocationController locationController = Get.find<LocationController>();
  final BookingController bookingController = Get.find<BookingController>();
  final AppController appController = Get.find<AppController>();
  final HomeController homeController = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();

    authController = Get.find<AuthController>();
    _listenForRideRequests();
    _initializeLocation();
    if (homeController.isDriverOnline) {
      _startLocationUpdates();
    }
  }

  Future<void> _initializeLocation() async {
    debugPrint('📍 HomeScreenDriver: initialize location');
    await locationController.refreshCurrentPosition(
      updateAddress: true,
      moveCamera: true,
    );

    if (locationController.currentLocation.value == null) {
      debugPrint('📍 HomeScreenDriver: using fallback location');
      final fallbackLocation = HomeScreenDriver._initialPosition.target;
      locationController.setPickupLocation(fallbackLocation);
      if (locationController.mapController.value != null) {
        locationController.mapController.value!.animateCamera(
          CameraUpdate.newLatLngZoom(fallbackLocation, 14.0),
        );
      }
      return;
    }

    debugPrint('📍 HomeScreenDriver: sending initial location update');
    await _sendLocationUpdate();
  }

  Future<void> _sendLocationUpdate() async {
    if (_isUpdatingLocation) return;
    if (authController.logInResponseModel?.data?.user?.id == null) {
      debugPrint('📍 driverId not ready, continuing with token auth');
    }

    _isUpdatingLocation = true;
    try {
      final position = await locationController.refreshCurrentPosition(
        updateAddress: false,
        moveCamera: false,
      );
      if (position == null) {
        debugPrint('📍 Location update skipped: no position');
        return;
      }

      final request = UpdateDriverLocationRequestModel(
        latitude: position.latitude,
        longitude: position.longitude,
        heading: position.heading,
        speed: position.speed,
        rideId: _activeRideId,
      );

      debugPrint(
        '📍 Update location payload: ${request.toJson()}',
      );
      await homeController.updateDriverLocation(request);
      debugPrint('📍 Location update sent to backend');
    } finally {
      _isUpdatingLocation = false;
    }
  }

  void _startLocationUpdates() {
    if (_locationUpdateTimer != null) return;
    debugPrint('📍 Start periodic location updates');
    _locationUpdateTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) async {
        if (!homeController.isDriverOnline) {
          debugPrint('📍 Stop periodic updates: driver offline');
          _stopLocationUpdates();
          return;
        }
        await _sendLocationUpdate();
      },
    );
  }

  void _stopLocationUpdates() {
    debugPrint('📍 Stop periodic location updates');
    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = null;
  }

  Future<void> _handleOnlineToggle(bool value) async {
    debugPrint('📍 Toggle online status: $value');
    await homeController.toggleOnlineStatus(value);
    if (!mounted) return;

    if (homeController.isDriverOnline) {
      _startLocationUpdates();
    } else {
      _stopLocationUpdates();
    }
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
    _stopLocationUpdates();
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
                                  : (value) => _handleOnlineToggle(value),
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
          _activeRideId = acceptedData?.rideId;
        });
        appController.showSuccessSnackbar(message);
        Get.to(
          () => PickUpOfferDriverScreen(
            incomingRideRequest: rideToSend,
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
