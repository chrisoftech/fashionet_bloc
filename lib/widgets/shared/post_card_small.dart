import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostCardSmall extends StatefulWidget {
  final Post post;

  const PostCardSmall({Key key, @required this.post}) : super(key: key);

  @override
  _PostCardSmallState createState() => _PostCardSmallState();
}

class _PostCardSmallState extends State<PostCardSmall> {
  BookmarkBloc _bookmarkBloc;
  PostItemBloc _postItemBloc;
  StreamSubscription _subscription;

  Post get _post => widget.post;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // _bookmarkBloc = BookmarkProvider.of(context);
    _initBloc();
  }

  @override
  void didUpdateWidget(PostCardSmall oldWidget) {
    super.didUpdateWidget(oldWidget);

    _disposeBloc();
    _initBloc();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  void _initBloc() {
    _bookmarkBloc = BookmarkProvider.of(context);
    _postItemBloc = PostItemBloc(post: _post);

    _subscription =
        _bookmarkBloc.bookmarkedPosts.listen(_postItemBloc.bookmarkedPosts);
  }

  void _disposeBloc() {
    _subscription?.cancel();
    _postItemBloc?.dispose();
  }

  void _navigateToPostDetailsPage() {
    // Navigator.of(context).pushNamed('/bookmark/${_bookmarkPost.postId}');
  }

  void _navigateToProfilePage() {
    // Navigator.of(context).pushNamed(
    // '/bookmarked-post-profile/${_bookmarkPost.postId}/${_bookmarkPost.profile.userId}');
  }

  Widget _buildPostPriceTag({@required BuildContext context}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 30.0,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0)),
            // borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(
            'GHC ${_post.price}',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900),
          ),
        ),
      ],
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

  Widget _buildPostDetailsCard(
      {@required BuildContext context,
      @required double postContainerHeight,
      @required double postContentContainerWidth,
      @required double deviceWidth}) {
    return Positioned(
      left: 15.0,
      bottom: 0.0,
      height: postContainerHeight,
      width: postContentContainerWidth,
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.only(left: deviceWidth * 0.18),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  isThreeLine: true,
                  title: Text('${_post.title}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${_post.description}',
                      overflow: TextOverflow.ellipsis),
                  trailing: StreamBuilder<bool>(
                      initialData: false,
                      stream: _postItemBloc.isBookmarked,
                      builder: (context, snapshot) {
                        return IconButton(
                          tooltip: 'Save this post',
                          icon: Icon(
                            snapshot.data
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            color: Theme.of(context).accentColor,
                          ),
                          onPressed: () {
                            print(snapshot.data);
                            _toggleBookmarkStatus(snapshot: snapshot);
                          },
                        );
                      }),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () => _navigateToProfilePage(),
                  title: Text(
                      'by ${_post.profile.firstName} ${_post.profile.lastName}'),
                  subtitle: Text(
                    '${DateFormat.yMMMMEEEEd().format(_post.lastUpdate.toDate())}',
                    style: TextStyle(fontSize: 11.0),
                  ),
                  trailing: _buildPostPriceTag(context: context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage() {
    return Material(
      elevation: 5.0,
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _post != null && _post.imageUrls.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: '${_post.imageUrls[0]}',
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
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                      image: AssetImage('assets/avatars/bg-avatar.png'),
                      fit: BoxFit.cover),
                ),
              ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: _post != null && _post.profile.imageUrl.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: '${_post.profile.imageUrl}',
              placeholder: (context, imageUrl) =>
                  Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
              errorWidget: (context, imageUrl, error) =>
                  Center(child: Icon(Icons.error)),
              imageBuilder: (BuildContext context, ImageProvider image) {
                return Hero(
                  tag: '${_post.postId}_${_post.profile.imageUrl}',
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25.0),
                    child: InkWell(
                      onTap: () => _navigateToProfilePage(),
                      borderRadius: BorderRadius.circular(25.0),
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2.0),
                          image:
                              DecorationImage(image: image, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          : Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2.0),
                image: DecorationImage(
                    image: AssetImage('assets/avatars/ps-avatar.png'),
                    fit: BoxFit.cover),
              ),
            ),
    );
  }

  Widget _buildPostImageCount() {
    return _post.imageUrls.length == 1
        ? Container()
        : Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 30.0,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        bottomLeft: Radius.circular(15.0)),
                  ),
                  child: Text(
                    '+ ${_post.imageUrls.length - 1}',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          );
  }

  Widget _buildPostImageStack(
      {@required double postContainerHeight,
      @required double postImageContainerWidth}) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      height: postContainerHeight,
      width: postImageContainerWidth,
      child: Stack(
        children: <Widget>[
          _buildPostImage(),
          _buildProfileAvatar(),
          _buildPostImageCount(),
        ],
      ),
    );
  }

  Widget _buildCardStack(
      {@required BuildContext context,
      @required double deviceWidth,
      @required double containerHeight}) {
    final double _postContentContainerWidth =
        deviceWidth * 0.85; // 85% of total device width.
    final double _postImageContainerWidth =
        deviceWidth * 0.25; // 25% of total device width.

    final double _postContainerHeight = containerHeight - 15.0;

    return Stack(
      children: <Widget>[
        _buildPostDetailsCard(
            context: context,
            postContainerHeight: _postContainerHeight,
            postContentContainerWidth: _postContentContainerWidth,
            deviceWidth: deviceWidth),
        _buildPostImageStack(
            postContainerHeight: _postContainerHeight,
            postImageContainerWidth: _postImageContainerWidth),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;

    final double _containerHeight = 150.0;
    final double _containerWidth = _deviceWidth > 500.0
        ? 500.0
        : _deviceWidth * 0.90; // 90% of total device width.

    return Column(
      children: <Widget>[
        Material(
          child: InkWell(
            onTap: () => _navigateToPostDetailsPage(),
            child: Container(
              height: _containerHeight,
              width: _containerWidth,
              child: _buildCardStack(
                  context: context,
                  deviceWidth: _deviceWidth,
                  containerHeight: _containerHeight),
            ),
          ),
        ),
        SizedBox(height: 5.0),
      ],
    );
  }
}
