// lib/feature/map/controllers/locaion_controller.dart
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ridetohealthdriver/core/constants/app_constant.dart';
import 'package:ridetohealthdriver/helpers/custom_snackbar.dart';

class LocationController extends GetxController {
  // Location state
  var currentPosition = Rxn<Position>(); // Keep this for raw geolocator position
  var currentLocation = Rxn<LatLng>(); // Add this for LatLng format
  var pickupLocation = Rxn<LatLng>();
  var destinationLocation = Rxn<LatLng>();
  var pickupAddress = ''.obs;
  var destinationAddress = ''.obs;
  var distance = 0.0.obs; // Added for distance calculation

  // Map state
  var mapController = Rxn<GoogleMapController>();
  var markers = <Marker>{}.obs;
  var polylines = <Polyline>{}.obs; // Add this for polylines

  var isLocationPermissionGranted = false.obs;

  // Search state
  var searchResults = <String>[].obs;
  var isSearching = false.obs;
  var searchQuery = ''.obs;
  RxString selectedAddress = ''.obs;

  // Saved locations
  RxString homeAddress = 'Mohakhali DOHS, Dhaka'.obs;
  RxString workAddress = 'Gulshan 2, Dhaka'.obs;
  RxString favoriteAddress = 'Banani, Dhaka'.obs;
  final Dio _dio = Dio();

  @override
  void onInit() {
    super.onInit();
    requestLocationPermission();
    getCurrentLocation();
    // Listen for changes in pickup or destination to regenerate route + distance
    everAll([pickupLocation, destinationLocation], (_) {
      print('📍 Pickup or destination changed, updating route... : form initstate ');
      _updateRoute();
    });
  }

