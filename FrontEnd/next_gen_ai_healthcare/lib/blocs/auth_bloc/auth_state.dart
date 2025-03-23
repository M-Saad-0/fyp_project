part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}
final class AuthLoading extends AuthState {}
final class GoogleAuthFailed extends AuthState{}
final class AuthLoadingSuccess extends AuthState {
  final User user;
  const AuthLoadingSuccess({required this.user});
  @override  
  List<Object> get props =>[];
}
final class AuthError extends AuthState {}
final class AuthLogoutState extends AuthState {}
final class AuthLogOutLoading extends AuthState {}
