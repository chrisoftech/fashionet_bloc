import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
abstract class AuthVerificationState extends Equatable {
  AuthVerificationState([List props = const []]) : super(props);
}

class Uninitialized extends AuthVerificationState {
  @override
  String toString() => 'Uninitialized';
}

class Authenticated extends AuthVerificationState {
  final FirebaseUser firebaseUser;

  Authenticated({@required this.firebaseUser}) : super([firebaseUser]);

  @override
  String toString() => 'Authenticated { userId: ${firebaseUser?.uid} }';
}

class Unauthenticated extends AuthVerificationState {
  @override
  String toString() => 'Unauthenticated';
}

abstract class AuthVerificationEvent extends Equatable {
  AuthVerificationEvent([List props = const []]) : super(props);
}

class AppStarted extends AuthVerificationEvent {
  @override
  String toString() => 'AppStarted';
}

class LoggedIn extends AuthVerificationEvent {
  @override
  String toString() => 'LoggedIn';
}

class LoggedOut extends AuthVerificationEvent {
  @override
  String toString() => 'LoggedOut';
}

class AuthVerificationBloc
    extends Bloc<AuthVerificationEvent, AuthVerificationState> {
  final AuthRepository _authRepository;

  AuthVerificationBloc() : _authRepository = AuthRepository();

  @override
  AuthVerificationState get initialState => Uninitialized();

  @override
  Stream<AuthVerificationState> mapEventToState(
      AuthVerificationEvent event) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthVerificationState> _mapAppStartedToState() async* {
    try {
      if (await _authRepository.authenticated() != null) {
        final FirebaseUser _user = await _authRepository.authenticated();
        yield Authenticated(firebaseUser: _user);
      } else {
        yield Unauthenticated();
      }
    } catch (e) {
      yield Unauthenticated();
    }
  }

  Stream<AuthVerificationState> _mapLoggedInToState() async* {
    final FirebaseUser _user = await _authRepository.authenticated();
    yield Authenticated(firebaseUser: _user);
  }

  Stream<AuthVerificationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _authRepository.signOut();
  }
}
