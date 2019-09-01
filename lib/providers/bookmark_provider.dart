import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:flutter/widgets.dart';

class BookmarkProvider extends InheritedWidget {
  final BookmarkBloc bloc;

  BookmarkProvider({Key key, Widget child})
      : bloc = BookmarkBloc(),
        super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static BookmarkBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(BookmarkProvider)
            as BookmarkProvider)
        .bloc;
  }
}
