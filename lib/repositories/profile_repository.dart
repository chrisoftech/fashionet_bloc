import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:flutter/material.dart';

class ProfileRepository {
  final AuthRepository _authRepository;
  final ProfileService _profileService;

  ProfileRepository()
      : _authRepository = AuthRepository(),
        _profileService = ProfileService();

  Profile _mapSnapshotToProfile({@required DocumentSnapshot document}) {
    return Profile(
      userId: document.documentID,
      firstName: document.data['firstname'],
      lastName: document.data['lastname'],
      businessName: document.data['businessName'],
      businessDescription: document.data['businessDescription'],
      dialCode: document.data['dialCode'],
      phoneNumber: document.data['phoneNumber'],
      otherPhoneNumber: document.data['otherPhoneNumber'],
      businessLocation: document.data['location'],
      imageUrl: document.data['imageUrl'],
      created: document.data['created'],
      lastUpdate: document.data['lastUpdate'],
    );
  }

  Future<bool> hasProfile() async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      final DocumentSnapshot _document =
          await _profileService.hasProfile(userId: _currentUserId);

      final bool _hasProfile = _document.exists;
      // _mapSnapshotToProfile(document: _document) != null;

      return _hasProfile;
    } catch (e) {
      throw (e);
    }
  }

  Future<Profile> fetchProfile(
      {String userId, bool isCurrentUser = false}) async {
    try {
      final String _userId = !isCurrentUser
          ? userId
          : (await _authRepository.authenticated())?.uid;

      DocumentSnapshot _document =
          await _profileService.fetchProfile(userId: _userId);

      return _mapSnapshotToProfile(document: _document);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<String>> fetchUserFollowing() async {
    try {
      final String _userId = (await _authRepository.authenticated())?.uid;

      QuerySnapshot _snapshot =
          await _profileService.fetchUserFollowing(userId: _userId);

      final List<String> _followingProfileIds = [];

      for (var document in _snapshot.documents) {
        final String _documentId = document.documentID;

        _followingProfileIds.add(_documentId);
      }

      return _followingProfileIds;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Profile>> fetchUserFollowers() async {
    try {
      final String _userId = (await _authRepository.authenticated())?.uid;

      QuerySnapshot _snapshot =
          await _profileService.fetchUserFollowers(userId: _userId);

      print('Followers count ${_snapshot.documents.length}');

      final List<Profile> _followersProfile = [];

      for (var document in _snapshot.documents) {
        final String _documentId = document.documentID;

        final Profile _profile = await fetchProfile(userId: _documentId);
        _followersProfile.add(_profile);
      }

      return _followersProfile;
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

      return _profileService.createProfile(
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
