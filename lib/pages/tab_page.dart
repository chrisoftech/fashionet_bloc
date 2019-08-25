import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _activeTabIndex = 0;

  ScrollController _scrollController;
  ScrollController _libraryTabScrollController;
  final _scrollThreshold = 5000.0;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _libraryTabScrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _libraryTabScrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() async {
    // if (_activeTabIndex == 2) {
    //   await _libraryTabScrollController.animateTo(
    //       _scrollController.position.minScrollExtent,
    //       duration: Duration(milliseconds: 500),
    //       curve: Curves.easeInOut);
    // }
    _scrollController.animateTo(_scrollController.position.minScrollExtent,
        duration: Duration(milliseconds: 1000), curve: Curves.easeInOut);
  }

  // bool _scrollToTopExtent() {
  //   print(_scrollController.position.pixels);
  //   return _scrollController.position.pixels >= _scrollThreshold ? true : false;
  // }

  Widget _builScrollToTopFAB() {
    return Material(
      elevation: 8.0,
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10.0),
      child: InkWell(
        onTap: () => _scrollToTop(),
        splashColor: Colors.black54,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          height: 50.0,
          width: 50.0,
          child: Icon(
            Icons.keyboard_arrow_up,
            color: Theme.of(context).accentColor,
            size: 35.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTabBody() {
    if (_activeTabIndex == 1) {
      return ExploreTab(scrollController: _scrollController);
    } else if (_activeTabIndex == 2) {
      return LibraryTab(
        scrollController: _scrollController,
        tabScrollController: _libraryTabScrollController,
      );
    }
    return HomeTab(scrollController: _scrollController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomTab(
        onActiveTabChanged: (int index) {
          setState(() {
            _activeTabIndex = index;
          });
        },
        activeTabIndex: _activeTabIndex,
      ),
      floatingActionButton: _builScrollToTopFAB(),
      // floatingActionButton: _scrollToTopExtent() ? _builScrollToTopFAB() : null,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _buildTabBody(),
        ),
      ),
    );
  }
}
