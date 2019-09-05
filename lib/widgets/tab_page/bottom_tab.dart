import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BottomTab extends StatefulWidget {
  final int activeTabIndex;
  final Function(int) onActiveTabChanged;

  const BottomTab(
      {Key key,
      @required this.activeTabIndex,
      @required this.onActiveTabChanged})
      : super(key: key);
  @override
  _BottomTabState createState() => _BottomTabState();
}

class _BottomTabState extends State<BottomTab> {
  int _activeIndex;

  int get _activeTabIndex => widget.activeTabIndex;
  Function(int) get _onActiveTabChanged => widget.onActiveTabChanged;

  @override
  void initState() {
    _activeIndex = widget.activeTabIndex;
    super.initState();
  }

  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    _activeIndex = _activeTabIndex;
  }

  // double _getItemSize({@required int index}) {
  //   return index == _activeIndex ? 35.0 : 30.0;
  // }

  // Color _getItemColor({@required int index}) {
  //   return index == _activeIndex
  //       ? Theme.of(context).primaryColor
  //       : Colors.grey[300];
  // }

  void _switchTab({@required int index}) {
    setState(() {
      _activeIndex = index;
      _onActiveTabChanged(_activeIndex);
    });
  }

  Widget _buildTabIcon({@required IconData icon, @required int index}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _activeIndex != index
          ? Icon(icon, key: UniqueKey(), color: Colors.grey[300], size: 30.0)
          : Icon(icon,
              key: UniqueKey(),
              color: Theme.of(context).primaryColor,
              size: 35.0),
    );
  }

  Widget _buildTabLabel({@required String title, @required int index}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _activeIndex != index
          ? Text('$title',
              key: UniqueKey(), style: TextStyle(color: Colors.grey[300]))
          : Text('$title',
              key: UniqueKey(),
              style: TextStyle(color: Theme.of(context).primaryColor)),
    );
  }

  Widget _buildTabIndicator({@required int index, @required double itemWidth}) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return ScaleTransition(child: child, scale: animation);
      },
      child: _activeIndex != index
          ? Container(key: UniqueKey())
          : Container(
              key: UniqueKey(),
              height: 5.0,
              width: itemWidth,
              margin: EdgeInsets.only(bottom: 5.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                  )),
            ),
    );
  }

  Widget _buildTabItem(
      {@required int index, @required IconData icon, @required String title}) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _itemWidth = _deviceWidth / 3;

    return InkWell(
      onTap: () => _switchTab(index: index),
      child: Container(
        width: _itemWidth,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10.0),
            _buildTabIcon(icon: icon, index: index),
            _buildTabLabel(title: title, index: index),
            _buildTabIndicator(index: index, itemWidth: _itemWidth)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      color: Colors.transparent,
      child: Container(
        height: 70.0,
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildTabItem(index: 0, icon: Icons.home, title: 'Home'),
              _buildTabItem(index: 1, icon: Icons.search, title: 'Explore'),
              _buildTabItem(
                  index: 2, icon: Icons.bookmark_border, title: 'Library'),
            ],
          ),
        ),
      ),
    );
  }
}
