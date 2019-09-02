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

  BookmarkBloc() : _bookmarkRepository = BookmarkRepository() {
    fetchBookmarks();
  }

  void _postActionOnBookmarks() {
    _bookmarkedPostsController.sink.add(_bookmarkedPosts.toList());
  }

  Future<ReturnType> fetchBookmarks() async {
    try {
      final List<Post> _posts = await _bookmarkRepository.fetchBookmarks();
      _bookmarkedPosts.addAll(_posts);
      _postActionOnBookmarks();

      return ReturnType(
          returnType: true, messagTag: 'Bookmarks successfully loaded');
    } catch (e) {
      return ReturnType(
          returnType: false,
          messagTag: 'Something went wrong when fetching bookmarks');
    }
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
      _bookmarkedPosts.removeWhere((Post _post) => _post.postId == post.postId);
      _postActionOnBookmarks();

      return ReturnType(
          returnType: false,
          messagTag: 'An error occured while saving ${post.title}');
    }
  }

  Future<ReturnType> removeFromBookmarks({@required Post post}) async {
    try {
      _bookmarkedPosts.removeWhere((Post _post) => _post.postId == post.postId);
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
