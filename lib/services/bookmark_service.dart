import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class BookmarkService {
  final CollectionReference _postCollection;
  final CollectionReference _profileCollection;
  final FieldValue _serverTimestamp;

  BookmarkService()
      : _postCollection = Firestore.instance.collection('posts'),
        _profileCollection = Firestore.instance.collection('profile'),
        _serverTimestamp = FieldValue.serverTimestamp();

  Future<QuerySnapshot> fetchBookmarks({@required String userId}) {
    return _profileCollection
        .document(userId)
        .collection('bookmarks')
        .orderBy('lastUpdate', descending: true)
        .getDocuments();
  }

  Future<void> addToBookmarks(
      {@required String postId, @required String userId}) async {
    await _postCollection
        .document(postId)
        .collection('bookmarks')
        .document(userId)
        .setData({'isBookmarked': true, 'lastUpdate': _serverTimestamp});

    return _profileCollection
        .document(userId)
        .collection('bookmarks')
        .document(postId)
        .setData({'isBookmarked': true, 'lastUpdate': _serverTimestamp});
  }

  Future<void> removeFromBookmarks(
      {@required String postId, @required String userId}) async {
    await _postCollection
        .document(postId)
        .collection('bookmarks')
        .document(userId)
        .delete();

    return _profileCollection
        .document(userId)
        .collection('bookmarks')
        .document(postId)
        .delete();
  }

  Future<void> deletePostBookmarks({@required String postId}) async {
    try {
      // get all profileId that bookmarked this post
      final QuerySnapshot _snapshot = await _postCollection
          .document(postId)
          .collection('bookmarks')
          .getDocuments();

      for (var document in _snapshot.documents) {
        final String _documentId = document.documentID;

        await _profileCollection
            .document(_documentId)
            .collection('bookmarks')
            .document(postId)
            .delete();
      }

      return;
    } catch (e) {
      throw (e);
    }
  }
}
