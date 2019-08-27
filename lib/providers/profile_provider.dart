import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends InheritedWidget {
  final ProfileBloc bloc;

  ProfileProvider({Key key, Widget child})
      : bloc = ProfileBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ProfileBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(ProfileProvider)
            as ProfileProvider)
        .bloc;
  }
}
