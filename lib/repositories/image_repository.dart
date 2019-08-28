import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ImageRepository {
  final AuthRepository _authRepository;
  final ImageService _imageService;

  ImageRepository()
      : _authRepository = AuthRepository(),
        _imageService = ImageService();

  Future<String> saveProfileImage({@required Asset asset}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _imageService.saveProfileImage(
          userId: _currentUserId, asset: asset);
    } catch (e) {
      throw (e);
    }
  }
}
