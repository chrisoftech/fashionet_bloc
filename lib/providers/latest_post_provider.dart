import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';

class LatestPostProvider extends InheritedWidget {
  final LatestPostBloc bloc;

  LatestPostProvider({Key key, Widget child})
      : bloc = LatestPostBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LatestPostBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(LatestPostProvider)
            as LatestPostProvider)
        .bloc;
  }
}
