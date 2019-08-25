import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class ExploreTab extends StatefulWidget {
  final ScrollController scrollController;

  const ExploreTab({Key key, @required this.scrollController})
      : super(key: key);
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  ScrollController get _scrollController => widget.scrollController;

  Widget _buildFlexibleSpaceBarTitle() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text('Explore',
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

  Widget _buildSearchField() {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _contentPadding),
      child: Material(
        elevation: 8.0,
        child: Container(
            child: TextField(
          style: Theme.of(context).textTheme.display1.copyWith(
              color: Theme.of(context).primaryColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            suffixIcon: Icon(Icons.mic),
            hintText: 'Search Posts',
            border: UnderlineInputBorder(borderSide: BorderSide.none),
          ),
        )),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      pinned: true,
      elevation: 0.0,
      expandedHeight: 200.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: _buildFlexibleSpaceBar(),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0), child: _buildSearchField()),
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

  Widget _buildCategories() {
    return SliverToBoxAdapter(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildSectionLabel(label: 'Categories'),
        Container(
          height: 100.0,
          child: ListView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return Row(
                children: <Widget>[
                  index == 0 ? SizedBox(width: 20.0) : Container(),
                  CategoryLabel(),
                  SizedBox(width: 10.0),
                ],
              );
            },
          ),
        ),
      ],
    ));
  }

  Widget _buildPostFeed() {
    return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
      return PostCardDefault();
    }, childCount: 10));
  }

  @override
  Widget build(BuildContext context) {
    // final double _deviceWidth = MediaQuery.of(context).size.width;
    // final double _contentMaxWidth =
    //     _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    // final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        _buildSliverAppBar(),
        _buildCategories(),
        SliverToBoxAdapter(child: _buildSectionLabel(label: 'Post Feed')),
        _buildPostFeed(),
      ],
    );
  }
}
