part of 'calculate_location_bloc.dart';

sealed class CalculateLocationEvent extends Equatable {
  const CalculateLocationEvent();

  @override
  List<Object> get props => [];
}


class CalculateLocationDistanceEvent extends CalculateLocationEvent{
  final Map<String, dynamic> userLocation;
  final Map<String, dynamic> itemLocation;
  const CalculateLocationDistanceEvent({required this.itemLocation, required this.userLocation});
  @override 
  List<Object> get props => [];
}