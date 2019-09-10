import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostRepository {
  final PostService _postService;
  final AuthRepository _authRepository;
  final ImageRepository _imageRepository;
  final ProfileRepository _profileRepository;
  // final BookmarkRepository _bookmarRepository;
  final BookmarkService _bookmarkService;

  PostRepository()
      : _postService = PostService(),
        _authRepository = AuthRepository(),
        _imageRepository = ImageRepository(),
        _profileRepository = ProfileRepository(),
        // _bookmarRepository = BookmarkRepository();
        _bookmarkService = BookmarkService();

  Future<List<String>> _uploadPostImage(
      {@required String userId,
      @required List<Asset> assets,
      Post post}) async {
    try {
      final String _fileLocation = '$userId/posts';

      // delete images
      if (post != null && assets.isNotEmpty) {
        for (String imageUrl in post.imageUrls) {
          await _imageRepository.deletePostImages(imageUrl: imageUrl);
        }
      }

      final List<String> imageUrls = await _imageRepository.savePostImages(
          fileLocation: _fileLocation, assets: assets);

      print('Image uploaded ${imageUrls.toList()}');
      return imageUrls;
    } catch (e) {
      throw (e);
    }
  }

  Future<void> _deletePostImage({@required Post post}) async {
    try {
      for (String imageUrl in post.imageUrls) {
        await _imageRepository.deletePostImages(imageUrl: imageUrl);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Post>> _mapSnapshotToPosts({QuerySnapshot querySnapshot}) async {
    final List<Post> _posts = [];

    if (querySnapshot.documents.length < 1) return _posts;

    for (var document in querySnapshot.documents) {
      final String _postUserId = document.data['userId'];
      final Profile _postProfile =
          await _profileRepository.fetchProfile(userId: _postUserId);

      final _post = Post(
        postId: document.documentID,
        userId: document.data['userId'],
        title: document.data['title'],
        description: document.data['description'],
        price: document.data['price'],
        isAvailable: document.data['isAvailable'],
        imageUrls: document.data['imageUrls'],
        categories: document.data['categories'],
        created: document.data['created'],
        lastUpdate: document.data['lastUpdate'],
        profile: _postProfile,
      );

      _posts.add(_post);
    }

    return _posts;
  }

  Future<Post> fetchPost({@required String postId}) async {
    try {
      final DocumentSnapshot _document =
          await _postService.fetchPost(postId: postId);
      final String _postUserId = _document.data['userId'];
      final Profile _postProfile =
          await _profileRepository.fetchProfile(userId: _postUserId);

      return Post(
        postId: _document.documentID,
        userId: _document.data['userId'],
        title: _document.data['title'],
        description: _document.data['description'],
        price: _document.data['price'],
        isAvailable: _document.data['isAvailable'],
        imageUrls: _document.data['imageUrls'],
        categories: _document.data['categories'],
        created: _document.data['created'],
        lastUpdate: _document.data['lastUpdate'],
        profile: _postProfile,
      );
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Post>> fetchPosts({@required Post lastVisible}) async {
    try {
      QuerySnapshot _snapshot =
          await _postService.fetchPosts(lastVisible: lastVisible);

      return _mapSnapshotToPosts(querySnapshot: _snapshot);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Post>> fetchProfilePosts(
      {@required Post lastVisible, @required String userId}) async {
    try {
      QuerySnapshot _snapshot = await _postService.fetchProfilePosts(
          lastVisible: lastVisible, userId: userId);

      return _mapSnapshotToPosts(querySnapshot: _snapshot);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Post>> fetchCategoryPosts(
      {@required Post lastVisible, @required String categoryId}) async {
    try {
      QuerySnapshot _snapshot = await _postService.fetchCategoryPosts(
          lastVisible: lastVisible, categoryId: categoryId);

      return _mapSnapshotToPosts(querySnapshot: _snapshot);
    } catch (e) {
      throw (e);
    }
  }

  Future<List<Post>> fetchLatestPosts() async {
    try {
      final List<String> _followingProfileIds =
          await _profileRepository.fetchUserFollowing();

      final List<Post> _latestPosts = [];

      for (var userId in _followingProfileIds) {
        final QuerySnapshot _snapshot =
            await _postService.fetchLatestPosts(userId: userId);

        final List<Post> _posts =
            await _mapSnapshotToPosts(querySnapshot: _snapshot);
        _latestPosts.add(_posts[0]);
      }

      // sort posts by lastUdate (decending order)
      _latestPosts.sort(
          (b, a) => a.lastUpdate.toDate().compareTo(b.lastUpdate.toDate()));

      return _latestPosts;
    } catch (e) {
      throw (e);
    }
  }

  Future<DocumentReference> createPost(
      {@required List<Asset> assets,
      @required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<String> categories}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      final List<String> _imageUrls =
          await _uploadPostImage(userId: _currentUserId, assets: assets);

      return _postService.createPost(
          imageUrls: _imageUrls,
          userId: _currentUserId,
          title: title,
          description: description,
          price: price,
          isAvailable: isAvailable,
          categories: categories);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> updatePost(
      {@required List<Asset> assets,
      @required String postId,
      @required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<String> categories}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      final List<String> _imageUrls = [];
      if (assets.isNotEmpty) {
        final List<String> _urls =
            await _uploadPostImage(userId: _currentUserId, assets: assets);

        _imageUrls..addAll(_urls);
      }

      return _postService.updatePost(
          imageUrls: _imageUrls,
          postId: postId,
          userId: _currentUserId,
          title: title,
          description: description,
          price: price,
          isAvailable: isAvailable,
          categories: categories);
    } catch (e) {
      throw (e);
    }
  }

  Future<void> deletePost({@required Post post}) async {
    try {
      await _deletePostImage(post: post);
      await _bookmarkService.deletePostBookmarks(postId: post.postId);
      return _postService.deletePost(postId: post.postId);
    } catch (e) {
      throw (e);
    }
  }
}
