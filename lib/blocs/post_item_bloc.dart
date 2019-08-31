import 'package:fashionet_bloc/models/models.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';

class PostItemBloc {
  // switch to determine if this post is bookmarked
  final _isBookmarkedController = BehaviorSubject<bool>();
  Observable<bool> get isBookmarked =>
      _isBookmarkedController.stream.defaultIfEmpty(false);

  // collection of all bookmarked posts
  final _bookmarkedPostsController = PublishSubject<List<Post>>();
  Function(List<Post>) get bookmarkedPosts =>
      _bookmarkedPostsController.sink.add;

  PostItemBloc({@required Post post}) {
    // verify if current post item exists in the bookmark collection
    _bookmarkedPostsController.stream.map((bookmarks) {
      return bookmarks.any((Post postItem) => postItem.postId == post.postId);
    }).listen((bool isBookmarked) {
      _isBookmarkedController.sink.add(isBookmarked);
    });
  }

  void dispose() {
    _isBookmarkedController?.close();
    _bookmarkedPostsController?.close();
  }
}
