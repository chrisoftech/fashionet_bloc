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

  final _isFollowingController = BehaviorSubject<bool>();
  Observable<bool> get isFollowing => _isFollowingController.stream.defaultIfEmpty(false);

  final _followingProfilesController = BehaviorSubject<List<Profile>>();
  Function(List<Profile>) get followingProfiles =>
      _followingProfilesController.sink.add;

  PostItemBloc({@required Post post}) {
    // verify if current post item exists in the bookmark collection
    _bookmarkedPostsController.stream.map((bookmarks) {
      return bookmarks.any((Post postItem) => postItem.postId == post.postId);
    }).listen((bool isBookmarked) {
      _isBookmarkedController.sink.add(isBookmarked);
    });

    // verify if current post item profile exists in the following collection
    _followingProfilesController.stream.map((profile) {
      return profile.any(
          (Profile profileItem) => profileItem.userId == post.profile.userId);
    }).listen((bool isFollowing) {
      _isFollowingController.sink.add(isFollowing);
    });
  }

  void dispose() {
    _isBookmarkedController?.close();
    _bookmarkedPostsController?.close();

    _isFollowingController?.close();
    _followingProfilesController?.close();
  }
}
