import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class CategoryCard extends StatefulWidget {
  @override
  _CategoryCardState createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  GlobalKey _menuButtonKey = GlobalKey();

  void _onClickMenu(MenuItemProvider item) {
    if (item.menuTitle == 'Update') {
      print('Update Category');
    } else {
      print('Delete Category');
    }
  }

  void _onStateChanged(bool isShow) {
    print('Menu is ${isShow ? 'Open' : 'Closed'}');
  }

  void _onDismiss() {
    print('Menu is closed');
  }

  void _openCustomMenuOptions() {
    PopupMenu _menu = PopupMenu(
        maxColumn: 1,
        items: [
          MenuItem(
              title: 'Update',
              image: Icon(
                Icons.update,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Delete',
              image: Icon(
                Icons.delete_outline,
                color: Colors.red,
              )),
        ],
        onClickMenu: _onClickMenu,
        stateChanged: _onStateChanged,
        onDismiss: _onDismiss);
    _menu.show(widgetKey: _menuButtonKey);
  }

  Widget _buildCategoryAvatar() {
    return CircleAvatar(
      backgroundColor: Theme.of(context).primaryColorLight,
      child: Center(
        child: Text(
          'S',
          style: Theme.of(context).textTheme.display1.copyWith(
              color: Colors.white70,
              fontSize: 30.0,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildCategoryListTile() {
    return ListTile(
      leading: _buildCategoryAvatar(),
      title: Text('Shoes',
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold)),
      subtitle: Text('This is a collection of shoes category'),
      trailing: IconButton(
        onPressed: _openCustomMenuOptions,
        key: _menuButtonKey,
        icon: Icon(Icons.more_vert),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 5.0,
        child: _buildCategoryListTile(),
      ),
    );
  }
}
