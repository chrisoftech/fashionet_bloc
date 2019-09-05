// import 'package:fashionet_bloc/widgets/shared/shared.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class SubscriptionTabPage extends StatelessWidget {
//   final bool isRefreshing;

//   const SubscriptionTabPage({Key key, @required this.isRefreshing}) : super(key: key);

//   bool get _isRefreshing => isRefreshing;

//   Widget _buildSliverList({@required ProfileBloc profileBloc}) {
//     return SliverList(
//       delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
//         return FollowerCard(
//             profile: profileBloc.profileSubscriptions[index]);
//       }, childCount: profileBloc.profileSubscriptions.length),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<ProfileBloc>(
//         builder: (BuildContext context, ProfileBloc profileBloc, Widget child) {
//       return
//       _isRefreshing ? _buildSliverList(profileBloc: profileBloc) :
//       profileBloc.profileSubscriptionState == ProfileState.Loading
//           ? SliverToBoxAdapter(
//               child: Column(
//                 children: <Widget>[
//                   SizedBox(height: 50.0),
//                   _isRefreshing ? Container() : CircularProgressIndicator(),
//                 ],
//               ),
//             )
//           : profileBloc.profileSubscriptions.length == 0
//               ? SliverToBoxAdapter(
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(height: 50.0),
//                       FlatButton(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           mainAxisSize: MainAxisSize.min,
//                           children: <Widget>[
//                             Icon(Icons.refresh),
//                             Text('refresh'),
//                           ],
//                         ),
//                         onPressed: () {
//                           profileBloc.fetchUserProfileSubscriptions();
//                         },
//                       ),
//                       Text('Sorry! You are not subsribed to any page :('),
//                     ],
//                   ),
//                 )
//               : _buildSliverList(profileBloc: profileBloc);
//     });
//   }
// }

import 'package:flutter/material.dart';

class SubscriptionTabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                  'You can always find your subscriptions here',
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

    return _buildNoSubscriptions();
  }
}