  Future<bool> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    isLocationPermissionGranted.value =
        permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
    return isLocationPermissionGranted.value;
  }

  Future<void> getCurrentLocation() async {
    try {
      await refreshCurrentPosition(updateAddress: true, moveCamera: true);
    } catch (e) {
      _safeSnackbar('Error', 'Failed to get current location: $e');
    }
  }

  Future<Position?> refreshCurrentPosition({
    bool updateAddress = false,
    bool moveCamera = false,
  }) async {
    try {
      print('📍 refreshCurrentPosition: start');
      if (!isLocationPermissionGranted.value) {
        final granted = await requestLocationPermission();
        print('📍 Location permission granted: $granted');
        if (!granted) {
          return null;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print(
        '📍 Current position: ${position.latitude}, ${position.longitude} (heading: ${position.heading}, speed: ${position.speed})',
      );
      currentPosition.value = position;
      currentLocation.value = LatLng(position.latitude, position.longitude);
      pickupLocation.value = LatLng(position.latitude, position.longitude);
      if (updateAddress) {
        await getAddressFromCoordinates(
          position.latitude,
          position.longitude,
          true,
        );
      }
      updateMapMarkers();
      if (moveCamera && mapController.value != null) {
        mapController.value!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLocation.value!, 14.0),
        );
      }
      return position;
    } catch (e) {
      _safeSnackbar('Error', 'Failed to get current location: $e');
      return null;
    }
  }

  Future<void> getAddressFromCoordinates(double lat, double lng, bool isPickup) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        // Combine address elements for a more complete address
        String address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country,
          place.postalCode
        ].where((element) => element != null && element.isNotEmpty).join(', ');

        if (isPickup) {
          pickupAddress.value = address;
        } else {
          destinationAddress.value = address;
        }
      }
    } catch (e) {
      _safeSnackbar('Error', 'Failed to get address: $e');
    }
  }

  void setPickupLocation(LatLng location) {
    pickupLocation.value = location;
    getAddressFromCoordinates(location.latitude, location.longitude, true);
    updateMapMarkers();
  }

  void setDestinationLocation(LatLng location) {
    destinationLocation.value = location;
    getAddressFromCoordinates(location.latitude, location.longitude, false);
    updateMapMarkers();
    // When destination is set, move camera to fit both locations
    if (mapController.value != null && pickupLocation.value != null && destinationLocation.value != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          pickupLocation.value!.latitude < destinationLocation.value!.latitude
              ? pickupLocation.value!.latitude
              : destinationLocation.value!.latitude,
          pickupLocation.value!.longitude < destinationLocation.value!.longitude
              ? pickupLocation.value!.longitude
              : destinationLocation.value!.longitude,
        ),
        northeast: LatLng(
          pickupLocation.value!.latitude > destinationLocation.value!.latitude
              ? pickupLocation.value!.latitude
              : destinationLocation.value!.latitude,
          pickupLocation.value!.longitude > destinationLocation.value!.longitude
              ? pickupLocation.value!.longitude
              : destinationLocation.value!.longitude,
        ),
      );
      mapController.value!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
    }
  }

  void setMapController(GoogleMapController controller) {
    mapController.value = controller;
    // If current location is already available when map is created, move camera
    if (currentLocation.value != null) {
      mapController.value!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation.value!, 14.0),
      );
    }
  }

  void updateMapMarkers() {
    markers.clear();

    if (pickupLocation.value != null) {
      markers.add(
        Marker(
          markerId: MarkerId('pickup'),
          position: pickupLocation.value!,
          infoWindow: InfoWindow(title: 'My Location'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    if (destinationLocation.value != null) {
      markers.add(
        Marker(
          markerId: MarkerId('destination'),
          position: destinationLocation.value!,
          infoWindow: InfoWindow(title: 'Destination'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }
  }

  /// Public helper if other screens call it directly.
  // Future<void> generatePolyline() async {
  //   await _updateRoute();
  // }

  /// Fetch route points for arbitrary origin/destination (driver screen).
  Future<List<LatLng>> getRoutePoints(
    LatLng origin,
    LatLng destination,
  ) async {
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&mode=driving&departure_time=now&traffic_model=best_guess&key=${AppConstant.apiKey}';

    try {
      final response = await _dio.get(url);
      if (response.statusCode != 200) {
        return <LatLng>[];
      }
      final Map<String, dynamic> data =
          response.data as Map<String, dynamic>;
      if (data['status'] != 'OK') {
        return <LatLng>[];
      }
      final List<dynamic> routes = data['routes'] as List<dynamic>;
      if (routes.isEmpty) {
        return <LatLng>[];
      }
      final String encodedPolyline =
          (routes.first['overview_polyline'] as Map<String, dynamic>)['points']
              as String;
      return _decodePolyline(encodedPolyline);
    } catch (e) {
      return <LatLng>[];
    }
  }

  // void _generateStraightLinePolyline() {
  //   polylines.clear();
  //   if (pickupLocation.value == null || destinationLocation.value == null) {
  //     return;
  //   }
  //   const String polylineIdVal = 'route_polyline';
  //   const PolylineId polylineId = PolylineId(polylineIdVal);

  //   final Polyline polyline = Polyline(
  //     polylineId: polylineId,
  //     color: const Color(0xFFC0392B),
  //     points: [
  //       pickupLocation.value!,
  //       destinationLocation.value!,
  //     ],
  //     width: 5,
  //     geodesic: true,
  //   );
  //   polylines.add(polyline);
  // }

  void _calculateStraightLineDistance() {
    if (pickupLocation.value == null || destinationLocation.value == null) {
      distance.value = 0.0;
      return;
    }
    final double calculatedDistance = Geolocator.distanceBetween(
      pickupLocation.value!.latitude,
      pickupLocation.value!.longitude,
      destinationLocation.value!.latitude,
      destinationLocation.value!.longitude,
    );
    distance.value = (calculatedDistance / 1000).toPrecision(1);
  }

  Future<void> _updateRoute() async {
    debugPrint('📍 _updateRoute: Generating route polyline and distance...');
    if (pickupLocation.value == null || destinationLocation.value == null) {
      distance.value = 0.0;
      polylines.clear();
      return;
    }

    final origin =
        '${pickupLocation.value!.latitude},${pickupLocation.value!.longitude}';
    final dest =
        '${destinationLocation.value!.latitude},${destinationLocation.value!.longitude}';

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$dest&mode=driving&departure_time=now&traffic_model=best_guess&key=${AppConstant.apiKey}';
    print("Is go to try catch block ?");
    try {
      final response = await _dio.get(url);

      debugPrint('Directional reaponse: ${response.data}');

      if (response.statusCode == 200 &&
          response.data['status'] == 'OK' &&
          (response.data['routes'] as List).isNotEmpty) {
        final route = response.data['routes'][0];
        final leg = route['legs'][0];
        final int distanceMeters = leg['distance']['value'];

        final String encodedPolyline =
            route['overview_polyline']['points'] as String;

        final List<LatLng> decodedPoints = _decodePolyline(encodedPolyline);


        polylines.clear();
        polylines.add(
          Polyline(
            polylineId: const PolylineId('route_polyline'),
            color: const Color(0xFF303644),
            width: 5,
            points: decodedPoints,
          ),
        );

        distance.value = (distanceMeters / 1000.0).toPrecision(1);
      } else {
        // _generateStraightLinePolyline();
        _calculateStraightLineDistance();
      }
    } catch (e) {
      debugPrint("debugPrint('Directional reSPNSE FAILURE');" +e.toString());
      // _generateStraightLinePolyline();
      _calculateStraightLineDistance();
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> polyline = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int result = 0;
      int shift = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final int deltaLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += deltaLat;

      result = 0;
      shift = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1f) << shift;
        shift += 5;
      } while (byte >= 0x20);
      final int deltaLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += deltaLng;

      polyline.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return polyline;
  }

  void searchLocation(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    isSearching.value = true;

    // Simulate search results - replace with actual API call (e.g., Google Places API)
    Future.delayed(const Duration(milliseconds: 500), () {
      searchResults.value = [
        '${query} Rd, Dhaka, Bangladesh',
        '${query} Market, Dhaka, Bangladesh',
        '${query} Tower, Dhaka, Bangladesh',
        '${query} Apartment, Dhaka, Bangladesh',
        '${query} Station, Dhaka, Bangladesh',
      ];
      isSearching.value = false;
    });
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }

  void selectSearchResult(String address) async {
    destinationAddress.value = address;
    searchResults.clear();
    searchQuery.value = ''; // Clear search query after selection

    // Try to get LatLng from address (geocoding) and set destinationLocation
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setDestinationLocation(LatLng(locations.first.latitude, locations.first.longitude));
      }
    } catch (e) {
      _safeSnackbar('Error', 'Failed to get coordinates for selected address: $e');
    }
  }

  void selectSavedLocation(String type) async {
    String addressToSet = '';
    switch (type) {
      case 'home':
        addressToSet = homeAddress.value;
        break;
      case 'work':
        addressToSet = workAddress.value;
        break;
      case 'favorite':
        addressToSet = favoriteAddress.value;
        break;
    }
    destinationAddress.value = addressToSet;

    // Try to get LatLng from address (geocoding) and set destinationLocation
    try {
      List<Location> locations = await locationFromAddress(addressToSet);
      if (locations.isNotEmpty) {
        setDestinationLocation(LatLng(locations.first.latitude, locations.first.longitude));
      }
    } catch (e) {
      _safeSnackbar('Error', 'Failed to get coordinates for saved address: $e');
    }
  }

  void _safeSnackbar(String title, String message) {
    showAppSnackBar(
      title,
      message,
      seconds: 3,
    );
  }
}





// work perfectlly for th car selection screen




// import 'dart:ui';

// import 'package:get/get.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';

// class LocationController extends GetxController {
//   // Location state
//   var currentPosition = Rxn<Position>(); // Keep this for raw geolocator position
//   var currentLocation = Rxn<LatLng>(); // Add this for LatLng format
//   var pickupLocation = Rxn<LatLng>();
//   var destinationLocation = Rxn<LatLng>();
//   var pickupAddress = ''.obs;
//   var destinationAddress = ''.obs;
//   var distance = 0.0.obs; // Added for distance calculation

//   // Map state
//   var mapController = Rxn<GoogleMapController>();
//   var markers = <Marker>{}.obs;
//   var polylines = <Polyline>{}.obs; // Add this for polylines

//   var isLocationPermissionGranted = false.obs;

//   // Search state
//   var searchResults = <String>[].obs;
//   var isSearching = false.obs;
//   var searchQuery = ''.obs;
//   RxString selectedAddress = ''.obs;

//   // Saved locations
//   RxString homeAddress = 'Mohakhali DOHS, Dhaka'.obs;
//   RxString workAddress = 'Gulshan 2, Dhaka'.obs;
//   RxString favoriteAddress = 'Banani, Dhaka'.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     requestLocationPermission();
//     getCurrentLocation();
//     // Listen for changes in pickup or destination to regenerate polyline
//     everAll([pickupLocation, destinationLocation], (_) => generatePolyline());
    
//   }

//   Future<void> requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }

//     isLocationPermissionGranted.value =
//         permission == LocationPermission.whileInUse ||
//         permission == LocationPermission.always;
//   }

//   Future<void> getCurrentLocation() async {
//     try {
//       if (isLocationPermissionGranted.value) {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         currentPosition.value = position;
//         currentLocation.value = LatLng(position.latitude, position.longitude); // Set currentLocation
//         pickupLocation.value = LatLng(position.latitude, position.longitude);
//         await getAddressFromCoordinates(position.latitude, position.longitude, true);
//         updateMapMarkers();
//         // Move camera to current location if map controller is ready
//         if (mapController.value != null && currentLocation.value != null) {
//           mapController.value!.animateCamera(
//             CameraUpdate.newLatLngZoom(currentLocation.value!, 14.0),
//           );
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get current location: $e');
//     }
//   }

//   Future<void> getAddressFromCoordinates(double lat, double lng, bool isPickup) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         // Combine address elements for a more complete address
//         String address = [
//           place.street,
//           place.subLocality,
//           place.locality,
//           place.administrativeArea,
//           place.country,
//           place.postalCode
//         ].where((element) => element != null && element.isNotEmpty).join(', ');

//         if (isPickup) {
//           pickupAddress.value = address;
//         } else {
//           destinationAddress.value = address;
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get address: $e');
//     }
//   }

//   void setPickupLocation(LatLng location) {
//     pickupLocation.value = location;
//     getAddressFromCoordinates(location.latitude, location.longitude, true);
//     updateMapMarkers();
//   }

//   void setDestinationLocation(LatLng location) {
//     destinationLocation.value = location;
//     getAddressFromCoordinates(location.latitude, location.longitude, false);
//     updateMapMarkers();
//     // When destination is set, move camera to fit both locations
//     if (mapController.value != null && pickupLocation.value != null && destinationLocation.value != null) {
//       LatLngBounds bounds = LatLngBounds(
//         southwest: LatLng(
//           pickupLocation.value!.latitude < destinationLocation.value!.latitude
//               ? pickupLocation.value!.latitude
//               : destinationLocation.value!.latitude,
//           pickupLocation.value!.longitude < destinationLocation.value!.longitude
//               ? pickupLocation.value!.longitude
//               : destinationLocation.value!.longitude,
//         ),
//         northeast: LatLng(
//           pickupLocation.value!.latitude > destinationLocation.value!.latitude
//               ? pickupLocation.value!.latitude
//               : destinationLocation.value!.latitude,
//           pickupLocation.value!.longitude > destinationLocation.value!.longitude
//               ? pickupLocation.value!.longitude
//               : destinationLocation.value!.longitude,
//         ),
//       );
//       mapController.value!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
//     }
//   }

//   void setMapController(GoogleMapController controller) {
//     mapController.value = controller;
//     // If current location is already available when map is created, move camera
//     if (currentLocation.value != null) {
//       mapController.value!.animateCamera(
//         CameraUpdate.newLatLngZoom(currentLocation.value!, 14.0),
//       );
//     }
//   }

//   void updateMapMarkers() {
//     markers.clear();

//     if (pickupLocation.value != null) {
//       markers.add(
//         Marker(
//           markerId: MarkerId('pickup'),
//           position: pickupLocation.value!,
//           infoWindow: InfoWindow(title: 'My Location'), // Changed to "My Location"
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         ),
//       );
//     }

//     if (destinationLocation.value != null) {
//       markers.add(
//         Marker(
//           markerId: MarkerId('destination'),
//           position: destinationLocation.value!,
//           infoWindow: InfoWindow(title: 'Destination'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//     }
//   }

//   // New method to generate polyline
//   void generatePolyline() {
//     polylines.clear();
//     if (pickupLocation.value != null && destinationLocation.value != null) {
//       final String polylineIdVal = 'route_polyline';
//       final PolylineId polylineId = PolylineId(polylineIdVal);

//       final Polyline polyline = Polyline(
//         polylineId: polylineId,
//         color:  Color(0xFFC0392B), // Red color for the polyline
//         points: [
//           pickupLocation.value!,
//           destinationLocation.value!,
//         ],
//         width: 5,
//         geodesic: true, // Follows the curvature of the earth
//       );
//       polylines.add(polyline);
//     }
//   }

//   void searchLocation(String query) {
//     searchQuery.value = query;
//     if (query.isEmpty) {
//       searchResults.clear();
//       return;
//     }

//     isSearching.value = true;

//     // Simulate search results - replace with actual API call
//     Future.delayed(const Duration(milliseconds: 500), () {
//       searchResults.value = [
//         '$query - Main Street',
//         '$query - Downtown',
//         '$query - City Center',
//         '$query - Shopping Mall',
//         '$query - Airport',
//       ];
//       isSearching.value = false;
//     });
//   }

//   void clearSearch() {
//     searchQuery.value = '';
//     searchResults.clear();
//   }

//   void selectSearchResult(int index) async {
//     final String address = searchResults[index];
//     destinationAddress.value = address;
//     searchResults.clear();

//     // Try to get LatLng from address (geocoding) and set destinationLocation
//     try {
//       List<Location> locations = await locationFromAddress(address);
//       if (locations.isNotEmpty) {
//         setDestinationLocation(LatLng(locations.first.latitude, locations.first.longitude));
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get coordinates for selected address: $e');
//     }
//   }

//   void selectSavedLocation(String type) async {
//     String addressToSet = '';
//     switch (type) {
//       case 'home':
//         addressToSet = homeAddress.value;
//         break;
//       case 'work':
//         addressToSet = workAddress.value;
//         break;
//       case 'favorite':
//         addressToSet = favoriteAddress.value;
//         break;
//     }
//     destinationAddress.value = addressToSet;

//     // Try to get LatLng from address (geocoding) and set destinationLocation
//     try {
//       List<Location> locations = await locationFromAddress(addressToSet);
//       if (locations.isNotEmpty) {
//         setDestinationLocation(LatLng(locations.first.latitude, locations.first.longitude));
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get coordinates for saved address: $e');
//     }
//   }
// }





// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';

// class LocationController extends GetxController {
//   // Location state
//   var currentPosition = Rxn<Position>();
//   var pickupLocation = Rxn<LatLng>();
//   var destinationLocation = Rxn<LatLng>();
//   var pickupAddress = ''.obs;
//   var destinationAddress = ''.obs;
  
//   // Map state
//   var mapController = Rxn<GoogleMapController>();
//   var markers = <Marker>{}.obs;
//   var isLocationPermissionGranted = false.obs;
  
//   // Search state
//   var searchResults = <String>[].obs;
//   var isSearching = false.obs;
//   var searchQuery = ''.obs;
//     RxString selectedAddress = ''.obs;
  
//   // Saved locations
//   // var homeAddress = '1234 Elm Street, City, State 12345'.obs;
//   // var workAddress = '5678 Oak Avenue, City, State 67890'.obs;
//   // var favoriteAddress = '9012 Pine Road, City, State 34567'.obs;

//   // You probably already have these
//   RxString homeAddress = 'Mohakhali DOHS, Dhaka'.obs;
//   RxString workAddress = 'Gulshan 2, Dhaka'.obs;
//   RxString favoriteAddress = 'Banani, Dhaka'.obs;
  
//   @override
//   void onInit() {
//     super.onInit();
//     requestLocationPermission();
//     getCurrentLocation();
//   }
  
//   Future<void> requestLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
    
//     isLocationPermissionGranted.value = 
//         permission == LocationPermission.whileInUse || 
//         permission == LocationPermission.always;
//   }
  
//   Future<void> getCurrentLocation() async {
//     try {
//       if (isLocationPermissionGranted.value) {
//         Position position = await Geolocator.getCurrentPosition(
//           desiredAccuracy: LocationAccuracy.high,
//         );
//         currentPosition.value = position;
//         pickupLocation.value = LatLng(position.latitude, position.longitude);
//         await getAddressFromCoordinates(position.latitude, position.longitude, true);
//         updateMapMarkers();
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get current location: $e');
//     }
//   }
  
//   Future<void> getAddressFromCoordinates(double lat, double lng, bool isPickup) async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks[0];
//         String address = '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
        
//         if (isPickup) {
//           pickupAddress.value = address;
//         } else {
//           destinationAddress.value = address;
//         }
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to get address: $e');
//     }
//   }
  
//   void setPickupLocation(LatLng location) {
//     pickupLocation.value = location;
//     getAddressFromCoordinates(location.latitude, location.longitude, true);
//     updateMapMarkers();
//   }
  
//   void setDestinationLocation(LatLng location) {
//     destinationLocation.value = location;
//     getAddressFromCoordinates(location.latitude, location.longitude, false);
//     updateMapMarkers();
//   }
  
//   void setMapController(GoogleMapController controller) {
//     mapController.value = controller;
//   }
  
//   void updateMapMarkers() {
//     markers.clear();
    
//     if (pickupLocation.value != null) {
//       markers.add(
//         Marker(
//           markerId: MarkerId('pickup'),
//           position: pickupLocation.value!,
//           infoWindow: InfoWindow(title: 'Pickup Location'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//         ),
//       );
//     }
    
//     if (destinationLocation.value != null) {
//       markers.add(
//         Marker(
//           markerId: MarkerId('destination'),
//           position: destinationLocation.value!,
//           infoWindow: InfoWindow(title: 'Destination'),
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//     }
//   }
  
//   void searchLocation(String query) {
//     searchQuery.value = query;
//     if (query.isEmpty) {
//       searchResults.clear();
//       return;
//     }
    
//     isSearching.value = true;
    
//     // Simulate search results - replace with actual API call
//     Future.delayed(Duration(milliseconds: 500), () {
//       searchResults.value = [
//         '$query - Main Street',
//         '$query - Downtown',
//         '$query - City Center',
//         '$query - Shopping Mall',
//         '$query - Airport',
//       ];
//       isSearching.value = false;
//     });
//   }
  
//   void clearSearch() {
//     searchQuery.value = '';
//     searchResults.clear();
//   }
  
//   void selectSearchResult(int index) {
//     destinationAddress.value = searchResults[index];
//     searchResults.clear();
//   }
  
//   void selectSavedLocation(String type) {
//     switch (type) {
//       case 'home':
//         destinationAddress.value = homeAddress.value;
//         break;
//       case 'work':
//         destinationAddress.value = workAddress.value;
//         break;
//       case 'favorite':
//         destinationAddress.value = favoriteAddress.value;
//         break;
//     }
//   }
// }
