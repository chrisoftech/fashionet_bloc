import 'package:flutter/material.dart';

class FollowersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Container(
      alignment: Alignment(0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.people_outline,
            size: 70.0,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            'No followers yet',
            style: Theme.of(context).textTheme.display1.copyWith(
                color: Theme.of(context).primaryColor,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 10.0, horizontal: _contentPadding),
            child: Text(
              'You can always find your followers here',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.display1.copyWith(
                  color: Theme.of(context).primaryColor, fontSize: 15.0),
            ),
          ),
        ],
      ),
    );
  }
}
