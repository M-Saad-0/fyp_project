import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:next_gen_ai_healthcare/widgets/ai_prognosis.dart';

part 'symptoms_event.dart';
part 'symptoms_state.dart';

class SymptomsBloc extends Bloc<SymptomsEvent, SymptomsState> {
  AiPrognosis aiPrognosis;
  SymptomsBloc({required this.aiPrognosis}) : super(SymptomsInitial()) {
    on<SymptomsPredictEvent>((event, emit) async {
      emit(SymptomsLoadingState());
      try {
        final value = await aiPrognosis.predictDisease(event.symptoms);
        if (value.isSuccess) {
          Map<String, dynamic> otherInfo =
              await aiPrognosis.getOtherInformationAboutDisease(
            value.value!.entries.first.key,
          );

          List<String>? medications, precautionDf, diets;

          if (otherInfo.containsKey("medications")) {
            medications = (otherInfo['medications'] as List).cast<String>();
          }

          if (otherInfo.containsKey("diets")) {
            diets = (otherInfo['diets'] as List).cast<String>();
          }

          if (otherInfo.containsKey("precautionDf")) {
            precautionDf = (otherInfo['precautionDf'] as List)
                .skip(1)
                .cast<String>()
                .toList();
          }

          emit(SymptomsSuccessState(
            result: value.value!,
            description: otherInfo['description']?[1],
            medications: medications?[1].replaceAll('[', "")
                .replaceAll(']', "")
                .replaceAll("'", ""),
            symptomSeverity: otherInfo['systemSeverity'],
            diets: diets?[1]
                .replaceAll('[', "")
                .replaceAll(']', "")
                .replaceAll("'", ""),
            precautionDf: precautionDf?.join(', '),
          ));
        } else {
          emit(SymptomsErrorState(error: value.error!));
        }
      } catch (e) {
        debugPrint(e.toString());
        emit(SymptomsErrorState(error: e.toString()));
      }
    });
    on<SymptomsResetEvent>(
      (event, emit) => emit(SymptomsInitial()),
    );
  }
}
