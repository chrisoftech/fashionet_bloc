// Post States
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class CategoryPostState extends Equatable {
  CategoryPostState([List props = const []]) : super(props);
}

class CategoryPostUninitialized extends CategoryPostState {
  @override
  String toString() => 'CategoryPostUninitialized';
}

class CategoryPostLoaded extends CategoryPostState {
  final List<Post> posts;
  final bool hasReachedMax;

  CategoryPostLoaded({@required this.posts, @required this.hasReachedMax})
      : super([posts, hasReachedMax]);

  CategoryPostLoaded copyWith({List<Post> posts, bool hasReachedMax}) {
    return CategoryPostLoaded(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() =>
      'CategoryPostLoaded { posts: ${posts.length},  hasReachedMax: $hasReachedMax }';
}

class CategoryPostError extends CategoryPostState {
  final String error;

  CategoryPostError({this.error}) : super([error]);

  @override
  String toString() => 'CategoryPostError { error: $error }';
}

// Post Events
abstract class CategoryPostEvent extends Equatable {
  CategoryPostEvent([List props = const []]) : super(props);
}

class CategoryFetchPosts extends CategoryPostEvent {
  final String categoryId;

  CategoryFetchPosts({@required this.categoryId}) : super([categoryId]);

  @override
  String toString() => 'CategoryFetchPosts { $categoryId }';
}

// Post Bloc
class CategoryPostBloc extends Bloc<CategoryPostEvent, CategoryPostState> {
  final PostRepository _postRepository;

  CategoryPostBloc() : _postRepository = PostRepository();

  @override
  Stream<CategoryPostState> transformEvents(
    Stream<CategoryPostEvent> events,
    Stream<CategoryPostState> Function(CategoryPostEvent event) next,
  ) {
    return super.transformEvents(
      (events as Observable<CategoryPostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  CategoryPostState get initialState => CategoryPostUninitialized();

  void onFetchPosts({@required String categoryId}) {
    dispatch(CategoryFetchPosts(categoryId: categoryId));
  }

  @override
  Stream<CategoryPostState> mapEventToState(CategoryPostEvent event) async* {
    bool _hasReachedMax(CategoryPostState state) =>
        state is CategoryPostLoaded && state.hasReachedMax;

    if (event is CategoryFetchPosts && !_hasReachedMax(currentState)) {
      try {
        if (currentState is CategoryPostUninitialized) {
          List<Post> posts = await _postRepository.fetchCategoryPosts(
              lastVisible: null, categoryId: event.categoryId);

          yield CategoryPostLoaded(posts: posts, hasReachedMax: false);
          return;
        }

        if (currentState is CategoryPostLoaded) {
          final List<Post> currentPosts =
              (currentState as CategoryPostLoaded).posts;

          final Post lastVisible = currentPosts[currentPosts.length - 1];

          List<Post> posts = await _postRepository.fetchCategoryPosts(
              lastVisible: lastVisible, categoryId: event.categoryId);

          yield posts.isEmpty
              ? (currentState as CategoryPostLoaded)
                  .copyWith(hasReachedMax: true)
              : CategoryPostLoaded(
                  posts: (currentState as CategoryPostLoaded).posts + posts,
                  hasReachedMax: false);
        }
      } catch (e) {
        print(e.toString());
        yield CategoryPostError(error: e.toString());
      }
    }
  }
}
