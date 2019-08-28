import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum ProfileState { Default, HasProfile, NoProfile }

class ProfileBloc with ProfileValidators {
  final ProfileRepository _profileRepository;

  final _profileStateController = BehaviorSubject<ProfileState>();
  final _currentUserProfileController = BehaviorSubject<Profile>();

  final _firstNameController = BehaviorSubject<String>();
  final _lastNameController = BehaviorSubject<String>();
  final _businessNameController = BehaviorSubject<String>();
  final _businessDescriptionController = BehaviorSubject<String>();

  final _countryCodeController = BehaviorSubject<CountryCode>();
  final _phoneNumberController = BehaviorSubject<String>();
  final _otherPhoneNumberController = BehaviorSubject<String>();
  final _locationController = BehaviorSubject<String>();

  ProfileBloc() : _profileRepository = ProfileRepository();

  Observable<ProfileState> get profileState =>
      _profileStateController.stream.defaultIfEmpty(ProfileState.Default);
  Observable<Profile> get currentUserProfile =>
      _currentUserProfileController.stream;

  Observable<String> get firstName =>
      _firstNameController.stream.transform(validateFirstName);
  Observable<String> get lastName =>
      _lastNameController.stream.transform(validateLastName);
  Observable<String> get businessName =>
      _businessNameController.stream.transform(validateBusinessName);
  Observable<String> get businesDescription =>
      _businessDescriptionController.stream
          .transform(validateBusinessDescription);

  Observable<CountryCode> get countryCode =>
      _countryCodeController.stream; // country code
  Observable<String> get phoneNumber =>
      _phoneNumberController.stream.transform(validatePhoneNumber);
  Observable<String> get otherPhoneNumber =>
      _otherPhoneNumberController.stream.transform(validateOtherPhoneNumber);

  Observable<String> get location =>
      _locationController.stream.transform(validateLocation);

  Function(String) get onFirstNameChanged => _firstNameController.add;
  Function(String) get onLastNameChanged => _lastNameController.add;
  Function(String) get onBusinessNameChanged => _businessNameController.add;
  Function(String) get onBusinessDescriptionChanged =>
      _businessDescriptionController.add;

  Function(CountryCode) get onCountryCodeChanged => _countryCodeController.add;
  Function(String) get onPhoneNumberChanged => _phoneNumberController.add;
  Function(String) get onOtherPhoneNumberChanged =>
      _otherPhoneNumberController.add;
  Function(String) get onLocationChanged => _locationController.add;

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

    _firstNameController?.close();
    _lastNameController?.close();
    _businessNameController?.close();
    _businessDescriptionController?.close();
    _countryCodeController?.close();
    _phoneNumberController?.close();
    _otherPhoneNumberController?.close();
    _locationController?.close();
  }
}
