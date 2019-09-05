import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  void _hideKeypad() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      builder: (context) => LoginBloc(),
      child: GestureDetector(
        onTap: _hideKeypad,
        child: Scaffold(body: SafeArea(child: AuthForm())),
      ),
    );
  }
}
