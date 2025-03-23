import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:backend_services_repository/backend_service_repositoy.dart';
import 'package:flutter/foundation.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthenticationImp authentication;
  AuthBloc({required this.authentication}) : super(AuthInitial()) {
    on<Authenticate>((event, emit) async {
      emit(AuthLoading());
      try {
        User? user = authentication.checkUserAccountOnStartUp();
        if (user != null) {
          emit(AuthLoadingSuccess(user: user));
        } else {
          debugPrint("here");
          emit(AuthError());
        }
      } catch (e) {
        print(e.toString());
        emit(AuthError());
      }
    });

    on<AuthLogout>((event, emit) async {
      emit(AuthLogOutLoading());
      if (await GoogleSignInAuth.isUserLoggedInWithGoogle()) {
        await GoogleSignInAuth.logOut();
      }
      print("***************************************************");
      authentication.logout();
      emit(AuthLogoutState());
      // add(Authenticate());
    });

    on<GoogleAuthRequired>((event, emit) async {
      try {
        if (await GoogleSignInAuth.isUserLoggedInWithGoogle()) {
          await GoogleSignInAuth.logOut();
        } else {
          final account = await GoogleSignInAuth.login();
          print("$account");
          final user = User(
              userId: account!.id,
              userName: account.displayName ?? "",
              email: account.email,
              picture: account.photoUrl ?? "");
          final googleAuntentication = await account.authentication;
          print("${googleAuntentication.idToken}");
          await authentication.loginWithGoogle(
              user: user, idToken: googleAuntentication.idToken);
          emit(AuthLoadingSuccess(user: user));
        }
      } catch (e) {
        print(
            "**********************************************************${e.toString()}");
        print("Stack trace: ${StackTrace.current}");
        emit(GoogleAuthFailed());
      }
    });
  }
}
