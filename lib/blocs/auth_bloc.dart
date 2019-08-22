import 'dart:async';

import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

enum AuthState { AppStarted, Authenticated, Unauthenticated }
enum LoginState { Default, Loading, Success, Failure }

class AuthBloc {
  final AuthRepository _authRepository;
  final FirebaseAuth _firebaseAuth;

  // input controllers
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _passwordConfirmController = BehaviorSubject<String>();

  // authentication states controllers
  final _authStateController = BehaviorSubject<AuthState>();
  final _loginStateController = BehaviorSubject<LoginState>();

  AuthBloc()
      : _authRepository = AuthRepository(),
        _firebaseAuth = FirebaseAuth.instance {
    _authStateController.sink.add(AuthState.AppStarted);
    _firebaseAuth.onAuthStateChanged.listen(_onAuthStateChanged);
  }

  // validators
  Observable<String> get email =>
      _emailController.stream.transform(_validateEmail);
  Observable<String> get password =>
      _passwordController.stream.transform(_validatePassword);
  Observable<String> get confirmPassword => _passwordConfirmController.stream
          .transform(_validatePassword)
          .doOnData((String c) {
        // compares _password controller value & confirm password value
        if (0 != _passwordController.value.compareTo(c)) {
          _passwordConfirmController.sink.addError('Passwords do not match');
        }
      });

  // validate sign-in form
  Observable<bool> get validateSignIn =>
      Observable.combineLatest2(email, password, (e, p) => true);

  // validate sign-up form
  Observable<bool> get validateSignUp => Observable.combineLatest3(
      email, password, confirmPassword, (e, p, c) => true);

  // authentication state streams
  Observable<AuthState> get authState =>
      _authStateController.stream.defaultIfEmpty(AuthState.AppStarted);
  Observable<LoginState> get loginState =>
      _loginStateController.stream.defaultIfEmpty(LoginState.Default);

  // form inputs
  Function(String) get onEmailChanged => _emailController.sink.add;
  Function(String) get onPasswordChanged => _passwordController.sink.add;
  Function(String) get onPasswordConfirmChanged =>
      _passwordConfirmController.sink.add;

  final _validateEmail = StreamTransformer<String, String>.fromHandlers(
      handleData: (String email, EventSink<String> sink) {
    if (email.isEmpty) {
      sink.addError('Enter a valid email');
    } else {
      sink.add(email);
    }
  });

  final _validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (String password, EventSink<String> sink) {
    if (password.isEmpty || password.length < 6) {
      sink.addError('Password should be 6 or more characters');
    } else {
      sink.add(password);
    }
  });

  Future<void> _onAuthStateChanged(FirebaseUser firebaseUser) async {
    if (firebaseUser == null) {
      _authStateController.sink.add(AuthState.Unauthenticated);
    } else {
      _authStateController.sink.add(AuthState.Authenticated);
    }
  }

  Future<ReturnType> authenticated() async {
    try {
      _authStateController.sink.add(AuthState.AppStarted);
      _loginStateController.sink.add(LoginState.Loading);

      final FirebaseUser _user = await _authRepository.authenticated();

      if (_user != null) {
        _authStateController.sink.add(AuthState.Authenticated);
        _loginStateController.sink.add(LoginState.Success);

        return ReturnType(returnType: true, messagTag: 'Authenticated');
      }

      _authStateController.sink.add(AuthState.Unauthenticated);
      _loginStateController.sink.add(LoginState.Failure);

      return ReturnType(returnType: false, messagTag: 'Unauthenticated');
    } catch (e) {
      _authStateController.sink.add(AuthState.Unauthenticated);
      _loginStateController.sink.add(LoginState.Failure);

      print(e.toString);

      return ReturnType(
          returnType: false, messagTag: (e as PlatformException).message);
    }
  }

  Future<ReturnType> signInUser() async {
    try {
      _loginStateController.sink.add(LoginState.Loading);

      await _authRepository.signInWithEmailAndPassword(
          email: _emailController.value, password: _passwordController.value);

      // await Future.delayed(Duration(seconds: 5));

      _authStateController.sink.add(AuthState.Authenticated);
      _loginStateController.sink.add(LoginState.Success);

      return ReturnType(returnType: true, messagTag: 'User Authenticated');
    } catch (e) {
      _authStateController.sink.add(AuthState.Unauthenticated);
      _loginStateController.sink.add(LoginState.Failure);

      return ReturnType(
          returnType: false, messagTag: (e as PlatformException).message);
    }
  }

  Future<ReturnType> signUpUser() async {
    try {
      _loginStateController.sink.add(LoginState.Loading);

      await _authRepository.createUserWithEmailAndPassword(
          email: _emailController.value, password: _passwordController.value);

      _authStateController.sink.add(AuthState.Authenticated);
      _loginStateController.sink.add(LoginState.Success);

      return ReturnType(returnType: true, messagTag: 'User Authenticated');
    } catch (e) {
      _authStateController.sink.add(AuthState.Unauthenticated);
      _loginStateController.sink.add(LoginState.Failure);

      return ReturnType(
          returnType: false, messagTag: (e as PlatformException).message);
    }
  }

  Future<ReturnType> signOutUser() async {
    try {
      _loginStateController.sink.add(LoginState.Loading);

      await _authRepository.signOut();

      return ReturnType(returnType: true, messagTag: 'User Signed-Out');
    } catch (e) {
      return ReturnType(
          returnType: false, messagTag: (e as PlatformException).message);
    }
  }

  void dispose() {
    _emailController?.drain();
    _emailController?.close();
    _passwordController?.drain();
    _passwordController?.close();
    _passwordConfirmController?.drain();
    _passwordConfirmController?.close();

    _authStateController?.drain();
    _authStateController?.close();
    _loginStateController?.drain();
    _loginStateController?.close();
  }
}
