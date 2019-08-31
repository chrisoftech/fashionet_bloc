import 'package:meta/meta.dart';

class Profile {
  final String userId;
  final String firstName;
  final String lastName;
  final String businessName;
  final String businessDescription;
  final String businessLocation;
  final String dialCode;
  final String phoneNumber;
  final String otherPhoneNumber;
  final String imageUrl;
  final dynamic created;
  final dynamic lastUpdate;
  // final bool isFollowing;
  // final int followersCount;

  Profile({
    @required this.userId,
    @required this.firstName,
    @required this.lastName,
    @required this.businessName,
    @required this.businessDescription,
    @required this.businessLocation,
    @required this.dialCode,
    @required this.phoneNumber,
    @required this.otherPhoneNumber,
    @required this.imageUrl,
    @required this.created,
    @required this.lastUpdate,
    // this.isFollowing = false,
    // this.followersCount = 0,
  });

  Profile copyWith({
    String userId,
    String firstName,
    String lastName,
    String businessName,
    String businessDescription,
    String businessLocation,
    String dialCode,
    String phoneNumber,
    String otherPhoneNumber,
    String imageUrl,
    dynamic created,
    dynamic lastUpdate,
    // bool isFollowing,
    // int followersCount
  }) {
    return Profile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      businessName: businessName ?? this.businessName,
      businessDescription: businessDescription ?? this.businessDescription,
      businessLocation: businessLocation ?? this.businessLocation,
      dialCode: dialCode ?? this.dialCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otherPhoneNumber: otherPhoneNumber ?? this.otherPhoneNumber,
      imageUrl: imageUrl ?? this.imageUrl,
      created: created ?? this.created,
      lastUpdate: lastUpdate ?? this.lastUpdate,
      // isFollowing: isFollowing ?? this.isFollowing,
      // followersCount: followersCount ?? this.followersCount,
    );
  }
}
