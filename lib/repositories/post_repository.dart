import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostRepository {
  final PostService _postService;
  final AuthRepository _authRepository;
  final ImageRepository _imageRepository;

  PostRepository()
      : _postService = PostService(),
        _authRepository = AuthRepository(),
        _imageRepository = ImageRepository();

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
