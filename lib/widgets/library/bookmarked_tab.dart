import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class BookmarkedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final double _deviceWidth = MediaQuery.of(context).size.width;
    // final double _contentMaxWidth =
    //     _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

    // final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    // return Container(
    //   alignment: Alignment(0.0, 0.0),
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: <Widget>[
    //       Icon(
    //         Icons.bookmark_border,
    //         size: 70.0,
    //         color: Theme.of(context).primaryColor,
    //       ),
    //       Text(
    //         'No bookmarks yet',
    //         style: Theme.of(context).textTheme.display1.copyWith(
    //             color: Theme.of(context).primaryColor,
    //             fontSize: 20.0,
    //             fontWeight: FontWeight.bold),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.symmetric(
    //             vertical: 10.0, horizontal: _contentPadding),
    //         child: Text(
    //           'Bookmark posts in Fashionet you love so you can always find them here',
    //           textAlign: TextAlign.center,
    //           style: Theme.of(context).textTheme.display1.copyWith(
    //               color: Theme.of(context).primaryColor, fontSize: 15.0),
    //         ),
    //       ),
    //     ],
    //   ),
    // );

    return ListView.builder(
      itemCount: 10,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: <Widget>[
            index == 0 ? SizedBox(height: 20.0) : Container(),
            PostCardSmall(),
            index == 9 ? SizedBox(height: 130.0) : SizedBox(height: 20.0),
          ],
        );
      },
    );
  }
}
