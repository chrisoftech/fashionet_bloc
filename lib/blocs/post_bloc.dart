import 'package:fashionet_bloc/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

// Post States
abstract class PostState extends Equatable {
  PostState([List props = const []]) : super(props);
}

class PostUninitialized extends PostState {
  @override
  String toString() => 'PostUninitialized';
}

class PostLoaded extends PostState {
  final List<Post> posts;
  final bool hasReachedMax;

  PostLoaded({@required this.posts, @required this.hasReachedMax})
      : super([posts, hasReachedMax]);

  PostLoaded copyWith({List<Post> posts, bool hasReachedMax}) {
    return PostLoaded(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() =>
      'PostLoaded { posts: ${posts.length},  hasReachedMax: $hasReachedMax }';
}

class PostError extends PostState {
  final String error;

  PostError({this.error}) : super([error]);

  @override
  String toString() => 'PostError { error: $error }';
}

// Post Events
abstract class PostEvent extends Equatable {}

class FetchPosts extends PostEvent {
  @override
  String toString() => 'FetchPosts';
}

// Post Bloc
class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;

  PostBloc() : _postRepository = PostRepository();

  @override
  Stream<PostState> transformEvents(
    Stream<PostEvent> events,
    Stream<PostState> Function(PostEvent event) next,
  ) {
    return super.transformEvents(
      (events as Observable<PostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  PostState get initialState => PostUninitialized();

  void onFetchPosts() {
    dispatch(FetchPosts());
  }

  @override
  Stream<PostState> mapEventToState(PostEvent event) async* {
    bool _hasReachedMax(PostState state) =>
        state is PostLoaded && state.hasReachedMax;

    if (event is FetchPosts && !_hasReachedMax(currentState)) {
      try {
        if (currentState is PostUninitialized) {
          List<Post> posts = await _postRepository.fetchPosts(lastVisible: null);


          yield PostLoaded(
              posts: posts,  hasReachedMax: false);
          return;
        }

        if (currentState is PostLoaded) {
          final List<Post> currentPosts = (currentState as PostLoaded).posts;

          final Post lastVisible = currentPosts[currentPosts.length - 1];

          List<Post> posts =
              await _postRepository.fetchPosts(lastVisible: lastVisible);


          yield posts.isEmpty
              ? (currentState as PostLoaded).copyWith(hasReachedMax: true)
              : PostLoaded(
                  posts: (currentState as PostLoaded).posts + posts,
                  hasReachedMax: false);
        }
      } catch (e) {
        print(e.toString());
        yield PostError(error: e.toString());
      }
    }
  }
}
