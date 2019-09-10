import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';

enum PostFormState { Default, Loading, Success, Failure }

class PostFormBloc {
  final PostRepository _postRepository;

  static UniqueKey _uniqueKey;

  final _postStateController = BehaviorSubject<PostFormState>();
  Observable<PostFormState> get postFormState =>
      _postStateController.stream.defaultIfEmpty(PostFormState.Default);

  PostFormBloc() : _postRepository = PostRepository();

  // set post-form unique key
  UniqueKey get uniqueKey => _uniqueKey;
  setUniqueKey({@required UniqueKey uniqueKey}) {
    _uniqueKey = uniqueKey;
  }

  Future<ReturnType> createPost(
      {@required List<Asset> assets,
      @required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<String> categories}) async {
    try {
      _postStateController.sink.add(PostFormState.Loading);

      await _postRepository.createPost(
        assets: assets,
        title: title,
        description: description,
        price: price,
        isAvailable: isAvailable,
        categories: categories,
      );

      _postStateController.sink.add(PostFormState.Success);

      return ReturnType(returnType: true, messagTag: 'Ad posted successfully');
    } catch (e) {
      print(e.toString());

      _postStateController.sink.add(PostFormState.Failure);
      return ReturnType(returnType: false, messagTag: e.toString());
    }
  }

  Future<ReturnType> updatePost(
      {@required List<Asset> assets,
      @required String postId,
      @required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<String> categories}) async {
    try {
      _postStateController.sink.add(PostFormState.Loading);

      await _postRepository.updatePost(
        assets: assets,
        postId: postId,
        title: title,
        description: description,
        price: price,
        isAvailable: isAvailable,
        categories: categories,
      );
      // await Future.delayed(Duration(seconds: 5));

      _postStateController.sink.add(PostFormState.Success);

      return ReturnType(returnType: true, messagTag: 'Ad updated successfully');
    } catch (e) {
      print(e.toString());

      _postStateController.sink.add(PostFormState.Failure);
      return ReturnType(returnType: false, messagTag: e.toString());
    }
  }

  Future<ReturnType> deletePost({@required Post post}) async {
    try {
      _postStateController.sink.add(PostFormState.Loading);

      await _postRepository.deletePost(post: post);
      // await Future.delayed(Duration(seconds: 5));

      _postStateController.sink.add(PostFormState.Success);

      return ReturnType(returnType: true, messagTag: 'Ad deleted successfully');
    } catch (e) {
      print(e.toString());

      _postStateController.sink.add(PostFormState.Failure);
      return ReturnType(returnType: false, messagTag: e.toString());
    }
  }

  void dispose() {
    _postStateController?.close();
    // _postsController?.close();
  }
}
