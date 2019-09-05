import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';

class LoginState {
  final bool isSuccess;
  final bool isFailure;
  final bool isSubmitting;

  LoginState(
      {@required this.isSuccess,
      @required this.isFailure,
      @required this.isSubmitting});

  factory LoginState.empty() {
    return LoginState(
      isSuccess: false,
      isFailure: false,
      isSubmitting: false,
    );
  }

  factory LoginState.loading() {
    return LoginState(
      isSuccess: false,
      isFailure: false,
      isSubmitting: true,
    );
  }

  factory LoginState.success() {
    return LoginState(
      isSuccess: true,
      isFailure: false,
      isSubmitting: false,
    );
  }

  factory LoginState.failure() {
    return LoginState(
      isSuccess: false,
      isFailure: true,
      isSubmitting: false,
    );
  }

  LoginState copyWith({bool isSuccess, bool isFailure, bool isSubmitting}) {
    return LoginState(
        isSubmitting: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        isSuccess: isSubmitting ?? this.isSubmitting);
  }

  @override
  String toString() {
    return '''LoginState {    
      isSuccess: $isSuccess,
      isFailure: $isFailure,
      isSubmitting: $isSubmitting,
    }''';
  }
}

abstract class LoginEvent extends Equatable {
  LoginEvent([List props = const []]) : super(props);
}

class LoginWithEmailAndPassword extends LoginEvent {
  final String email;
  final String password;

  LoginWithEmailAndPassword({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() =>
      ' LoginWithEmailAndPassword: { email: $email, password: $password }';
}

class SignUpWithEmailAndPassword extends LoginEvent {
  final String email;
  final String password;

  SignUpWithEmailAndPassword({@required this.email, @required this.password})
      : super([email, password]);

  @override
  String toString() =>
      ' SignUpWithEmailAndPassword: { email: $email, password: $password }';
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc() : _authRepository = AuthRepository();

  @override
  LoginState get initialState => LoginState.empty();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginWithEmailAndPassword) {
      yield* _mapLoginWithEmailAndPasswordToState(
          email: event.email, password: event.password);
    }
    if (event is SignUpWithEmailAndPassword) {
      yield* _mapSignUpWithEmailAndPasswordToState(
          email: event.email, password: event.password);
    }
  }

  Stream<LoginState> _mapLoginWithEmailAndPasswordToState(
      {@required String email, @required String password}) async* {
    yield LoginState.loading();

    try {
      await _authRepository.signInWithEmailAndPassword(
          email: email, password: password);
      yield LoginState.success();
    } catch (e) {
      yield LoginState.failure();
    }
  }

  Stream<LoginState> _mapSignUpWithEmailAndPasswordToState(
      {@required String email, @required String password}) async* {
    yield LoginState.loading();

    try {
      await _authRepository.createUserWithEmailAndPassword(
          email: email, password: password);
      yield LoginState.success();
    } catch (e) {
      yield LoginState.failure();
    }
  }
}
