import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';

class ProfileRepository {
  final AuthRepository _authRepository;
  final ProfileService _profileService;

  ProfileRepository()
      : _authRepository = AuthRepository(),
        _profileService = ProfileService();

  Future<Stream<DocumentSnapshot>> hasProfile() async {
    try {
      final String _currentUserId = (await _authRepository.authenticated())?.uid;

      return  _profileService.hasProfile(userId: _currentUserId);
    } catch (e) {
      throw (e);
    }
  }
}
