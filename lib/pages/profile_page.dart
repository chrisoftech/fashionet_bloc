import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfilePage extends StatefulWidget {
  final Profile profile;
  final bool isCurrentUserProfile;

  const ProfilePage(
      {Key key, @required this.profile, @required this.isCurrentUserProfile})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  PopupMenu _menu;
  GlobalKey _menuButtonKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final PanelController _panelController = PanelController();

  int _currentDisplayedPageIndex = 0;

  Profile get _profile => widget.profile;
  bool get _isCurrentUserProfile => widget.isCurrentUserProfile;

  FollowingBloc _followingBloc;
  PostProfileBloc _postProfileBloc;
  StreamSubscription _subscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initBloc();
  }

  @override
  void didUpdateWidget(ProfilePage oldWidget) {
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
    _followingBloc = FollowingProvider.of(context);
    _postProfileBloc = PostProfileBloc(_profile);

    _subscription = _followingBloc.followingProfiles
        .listen(_postProfileBloc.followingProfiles);
  }

  void _disposeBloc() {
    _subscription?.cancel();
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
  }

  void onDismiss() {
    print('Menu is closed');
  }

  void _openCustomMenu() {
    _menu = PopupMenu(
        maxColumn: 1,
        items: [
          MenuItem(
              title: 'Boost Ad',
              image: Icon(
                Icons.poll,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Statistics',
              image: Icon(
                Icons.timeline,
                color: Colors.white,
              )),
        ],
        onClickMenu: onClickMenu,
        onDismiss: onDismiss);
    _menu.show(widgetKey: _menuButtonKey);
  }

  SliverAppBar _buildSliverAppBar(
      BuildContext context, double _deviceHeight, double _deviceWidth) {
    return SliverAppBar(
      pinned: true,
      // title: Text(
      //   '${_profile.firstName.trim()} ${_profile.lastName.trim()}',
      // ),
      expandedHeight: 360.0,
      actions: <Widget>[
        IconButton(
            key: _menuButtonKey,
            icon: Icon(Icons.more_vert),
            onPressed: _openCustomMenu),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: _buildFlexibleSpace(
            context: context,
            deviceHeight: _deviceHeight,
            deviceWidth: _deviceWidth),
      ),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(5.0),
          child: ProfileTabBar(
            isCurrentUserProfile: _isCurrentUserProfile,
            onActiveIndexChange: (int index) {
              setState(() {
                _currentDisplayedPageIndex = index;
              });

              // if (_currentDisplayedPageIndex == 0) {
              //   _postBloc.fetchProfilePosts(userId: _profile.userId);
              // } else if (_currentDisplayedPageIndex == 1) {
              //   _profileBloc.fetchUserProfileSubscriptions();
              // }

              print(_currentDisplayedPageIndex);
            },
          )),
    );
  }

  Widget _buildProfileAvatar() {
    return _profile != null && _profile.imageUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: '${_profile.imageUrl}',
            placeholder: (context, imageUrl) =>
                Center(child: CircularProgressIndicator(strokeWidth: 2.0)),
            errorWidget: (context, imageUrl, error) =>
                Center(child: Icon(Icons.error)),
            imageBuilder: (BuildContext context, ImageProvider image) {
              return Hero(
                tag:
                    // _isUserProfile
                    // ?
                    '${_profile.imageUrl}',
                // : '${_post.postId}_${_profile.profileImageUrl}',
                child: Container(
                  height: 120.0,
                  width: 120.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: image, fit: BoxFit.cover),
                    border: Border.all(width: 1.0, color: Colors.white),
                  ),
                ),
              );
            },
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(25.0),
            child:
                Image.asset('assets/avatars/ps-avatar.png', fit: BoxFit.cover),
          );
  }

  Widget _buildProfileName() {
    return Text(
      '${_profile.firstName.trim()} ${_profile.lastName.trim()}',
      style: TextStyle(
          color: Colors.white, fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildFollowButton({@required AsyncSnapshot<bool> snapshot}) {
    return _isCurrentUserProfile
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '50k',
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5.0),
              Container(
                height: 15.0,
                width: 1.0,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              SizedBox(width: 10.0),
              Text(
                'Followers',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontSize: 15.0,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  snapshot.data ? 'Following' : 'Follow',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      // color: Colors.black45,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(width: 5.0),
              Container(
                height: 15.0,
                width: 1.0,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(5.0)),
              ),
              SizedBox(width: 10.0),
              Icon(
                snapshot.data ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
                size: 20.0,
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

  Widget _buildProfileFollowButton() {
   
    return StreamBuilder<bool>(
        initialData: false,
        stream: _postProfileBloc.isFollowing,
        builder: (context, snapshot) {
          final double _containerHeight = snapshot.data ? 30.0 : 30.0;
          final double _containerWidth =
              _isCurrentUserProfile ? 120.0 : snapshot.data ? 120.0 : 100.0;

          return Material(
            elevation: 10.0,
            type: MaterialType.button,
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(20.0),
            child: InkWell(
              splashColor: Colors.black38,
              borderRadius: BorderRadius.circular(20.0),
              onTap: _isCurrentUserProfile
                  ? null
                  : () => _toggleFollowingStatus(snapshot: snapshot),
              child: AnimatedContainer(
                height: _containerHeight,
                width: _containerWidth,
                duration: Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
                child: _buildFollowButton(snapshot: snapshot),
              ),
            ),
          );
        });
  }

  Widget _buildProfileContactButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              shape: BoxShape.circle),
          child: IconButton(
            tooltip:
                'Call ${_profile.firstName.trim()} ${_profile.lastName.trim()}',
            icon: Icon(
              Icons.call,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(width: 10.0),
        Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black38),
              shape: BoxShape.circle),
          child: IconButton(
            tooltip:
                'Chat with ${_profile.firstName.trim()} ${_profile.lastName.trim()}',
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildFlexibleSpace(
      {@required BuildContext context,
      @required double deviceHeight,
      @required double deviceWidth}) {
    return Container(
      height: 200.0,
      width: deviceWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildProfileAvatar(),
          SizedBox(height: 15.0),
          _buildProfileName(),
          SizedBox(height: 5.0),
          _buildProfileFollowButton(),
          SizedBox(height: 10.0),
          _buildProfileContactButtons(),
        ],
      ),
    );
  }

  FloatingActionButton _buildProfileFAB() {
    return FloatingActionButton(
      elevation: 8.0,
      highlightElevation: 10.0,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.call,
        size: 30.0,
        color: Colors.white,
      ),
      onPressed: () {
        print('call ${_profile.firstName}');
        // Navigator.of(context).pushNamed('/post-form');
      },
    );
  }

  Widget _buildDynamicSliverContent() {
    Widget _dynamicSliverContent;

    switch (_currentDisplayedPageIndex) {
      case 0:
        _dynamicSliverContent = TimelineTabPage(profile: _profile);
        break;

      case 1:
        _dynamicSliverContent = _isCurrentUserProfile
            ? SubscriptionTabPage()
            : ProfileTabPage(profile: _profile);
        break;

      case 2:
        _dynamicSliverContent = ProfileTabPage(profile: _profile);
        break;

      default:
        _dynamicSliverContent = TimelineTabPage(profile: _profile);
        break;
    }

    return _dynamicSliverContent;
  }

  Widget _floatingCollapsed() {
    return Container(
      margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 0.0),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      child: Center(
        child: Text(
          'Slide up to post item',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _floatingPanel() {
    return Container(
      margin: const EdgeInsets.only(top: 24.0, right: 24.0, left: 24.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
          ]),
      child: Container(
        margin: EdgeInsets.only(top: 25.0),
        child: PostForm(),
      ),
    );
  }

  Widget _buildCustomScrollView(
      {@required double deviceHeight, @required deviceWidth}) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        _buildSliverAppBar(context, deviceHeight, deviceWidth),
        _buildDynamicSliverContent(),
      ],
    );
  }

  Widget _buildSlideUpPanel(
      {@required double deviceHeight, @required deviceWidth}) {
    return SlidingUpPanel(
        minHeight: 50.0,
        renderPanelSheet: false,
        controller: _panelController,
        panel: _floatingPanel(),
        collapsed: _floatingCollapsed(),
        body: _buildCustomScrollView(
            deviceHeight: deviceHeight, deviceWidth: deviceWidth));
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceHeight = MediaQuery.of(context).size.height;
    final double _deviceWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (_isCurrentUserProfile && _menu != null && _menu.isShow) {
          _menu.dismiss();
        }

        if (_isCurrentUserProfile && _panelController.isPanelOpen()) {
          _panelController.close();
          return false;
        }
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        floatingActionButton:
            _isCurrentUserProfile ? Container() : _buildProfileFAB(),
        body: _isCurrentUserProfile
            ? _buildSlideUpPanel(
                deviceHeight: _deviceHeight, deviceWidth: _deviceWidth)
            : _buildCustomScrollView(
                deviceHeight: _deviceHeight, deviceWidth: _deviceWidth),
      ),
    );
  }
}
