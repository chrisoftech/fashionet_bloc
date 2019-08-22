import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = AuthProvider.of(context);
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(
              onPressed: () => _authBloc.signOutUser(),
              icon: Icon(Icons.exit_to_app))
        ],
      ),
    );
  }
}
