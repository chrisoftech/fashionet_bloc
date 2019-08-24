import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  int _activeTabIndex;

  Widget _buildTabBody() {
    if (_activeTabIndex == 0) {
      return HomeTab();
    } else if (_activeTabIndex == 1) {
      return ExploreTab();
    }
    return LibraryTab();
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
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: _buildTabBody(),
      ),
    );
  }
}
