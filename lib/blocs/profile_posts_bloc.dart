// Post States
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/repositories/repositories.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

abstract class ProfilePostState extends Equatable {
  ProfilePostState([List props = const []]) : super(props);
}

class ProfilePostUninitialized extends ProfilePostState {
  @override
  String toString() => 'ProfilePostUninitialized';
}

class ProfilePostLoaded extends ProfilePostState {
  final List<Post> posts;
  final bool hasReachedMax;

  ProfilePostLoaded({@required this.posts, @required this.hasReachedMax})
      : super([posts, hasReachedMax]);

  ProfilePostLoaded copyWith({List<Post> posts, bool hasReachedMax}) {
    return ProfilePostLoaded(
        posts: posts ?? this.posts,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() =>
      'ProfilePostLoaded { posts: ${posts.length},  hasReachedMax: $hasReachedMax }';
}

class ProfilePostError extends ProfilePostState {
  final String error;

  ProfilePostError({this.error}) : super([error]);

  @override
  String toString() => 'ProfilePostError { error: $error }';
}

// Post Events
abstract class ProfilePostEvent extends Equatable {
  ProfilePostEvent([List props = const []]) : super(props);
}

class ProfileFetchPosts extends ProfilePostEvent {
  final String userId;

  ProfileFetchPosts({@required this.userId}) : super([userId]);

  @override
  String toString() => 'ProfileFetchPosts { $userId }';
}

// Post Bloc
class ProfilePostBloc extends Bloc<ProfilePostEvent, ProfilePostState> {
  final PostRepository _postRepository;

  ProfilePostBloc() : _postRepository = PostRepository();

  @override
  Stream<ProfilePostState> transformEvents(
    Stream<ProfilePostEvent> events,
    Stream<ProfilePostState> Function(ProfilePostEvent event) next,
  ) {
    return super.transformEvents(
      (events as Observable<ProfilePostEvent>).debounceTime(
        Duration(milliseconds: 500),
      ),
      next,
    );
  }

  @override
  ProfilePostState get initialState => ProfilePostUninitialized();

  void onFetchPosts({@required String userId}) {
    dispatch(ProfileFetchPosts(userId: userId));
  }

  @override
  Stream<ProfilePostState> mapEventToState(ProfilePostEvent event) async* {
    bool _hasReachedMax(ProfilePostState state) =>
        state is ProfilePostLoaded && state.hasReachedMax;

    if (event is ProfileFetchPosts && !_hasReachedMax(currentState)) {
      try {
        if (currentState is ProfilePostUninitialized) {
          List<Post> posts = await _postRepository.fetchProfilePosts(
              lastVisible: null, userId: event.userId);

          yield ProfilePostLoaded(posts: posts, hasReachedMax: false);
          return;
        }

        if (currentState is ProfilePostLoaded) {
          final List<Post> currentPosts =
              (currentState as ProfilePostLoaded).posts;

          final Post lastVisible = currentPosts[currentPosts.length - 1];

          List<Post> posts = await _postRepository.fetchProfilePosts(
              lastVisible: lastVisible, userId: event.userId);

          yield posts.isEmpty
              ? (currentState as ProfilePostLoaded)
                  .copyWith(hasReachedMax: true)
              : ProfilePostLoaded(
                  posts: (currentState as ProfilePostLoaded).posts + posts,
                  hasReachedMax: false);
        }
      } catch (e) {
        print(e.toString());
        yield ProfilePostError(error: e.toString());
      }
    }
  }
}
