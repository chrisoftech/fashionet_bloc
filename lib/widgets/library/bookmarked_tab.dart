import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class BookmarkedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final BookmarkBloc _bookmarkBloc = BookmarkProvider.of(context);

    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    Widget _buildNoBookmarks() {
      return Container(
        alignment: Alignment(0.0, 0.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.bookmark_border,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'No bookmarks yet',
              style: Theme.of(context).textTheme.display1.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: 10.0, horizontal: _contentPadding),
              child: Text(
                'Bookmark posts in Fashionet you love so you can always find them here',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.display1.copyWith(
                    color: Theme.of(context).primaryColor, fontSize: 15.0),
              ),
            ),
          ],
        ),
      );
    }

    return StreamBuilder<List<Post>>(
        stream: _bookmarkBloc.bookmarkedPosts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
          }

          final List<Post> _posts = snapshot.data;

          return _posts.length == 0
              ? _buildNoBookmarks()
              : ListView.builder(
                  itemCount: _posts.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Post _post = _posts[index];

                    return Column(
                      children: <Widget>[
                        index == 0 ? SizedBox(height: 10.0) : Container(),
                        PostCardSmall(post: _post),
                        index == _posts.length - 1
                            ? SizedBox(height: 130.0)
                            : SizedBox(height: 10.0),
                      ],
                    );
                  },
                );
        });
  }
}
