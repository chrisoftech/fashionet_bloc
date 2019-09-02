import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:meta/meta.dart';

class FollowingRepository {
  final FollowingService _followingService;
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  FollowingRepository()
      : _followingService = FollowingService(),
        _authRepository = AuthRepository(),
        _profileRepository = ProfileRepository();

  Future<List<Profile>> fetchFollowing() async {
    final String _currentUserId = (await _authRepository.authenticated())?.uid;

    final QuerySnapshot _snapshot =
        await _followingService.fetchFollowing(userId: _currentUserId);

    final List<Profile> _profiles = [];

    for (var document in _snapshot.documents) {
      final String _profileId = document.documentID;

      final Profile _profile =
          await _profileRepository.fetchProfile(userId: _profileId);

      _profiles.add(_profile);
    }

    return _profiles;
  }

  Future<void> addToFollowing({@required String followingId}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _followingService.addToFollowing(
          followingId: followingId, userId: _currentUserId);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> removeFromFollowing({@required String followingId}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _followingService.removeFromFollowing(
          followingId: followingId, userId: _currentUserId);
    } catch (e) {
      throw (e);
    }
  }
}
