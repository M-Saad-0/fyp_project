import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'hero_bloc_event.dart';
part 'hero_bloc_state.dart';

class HeroBlocBloc extends Bloc<HeroBlocEvent, HeroBlocState> {
  final RetrieveDataImp retrieveData;

  HeroBlocBloc({required this.retrieveData}) : super(HeroInitial()) {
    
    on<MoreHeroItemsRequired>((event, emit) async {
      emit(HeroLoadingState());
      try {
        Result<List<Item>, String> result =
            await retrieveData.getSpecificNumberOfItems(
                itemCount: event.setNo, location: event.location);
        if (result.isFailure) {
          emit(HeroErrorState(error: result.error!));
        } else {
          emit(HeroSuccessState(items: result.value!));
        }
      } catch (e) {
        emit(HeroErrorState(error: e.toString()));
      }
    });
  }
}
