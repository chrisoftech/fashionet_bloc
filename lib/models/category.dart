import 'package:meta/meta.dart';

class Category {
  final String categoryId;
  final String title;
  final String description;
  final dynamic created;
  final dynamic lastUpdate;

  Category(
      {@required this.categoryId,
      @required this.title,
      @required this.description,
      @required this.created,
      @required this.lastUpdate});
}
