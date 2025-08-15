import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:mini_zomato/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository}) 
      : _authRepository = authRepository,
        super(AuthInitial()) {
    on<AppStarted>((event, emit) async {
      emit(AuthLoading());
      final User? user = _authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(email: user.email ?? ""));
      } else {
        emit(UnAuthenticated());
      }
    });

    on<LoginRequested>((event, emit) async {
      // TODO: implement event handler
      final String email = event.email;
      final String password = event.password;
      if (email.isNotEmpty && password.isNotEmpty) {
        if (password.length >= 8) {
          emit(AuthLoading());
          try {
            await _authRepository.signIn(email: email, password: password);
            emit(Authenticated(email: email));
            return;
          } on FirebaseAuthException catch (e) {
            print(e.message.toString());
            if (e.code == 'user-not-found') {
              emit(AuthRegister(email: email, passWord: password));
              return;
            } else if (e.code == 'wrong-password') {
              emit(AuthenticationError(error: "Wrong Password"));
              return;
            } else {
              emit(AuthenticationError(error: "Login Failed"));
              return;
            }
          }
        } else {
          emit(
            AuthenticationError(
              error: "Password must be atleast 8 characters long",
            ),
          );
          return;
        }
      } else {
        emit(AuthenticationError(error: "Email or password cannot be empty"));
        return;
      }
    });

    //Register
    on<RegisterRequested>((event, emit) async {
      final String email = event.email;
      final String name = event.name;
      final String password = event.password;

      if (email.isEmpty || password.isEmpty) {
        emit(AuthenticationError(error: "Email or Password cannot be empty"));
        return;
      }
      if (name.isEmpty) {
        emit(AuthenticationError(error: "Name cannot be empty"));
      }

      if (password.length < 8) {
        emit(
          AuthenticationError(
            error: "Password should be atleast 8 characters long",
          ),
        );
        return;
      }

      try {
        await _authRepository.register(
          name: name,
          email: email,
          password: password,
        );
        emit(Authenticated(email: email));
      } on FirebaseAuthException catch (e) {
        print(e.message.toString());
        emit(
          AuthenticationError(error: "Registration Failed. Please try again"),
        );
      }
    });

    on<AuthLogOutRequested>((event, emit) async {
      emit(AuthLoading());
      await _authRepository.signOut();
      emit(UnAuthenticated());
    });
  }
}
