import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/pages/pages.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/transitions/transitions.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_menu/popup_menu.dart';

class HomeTab extends StatefulWidget {
  final ScrollController scrollController;

  const HomeTab({Key key, @required this.scrollController}) : super(key: key);
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  LatestPostBloc _latestPostBloc;

  ScrollController get _scrollController => widget.scrollController;

  GlobalKey _menuButtonKey = GlobalKey();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _latestPostBloc = LatestPostProvider.of(context);
  }

  void _onClickMenu(MenuItemProvider item) {
    if (item.menuTitle == 'Categories') {
      Navigator.of(context).push(SlideLeftRoute(page: CategoriesPage()));
    } else if (item.menuTitle == 'Signout') {
      print('App signout');
      BlocProvider.of<AuthVerificationBloc>(context)..dispatch(LoggedOut());
    }
  }

  void _onStateChanged(bool isShow) {
    print('Menu is ${isShow ? 'Open' : 'Closed'}');
  }

  void _onDismiss() {
    print('Menu is closed');
  }

  void _openCustomMenuOptions() {
    PopupMenu _menu = PopupMenu(
        maxColumn: 1,
        items: [
          MenuItem(
              title: 'Profile',
              image: Icon(
                Icons.person_outline,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Categories',
              image: Icon(
                Icons.category,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Settings',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Signout',
              image: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              )),
        ],
        onClickMenu: _onClickMenu,
        stateChanged: _onStateChanged,
        onDismiss: _onDismiss);
    _menu.show(widgetKey: _menuButtonKey);
  }

  Widget _buildFlexibleSpaceBarTitle() {
    return Text('Home',
        style: Theme.of(context).textTheme.display1.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold));
  }

  Widget _buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      title: _buildFlexibleSpaceBarTitle(),
      titlePadding: EdgeInsets.only(left: 20.0, bottom: 10.0),
    );
  }

  Widget _buildSectionLabel({@required String label}) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 20.0, bottom: 5.0),
      child: Text('$label',
          style: Theme.of(context).textTheme.display1.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 110.0,
      backgroundColor: Colors.white,
      flexibleSpace: _buildFlexibleSpaceBar(),
      actions: <Widget>[
        IconButton(
            onPressed: _openCustomMenuOptions,
            key: _menuButtonKey,
            color: Theme.of(context).primaryColor,
            iconSize: 30.0,
            icon: Icon(Icons.more_vert))
      ],
    );
  }

  Widget _buildNoPosts() {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Container(
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
            'You don\'t have any latest posts',
            style: Theme.of(context).textTheme.display1.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10.0, horizontal: _contentPadding),
            child: Text(
              'You can easily find all subscribed users latest posts here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.display1.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestPosts() {
    return SliverToBoxAdapter(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionLabel(label: 'Latest Posts'),
        Container(
          height: 260.0,
          child: StreamBuilder<List<Post>>(
              stream: _latestPostBloc.latestPosts,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(strokeWidth: 2.0));
                }

                final List<Post> _posts = snapshot.data;

                return _posts.length == 0
                    ? _buildNoPosts()
                    : ListView.builder(
                        itemCount: snapshot.data.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (contex, index) {
                          final Post _post = _posts[index];

                          return Row(
                            children: <Widget>[
                              index == 0 ? SizedBox(width: 20.0) : Container(),
                              PostCardLarge(post: _post),
                              SizedBox(width: 10.0),
                            ],
                          );
                        },
                      );
              }),
        )
      ],
    ));
  }

  Widget _buildSuggestedPosts({@required double contentPadding}) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildSectionLabel(label: 'Suggested'),
          Container(
            alignment: Alignment(0.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  // Icons.adb,
                  Icons.new_releases,
                  size: 70.0,
                  color: Theme.of(context).primaryColor,
                ),
                Text(
                  'No suggested posts yet',
                  style: Theme.of(context).textTheme.display1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: contentPadding),
                  child: Text(
                    'All recommended and suggested posts will be displayed here',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.display1.copyWith(
                        color: Theme.of(context).primaryColor, fontSize: 15.0),
                  ),
                ),
                SizedBox(height: 20.0)
              ],
            ),
          )
        ],
      ),
    );

    // return SliverList(
    //   delegate: SliverChildListDelegate([
    //     _buildSectionLabel(label: 'Suggested'),
    //     SizedBox(
    //       height: 150.0,
    //       width: 200.0,
    //       child: Card(),
    //     ),
    //     SizedBox(
    //       height: 150.0,
    //       width: 200.0,
    //       child: Card(),
    //     ),
    //     SizedBox(
    //       height: 150.0,
    //       width: 200.0,
    //       child: Card(),
    //     ),
    //     SizedBox(
    //       height: 150.0,
    //       width: 200.0,
    //       child: Card(),
    //     ),
    //     SizedBox(
    //       height: 150.0,
    //       width: 200.0,
    //       child: Card(),
    //     ),
    //   ]),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        _buildSliverAppBar(),
        SliverToBoxAdapter(child: PageIndicator()),
        _buildLatestPosts(),
        _buildSuggestedPosts(contentPadding: _contentPadding),
        SliverToBoxAdapter(child: SizedBox(height: 130.0)),
      ],
    );
  }
}
