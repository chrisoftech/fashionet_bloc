import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class FollowingService {
  final CollectionReference _profileCollection;
  final FieldValue _serverTimestamp;

  FollowingService()
      : _profileCollection = Firestore.instance.collection('profile'),
        _serverTimestamp = FieldValue.serverTimestamp();

  Future<QuerySnapshot> fetchFollowing({@required String userId}) {
    return _profileCollection
        .document(userId)
        .collection('following')
        .orderBy('lastUpdate', descending: true)
        .getDocuments();
  }

  Future<void> addToFollowing(
      {@required String followingId, @required String userId}) async {
    await _profileCollection
        .document(followingId)
        .collection('followers')
        .document(userId)
        .setData({'isFollower': true, 'lastUpdate': _serverTimestamp});

    return _profileCollection
        .document(userId)
        .collection('following')
        .document(followingId)
        .setData({'isFollowing': true, 'lastUpdate': _serverTimestamp});
  }

  Future<void> removeFromFollowing(
      {@required String followingId, @required String userId}) async {
    await _profileCollection
        .document(followingId)
        .collection('followers')
        .document(userId)
        .delete();

    return _profileCollection
        .document(userId)
        .collection('following')
        .document(followingId)
        .delete();
  }
}
