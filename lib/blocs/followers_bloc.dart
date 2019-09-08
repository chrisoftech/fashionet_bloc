import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

enum FollowersState { Default, Loading, Failure, Success }

class FollowersBloc {
  final ProfileRepository _profileRepository;

  final _followersController = BehaviorSubject<List<Profile>>();
  Observable<List<Profile>> get followers => _followersController.stream;

  FollowersBloc() : _profileRepository = ProfileRepository() {
    fetchFollowers();
  }

  Future<ReturnType> fetchFollowers() async {
    try {
      final List<Profile> _followersProfiles =
          await _profileRepository.fetchUserFollowers();

      _followersController.sink.add(_followersProfiles);

      return ReturnType(
          returnType: true, messagTag: 'Followers successfully loaded');
    } catch (e) {
      return ReturnType(
          returnType: false,
          messagTag: 'Something went wrong when fetching followers');
    }
  }

  void dispose() {
    _followersController?.close();
  }
}
