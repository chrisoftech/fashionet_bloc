import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class CategoryService {
  final CollectionReference _categoryCollection;
  final FieldValue _serverTimestamp;

  CategoryService()
      : _serverTimestamp = FieldValue.serverTimestamp(),
        _categoryCollection = Firestore.instance.collection('categories');

  Stream<QuerySnapshot> fetchCategories() {
    return _categoryCollection.snapshots();
  }

  Future<DocumentReference> createCategory(
      {@required String userId,
      @required String title,
      @required String description}) {
    return _categoryCollection.add({
      'userId': userId,
      'title': title,
      'description': description,
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp,
    }).timeout(Duration(seconds: 30), onTimeout: () {
      throw ('Operation timeout! Poor internet connection detected');
    });
  }

  Future<void> updateCategory(
      {@required String categoryId,
      @required String title,
      @required String description}) {
    return _categoryCollection.document(categoryId).setData({
      'title': title,
      'description': description,
      'lastUpdate': _serverTimestamp,
    }).timeout(Duration(seconds: 30), onTimeout: () {
      throw ('Operation timeout! Poor internet connection detected');
    });
  }
}
