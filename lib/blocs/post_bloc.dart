import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';

enum PostState { Default, Loading, Success, Failure }

class PostBloc {
  final PostRepository _postRepository;

  final _postStateController = BehaviorSubject<PostState>();

  PostBloc() : _postRepository = PostRepository();

  Observable<PostState> get postState =>
      _postStateController.stream.defaultIfEmpty(PostState.Default);

  Future<ReturnType> createPost(
      {@required List<Asset> assets,
      @required String title,
      @required String description,
      @required double price,
      @required bool isAvailable,
      @required List<String> categories}) async {
    try {
      _postStateController.sink.add(PostState.Loading);

      await _postRepository.createPost(
        assets: assets,
        title: title,
        description: description,
        price: price,
        isAvailable: isAvailable,
        categories: categories,
      );

      _postStateController.sink.add(PostState.Success);

      return ReturnType(returnType: true, messagTag: 'Ad posted successfully');
    } catch (e) {
      print(e.toString());

      _postStateController.sink.add(PostState.Failure);
      return ReturnType(returnType: true, messagTag: e.toString());
    }
  }

  void dispose() {
    _postStateController?.close();
  }
}
