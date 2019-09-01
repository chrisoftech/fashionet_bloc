import 'package:fashionet_bloc/models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class BookmarkBloc {
  // list of bookmarked posts
  Set<Post> _bookmarkedPosts = Set<Post>();

  final _bookmarkedPostsController = BehaviorSubject<List<Post>>();
  Observable<List<Post>> get bookmarkedPosts => _bookmarkedPostsController.stream;

  void _postActionOnBookmarks() {
    _bookmarkedPostsController.sink.add(_bookmarkedPosts.toList());
  }

  void addToBookmarks({@required Post post}) {
    _bookmarkedPosts.add(post);
    _postActionOnBookmarks();
  }

  void removeFromBookmarks({@required Post post}) {
    _bookmarkedPosts.remove(post);
    _postActionOnBookmarks();
  }

  void dispose() {
    _bookmarkedPostsController?.close();
  }
}