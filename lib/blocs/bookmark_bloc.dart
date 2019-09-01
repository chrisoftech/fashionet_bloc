import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class BookmarkBloc {
  final BookmarkRepository _bookmarkRepository;

  // list of bookmarked posts
  Set<Post> _bookmarkedPosts = Set<Post>();

  final _bookmarkedPostsController = BehaviorSubject<List<Post>>();
  Observable<List<Post>> get bookmarkedPosts =>
      _bookmarkedPostsController.stream;

  BookmarkBloc() : _bookmarkRepository = BookmarkRepository();

  void _postActionOnBookmarks() {
    _bookmarkedPostsController.sink.add(_bookmarkedPosts.toList());
  }

  Future<ReturnType> addToBookmarks({@required Post post}) async {
    try {
      _bookmarkedPosts.add(post);
      _postActionOnBookmarks();

      await _bookmarkRepository.addToBookmarks(postId: post.postId);

      return ReturnType(
          returnType: true,
          messagTag: '${post.title} has been saved in bookmarks');
    } catch (e) {

      // reverse changes if error occurs
      _bookmarkedPosts.add(post);
      _postActionOnBookmarks();

      return ReturnType(
          returnType: false,
          messagTag: 'An error occured while saving ${post.title}');
    }
  }

  Future<ReturnType> removeFromBookmarks({@required Post post}) async {
    try {
      _bookmarkedPosts.remove(post);
      _postActionOnBookmarks();

      await _bookmarkRepository.removeFromBookmarks(postId: post.postId);

      return ReturnType(
          returnType: true,
          messagTag: '${post.title} has been removed from bookmarks');
    } catch (e) {

      // reverse changes if error occurs
      _bookmarkedPosts.add(post);
      _postActionOnBookmarks();

      return ReturnType(
          returnType: false,
          messagTag: 'An error occured while un-saving ${post.title}');
    }
  }

  void dispose() {
    _bookmarkedPostsController?.close();
  }
}
