import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/pages/pages.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FollowerCard extends StatefulWidget {
  final Profile profile;
  final bool showControl;

  const FollowerCard(
      {Key key, @required this.profile, this.showControl = true})
      : super(key: key);

  @override
  _FollowerCardState createState() => _FollowerCardState();
}

class _FollowerCardState extends State<FollowerCard> {
  FollowingBloc _followingBloc;
  PostProfileBloc _postProfileBloc;
  StreamSubscription _subscription;

  Profile get _profile => widget.profile;
  bool get _showControl => widget.showControl;

  @override
  void didUpdateWidget(FollowerCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    _disposeBloc();
    _initBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initBloc();
  }

  @override
  void dispose() {
    _disposeBloc();
    super.dispose();
  }

  void _initBloc() {
    _followingBloc = FollowingProvider.of(context);
    _postProfileBloc = PostProfileBloc(_profile);

    _subscription = _followingBloc.followingProfiles
        .listen(_postProfileBloc.followingProfiles);
  }

  void _disposeBloc() {
    _subscription?.cancel();
  }

  void _navigateToProfilePage() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
            builder: (context) =>
                ProfilePostBloc()..onFetchPosts(userId: _profile.userId),
            child:
                ProfilePage(profile: _profile, isCurrentUserProfile: false))));
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
        ? await _followingBloc.addToFollowing(profile: _profile)
        : await _followingBloc.removeFromFollowing(profile: _profile);

    if (_response.returnType) {
      final _icon = Icon(Icons.info_outline, color: Colors.amber);
      _showSnackbar(
          icon: _icon, title: 'Success', message: _response.messagTag);
    } else {
      final _icon = Icon(Icons.error_outline, color: Colors.amber);
      _showSnackbar(icon: _icon, title: 'Error', message: _response.messagTag);
    }
  }

  Widget _buildUnfollowButton() {
    return StreamBuilder<bool>(
      initialData: false,
      stream: _postProfileBloc.isFollowing,
      builder: (context, snapshot) {
        return Material(
          elevation: 5.0,
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(10.0),
          child: InkWell(
            onTap: () => _toggleFollowingStatus(snapshot: snapshot),
            borderRadius: BorderRadius.circular(10.0),
            child: Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                snapshot.data ? 'Unfollow' : 'Follow',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleListTile({@required BuildContext context}) {
    return ListTile(
      leading: SizedBox(
        height: 50.0,
        width: 50.0,
        child: _profile != null && _profile.imageUrl.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: '${_profile.imageUrl}',
                placeholder: (context, imageUrl) =>
                    Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
                errorWidget: (context, imageUrl, error) =>
                    Center(child: Icon(Icons.error)),
                imageBuilder: (BuildContext context, ImageProvider image) {
                  return Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(image: image, fit: BoxFit.cover),
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
      title: Text('${_profile.businessName}',
          style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(Icons.location_on, size: 15.0),
          SizedBox(width: 5.0),
          Flexible(
              child: Text(
            '${_profile.businessLocation}',
            overflow: TextOverflow.ellipsis,
          )),
        ],
      ),
      trailing: !_showControl
          ? Container(height: 20.0, width: 20.0)
          : _buildUnfollowButton(),
    );
  }

  Widget _buildFollowersCountTag({@required BuildContext context}) {
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
          ),
          child: Text(
            '50k',
            // '${_profile.followersCount} ${_profile.followersCount > 1 ? 'followers' : 'follower'}',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionListTile({@required BuildContext context}) {
    return ListTile(
      title: Text(
        'Description',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        '${_profile.businessDescription}',
        overflow: TextOverflow.ellipsis,
      ),
      trailing: _buildFollowersCountTag(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _deviceWidth = MediaQuery.of(context).size.width;
    final _contentWidth = _deviceWidth > 500.0 ? 500.0 : _deviceWidth;

    return Card(
      elevation: 3.0,
      child: InkWell(
        onTap: () {
          _navigateToProfilePage();
        },
        child: Container(
          width: _contentWidth,
          child: Column(
            children: <Widget>[
              _buildTitleListTile(context: context),
              _buildDescriptionListTile(context: context),
            ],
          ),
        ),
      ),
    );
  }
}
