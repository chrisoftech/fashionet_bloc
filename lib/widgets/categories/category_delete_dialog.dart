import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class CategoryDeleteDialog extends StatefulWidget {
  final Category category;

  const CategoryDeleteDialog({Key key, @required this.category})
      : super(key: key);

  @override
  _CategoryDeleteDialogState createState() => _CategoryDeleteDialogState();
}

class _CategoryDeleteDialogState extends State<CategoryDeleteDialog> {
  CategoryBloc _categoryBloc;
  Category get _category => widget.category;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _categoryBloc = CategoryProvider.of(context);
  }

  Widget _buildDialogIcon() {
    return CircleAvatar(
      radius: 40.0,
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.info_outline,
        color: Colors.white24,
        size: 80.0,
      ),
    );
  }

  Widget _buidlCancelButton() {
    return Flexible(
      child: RaisedButton(
        onPressed: () => Navigator.pop(context, false),
        color: Theme.of(context).primaryColorLight,
        textColor: Theme.of(context).primaryColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Text('Cancel'),
      ),
    );
  }

  void _showSnackbar(
      {@required Icon icon, @required String title, @required String message}) {
    Flushbar(
      icon: icon,
      title: title,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void deleteCategory() async {
    final ReturnType _isDeleted =
        await _categoryBloc.deleteCategory(categoryId: _category.categoryId);

    if (_isDeleted.returnType) {
      Navigator.pop(context, true);
    } else {
      final _icon = Icon(Icons.error_outline, color: Colors.red);

      _showSnackbar(icon: _icon, title: 'Error', message: _isDeleted.messagTag);
    }
  }

  Widget _buidlDeleteButton() {
    return StreamBuilder<CategoryState>(
        stream: _categoryBloc.categoryFormState,
        builder: (context, snapshot) {
          return Flexible(
            child: RaisedButton(
              onPressed: snapshot.data == CategoryState.Loading
                  ? null
                  : () => deleteCategory(),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: snapshot.data == CategoryState.Loading
                  ? SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
                  : Text('Delete'),
            ),
          );
        });
  }

  Widget _buildDialogActionButtons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buidlCancelButton(),
        SizedBox(width: 10.0),
        _buidlDeleteButton(),
      ],
    );
  }

  Widget _buildDialogMessage() {
    return Container(
      padding: EdgeInsets.only(
        top: 30.0,
      ),
      child: Column(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Delete',
                  style: Theme.of(context).textTheme.display2.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: 10.0),
              Text('Are you sure of deleting ${_category.title}?'),
            ],
          ),
          Spacer(),
          _buildDialogActionButtons()
        ],
      ),
    );
  }

  Widget _buildDialogContent() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(75.0),
            bottomLeft: Radius.circular(75.0),
            topRight: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0)),
      ),
      child: Row(
        children: <Widget>[
          _buildDialogIcon(),
          SizedBox(width: 5.0),
          _buildDialogMessage(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(),
      child: _buildDialogContent(),
    );
  }
}
