import 'package:flutter/material.dart';

class PostCardDefault extends StatefulWidget {
  @override
  _PostCardDefaultState createState() => _PostCardDefaultState();
}

class _PostCardDefaultState extends State<PostCardDefault> {
  bool _isFollowing = false;
  bool _isBookmarked = false;

  Widget _buildPostImage() {
    return Container(
      child: Stack(
        children: <Widget>[
          Image.asset('assets/images/temp3.jpg', fit: BoxFit.cover),
        ],
      ),
    );
  }

  Widget _buildFollowTrailingButton() {
    final double _containerHeight = _isFollowing ? 40.0 : 30.0;
    final double _containerWidth = _isFollowing ? 40.0 : 100.0;

    return InkWell(
      onTap: () {
        setState(() {
          _isFollowing = !_isFollowing;
        });
      },
      splashColor: Colors.black38,
      borderRadius: BorderRadius.circular(15.0),
      child: AnimatedContainer(
        height: _containerHeight,
        width: _containerWidth,
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _isFollowing
                ? Container()
                : Flexible(
                    flex: 2,
                    child: Text(
                      'FOLLOW',
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w900),
                    ),
                  ),
            SizedBox(width: _isFollowing ? 0.0 : 5.0),
            Flexible(
              child: Center(
                child: Icon(
                  _isFollowing ? Icons.favorite : Icons.favorite_border,
                  size: 20.0,
                  color: Colors.red,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPostUser() {
    return Flexible(
      child: ListTile(
        leading: Container(
          height: 45.0,
          width: 45.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22.5),
            child:
                Image.asset('assets/avatars/ps-avatar.png', fit: BoxFit.cover),
          ),
        ),
        title: Text('John Doe',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text('Thursday January 15, 2019', overflow: TextOverflow.ellipsis),
        trailing: _buildFollowTrailingButton(),
      ),
    );
  }

  Widget _buildPostTitle() {
    return Flexible(
      child: ListTile(
        title: Text('Jean Wears',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
            'Dolor aliqua eu cillum consectetur sunt eu incididunt fugiat culpa. Ullamco deserunt cillum ex dolor anim.',
            overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              _isBookmarked = !_isBookmarked;
            });
          },
          tooltip: 'Save this post',
          icon: Icon(
            _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  Widget _buildPostDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        _buildPostUser(),
        _buildPostTitle(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // final double _deviceWidth = MediaQuery.of(context).size.width;
    // final double _contentMaxWidth = _deviceWidth > 500.0 ? 500.0 : _deviceWidth;

    // final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return Card(
      elevation: 5.0,
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildPostDetails(),
            _buildPostImage(),
          ],
        ),
      ),
    );
  }
}
