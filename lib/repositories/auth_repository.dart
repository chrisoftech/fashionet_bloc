import 'package:fashionet_bloc/services/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class AuthRepository {
  final AuthService _authService;

  AuthRepository() : _authService = AuthService();

  Future<FirebaseUser> authenticated() {
    try {
      return _authService.authenticated();
    } catch (e) {
      throw e;
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      AuthResult _authResult = await _authService
          .createUserWithEmailAndPassword(email: email, password: password);

      return _authResult.user;
    } catch (e) {
      throw e;
    }
  }

  Future<FirebaseUser> signInWithEmailAndPassword(
      {@required String email, @required String password}) async {
    try {
      AuthResult _authResult = await _authService.signInWithEmailAndPassword(
          email: email, password: password);

      return _authResult.user;
    } catch (e) {
      throw e;
    }
  }

  Future<void> signOut() {
    try {
      return _authService.signOut();
    } catch (e) {
      throw e;
    }
  }
}
