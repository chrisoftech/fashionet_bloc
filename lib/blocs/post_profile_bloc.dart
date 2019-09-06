import 'package:fashionet_bloc/models/models.dart';
import 'package:rxdart/rxdart.dart';

class PostProfileBloc {
  final _isFollowingController = BehaviorSubject<bool>();
  Observable<bool> get isFollowing =>
      _isFollowingController.stream.defaultIfEmpty(false);

  final _followingProfilesController = BehaviorSubject<List<Profile>>();
  Function(List<Profile>) get followingProfiles =>
      _followingProfilesController.sink.add;

  PostProfileBloc(Profile profile) {
    _followingProfilesController.stream.map((profiles) {
      return profiles
          .any((Profile _profile) => _profile.userId == profile.userId);
    }).listen((bool isFollowing) {
      _isFollowingController.sink.add(isFollowing);
    });
  }

  void dispose() {
    _isFollowingController?.close();
    _followingProfilesController?.close();
  }
}
