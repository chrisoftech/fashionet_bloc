import 'package:flutter/material.dart';

class LibraryTab extends StatefulWidget {
  final ScrollController scrollController;

  const LibraryTab({Key key, @required this.scrollController})
      : super(key: key);
  @override
  _LibraryTabState createState() => _LibraryTabState();
}

class _LibraryTabState extends State<LibraryTab> {
  ScrollController get _scrollController => widget.scrollController;

  Widget _buildFlexibleSpaceBarTitle() {
    return Text('Library',
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

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;
    return CustomScrollView(
      controller: _scrollController,
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 150.0,
          backgroundColor: Colors.white,
          flexibleSpace: _buildFlexibleSpaceBar(),
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                color: Theme.of(context).primaryColor,
                iconSize: 30.0,
                icon: Icon(Icons.settings))
          ],
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.only(left: 20.0, right: _contentPadding * 8),
              child: Container(
                height: 10.0,
                width: 50.0,
                margin: EdgeInsets.only(bottom: 5.0),
                decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    )),
              ),
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
        )
      ],
    );
  }
}
