import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../services/auth_service.dart';

class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;

  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);
}

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc(this._authService) : super(AuthInitial()) {
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await _authService.login(event.email, event.password);
        if (user != null) {
          emit(AuthSuccess(user));
        } else {
          emit(AuthFailure('Invalid credentials'));
        }
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
