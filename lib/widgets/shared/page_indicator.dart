import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Container(
      padding: EdgeInsets.only(left: 20.0, right: _contentPadding * 8),
      child: Container(
        height: 10.0,
        width: 50.0,
        margin: EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            topRight: Radius.circular(50.0),
          ),
        ),
      ),
    );
  }
}
