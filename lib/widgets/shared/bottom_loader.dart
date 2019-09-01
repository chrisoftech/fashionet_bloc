import 'package:flutter/material.dart';

class BottomLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Center(
            child: SizedBox(
              width: 33,
              height: 33,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }
}
