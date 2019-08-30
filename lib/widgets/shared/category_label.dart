import 'package:fashionet_bloc/models/models.dart';
import 'package:flutter/material.dart';

class CategoryLabel extends StatelessWidget {
  final Category category;

  const CategoryLabel({Key key, @required this.category}) : super(key: key);

  Category get _category => category;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      splashColor: Colors.black54,
      borderRadius: BorderRadius.circular(20.0),
      child: Container(
        height: 80.0,
        width: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment(0.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black26,
              ),
              child: Center(
                child: Text(
                  '${_category.title.substring(0, 1)}',
                  style: Theme.of(context).textTheme.display1.copyWith(
                      color: Colors.white30,
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Container(
              height: 100.0,
              width: 100.0,
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Colors.black26,
              ),
              child: Center(
                child: Text(
                  '${_category.title}',
                  style: Theme.of(context).textTheme.display1.copyWith(
                      color: Colors.white,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
