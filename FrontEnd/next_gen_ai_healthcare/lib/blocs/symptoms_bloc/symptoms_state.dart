part of 'symptoms_bloc.dart';

sealed class SymptomsState extends Equatable {
  const SymptomsState();
  
  @override
  List<Object> get props => [];
}

final class SymptomsInitial extends SymptomsState {}
final class SymptomsLoadingState extends SymptomsState {}
final class SymptomsErrorState extends SymptomsState {
  final String error;
  const SymptomsErrorState({required this.error}); 
  @override 
  List<Object> get props => [error];
}
final class SymptomsSuccessState extends SymptomsState {
  final Map<String, dynamic> result;
  final String? description;
  final String? diets;
  final String? medications;
  final String? precautionDf;
  final int? symptomSeverity;
  const SymptomsSuccessState({
    required this.result,
    this.description,
    this.diets,
    this.medications,
    this.precautionDf,
    this.symptomSeverity,
  });
  @override 
  List<Object> get props => [
        result,
        description ?? '',
        diets ?? '',
        medications ?? '',
        precautionDf ?? '',
        symptomSeverity ?? 0,
      ];
}

