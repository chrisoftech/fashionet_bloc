import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class TimelineTabPage extends StatelessWidget {
  final Profile profile;
  final ProfilePostState state;

  const TimelineTabPage({Key key, @required this.profile, @required this.state})
      : super(key: key);

  Profile get _profile => profile;
  ProfilePostState get _state => state;

  @override
  Widget build(BuildContext context) {
    Widget _buildLoadingIndicator() {
      return SliverFillRemaining(
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)));
    }

    Widget _buildNoPosts() {
      final double _deviceWidth = MediaQuery.of(context).size.width;
      final double _contentMaxWidth =
          _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

      final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

      return SliverFillRemaining(
        child: Container(
          alignment: Alignment(0.0, 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.new_releases,
                size: 70.0,
                color: Theme.of(context).primaryColor,
              ),
              Text(
                'No posts yet',
                style: Theme.of(context).textTheme.display1.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: _contentPadding),
                child: Text(
                  'You can easily find all posts by ${_profile.firstName} here',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display1.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSliverDynamicContent({@required ProfilePostState state}) {
      if (state is ProfilePostUninitialized) {
        return _buildLoadingIndicator();
      }
      if (state is ProfilePostError) {
        return SliverFillRemaining(
          child: Center(
            child: Text('failed to fetch posts'),
          ),
        );
      }

      if (state is ProfilePostLoaded) {
        if (state.posts.isEmpty) {
          return _buildNoPosts();
        }

        final List<Post> _posts = state.posts;

        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return index >= state.posts.length
                ? BottomLoader()
                : PostCardDefault(post: _posts[index], isProfilePost: true);
          },
              childCount: state.hasReachedMax
                  ? state.posts.length
                  : state.posts.length + 1),
        );
      }

      return SliverToBoxAdapter(child: Container());
    }

    // return BlocBuilder<ProfilePostBloc, ProfilePostState>(
    //   builder: (context, state) {
    return _buildSliverDynamicContent(state: _state);
    //   },
    // );
  }
}
