import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';

class FollowingProvider extends InheritedWidget {
  final FollowingBloc bloc;

  FollowingProvider({Key key, Widget child})
      : bloc = FollowingBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FollowingBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(FollowingProvider)
            as FollowingProvider)
        .bloc;
  }
}
