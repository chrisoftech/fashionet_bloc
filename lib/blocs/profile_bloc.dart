import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum ProfileState { Default, HasProfile, NoProfile }

class ProfileBloc {
  final ProfileRepository _profileRepository;
  final _profileStateController = BehaviorSubject<ProfileState>();
  final _currentUserProfileController = BehaviorSubject<Profile>();

  Observable<ProfileState> get profileState =>
      _profileStateController.stream.defaultIfEmpty(ProfileState.Default);
  Observable<Profile> get currentUserProfile =>
      _currentUserProfileController.stream;

  ProfileBloc() : _profileRepository = ProfileRepository();

  void _mapStreamToProfile({@required Stream<DocumentSnapshot> document}) {
    document.listen(
      (snapshot) {
        if (snapshot.exists) {
          final Profile _profile = Profile(
            userId: snapshot.documentID,
            firstName: snapshot.data['firstName'],
            lastName: snapshot.data['lastName'],
            businessName: snapshot.data['businessName'],
            businessDescription: snapshot.data['businessDescription'],
            phoneNumber: snapshot.data['phoneNumber'],
            otherPhoneNumber: snapshot.data['otherPhoneNumber'],
            businessLocation: snapshot.data['businessLocation'],
            profileImageUrl: snapshot.data['profileImageUrl'],
            created: snapshot.data['created'],
            lastUpdate: snapshot.data['lastUpdate'],
          );

          _currentUserProfileController.sink.add(_profile);
          _profileStateController.sink.add(ProfileState.HasProfile);
          return;
        }

        _currentUserProfileController.sink.add(null);
        _profileStateController.sink.add(ProfileState.NoProfile);
        return;
      },
    );
  }

  void hasProfile() {
    try {
      _profileStateController.sink.add(ProfileState.Default);

      _profileRepository.hasProfile().then((Stream<DocumentSnapshot> document) {
        return _mapStreamToProfile(document: document);
      });
    } catch (e) {
      print(e.toString());
      
      _currentUserProfileController.sink.add(null);
      _profileStateController.sink.add(ProfileState.NoProfile);
      return;
    }
  }

  void dispose() {
    _profileStateController?.close();
    _currentUserProfileController?.close();
  }
}
