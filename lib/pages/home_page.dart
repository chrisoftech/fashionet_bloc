import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = AuthProvider.of(context);
  }

  void _showSnackbar({@required String message}) {
    final snackbar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(child: Text(message)),
            Icon(Icons.info_outline, color: Theme.of(context).accentColor)
          ],
        ),
        duration: new Duration(seconds: 2));
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  void _signOut() async {
    final ReturnType _isSignedOut = await _authBloc.signOutUser();
    if (!_isSignedOut.returnType) {
      _showSnackbar(message: _isSignedOut.messagTag);
    } else {
      print('SignedOut Successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(onPressed: () => _signOut(), icon: Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}
