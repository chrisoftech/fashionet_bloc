import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/pages/pages.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/transitions/transitions.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class PostCardDefault extends StatefulWidget {
  final Post post;
  final String categoryId;
  final bool isProfilePost;

  const PostCardDefault(
      {Key key,
      @required this.post,
      this.categoryId,
      this.isProfilePost = false})
      : super(key: key);

  @override
  _PostCardDefaultState createState() => _PostCardDefaultState();
}

class _PostCardDefaultState extends State<PostCardDefault> {
  BookmarkBloc _bookmarkBloc;
  FollowingBloc _followingBloc;
  ProfileBloc _profileBloc;
  PostItemBloc _postItemBloc;

  PostFormBloc _postFormBloc;

  StreamSubscription _bookmarkSubscription;
  StreamSubscription _followingSubscription;
  StreamSubscription _currentUserSubscription;

  int _currentPostImageIndex = 0;

  Post get _post => widget.post;
  String get _categoryId => widget.categoryId;
  bool get _isProfilePost =>
      widget.isProfilePost; // deactivate navigating to post profilepage
  bool _isCurrentUserPost;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initBloc();
  }

  @override
  void didUpdateWidget(PostCardDefault oldWidget) {
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
    _followingBloc = FollowingProvider.of(context);
    _profileBloc = ProfileProvider.of(context);
    _postItemBloc = PostItemBloc(post: _post);

    _bookmarkSubscription =
        _bookmarkBloc.bookmarkedPosts.listen(_postItemBloc.bookmarkedPosts);

    _followingSubscription = _followingBloc.followingProfiles
        .listen(_postItemBloc.followingProfiles);

    _currentUserSubscription = _profileBloc.currentUserProfile
        .listen(_postItemBloc.currentUserProfile);

    _postFormBloc = PostFormProvider.of(context);
  }

  void _disposeBloc() {
    _followingSubscription?.cancel();
    _bookmarkSubscription?.cancel();
    _currentUserSubscription?.cancel();
    _postItemBloc?.dispose();
  }

  void _navigateToPostUserProfile() {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => BlocProvider(
          builder: (context) =>
              ProfilePostBloc()..onFetchPosts(userId: _post.profile.userId),
          child: ProfilePage(
              profile: _post.profile,
              isCurrentUserProfile: _isCurrentUserPost)),
    ))
        .then((_) {
      final _uniqueKey = UniqueKey(); // reset post-state
      _postFormBloc.setUniqueKey(uniqueKey: _uniqueKey);
    });
  }

  Widget _buildActivePostImage() {
    return Container(
      width: 9.0,
      height: 9.0,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.transparent,
        border: Border.all(width: 2.0, color: Theme.of(context).accentColor),
      ),
    );
  }

  Widget _buildInactivePostImage() {
    return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey));
  }

  Widget _buildPostImageCarouselIndicator() {
    List<Widget> dots = [];

    for (int i = 0; i < _post.imageUrls.length; i++) {
      dots.add(i == _currentPostImageIndex
          ? _buildActivePostImage()
          : _buildInactivePostImage());
    }

    return Positioned(
        left: 0.0,
        right: 0.0,
        bottom: 20.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dots,
        ));
  }

  Widget _buildPostImageSynopsis() {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: Container(
        height: 70.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[Colors.transparent, Colors.black38],
          ),
        ),
      ),
    );
  }

  Widget _buildPostImageCarousel() {
    return CarouselSlider(
        height: 400.0,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: (int index) {
          setState(() {
            _currentPostImageIndex = index;
          });
        },
        items: _post.imageUrls.map((dynamic postImageUrl) {
          return Builder(
            builder: (BuildContext context) {
              return CachedNetworkImage(
                imageUrl: '${postImageUrl.toString()}',
                placeholder: (context, imageUrl) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, imageUrl, error) =>
                    Center(child: Icon(Icons.error)),
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Hero(
                    tag: '${_post.postId}_${_post.imageUrls[0]}',
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(image: image, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              );
            },
          );
        }).toList());
  }

  Widget _buildPostPriceTag() {
    return Positioned(
      top: 20.0,
      right: 0.0,
      child: Container(
        height: 30.0,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0)),
          // borderRadius: BorderRadius.circular(25.0),
        ),
        child: Text(
          'GHC ${_post.price}',
          style: TextStyle(
              color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildPostCardBackgroundImage() {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          child: _post.imageUrls != null && _post.imageUrls.length > 0
              ? _buildPostImageCarousel()
              : Image.asset('assets/avatars/bg-avatar.png', fit: BoxFit.cover),
        ),
        _buildPostImageSynopsis(),
        _post.imageUrls.length > 1
            ? _buildPostImageCarouselIndicator()
            : Container(),
        _buildPostPriceTag()
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

  void _toggleFollowingStatus({@required AsyncSnapshot<bool> snapshot}) async {
    ReturnType _response = !snapshot.data
        ? await _followingBloc.addToFollowing(profile: _post.profile)
        : await _followingBloc.removeFromFollowing(profile: _post.profile);

    if (_response.returnType) {
      final _icon = Icon(Icons.info_outline, color: Colors.amber);
      _showSnackbar(
          icon: _icon, title: 'Success', message: _response.messagTag);
    } else {
      final _icon = Icon(Icons.error_outline, color: Colors.amber);
      _showSnackbar(icon: _icon, title: 'Error', message: _response.messagTag);
    }
  }

  Widget _buildFollowTrailingButton() {
    return StreamBuilder<bool>(
        initialData: false,
        stream: _postItemBloc.isFollowing,
        builder: (context, snapshot) {
          final double _containerHeight = snapshot.data ? 40.0 : 30.0;
          final double _containerWidth = snapshot.data ? 40.0 : 100.0;

          return InkWell(
            onTap: () => _toggleFollowingStatus(snapshot: snapshot),
            splashColor: Colors.black38,
            borderRadius: BorderRadius.circular(15.0),
            child: AnimatedContainer(
              height: _containerHeight,
              width: _containerWidth,
              duration: Duration(milliseconds: 100),
              padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  !snapshot.data
                      ? Flexible(
                          flex: 2,
                          child: Text(
                            'FOLLOW',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w900),
                          ),
                        )
                      : Container(),
                  !snapshot.data ? SizedBox(width: 5.0) : Container(),
                  Flexible(
                    child: Center(
                      child: Icon(
                        !snapshot.data ? Icons.favorite_border : Icons.favorite,
                        size: 20.0,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  void _refreshFetchedPosts() {
    // refresh fetched posts
    BlocProvider.of<PostBloc>(context)..onFetchPosts(isRefresh: true);
    if (_categoryId != null && _categoryId.isNotEmpty) {
      BlocProvider.of<CategoryPostBloc>(context)
        ..onFetchPosts(categoryId: _categoryId, isRefresh: true);
    }
  }

  void _buildDeleteConfirmationDialog() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return PostDeleteDialog(post: _post);
        }).then((_) {
      if (_ != null && _) {
        final _icon = Icon(Icons.verified_user, color: Colors.green);
        final _deleteMessage = 'Post deleted successfully';
        _showSnackbar(icon: _icon, title: 'Success', message: _deleteMessage);

        _refreshFetchedPosts();
      }
    });
  }

  void _onSelectOption(dynamic value) {
    if (value == 'EDIT') {
      final _page = PostEditPage(post: _post);

      Navigator.of(context).push(SlideLeftRoute(page: _page)).then((_) {
        final _uniqueKey = UniqueKey(); // reset post-state
        _postFormBloc.setUniqueKey(uniqueKey: _uniqueKey);

        _refreshFetchedPosts();
      });
    } else {
      _buildDeleteConfirmationDialog();
    }
  }

  Widget _buildPopUpMenu() {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) {
        return <PopupMenuItem>[
          PopupMenuItem(
            child: Text('Edit'),
            value: 'EDIT',
          ),
          PopupMenuItem(
            child: Text('Delete'),
            value: 'DELETE',
          ),
        ];
      },
      onSelected: _onSelectOption,
    );
  }

  Widget _buildUserListTile() {
    return ListTile(
      onTap: _isProfilePost ? null : () => _navigateToPostUserProfile(),
      leading: Container(
        height: 50.0,
        width: 50.0,
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
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: image, fit: BoxFit.cover),
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
      title: Text('${_post.profile.firstName} ${_post.profile.lastName}',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle:
          Text('${DateFormat.yMMMMEEEEd().format(_post.lastUpdate.toDate())}'),
      trailing: StreamBuilder<bool>(
          initialData: false,
          stream: _postItemBloc.isCurrentUser,
          builder: (context, snapshot) {
            _isCurrentUserPost =
                snapshot.data; // if this post is by current user
            return snapshot.data
                ? _buildPopUpMenu()
                : _buildFollowTrailingButton();
          }),
    );
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

  Widget _buildPostListTile() {
    return ListTile(
        title: Text('${_post.title}',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${_post.description}', overflow: TextOverflow.ellipsis),
        trailing: StreamBuilder<bool>(
            initialData: false,
            stream: _postItemBloc.isBookmarked,
            builder: (context, snapshot) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      print(snapshot.data);
                      _toggleBookmarkStatus(snapshot: snapshot);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Icon(
                        snapshot.data ? Icons.bookmark : Icons.bookmark_border,
                        color: Theme.of(context).accentColor,
                      ),
                    ),
                  ),
                  // _buildActionMenu()
                ],
              );
            }));
  }

  Widget _buildPostDetails() {
    return Column(
      children: <Widget>[
        _buildUserListTile(),
        _buildPostListTile(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final double _deviceWidth = MediaQuery.of(context).size.width;
    // final double _contentMaxWidth = _deviceWidth > 500.0 ? 500.0 : _deviceWidth;

    // final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _contentWidth = _deviceWidth > 500.0 ? 500.0 : _deviceWidth;

    return Column(
      children: <Widget>[
        Card(
          elevation: 8.0,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PostDetailsPage(post: _post)));
            },
            child: Container(
              width: _contentWidth,
              child: Column(
                children: <Widget>[
                  _buildPostDetails(),
                  _buildPostCardBackgroundImage()
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 20.0)
      ],
    );
  }
}
