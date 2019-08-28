import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

class CategoryService {
  final CollectionReference _categoryCollection;
  final FieldValue _serverTimestamp;

  CategoryService()
      : _serverTimestamp = FieldValue.serverTimestamp(),
        _categoryCollection = Firestore.instance.collection('categories');

  Future<DocumentReference> createdCategory(
      {@required String userId,
      @required String title,
      @required String description}) {
    return _categoryCollection.add({
      'userId': userId,
      'title': title,
      'description': description,
      'created': _serverTimestamp,
      'lastUpdate': _serverTimestamp,
    });
  }
}
