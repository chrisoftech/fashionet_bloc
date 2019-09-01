import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:rxdart/rxdart.dart';

enum PostFormState { Default, Loading, Success, Failure }

class PostFormBloc {
  final PostRepository _postRepository;

  final _postStateController = BehaviorSubject<PostFormState>();
  Observable<PostFormState> get postFormState =>
      _postStateController.stream.defaultIfEmpty(PostFormState.Default);

  // // List of all posts
  // final _postsController = BehaviorSubject<List<Post>>();
  // Observable<List<Post>> get posts => _postsController.stream;

  PostFormBloc() : _postRepository = PostRepository();

  // Future<ReturnType> fetchPosts() async {
  //   try {
  //     final List<Post> _posts = await _postRepository.fetchPosts();
  //     _postsController.sink.add(_posts);

  //     return ReturnType(
  //         returnType: true, messagTag: 'Posts loaded successfully');
  //   } catch (e) {
  //     return ReturnType(returnType: true, messagTag: e.toString());
  //   }
  // }

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
      return ReturnType(returnType: true, messagTag: e.toString());
    }
  }

  void dispose() {
    _postStateController?.close();
    // _postsController?.close();
  }
}
