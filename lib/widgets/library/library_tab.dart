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

  Widget _buildFlexibleSpaceBarTitle() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Library',
                  style: Theme.of(context).textTheme.display2.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
            ),
            PageIndicator()
          ],
        ),
      ),
    );
  }

  Widget _buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(background: _buildFlexibleSpaceBarTitle());
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

  Widget _buildBottomTabBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildTabBar(),
            Material(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.filter_list),
                        SizedBox(width: 5.0),
                        Text('Filters'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text('First added'),
                        Icon(Icons.arrow_drop_down),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 220.0,
      backgroundColor: Colors.white,
      flexibleSpace: _buildFlexibleSpaceBar(),
      actions: <Widget>[
        IconButton(
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            iconSize: 30.0,
            icon: Icon(Icons.label_outline))
      ],
      bottom: _buildBottomTabBar(),
    );
  }

  Widget _buildTabBarView() {
    return SliverFillRemaining(
      child: TabBarView(
        controller: _tabController,
        children: <Widget>[
          BookmarkedTab(),
          FollowersTab(),
          NotificationsTab(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[_buildSliverAppBar(), _buildTabBarView()],
    );
  }
}
