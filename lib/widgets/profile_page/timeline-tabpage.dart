// import 'package:fashionet_provider/blocs/blocs.dart';
// import 'package:fashionet_provider/modules/utilities/utilities.dart';
// import 'package:fashionet_provider/widgets/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class TimelineTabPage extends StatelessWidget {
//   final String userId;
//   final bool isRefreshing;

//   const TimelineTabPage(
//       {Key key, @required this.userId, @required this.isRefreshing})
//       : super(key: key);

//   String get _userId => userId;
//   bool get _isRefreshing => isRefreshing;

//   Widget _buildSliverList({@required PostBloc postBloc}) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate(
//         (BuildContext context, int index) {
//           return index >= postBloc.profilePosts.length
//               ? BottomLoader()
//               : PostItemCardDefault(
//                   post: postBloc.profilePosts[index], isProfilePost: true);
//         },
//         childCount: postBloc.moreProfilePostsAvailable
//             ? postBloc.profilePosts.length + 1
//             : postBloc.profilePosts.length,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PostBloc>(
//         builder: (BuildContext context, PostBloc postBloc, Widget child) {
//       return _isRefreshing
//           ? _buildSliverList(postBloc: postBloc)
//           : postBloc.profilePostState == PostState.Loading
//               ? SliverToBoxAdapter(
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(height: 50.0),
//                       _isRefreshing ? Container() : CircularProgressIndicator(),
//                     ],
//                   ),
//                 )
//               : postBloc.profilePosts.length == 0
//                   ? SliverToBoxAdapter(
//                       child: Column(
//                         children: <Widget>[
//                           SizedBox(height: 50.0),
//                           FlatButton(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               mainAxisSize: MainAxisSize.min,
//                               children: <Widget>[
//                                 Icon(Icons.refresh),
//                                 Text('refresh'),
//                               ],
//                             ),
//                             onPressed: () {
//                               postBloc.fetchProfilePosts(userId: _userId);
//                             },
//                           ),
//                           Text('No Post(s) Loaded'),
//                         ],
//                       ),
//                     )
//                   : _buildSliverList(postBloc: postBloc);
//     });
//   }
// }

import 'package:fashionet_bloc/models/models.dart';
import 'package:flutter/material.dart';

class TimelineTabPage extends StatelessWidget {
  final Profile profile;

  const TimelineTabPage({Key key, @required this.profile}) : super(key: key);

  Profile get _profile => profile;

  @override
  Widget build(BuildContext context) {
    // final double _deviceWidth = MediaQuery.of(context).size.width;
    // final double _contentMaxWidth =
    //     _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    // final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

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

    return _buildNoPosts();
  }
}
