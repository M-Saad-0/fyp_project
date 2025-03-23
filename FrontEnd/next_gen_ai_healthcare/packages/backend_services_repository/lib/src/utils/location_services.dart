import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

abstract class LocationServices {
  Future<Map<String, dynamic>> getLocation();
}

class LocationServicesImp extends LocationServices {
  @override
  Future<Map<String, dynamic>> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      debugPrint("Location Permission Denied - Requesting Again...");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("User denied again!");
        return {};
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint(
          "Permission permanently denied! Ask user to enable it manually.");
      return {};
    }

    Position currentPosition = await Geolocator.getCurrentPosition();
    return currentPosition.toJson();
  }
}
