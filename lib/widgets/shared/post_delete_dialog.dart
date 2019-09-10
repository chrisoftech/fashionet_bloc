import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class PostDeleteDialog extends StatefulWidget {
  final Post post;

  const PostDeleteDialog({Key key, @required this.post}) : super(key: key);

  @override
  _PostDeleteDialogState createState() => _PostDeleteDialogState();
}

class _PostDeleteDialogState extends State<PostDeleteDialog> {
  PostFormBloc _postFormBloc;
  BookmarkBloc _bookmarkBloc;
  Post get _post => widget.post;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _postFormBloc = PostFormProvider.of(context);
    _bookmarkBloc = BookmarkProvider.of(context);
  }

  Widget _buildDialogIcon() {
    return Icon(
      Icons.delete_outline,
      color: Colors.black12,
      size: 80.0,
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
    if (!mounted) return;

    Flushbar(
      icon: icon,
      title: title,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void deletePost() async {
    final ReturnType _isDeleted = await _postFormBloc.deletePost(post: _post);

    if (_isDeleted.returnType) {
      // _bookmarkBloc.fetchBookmarks();
      await _bookmarkBloc.removeFromBookmarks(post: _post);
      Navigator.pop(context, true);
    } else {
      final _icon = Icon(Icons.error_outline, color: Colors.red);

      _showSnackbar(icon: _icon, title: 'Error', message: _isDeleted.messagTag);
    }
  }

  Widget _buidlDeleteButton() {
    return StreamBuilder<PostFormState>(
        stream: _postFormBloc.postFormState,
        builder: (context, snapshot) {
          return Flexible(
            child: RaisedButton(
              onPressed: snapshot.data == PostFormState.Loading
                  ? null
                  : () => deletePost(),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).accentColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              child: snapshot.data == PostFormState.Loading
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
      // width: 400.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              Text('Are you sure of deleting'),
              Text('${_post.title}?',
                  style: TextStyle(fontWeight: FontWeight.bold)),
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
      height: 160.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(80.0),
            bottomLeft: Radius.circular(80.0),
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
