import 'dart:async';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';

enum ProfileState { Default, Loading, Success, Failure }

class ProfileBloc with ProfileValidators {
  final ProfileRepository _profileRepository;
  final ImageRepository _imageRepository;

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
  final _profileImageController = BehaviorSubject<Asset>();

  ProfileBloc()
      : _profileRepository = ProfileRepository(),
        _imageRepository = ImageRepository();

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
  Observable<String> get businessDescription =>
      _businessDescriptionController.stream
          .transform(validateBusinessDescription);

  Observable<CountryCode> get countryCode =>
      _countryCodeController.stream; // country code
  Observable<String> get phoneNumber =>
      _phoneNumberController.stream.transform(validatePhoneNumber);
  // Observable<String> get otherPhoneNumber =>
  //     _otherPhoneNumberController.stream.transform(validateOtherPhoneNumber);

  Observable<String> get location =>
      _locationController.stream.transform(validateLocation);
  // Observable<Asset> get profileImage => _profileImageController.stream;

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
  Function(Asset) get onProfileImageChanged => _profileImageController.add;

  Observable<bool> get validateForm => Observable.combineLatest6(
      firstName,
      lastName,
      businessName,
      businessDescription,
      phoneNumber,
      location,
      (f, n, b, d, p, l) => true);

  Future<String> _uploadProfileImage({@required Asset asset}) {
    try {
      return _imageRepository.saveProfileImage(asset: asset);
    } catch (e) {
      throw (e);
    }
  }

  Future<ReturnType> fetchCurrentUserProfile() async {
    try {
      final Profile _profile =
          await _profileRepository.fetchProfile(isCurrentUser: true);
      
      _currentUserProfileController.sink.add(_profile);
      
      return ReturnType(
          returnType: true, messagTag: 'User profile fetch successfully');
    } catch (e) {
        return ReturnType(
          returnType: false, messagTag: 'An error occured when fetching user profile');
    }
  }

  Future<ReturnType> createProfile() async {
    try {
      _profileStateController.add(ProfileState.Loading);

      final String _imageUrl =
          await _uploadProfileImage(asset: _profileImageController.value);

      await _profileRepository.createProfile(
        firstname: _firstNameController.value,
        lastname: _lastNameController.value,
        businessName: _businessNameController.value,
        businessDescription: _businessDescriptionController.value,
        dialCode: _countryCodeController.value.dialCode,
        phoneNumber: _phoneNumberController.value,
        otherPhoneNumber: _otherPhoneNumberController.value,
        location: _locationController.value,
        imageUrl: _imageUrl,
      );

      _profileStateController.add(ProfileState.Success);

      return ReturnType(
          returnType: true, messagTag: 'Profile created successfully');
    } catch (e) {
      print(e.toString());
      _profileStateController.add(ProfileState.Failure);

      return ReturnType(
          returnType: false,
          messagTag: 'An error occured while creating profile!');
    }
  }

  void dispose() {
    _currentUserProfileController?.close();

    _firstNameController?.close();
    _lastNameController?.close();
    _businessNameController?.close();
    _businessDescriptionController?.close();
    _countryCodeController?.close();
    _phoneNumberController?.close();
    _otherPhoneNumberController?.close();
    _locationController?.close();
    _profileImageController?.close();
  }
}
