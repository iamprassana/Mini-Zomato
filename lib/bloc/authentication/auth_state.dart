part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

//Authentication in progress
final class AuthLoading extends AuthState {}

//Register new user
final class AuthRegister extends AuthState {
  final String email;
  final String passWord;

  AuthRegister({required this.email, required this.passWord});
}

//Authentication is success
final class Authenticated extends AuthState {
  final String email;
  Authenticated({required this.email});
}

//Authentication failed
final class UnAuthenticated extends AuthState {}

//Authentication error
final class AuthenticationError extends AuthState {
  final String error;

  AuthenticationError({required this.error});
}
