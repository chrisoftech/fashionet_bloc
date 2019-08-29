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

  Stream<QuerySnapshot> fetchCategories() {
    try {
      return _categoryService.fetchCategories();
    } catch (e) {
      throw (e);
    }
  }

  Future<DocumentReference> createCategory(
      {@required String title, @required String description}) async {
    try {
      final String _currentUserId =
          (await _authRepository.authenticated())?.uid;

      return _categoryService.createCategory(
          userId: _currentUserId, title: title, description: description);
    } catch (e) {
      throw (e);
    }
  }
}
