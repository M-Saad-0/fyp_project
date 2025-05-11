part of 'symptoms_bloc.dart';

sealed class SymptomsEvent extends Equatable {
  const SymptomsEvent();

  @override
  List<Object> get props => [];
}

class SymptomsPredictEvent extends SymptomsEvent{
  final List<String> symptoms;
  const SymptomsPredictEvent({required this.symptoms});
  @override 
  List<Object> get props => [symptoms];
}

class SymptomsResetEvent extends SymptomsEvent{}