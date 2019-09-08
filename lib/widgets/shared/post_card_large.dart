import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/pages/pages.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCardLarge extends StatefulWidget {
  final Post post;

  const PostCardLarge({Key key, @required this.post}) : super(key: key);

  @override
  _PostCardLargeState createState() => _PostCardLargeState();
}

class _PostCardLargeState extends State<PostCardLarge> {
  BookmarkBloc _bookmarkBloc;
  PostItemBloc _postItemBloc;
  StreamSubscription _subscription;

  Post get _post => widget.post;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initBloc();
  }

  @override
  void didUpdateWidget(PostCardLarge oldWidget) {
    super.didUpdateWidget(oldWidget);

    _dispose();
    _initBloc();
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _initBloc() {
    _bookmarkBloc = BookmarkProvider.of(context);
    _postItemBloc = PostItemBloc(post: _post);

    _subscription =
        _bookmarkBloc.bookmarkedPosts.listen(_postItemBloc.bookmarkedPosts);
  }

  void _dispose() {
    _postItemBloc?.dispose();
    _subscription?.cancel();
  }

  Widget _buildPostImage({@required double contentMaxWidth}) {
    return Positioned(
      top: 0.0,
      height: 200.0,
      width: contentMaxWidth,
      child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(10.0),
          child: CachedNetworkImage(
            imageUrl: '${_post.imageUrls[0].toString()}',
            placeholder: (context, imageUrl) =>
                Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
            errorWidget: (context, imageUrl, error) =>
                Center(child: Icon(Icons.error)),
            imageBuilder: (BuildContext context, ImageProvider image) {
              return Hero(
                tag: '${_post.postId}_${_post.imageUrls[0]}',
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image:
                            DecorationImage(fit: BoxFit.cover, image: image))),
              );
            },
          )),
    );
  }

  void _showSnackbar(
      {@required Icon icon, @required String title, @required String message}) {
    if (!mounted) return;

    Flushbar(
      icon: icon,
      title: title,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void _toggleBookmarkStatus({@required AsyncSnapshot<bool> snapshot}) async {
    ReturnType _response = !snapshot.data
        ? await _bookmarkBloc.addToBookmarks(post: _post)
        : await _bookmarkBloc.removeFromBookmarks(post: _post);

    if (_response.returnType) {
      final _icon = Icon(Icons.info_outline, color: Colors.amber);
      _showSnackbar(
          icon: _icon, title: 'Success', message: _response.messagTag);
    } else {
      final _icon = Icon(Icons.error_outline, color: Colors.amber);
      _showSnackbar(icon: _icon, title: 'Error', message: _response.messagTag);
    }
  }

  Widget _buildPostTitle() {
    return Flexible(
      child: ListTile(
        // onTap: () => _navigateToPostDetailsPage(),
        title: Text('${_post.title}',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${_post.description}', overflow: TextOverflow.ellipsis),
        trailing: StreamBuilder<bool>(
            initialData: false,
            stream: _postItemBloc.isBookmarked,
            builder: (context, snapshot) {
              return IconButton(
                tooltip: 'Save this post',
                icon: Icon(
                  snapshot.data ? Icons.bookmark : Icons.bookmark_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => _toggleBookmarkStatus(snapshot: snapshot),
              );
            }),
      ),
    );
  }

  Widget _buildPostUser() {
    return Flexible(
      child: ListTile(
        // onTap: () => _navigateToProfilePage(),
        leading: Container(
          height: 45.0,
          width: 45.0,
          child: _post != null && _post.profile.imageUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: '${_post.profile.imageUrl}',
                  placeholder: (context, imageUrl) => Center(
                      child: CircularProgressIndicator(strokeWidth: 2.0)),
                  errorWidget: (context, imageUrl, error) =>
                      Center(child: Icon(Icons.error)),
                  imageBuilder: (BuildContext context, ImageProvider image) {
                    return Hero(
                      tag: '${_post.postId}_${_post.profile.imageUrl}',
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image:
                              DecorationImage(image: image, fit: BoxFit.cover),
                        ),
                      ),
                    );
                  },
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: Image.asset('assets/avatars/ps-avatar.png',
                      fit: BoxFit.cover),
                ),
        ),
        title: Text('by ${_post.profile.firstName} ${_post.profile.lastName}',
            overflow: TextOverflow.ellipsis),
        subtitle: Text(
            '${DateFormat.yMMMMEEEEd().format(_post.lastUpdate.toDate())}',
            overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget _buildPostDetails({@required double contentMaxWidth}) {
    return Positioned(
      bottom: 0.0,
      height: 150.0,
      width: contentMaxWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          // color: Colors.blue,
          child: Card(
            elevation: 3.0,
            child: Column(
              children: <Widget>[
                _buildPostTitle(),
                SizedBox(height: 5.0),
                _buildPostUser(),
                SizedBox(height: 20.0)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    // final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => PostDetailsPage(post: _post)));
      },
      splashColor: Colors.transparent,
      child: Container(
        height: 250.0,
        width: _contentMaxWidth,
        child: Stack(
          children: <Widget>[
            _buildPostImage(contentMaxWidth: _contentMaxWidth),
            _buildPostDetails(contentMaxWidth: _contentMaxWidth)
          ],
        ),
      ),
    );
  }
}
