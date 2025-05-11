import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapPage extends StatefulWidget {
  final Map<String, dynamic> itemLocation;
  final Map<String, dynamic> userLocation;
  final String itemId;

  const LocationMapPage({
    super.key,
    required this.itemLocation,
    required this.userLocation,
    required this.itemId,
  });

  @override
  State<LocationMapPage> createState() => _LocationMapPageState();
}

class _LocationMapPageState extends State<LocationMapPage> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          widget.userLocation['coordinates'][1],
          widget.userLocation['coordinates'][0],
        ),
        zoom: 14, // optional: set an appropriate zoom level
      ),
      markers: {
        Marker(
          markerId: MarkerId(widget.itemId),
          position: LatLng(
            widget.itemLocation['coordinates'][1],
            widget.itemLocation['coordinates'][0],
          ),
        ),
      },
    );
  }
}
