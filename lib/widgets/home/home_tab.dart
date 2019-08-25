import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class HomeTab extends StatefulWidget {
  final ScrollController scrollController;

  const HomeTab({Key key, @required this.scrollController}) : super(key: key);
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  ScrollController get _scrollController => widget.scrollController;

 

  Widget _buildFlexibleSpaceBarTitle() {
    return Text('Home',
        style: Theme.of(context).textTheme.display1.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold));
  }

  Widget _buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      title: _buildFlexibleSpaceBarTitle(),
      titlePadding: EdgeInsets.only(left: 20.0),
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
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            iconSize: 30.0,
            icon: Icon(Icons.settings))
      ],
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
            child: ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              itemBuilder: (contex, index) {
                return Row(
                  children: <Widget>[
                    index == 0 ? SizedBox(width: 20.0) : Container(),
                    PostCardLarge(),
                    SizedBox(width: 10.0),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSuggestedPosts() {
    return SliverList(
      delegate: SliverChildListDelegate([
        _buildSectionLabel(label: 'Suggested'),
        SizedBox(
          height: 150.0,
          width: 200.0,
          child: Card(),
        ),
        SizedBox(
          height: 150.0,
          width: 200.0,
          child: Card(),
        ),
        SizedBox(
          height: 150.0,
          width: 200.0,
          child: Card(),
        ),
        SizedBox(
          height: 150.0,
          width: 200.0,
          child: Card(),
        ),
        SizedBox(
          height: 150.0,
          width: 200.0,
          child: Card(),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      slivers: <Widget>[
        _buildSliverAppBar(),
        SliverToBoxAdapter(child: PageIndicator()),
        _buildLatestPosts(),
        _buildSuggestedPosts()
      ],
    );
  }
}
