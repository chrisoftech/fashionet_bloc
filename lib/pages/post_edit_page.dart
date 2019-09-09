import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';

class PostEditPage extends StatefulWidget {
  final Post post;

  const PostEditPage({Key key, @required this.post}) : super(key: key);

  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  Post get _post => widget.post;

  @override
  Widget build(BuildContext context) {
    return PostForm(post: _post);
  }
}
