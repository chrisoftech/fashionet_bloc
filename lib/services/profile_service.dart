import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class ProfileService {
  final CollectionReference _profileCollection;
  final FieldValue _serverTimeStamp;

  ProfileService()
      : _serverTimeStamp = FieldValue.serverTimestamp(),
        _profileCollection = Firestore.instance.collection('profile');

  Future<DocumentSnapshot> hasProfile({@required String userId}) {
    return _profileCollection.document(userId).get();
  }

  Future<DocumentSnapshot> fetchProfile({@required String userId}) {
    return _profileCollection.document(userId).get();
  }

  Future<QuerySnapshot> fetchUserFollowing({@required String userId}) {
    return _profileCollection
        .document(userId)
        .collection('following')
        .getDocuments();
  }

  Future<QuerySnapshot> fetchUserFollowers({@required String userId}) {
    return _profileCollection
        .document(userId)
        .collection('followers')
        .getDocuments();
  }

  Future<void> createProfile(
      {@required String userId,
      @required String firstname,
      @required String lastname,
      @required String businessName,
      @required String businessDescription,
      @required String dialCode,
      @required String phoneNumber,
      @required String otherPhoneNumber,
      @required String location,
      @required String imageUrl}) {
    return _profileCollection.document(userId).setData({
      'firstname': firstname,
      'lastname': lastname,
      'businessName': businessName,
      'businessDescription': businessDescription,
      'dialCode': dialCode,
      'phoneNumber': phoneNumber,
      'otherPhoneNumber': otherPhoneNumber,
      'location': location,
      'imageUrl': imageUrl,
      'created': _serverTimeStamp,
      'lastUpdate': _serverTimeStamp,
    }, merge: true);
  }
}
