import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';

abstract class ProfileVerificationState extends Equatable {
  ProfileVerificationState([List props = const []]) : super(props);
}

class UninitializedProfile extends ProfileVerificationState {
  @override
  String toString() => 'UninitializedProfile';
}

class HasProfile extends ProfileVerificationState {
  final Profile profile;

  HasProfile({@required this.profile}) : super([profile]);

  @override
  String toString() => 'HasProfile { profileId: ${profile.userId} }';
}

class NoProfile extends ProfileVerificationState {
  @override
  String toString() => 'NoProfile';
}

class Failure extends ProfileVerificationState {
  final String error;

  Failure({@required this.error}) : super([error]);

  @override
  String toString() => 'Failure { error: ${error.toString()} }';
}

abstract class ProfileVerificationEvent extends Equatable {}

class VerifyProfile extends ProfileVerificationEvent {
  @override
  String toString() => 'VerifyProfile';
}

class ProfileVerificationBloc
    extends Bloc<ProfileVerificationEvent, ProfileVerificationState> {
  final ProfileRepository _profileRepository;

  ProfileVerificationBloc() : _profileRepository = ProfileRepository();

  @override
  ProfileVerificationState get initialState => UninitializedProfile();

  @override
  Stream<ProfileVerificationState> mapEventToState(
      ProfileVerificationEvent event) async* {
    if (event is VerifyProfile) {
      yield* _mapVerifyProfileToState();
    }
  }

  Stream<ProfileVerificationState> _mapVerifyProfileToState() async* {
    try {
      final bool _hasProfile = await _profileRepository.hasProfile() != null;
      if (_hasProfile) {
        final Profile _profile = await _profileRepository.hasProfile();

        yield HasProfile(profile: _profile);
      } else {
        yield NoProfile();
      }
    } catch (e) {
      yield Failure(error: e.toString());
    }
  }
}
