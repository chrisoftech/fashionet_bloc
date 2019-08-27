import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';

class ProfileService {

  final CollectionReference _profileCollection;

  ProfileService()
      : 
        _profileCollection = Firestore.instance.collection('profile');

  Stream<DocumentSnapshot> hasProfile({@required String userId}) {
    return _profileCollection.document(userId).snapshots();
  }
}
