import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends InheritedWidget {
  final AuthBloc bloc;

  AuthProvider({Key key, Widget child})
      : bloc = AuthBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static AuthBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider)
        .bloc;
  }
}
