import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _activeTabIndex = 0;

  final PanelController _panelController = PanelController();

  ScrollController _scrollController;
  ScrollController _libraryTabScrollController;
  // final _scrollThreshold = 5000.0;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
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
        child: SlidingUpPanel(
          minHeight: 50.0,
          renderPanelSheet: false,
          controller: _panelController,
          panel: _floatingPanel(),
          collapsed: _floatingCollapsed(),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: _buildTabBody(),
          ),
        ),
      ),
    );
  }
}
