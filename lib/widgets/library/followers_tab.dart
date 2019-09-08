import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class FollowersTab extends StatefulWidget {
  @override
  _FollowersTabState createState() => _FollowersTabState();
}

class _FollowersTabState extends State<FollowersTab> {
  FollowersBloc _followersBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _followersBloc = FollowersProvider.of(context)..fetchFollowers();
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildNoFollowers() {
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

    return StreamBuilder<List<Profile>>(
        stream: _followersBloc.followers,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
          }

          final List<Profile> _profiles = snapshot.data;

          return _profiles.length == 0
              ? _buildNoFollowers()
              : ListView.builder(
                  itemCount: _profiles.length,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final Profile _profile = _profiles[index];

                    return Column(
                      children: <Widget>[
                        index == 0 ? SizedBox(height: 10.0) : Container(),
                        FollowerCard(profile: _profile, showControl: false),
                        index == _profiles.length - 1
                            ? SizedBox(height: 130.0)
                            : SizedBox(height: 10.0),
                      ],
                    );
                  },
                );
        });
  }
}
