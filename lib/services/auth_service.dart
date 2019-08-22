import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService() : _firebaseAuth = FirebaseAuth.instance;

  Future<FirebaseUser> authenticated() {
    return _firebaseAuth.currentUser();
  }

  Future<AuthResult> createUserWithEmailAndPassword(
      {@required String email, @required String password}) {
    return _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<AuthResult> signInWithEmailAndPassword(
      {@required String email, @required String password}) {
    return _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }
}
