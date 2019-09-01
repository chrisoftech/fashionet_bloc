import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:meta/meta.dart';

class PostService {
  final CollectionReference _postCollection;
  final FieldValue _serverTimestamp;

  PostService()
      : _postCollection = Firestore.instance.collection('posts'),
        _serverTimestamp = FieldValue.serverTimestamp();

  // Future<QuerySnapshot> fetchPosts() {
  //   return _postCollection
  //       .orderBy('lastUpdate', descending: true)
  //       .getDocuments();
  // }

  Future<QuerySnapshot> fetchPosts({@required Post lastVisible}) {
    return lastVisible == null
        ? _postCollection
            .orderBy('lastUpdate', descending: true)
            .limit(2)
            .getDocuments()
        : _postCollection
            .orderBy('lastUpdate', descending: true)
            .startAfter([lastVisible.lastUpdate])
            .limit(2)
            .getDocuments();
  }

  Future<DocumentReference> createPost(
      {@required List<String> imageUrls,
      @required String userId,
      @required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<String> categories}) {
    return _postCollection.add({
      'imageUrls': imageUrls,
      'userId': userId,
      'title': title,
      'description': description,
      'price': price,
      'isAvailable': isAvailable,
      'categories': categories,
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp,
    });
  }
}
