import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:next_gen_ai_healthcare/blocs/auth_bloc/auth_bloc.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  AuthenticationImp auth;
  AuthBloc authBloc;
  SignUpBloc({required this.auth, required this.authBloc}) : super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async{
      emit(SignUpLoading());
      try {
        Result result =
            await auth.createAnAccount(user: event.user, password:event.password);
        if (result.isSuccess) {
          debugPrint("Adding AuthEvent");
          emit(SignUpSuccess(user: result.value));
          authBloc.add(Authenticate());
        } else {
          debugPrint(result.error);
          emit(SignUpError(error: result.error));
        }
      } catch (e) {
          debugPrint("An Unexpected error has occurred");
        emit(const SignUpError(error: "An Unexpected error has occurred"));
      }
    });
  }
}
