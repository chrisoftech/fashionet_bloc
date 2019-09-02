import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class FollowingBloc {
  final FollowingRepository _followingRepository;

  Set<Profile> _followingProfile = Set<Profile>();

  final _followingProfilesController = BehaviorSubject<List<Profile>>();
  Observable<List<Profile>> get followingProfiles =>
      _followingProfilesController.stream;

  FollowingBloc() : _followingRepository = FollowingRepository();

  void _postActionOnFollowing() {
    _followingProfilesController.sink.add(_followingProfile.toList());
  }

  Future<ReturnType> fetchFollowing() async {
    try {
      final List<Profile> _profiles =
          await _followingRepository.fetchFollowing();
      _followingProfile.addAll(_profiles);
      _postActionOnFollowing();

      return ReturnType(
          returnType: true, messagTag: 'Following successfully loaded');
    } catch (e) {
      return ReturnType(
          returnType: false,
          messagTag: 'Something went wrong when fetching following');
    }
  }

  Future<ReturnType> addToFollowing({@required Profile profile}) async {
    try {
      _followingProfile.add(profile);
      _postActionOnFollowing();

      await _followingRepository.addToFollowing(followingId: profile.userId);

      return ReturnType(
          returnType: true,
          messagTag: 'You are now following ${profile.businessName}');
    } catch (e) {
      _followingProfile
          .removeWhere((Profile _profile) => _profile.userId == profile.userId);
      _postActionOnFollowing();

      return ReturnType(
          returnType: false,
          messagTag:
              'An error occured while following ${profile.businessName}');
    }
  }

  Future<ReturnType> removeFromFollowing({@required Profile profile}) async {
    try {
      _followingProfile
          .removeWhere((Profile _profile) => _profile.userId == profile.userId);
      _postActionOnFollowing();

      await _followingRepository.removeFromFollowing(
          followingId: profile.userId);

      return ReturnType(
          returnType: true,
          messagTag: 'You unfollowed ${profile.businessName}');
    } catch (e) {
      _followingProfile.add(profile);
      _postActionOnFollowing();

      return ReturnType(
          returnType: false,
          messagTag:
              'An error occured while unfollowing ${profile.businessName}');
    }
  }

  void dispose() {
    _followingProfilesController?.close();
  }
}
