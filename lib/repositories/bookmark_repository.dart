import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:meta/meta.dart';

class BookmarkRepository {
  final BookmarkService _bookmarkService;
  final AuthRepository _authRepository;
  final PostRepository _postRepository;

  BookmarkRepository()
      : _bookmarkService = BookmarkService(),
        _authRepository = AuthRepository(),
        _postRepository = PostRepository();

  Future<List<Post>> fetchBookmarks() async {
    final String _currentUserId = (await _authRepository.authenticated())?.uid;

    final QuerySnapshot _snapshot =
        await _bookmarkService.fetchBookmarks(userId: _currentUserId);

    final List<Post> _posts = [];

    for (var document in _snapshot.documents) {
      final String _postId = document.documentID;

      final Post _post = await _postRepository.fetchPost(postId: _postId);

      _posts.add(_post);
    }

    return _posts;
  }

  Future<void> addToBookmarks({@required String postId}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _bookmarkService.addToBookmarks(
          postId: postId, userId: _currentUserId);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> removeFromBookmarks({@required String postId}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _bookmarkService.removeFromBookmarks(
          postId: postId, userId: _currentUserId);
    } catch (e) {
      throw (e);
    }
  }

  // Future<void> deletePostBookmarks({@required String postId}) async {
  //   try {
  //     return _bookmarkService.deletePostBookmarks(postId: postId);
  //   } catch(e) {
  //     throw(e);
  //   }
  // }
}
