import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';

class LibraryTab extends StatefulWidget {
  final ScrollController scrollController;
  final ScrollController tabScrollController;

  const LibraryTab(
      {Key key,
      @required this.scrollController,
      @required this.tabScrollController})
      : super(key: key);
  @override
  _LibraryTabState createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab>
    with SingleTickerProviderStateMixin {
  ScrollController get _scrollController => widget.scrollController;
  ScrollController get _tabScrollController => widget.tabScrollController;
  TabController _tabController;

  initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Theme.of(context).primaryColor,
      labelStyle: Theme.of(context)
          .textTheme
          .display2
          .copyWith(fontSize: 15.0, fontWeight: FontWeight.bold),
      tabs: <Widget>[
        Tab(
          child: Text('Bookmarked'),
        ),
        Tab(
          child: Text('Followers'),
        ),
        Tab(
          child: Text('Notifications'),
        ),
      ],
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text('Library',
          style: Theme.of(context).textTheme.display2.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold)),
      bottom: _buildTabBar(),
    );
  }

  Widget _buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: <Widget>[
        BookmarkedTab(),
        FollowersTab(),
        NotificationsTab(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildTabBarView(),
    );
  }
}
