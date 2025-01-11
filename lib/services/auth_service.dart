import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }
}

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<User?> login(String email, String password) {
    return _authRepository.loginWithEmail(email, password);
  }
}
