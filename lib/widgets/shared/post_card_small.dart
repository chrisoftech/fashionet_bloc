import 'package:flutter/material.dart';

class PostCardSmall extends StatefulWidget {
  @override
  _PostCardSmallState createState() => _PostCardSmallState();
}

class _PostCardSmallState extends State<PostCardSmall> {
  Widget _buildPostImage(
      {@required double contentHeight, @required contentMaxWidth}) {
    return Positioned(
      top: 0.0,
      left: 0.0,
      height: contentHeight - 20.0,
      width: contentMaxWidth * .30,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.asset('assets/images/temp2.jpg', fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildPostPriceTag({@required BuildContext context}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 30.0,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0)),
            // borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(
            'GHC 200.0',
            style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _buildCardDetails(
      {@required double contentHeight, @required contentMaxWidth}) {
    return Positioned(
      right: 0.0,
      bottom: 0.0,
      height: contentHeight - 20.0,
      width: contentMaxWidth - 20.0,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        child: Container(
          padding: EdgeInsets.only(left: contentMaxWidth * .23),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              bottomRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  isThreeLine: true,
                  title: Text('Jean Wears',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      'Dolor aliqua eu cillum consectetur sunt eu incididunt fugiat culpa. Ullamco deserunt cillum ex dolor anim.',
                      overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    tooltip: 'Save this post',
                    icon: Icon(
                      Icons.bookmark_border,
                      color: Theme.of(context).accentColor,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
              Expanded(
                child: ListTile(
                  onTap: () {},
                  title: Text('by John Doe'),
                  subtitle: Text(
                    'Thursday January 15, 2019',
                    // '${DateFormat.yMMMMEEEEd().format(_bookmarkPost.lastUpdate.toDate())}',
                    style: TextStyle(fontSize: 11.0),
                  ),
                  trailing: _buildPostPriceTag(context: context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;
    final double _contentHeight = 170.0;

    return Container(
      height: _contentHeight,
      padding: EdgeInsets.symmetric(horizontal: _contentPadding),
      child: Stack(
        children: <Widget>[
          _buildCardDetails(
              contentHeight: _contentHeight, contentMaxWidth: _contentMaxWidth),
          _buildPostImage(
              contentHeight: _contentHeight, contentMaxWidth: _contentMaxWidth)
        ],
      ),
    );
  }
}
