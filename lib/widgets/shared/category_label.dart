import 'package:flutter/material.dart';

class CategoryLabel extends StatelessWidget {
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
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Colors.black26,
                        Colors.black,
                        // Theme.of(context).accentColor,
                        // Theme.of(context).primaryColor,
                      ])),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Shoes',
                style: Theme.of(context).textTheme.display1.copyWith(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}
