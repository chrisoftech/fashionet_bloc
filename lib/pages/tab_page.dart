import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  PageController _pageController;
  PageView _pageView;

  int _activeTabIndex;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(keepPage: false);
    _activeTabIndex = _pageController.initialPage;
  }

  Widget _buildPageSample(String pageTitle) {
    return Container(
      child: Center(
        child: Text('$pageTitle', style: Theme.of(context).textTheme.display1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _pageView = PageView(
      controller: _pageController,
      physics: BouncingScrollPhysics(),
      onPageChanged: (int index) {
        setState(() {
          _activeTabIndex = index;
        });
      },
      children: <Widget>[
        _buildPageSample('Home'),
        _buildPageSample('Explore'),
        _buildPageSample('Library')
      ],
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Home',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontSize: 25.0,
                fontWeight: FontWeight.w900)),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              color: Theme.of(context).primaryColor,
              iconSize: 25.0,
              icon: Icon(Icons.settings))
        ],
      ),
      bottomNavigationBar: BottomTab(
        onActiveTabChanged: (int index) {
          setState(() {
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          });
        },
        activeTabIndex: _activeTabIndex,
      ),
      body: _pageView,
    );
  }
}
