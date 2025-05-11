import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'calculate_location_event.dart';
part 'calculate_location_state.dart';

class CalculateLocationBloc
    extends Bloc<CalculateLocationEvent, CalculateLocationState> {
  CalculateLocationBloc() : super(CalculateLocationInitial()) {
    on<CalculateLocationDistanceEvent>((event, emit) {
      print(event.userLocation);
      final double itemLong = event.itemLocation['coordinates'][0];
      final double itemLat =  event.itemLocation['coordinates'][1];
      final double userLong = event.userLocation['coordinates'][0];
      final double userLat =  event.userLocation['coordinates'][1];

      emit(CalculateLocationLoading());
      final distance = _calculateDistance(itemLat, itemLong, userLat, userLong);

      emit(CalculateLocationSuccess('${distance.toStringAsFixed(2)} km'));
    });
  }
  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
        debugPrint('Calculating distance between: '
          'Lat1: $lat1, Lon1: $lon1 and Lat2: $lat2, Lon2: $lon2');
    const earthRadius = 6371; // in kilometers

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180;
  }
}
