part of 'calculate_location_bloc.dart';

sealed class CalculateLocationState extends Equatable {
  const CalculateLocationState();
  
  @override
  List<Object> get props => [];
}

final class CalculateLocationInitial extends CalculateLocationState {}
final class CalculateLocationLoading extends CalculateLocationState {}

final class CalculateLocationSuccess extends CalculateLocationState {
  final String location;

  const CalculateLocationSuccess(this.location);

  @override
  List<Object> get props => [location];
}