import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:meta/meta.dart';

class BookmarkRepository {
  final BookmarkService _bookmarkService;
  final AuthRepository _authRepository;

  BookmarkRepository() : _bookmarkService = BookmarkService(), _authRepository = AuthRepository();

  Future<void> addToBookmarks({@required String postId}) async {
    try {
       final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _bookmarkService.addToBookmarks(postId: postId, userId: _currentUserId);
    } catch(e) {
      throw(e);
    }
  }

  Future<void> removeFromBookmarks({@required String postId}) async {
    try {
       final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _bookmarkService.removeFromBookmarks(postId: postId, userId: _currentUserId);
    } catch(e) {
      throw(e);
    }
  }
}
