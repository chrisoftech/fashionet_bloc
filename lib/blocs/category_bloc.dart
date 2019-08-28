import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/category_repository.dart';
import 'package:fashionet_bloc/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum CategoryFormState { Default, Loading, Success, Failure }

class CategoryBloc with CategoryValidators {
  final CategoryRepository _categoryRepository;

  // final _titleController = BehaviorSubject<String>();
  final _titleController = PublishSubject<String>();
  final _descriptionController = PublishSubject<String>();

  // states controllers
  final _categoryFormStateController = BehaviorSubject<CategoryFormState>();

  CategoryBloc() : _categoryRepository = CategoryRepository();

  // validators
  Observable<String> get title =>
      _titleController.stream.transform(validateTitle);
  Observable<String> get description =>
      _descriptionController.stream.transform(validateDescription);

  // form validation
  Observable<bool> get validateForm =>
      Observable.combineLatest2(title, description, (t, d) => true);

  // states
  Observable<CategoryFormState> get categoryFormState =>
      _categoryFormStateController.stream
          .defaultIfEmpty(CategoryFormState.Default);

  // inputs
  Function(String) get onTitleChanged => _titleController.add;
  Function(String) get onDescriptionChanged => _descriptionController.add;

  Future<ReturnType> createCategory(
      {@required String title, @required String description}) async {
    try {
      _categoryFormStateController.sink.add(CategoryFormState.Loading);

      await _categoryRepository.createCategory(
          title: title, description: description);

      _categoryFormStateController.sink.add(CategoryFormState.Success);

      return ReturnType(
          returnType: true, messagTag: 'Category created successfully');
    } catch (e) {
      print(e.toString());

      _categoryFormStateController.sink.add(CategoryFormState.Failure);
      return ReturnType(
          returnType: false,
          messagTag: 'An error occured while creating category!');
    }
  }

  void dispose() {
    _titleController?.close();
    _descriptionController?.close();

    _categoryFormStateController?.close();

    print('Category bloc disposed');
  }
}
