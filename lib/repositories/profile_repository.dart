import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:flutter/material.dart';

class ProfileRepository {
  final AuthRepository _authRepository;
  final ProfileService _profileService;

  ProfileRepository()
      : _authRepository = AuthRepository(),
        _profileService = ProfileService();

  Future<Stream<DocumentSnapshot>> hasProfile() async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _profileService.hasProfile(userId: _currentUserId);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> createProfile(
      {@required String firstname,
      @required String lastname,
      @required String businessName,
      @required String businessDescription,
      @required String dialCode,
      @required String phoneNumber,
      @required String otherPhoneNumber,
      @required String location,
      @required String imageUrl}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _profileService.createdProfile(
        userId: _currentUserId,
        firstname: firstname,
        lastname: lastname,
        businessName: businessName,
        businessDescription: businessDescription,
        dialCode: dialCode,
        phoneNumber: phoneNumber,
        otherPhoneNumber: otherPhoneNumber,
        location: location,
        imageUrl: imageUrl,
      );
    } catch (e) {
      throw (e);
    }
  }
}
