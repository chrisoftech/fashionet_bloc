import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/widgets.dart';

class CategoryProvider extends InheritedWidget {
  final CategoryBloc bloc;

  CategoryProvider({Key key, Widget child})
      : bloc = CategoryBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static CategoryBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(CategoryProvider)
            as CategoryProvider)
        .bloc;
  }
}
