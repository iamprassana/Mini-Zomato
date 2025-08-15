part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AppStarted extends AuthEvent {}

final class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});
}

final class AuthLogOutRequested extends AuthEvent {}

final class RegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
  });
}

final class AuthCheckStatus extends AuthEvent {}
