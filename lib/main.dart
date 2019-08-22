import 'package:fashionet_bloc/pages/pages.dart';
import 'package:flutter/material.dart';

import 'blocs/blocs.dart';
import 'models/models.dart';
import 'providers/providers.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'QuickSand',
            primarySwatch: Colors.indigo,
            accentColor: Colors.amber),
        home: DecisionPage(),
      ),
    );
  }
}

class DecisionPage extends StatefulWidget {
  @override
  _DecisionPageState createState() => _DecisionPageState();
}

class _DecisionPageState extends State<DecisionPage> {
  AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = AuthProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _authBloc.authState,
        builder: (context, AsyncSnapshot<AuthState> snapshot) {
          print(snapshot.data.toString());
          if (snapshot.hasData) {
            if (snapshot.data == AuthState.AppStarted) {
              return SplashPage();
            } else if (snapshot.data == AuthState.Authenticated) {
              return HomePage();
            } else {
              return AuthPage();
            }
          }
          return SplashPage();
        });
  }
}
