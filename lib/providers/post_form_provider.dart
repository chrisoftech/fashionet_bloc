import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/material.dart';

class PostFormProvider extends InheritedWidget {
  final PostFormBloc bloc;

  PostFormProvider({Key key, Widget child})
      : bloc = PostFormBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static PostFormBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PostFormProvider) as PostFormProvider)
        .bloc;
  }
}
