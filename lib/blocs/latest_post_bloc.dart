import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';

enum LatestPostState { Default, Loading, Success, Failure }

class LatestPostBloc {
  final PostRepository _postRepository;

  LatestPostBloc() : _postRepository = PostRepository() {
    fetchLatestPost();
  }

  final _latestPostStateController = BehaviorSubject<LatestPostState>();
  Observable<LatestPostState> get latestPostState =>
      _latestPostStateController.stream.defaultIfEmpty(LatestPostState.Default);

  final _latestPostController = BehaviorSubject<List<Post>>();
  Observable<List<Post>> get latestPosts => _latestPostController.stream;

  Future<ReturnType> fetchLatestPost() async {
    try {
      _latestPostStateController.sink.add(LatestPostState.Loading);

      final List<Post> _latestPosts = await _postRepository.fetchLatestPosts();
      _latestPostController.sink.add(_latestPosts);

      _latestPostStateController.sink.add(LatestPostState.Success);

      return ReturnType(
          returnType: true, messagTag: 'Fetched latest post successfully');
    } catch (e) {
      print(e.toString());

      _latestPostStateController.sink.add(LatestPostState.Failure);
      return ReturnType(returnType: false, messagTag: e.toString());
    }
  }

  void dispose() {
    _latestPostStateController?.close();
    _latestPostController?.close();
  }
}
