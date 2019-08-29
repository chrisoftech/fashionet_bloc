import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/category_repository.dart';
import 'package:fashionet_bloc/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum CategoryState { Default, Loading, Success, Failure }

class CategoryBloc with CategoryValidators {
  final CategoryRepository _categoryRepository;

  // final _categoriesController = BehaviorSubject<List<Category>>();

  final _titleController = PublishSubject<String>();
  final _descriptionController = PublishSubject<String>();

  // states controllers
  final _categoryFormStateController = BehaviorSubject<CategoryState>();
  final _categoryStateController = BehaviorSubject<CategoryState>();

  CategoryBloc() : _categoryRepository = CategoryRepository();

  // Observable<List<Category>> get categories => _categoriesController.stream;

  // validators
  Observable<String> get title =>
      _titleController.stream.transform(validateTitle);
  Observable<String> get description =>
      _descriptionController.stream.transform(validateDescription);

  // form validation
  // Observable<bool> get validateForm =>
  //     Observable.combineLatest2(title, description, (t, d) => true);

  // states
  Observable<CategoryState> get categoryFormState =>
      _categoryFormStateController.stream.defaultIfEmpty(CategoryState.Default);
  Observable<CategoryState> get categoryState =>
      _categoryStateController.stream.defaultIfEmpty(CategoryState.Default);

  // inputs
  Function(String) get onTitleChanged => _titleController.add;
  Function(String) get onDescriptionChanged => _descriptionController.add;

  List<Category> _mapStreamToCategory({@required QuerySnapshot snapshot}) {
    final List<Category> _categories = [];

    for (var document in snapshot.documents) {
      final _category = Category(
        categoryId: document.documentID,
        title: document.data['title'],
        description: document.data['description'],
        created: document.data['created'],
        lastUpdate: document.data['lastUpdate'],
      );

      _categories.add(_category);
    }

    return _categories;
  }

  Stream<List<Category>> fetchCategories() {
    return _categoryRepository.fetchCategories().map(
        (QuerySnapshot snapshot) => _mapStreamToCategory(snapshot: snapshot));

    //  final List<Category> _categories = _mapStreamToCategory(snapshot: snapshot);
    //   _categoriesController.sink.add(_categories);
  }

  Future<ReturnType> createCategory(
      {@required String title, @required String description}) async {
    try {
      _categoryFormStateController.sink.add(CategoryState.Loading);

      await _categoryRepository.createCategory(
          title: title, description: description);

      _categoryFormStateController.sink.add(CategoryState.Success);

      return ReturnType(
          returnType: true, messagTag: 'Category created successfully');
    } catch (e) {
      print(e.toString());

      _categoryFormStateController.sink.add(CategoryState.Failure);
      return ReturnType(returnType: false, messagTag: e.toString());
    }
  }

  Future<ReturnType> updateCategory(
      {@required String categoryId,
      @required String title,
      @required String description}) async {
    try {
      _categoryFormStateController.sink.add(CategoryState.Loading);

      await _categoryRepository.updateCategory(
          categoryId: categoryId, title: title, description: description);

      _categoryFormStateController.sink.add(CategoryState.Success);

      return ReturnType(
          returnType: true, messagTag: 'Category updated successfully');
    } catch (e) {
      print(e.toString());

      _categoryFormStateController.sink.add(CategoryState.Failure);
      return ReturnType(returnType: false, messagTag: e.toString());
    }
  }

  Future<ReturnType> deleteCategory({@required String categoryId}) async {
    try {
      _categoryFormStateController.sink.add(CategoryState.Loading);

      await _categoryRepository.deleteCategory(categoryId: categoryId);

      _categoryFormStateController.sink.add(CategoryState.Success);

      return ReturnType(
          returnType: true, messagTag: 'Category deleted successfully');
    } catch (e) {
      print(e.toString());

      _categoryFormStateController.sink.add(CategoryState.Failure);
      return ReturnType(returnType: false, messagTag: e.toString());
    }
  }

  void dispose() {
    // _categoriesController?.close();

    _titleController?.close();
    _descriptionController?.close();

    _categoryFormStateController?.close();
    _categoryStateController?.close();

    print('Category bloc disposed');
  }
}
