import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class SubscriptionTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FollowingBloc _followingBloc = FollowingProvider.of(context);

    Widget _buildLoadingIndicator() {
      return SliverFillRemaining(
          child: Center(child: CircularProgressIndicator(strokeWidth: 2.0)));
    }

    Widget _buildNoSubscriptions() {
      final double _deviceWidth = MediaQuery.of(context).size.width;
      final double _contentMaxWidth =
          _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .80;

      final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

      return SliverFillRemaining(
        child: Container(
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
                'No subscriptions yet',
                style: Theme.of(context).textTheme.display1.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: _contentPadding),
                child: Text(
                  'You are yet to subscribe/follow your favorite posts',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.display1.copyWith(
                      color: Theme.of(context).primaryColor, fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      );
    }

    Widget _buildSliverList({@required List<Profile> profiles}) {
      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              index == 0 ? SizedBox(height: 10.0) : Container(),
              FollowerCard(profile: profiles[index]),
              index == profiles.length - 1
                  ? SizedBox(height: 40.0)
                  : SizedBox(height: 10.0),
            ],
          );
        }, childCount: profiles.length),
      );
    }

    return StreamBuilder<List<Profile>>(
        stream: _followingBloc.followingProfiles,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return _buildLoadingIndicator();
          }

          final List<Profile> _profiles = snapshot.data;

          return _profiles == null || _profiles.length == 0
              ? _buildNoSubscriptions()
              : _buildSliverList(profiles: _profiles);
        });
  }
}
