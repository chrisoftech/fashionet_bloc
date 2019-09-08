import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';

class FollowersProvider extends InheritedWidget {
  final FollowersBloc bloc;

  FollowersProvider({Key key, Widget child})
      : bloc = FollowersBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FollowersBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(FollowersProvider)
            as FollowersProvider)
        .bloc;
  }
}
