import 'package:bloc/bloc.dart';
import 'package:fashionet_bloc/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_menu/popup_menu.dart';

import 'blocs/blocs.dart';
import 'providers/providers.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    AuthProvider(
      child: ProfileProvider(
        child: PostFormProvider(
            child: FollowingProvider(
                child:
                    BookmarkProvider(child: CategoryProvider(child: MyApp())))),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthBloc _authBloc;
  ProfileBloc _profileBloc;
  PostFormBloc _postFormBloc;
  BookmarkBloc _bookmarkBloc;
  CategoryBloc _categoryBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = AuthProvider.of(context);
    _profileBloc = ProfileProvider.of(context);
    _postFormBloc = PostFormProvider.of(context);
    _bookmarkBloc = BookmarkProvider.of(context);
    _categoryBloc = CategoryProvider.of(context);
  }

  @override
  void dispose() {
    super.dispose();
    _authBloc.dispose();
    _profileBloc.dispose();
    _postFormBloc.dispose();
    _bookmarkBloc.dispose();
    _categoryBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          fontFamily: 'QuickSand',
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber),
      home: AuthDecisionPage(),
      routes: <String, WidgetBuilder>{
        '/categories': (context) => CategoriesPage()
      },
    );
  }
}

class AuthDecisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    AuthBloc _authBloc = AuthProvider.of(context);
    ProfileBloc _profileBloc = ProfileProvider.of(context);

    return StreamBuilder(
        stream: _authBloc.authState,
        builder: (context, AsyncSnapshot<AuthState> snapshot) {
          print('Auth Descision Page ${snapshot.data.toString()}');
          if (snapshot.hasData) {
            if (snapshot.data == AuthState.AppStarted) {
              return SplashPage();
            } else if (snapshot.data == AuthState.Authenticated) {
              _profileBloc.hasProfile();
              return ProfileDecisionPage();
            } else {
              return AuthPage();
            }
          }
          return SplashPage();
        });
  }
}

class ProfileDecisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileBloc _profileBloc = ProfileProvider.of(context);

    return StreamBuilder<ProfileStatus>(
        stream: _profileBloc.profileStatus,
        builder: (context, snapshot) {
          print('Profile Descision Page ${snapshot.data.toString()}');
          if (snapshot.hasData) {
            if (snapshot.data == ProfileStatus.Default) {
              return SplashPage();
            } else if (snapshot.data == ProfileStatus.HasProfile) {
              return BlocProvider(
                builder: (context) => PostBloc()..onFetchPosts(),
                child: TabPage(),
              );
            } else {
              return ProfileFormPage();
            }
          }
          return SplashPage();
        });
  }
}
