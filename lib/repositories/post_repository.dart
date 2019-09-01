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

  PostRepository()
      : _postService = PostService(),
        _authRepository = AuthRepository(),
        _imageRepository = ImageRepository(),
        _profileRepository = ProfileRepository();

  Future<List<String>> _uploadPostImage(
      {@required String userId, @required List<Asset> assets}) async {
    try {
      final String _fileLocation = '$userId/posts';

      final List<String> imageUrls = await _imageRepository.savePostImages(
          fileLocation: _fileLocation, assets: assets);

      print('Image uploaded ${imageUrls.toList()}');
      return imageUrls;
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
        categories: document.data['category'],
        created: document.data['created'],
        lastUpdate: document.data['lastUpdate'],
        profile: _postProfile,
      );

      _posts.add(_post);
    }

    return _posts;
  }

  // Future<List<Post>> fetchPosts() async {
  //   try {
  //     final QuerySnapshot _snapshot = await _postService.fetchPosts();

  //     return _mapStreamToPosts(querySnapshot: _snapshot);
  //   } catch (e) {
  //     throw (e);
  //   }
  // }

  Future<List<Post>> fetchPosts({@required Post lastVisible}) async {
    try {
      QuerySnapshot _snapshot =
          await _postService.fetchPosts(lastVisible: lastVisible);

     return _mapSnapshotToPosts(querySnapshot: _snapshot);
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
}
