import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridetohealthdriver/core/extensions/text_extensions.dart';
import 'package:ridetohealthdriver/core/widgets/normal_custom_button.dart';
import 'package:ridetohealthdriver/feature/home/domain/response_model/accept_ride_response_model.dart';
import '../../../../../core/widgets/normal_custom_icon_button.dart';
import '../../../controllers/app_controller.dart';
import '../../../controllers/locaion_controller.dart';
import '../chat_screen.dart';
import '../call_screen.dart';
import 'home_screen_driver.dart';

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
  final LocationController locationController = Get.find<LocationController>();
  final AppController appController = Get.find<AppController>();

  StreamSubscription<Position>? _positionSubscription;
  LatLng? _driverLatLng;
  LatLng? _customerPickupLatLng;
  LatLng? _customerDestinationLatLng;
  bool _isAtPickup = false;
  bool _journeyStarted = false;
  bool _showStartJourneyPopup = false;
  bool _showJourneyCompletedPopup = false;
  double _activeDistanceKm = 0;
  bool _isSheetExpanded = true;
  bool _isInitializing = true;
  BitmapDescriptor? _driverMarkerIcon;

  @override
  void initState() {
    super.initState();
    _initJourney();
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
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

  LatLng? _extractPickupLatLng() {
    final coords = widget.acceptedRideData?.customerInfo.pickup.coordinates;
    if (coords != null && coords.length >= 2) {
      return LatLng(coords[1], coords[0]); // backend returns [lng, lat]
    }
    return locationController.pickupLocation.value;
  }

  LatLng? _extractDestinationLatLng() {
    final coords = widget.acceptedRideData?.customerInfo.dropoff.coordinates;
    if (coords != null && coords.length >= 2) {
      return LatLng(coords[1], coords[0]);
    }
    return locationController.destinationLocation.value;
  }

  Future<void> _initJourney() async {
    await locationController.requestLocationPermission();
    await locationController.getCurrentLocation();
    await _ensureDriverMarkerIcon();

    _driverLatLng = locationController.currentLocation.value;
    _customerPickupLatLng = _extractPickupLatLng();
    _customerDestinationLatLng = _extractDestinationLatLng();

    _refreshMarkers();
    _refreshPolyline();
    _animateToRoute();
    _listenToDriverLocation();
    _updateDistances();

    if (mounted) {
      setState(() {
        _isInitializing = false;
      });
    }
  }

  void _listenToDriverLocation() {
    _positionSubscription?.cancel();
    _positionSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((pos) {
      _driverLatLng = LatLng(pos.latitude, pos.longitude);
      locationController.currentLocation.value = _driverLatLng;
      _refreshMarkers();
      _refreshPolyline();
      _updateDistances();
    });
  }

  Future<void> _ensureDriverMarkerIcon() async {
    if (_driverMarkerIcon != null) return;
    final icon = await _createDriverMarkerIcon();
    if (!mounted) return;
    setState(() {
      _driverMarkerIcon = icon;
    });
  }

  Future<BitmapDescriptor> _createDriverMarkerIcon() async {
    const double size = 120;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final center = Offset(size / 2, size / 2);

    // Shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.35)
      ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 12);
    canvas.drawCircle(center.translate(0, 4), size * 0.46, shadowPaint);

    // Red circle with subtle gradient
    final gradient = ui.Gradient.radial(
      center.translate(-8, -8),
      size * 0.48,
      const [
        Color(0xFFB10000),
        Color(0xFF7F0000),
      ],
      const [0.25, 1.0],
    );
    final circlePaint = Paint()
      ..shader = gradient;
    canvas.drawCircle(center, size * 0.48, circlePaint);

    // Paper plane path
    final path = Path()
      ..moveTo(size * 0.30, size * 0.56)
      ..lineTo(size * 0.58, size * 0.72)
      ..lineTo(size * 0.80, size * 0.30)
      ..lineTo(size * 0.50, size * 0.46)
      ..lineTo(size * 0.44, size * 0.30)
      ..close();

    final planePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, planePaint);

    final image = await recorder.endRecording().toImage(
          size.toInt(),
          size.toInt(),
        );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  void _animateToRoute() {
    final controller = locationController.mapController.value;
    if (controller == null ||
        _driverLatLng == null ||
        _customerPickupLatLng == null) return;

    final target = _journeyStarted
        ? _customerDestinationLatLng ?? _customerPickupLatLng!
        : _customerPickupLatLng!;
    final bounds = LatLngBounds(
      southwest: LatLng(
        _driverLatLng!.latitude <= target.latitude
            ? _driverLatLng!.latitude
            : target.latitude,
        _driverLatLng!.longitude <= target.longitude
            ? _driverLatLng!.longitude
            : target.longitude,
      ),
      northeast: LatLng(
        _driverLatLng!.latitude > target.latitude
            ? _driverLatLng!.latitude
            : target.latitude,
        _driverLatLng!.longitude > target.longitude
            ? _driverLatLng!.longitude
            : target.longitude,
      ),
    );
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80));
  }

  void _refreshMarkers() {
    final markers = <Marker>{};
    if (_driverLatLng != null) {
      final driverIcon = _journeyStarted && _driverMarkerIcon != null
          ? _driverMarkerIcon!
          : BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            );
      final heading = _journeyStarted ? _headingToTarget() : null;
      markers.add(
        Marker(
          markerId: const MarkerId('driver'),
          position: _driverLatLng!,
          infoWindow: const InfoWindow(title: 'My Location'),
          icon: driverIcon,
          rotation: heading ?? 0,
          flat: true,
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    if (!_journeyStarted && _customerPickupLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _customerPickupLatLng!,
          infoWindow: InfoWindow(title: _isAtPickup ? 'Pick Here' : 'Pickup'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    if (_journeyStarted && _customerDestinationLatLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: _customerDestinationLatLng!,
          infoWindow: const InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
        ),
      );
    }

    locationController.markers.value = markers;
  }

  void _refreshPolyline() {
    if (_driverLatLng == null) return;
    final target =
        _journeyStarted ? _customerDestinationLatLng : _customerPickupLatLng;
    if (target == null) return;

    locationController.polylines.value = {
      Polyline(
        polylineId: PolylineId(_journeyStarted ? 'to_destination' : 'to_pickup'),
        color: const Color(0xFF0F1323),
        width: 6,
        geodesic: true,
        points: [
          _driverLatLng!,
          target,
        ],
      ),
    };
  }

  double _distanceInKm(LatLng a, LatLng b) {
    return Geolocator.distanceBetween(
          a.latitude,
          a.longitude,
          b.latitude,
          b.longitude,
        ) /
        1000;
  }

  String get _etaText {
    if (_activeDistanceKm <= 0) return '1 min';
    final minutes = (_activeDistanceKm / 0.6).ceil(); // ~36km/h
    return '${minutes.clamp(1, 90)} min';
  }

  String get _distanceLabel {
    if (_activeDistanceKm <= 0) return 'Nearby';
    return '${_activeDistanceKm.toStringAsFixed(1)} km';
  }

  double? _headingToTarget() {
    final target = _journeyStarted ? _customerDestinationLatLng : null;
    if (target == null || _driverLatLng == null) return null;
    final bearing = Geolocator.bearingBetween(
      _driverLatLng!.latitude,
      _driverLatLng!.longitude,
      target.latitude,
      target.longitude,
    );
    if (bearing.isNaN || bearing.isInfinite) return null;
    return bearing;
  }

  void _updateDistances() {
    if (_driverLatLng == null) return;

    if (!_journeyStarted && _customerPickupLatLng != null) {
      _activeDistanceKm = _distanceInKm(_driverLatLng!, _customerPickupLatLng!);
      final reached = _activeDistanceKm <= 0.05; // 50m threshold
      if (reached && !_showStartJourneyPopup) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (!mounted) return;
          setState(() {
            _isAtPickup = true;
            _showStartJourneyPopup = true;
          });
        });
      } else {
        if (mounted) {
          setState(() {
            _isAtPickup = reached;
          });
        }
      }
    } else if (_journeyStarted && _customerDestinationLatLng != null) {
      _activeDistanceKm =
          _distanceInKm(_driverLatLng!, _customerDestinationLatLng!);
      final reached = _activeDistanceKm <= 0.05;
      if (reached && !_showJourneyCompletedPopup) {
        setState(() {
          _showJourneyCompletedPopup = true;
        });
      }
    }
  }

  void _startJourneyToDestination() {
    if (_customerDestinationLatLng == null) return;
    setState(() {
      _journeyStarted = true;
      _showStartJourneyPopup = false;
      _isAtPickup = false;
      _isSheetExpanded = false;
    });
    _refreshMarkers();
    _refreshPolyline();
    _animateToRoute();
    _updateDistances();
  }

  void _completeJourney() {
    setState(() {
      _showJourneyCompletedPopup = false;
      _journeyStarted = false;
      _isSheetExpanded = true;
    });
    locationController.polylines.value = {};
  }

  String get _statusLabel =>
      _journeyStarted ? 'Journey in progress' : 'Almost at pickup';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hasRide =
        widget.rideRequest != null || widget.acceptedRideData != null;

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
            ),

            if (hasRide)
              Positioned(
                top: MediaQuery.of(context).padding.top + 12,
                left: 16,
                right: 16,
                child: _buildTopStatusBanner(),
              ),

            if (hasRide) _buildBottomRideCard(size),

            if (_showStartJourneyPopup)
              _buildBlurOverlay(
                child: _buildStartJourneyDialog(),
              ),

            if (_showJourneyCompletedPopup)
              _buildBlurOverlay(
                child: _buildJourneyCompletedDialog(),
              ),
            // Loading overlay
            if (appController.isLoading.value || _isInitializing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopStatusBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF202533),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              _statusLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF151826),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _journeyStarted
                  ? '${_distanceLabel} • $_etaText'
                  : 'Arriving in $_etaText',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRideCard(Size size) {
    final collapsed = !_isSheetExpanded;
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        width: size.width,
        padding: EdgeInsets.fromLTRB(
          20,
          collapsed ? 10 : 16,
          20,
          collapsed ? 18 : 32,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF2E2E38),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
        ),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (_journeyStarted) {
              setState(() {
                _isSheetExpanded = !_isSheetExpanded;
              });
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: collapsed ? 18 : 26,
                    backgroundColor: Colors.grey.shade400,
                    child: ClipOval(
                      child: Image.asset(
                        "assets/images/user6.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _riderName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: collapsed ? 14 : 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _riderPhone,
                          style: const TextStyle(
                            color: Color(0xffB5B5B5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color(0xFFFFD166),
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.9',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: collapsed ? 13 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (_journeyStarted)
                        Icon(
                          _isSheetExpanded
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_up,
                          color: Colors.white70,
                        ),
                    ],
                  ),
                ],
              ),
              if (!collapsed) ...[
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF303644),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.place, color: Colors.red, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Pickup".text14White500(),
                                const SizedBox(height: 4),
                                Text(
                                  _pickupAddress,
                                  style: const TextStyle(
                                    color: Color(0xffB5B5B5),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (!_journeyStarted && _distanceText != null)
                            Text(
                              _distanceText!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.flag, color: Colors.green, size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Destination".text14White500(),
                                const SizedBox(height: 4),
                                Text(
                                  _destinationAddress,
                                  style: const TextStyle(
                                    color: Color(0xffB5B5B5),
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    "Total".text16White500(),
                    _fareText.text16White500(),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: NormalCustomIconButton(
                        icon: Icons.call_outlined,
                        iconSize: 26,
                        onPressed: () {
                          Get.to(CallScreen());
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: NormalCustomIconButton(
                        icon: Icons.messenger_outline,
                        iconSize: 26,
                        onPressed: () {
                          Get.to(ChatScreen());
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: NormalCustomButton(
                        height: 51,
                        fontSize: 18,
                        circularRadious: 30,
                        text: "Cancel Ride",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlurOverlay({required Widget child}) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          color: Colors.black.withOpacity(0.35),
          child: Center(child: child),
        ),
      ),
    );
  }

  Widget _buildStartJourneyDialog() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E38),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: () {
                setState(() {
                  _showStartJourneyPopup = false;
                });
              },
              icon: const Icon(Icons.close, color: Colors.white70, size: 18),
            ),
          ),
          const Icon(
            Icons.near_me,
            color: Colors.red,
            size: 52,
          ),
          const SizedBox(height: 12),
          const Text(
            'Start Your Journey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have arrived at the pickup location. Start the journey when the rider is in your vehicle.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffB5B5B5),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          NormalCustomButton(
            text: "Start Now",
            height: 48,
            fontSize: 16,
            onPressed: _startJourneyToDestination,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCompletedDialog() {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2E2E38),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: () {
                _completeJourney();
              },
              icon: const Icon(Icons.close, color: Colors.white70, size: 18),
            ),
          ),
          const Icon(
            Icons.check_circle,
            color: Colors.red,
            size: 52,
          ),
          const SizedBox(height: 12),
          const Text(
            'Journey Completed',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have arrived at the destination. The journey is now complete.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xffB5B5B5),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 18),
          NormalCustomButton(
            text: "Complete",
            height: 48,
            fontSize: 16,
            onPressed: _completeJourney,
          ),
        ],
      ),
    );
  }
}
