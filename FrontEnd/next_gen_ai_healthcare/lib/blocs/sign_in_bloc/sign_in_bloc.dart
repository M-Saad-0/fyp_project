import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthenticationImp auth;
  AuthBloc authBloc;
  SignInBloc({required this.auth, required this.authBloc}) : super(SignInInitial()) {
    on<SignInRequired>((event, emit) async {
      emit(SignInLoading());
      try {
        Result result =
            await auth.login(email: event.email, password: event.password);
        if (result.isSuccess) {
          emit(SignInSuccess(user: result.value));
          authBloc.add(Authenticate());
        } else {
          debugPrint(result.error);
          emit(SignInError(error: result.error));
        }
      } catch (e) {
          debugPrint("An Unexpected error has occurred");
        emit(const SignInError(error: "An Unexpected error has occurred"));
      }
    });
  }
}
