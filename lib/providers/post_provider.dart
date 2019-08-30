import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';

class PostProvider extends InheritedWidget {
  final PostBloc bloc;

  PostProvider({Key key, Widget child})
      : bloc = PostBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static PostBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PostProvider) as PostProvider)
        .bloc;
  }
}
