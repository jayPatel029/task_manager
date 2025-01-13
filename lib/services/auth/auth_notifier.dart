/*
* firebase email login
*
*
* **/

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';
import 'auth_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    state = AuthLoading();
    try {
      final user = await authService.login(email, password);
      if (user != null) {
        state = AuthSuccess(user);
      } else {
        state = AuthFailure('Invalid credentials');
      }
    } catch (e) {
      state = AuthFailure(e.toString());
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
final authNotifierProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

