import 'package:flutter/material.dart';

class PostCardLarge extends StatefulWidget {
  @override
  _PostCardLargeState createState() => _PostCardLargeState();
}

class _PostCardLargeState extends State<PostCardLarge> {
  Widget _buildPostImage({@required double contentMaxWidth}) {
    return Positioned(
      top: 0.0,
      height: 200.0,
      width: contentMaxWidth,
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/temp5.jpg')))),
      ),
    );
  }

  Widget _buildPostTitle() {
    return Flexible(
      child: ListTile(
        // onTap: () => _navigateToPostDetailsPage(),
        title: Text('Jean Wears',
            overflow: TextOverflow.ellipsis,
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
    );
  }

  Widget _buildPostUser() {
    return Flexible(
      child: ListTile(
        // onTap: () => _navigateToProfilePage(),
        leading: Container(
          height: 45.0,
          width: 45.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.5),
            child:
                Image.asset('assets/avatars/ps-avatar.png', fit: BoxFit.cover),
          ),
        ),
        title: Text('by John Doe', overflow: TextOverflow.ellipsis),
        subtitle: Text('Thursday January 15, 2019',
            // '${DateFormat.yMMMMEEEEd().format(_post.lastUpdate.toDate())}',
            overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Widget _buildPostDetails({@required double contentMaxWidth}) {
    return Positioned(
      bottom: 0.0,
      height: 150.0,
      width: contentMaxWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Container(
          // color: Colors.blue,
          child: Card(
            child: Column(
              children: <Widget>[
                _buildPostTitle(),
                SizedBox(height: 5.0),
                _buildPostUser(),
                SizedBox(height: 20.0)
              ],
            ),
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

    // final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Container(
      height: 250.0,
      width: _contentMaxWidth,
      child: Stack(
        children: <Widget>[
          _buildPostImage(contentMaxWidth: _contentMaxWidth),
          _buildPostDetails(contentMaxWidth: _contentMaxWidth)
        ],
      ),
    );
  }
}
