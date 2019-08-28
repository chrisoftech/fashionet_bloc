import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:fashionet_bloc/services/services.dart';
import 'package:meta/meta.dart';

class CategoryRepository {
  final CategoryService _categoryService;
  final AuthRepository _authRepository;

  CategoryRepository()
      : _categoryService = CategoryService(),
        _authRepository = AuthRepository();

  Future<DocumentReference> createCategory(
      {@required String title, @required String description}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _categoryService.createdCategory(
          userId: _currentUserId, title: title, description: description);
    } catch (e) {
      throw (e);
    }
  }
}
