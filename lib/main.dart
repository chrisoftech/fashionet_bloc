import 'package:bloc/bloc.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/pages/pages.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:popup_menu/popup_menu.dart';

import 'blocs/blocs.dart';
import 'providers/providers.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
    print(error);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    BlocProvider(
      builder: (context) => AuthVerificationBloc()..dispatch(AppStarted()),
      child: AuthProvider(
        child: ProfileProvider(
          child: PostFormProvider(
              child: FollowingProvider(
                  child: BookmarkProvider(
                      child: CategoryProvider(child: MyApp())))),
        ),
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

    return BlocBuilder<AuthVerificationBloc, AuthVerificationState>(
      builder: (context, state) {
        if (state is Uninitialized) {
          return SplashPage();
        }
        if (state is Unauthenticated) {
          return AuthPage();
        }
        if (state is Authenticated) {
          return BlocProvider(
              builder: (context) =>
                  ProfileVerificationBloc()..dispatch(VerifyProfile()),
              child: ProfileDecisionPage());
        }

        return SplashPage();
      },
    );
  }
}

class ProfileDecisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProfileBloc _profileBloc = ProfileProvider.of(context);

    void _showSnackbar(
        {@required Icon icon,
        @required String title,
        @required String message}) {
      // if (!mounted) return;

      Flushbar(
        icon: icon,
        title: title,
        message: message,
        flushbarStyle: FlushbarStyle.FLOATING,
        duration: Duration(seconds: 3),
      )..show(context);
    }

    void _fetchUserProfile() async {
      ReturnType _response = await _profileBloc.fetchCurrentUserProfile();
      if (!_response.returnType) {
        final _icon = Icon(Icons.error_outline, color: Colors.amber);
        _showSnackbar(
            icon: _icon, title: 'Error', message: _response.messagTag);
      }
    }

    return BlocBuilder<ProfileVerificationBloc, ProfileVerificationState>(
      builder: (context, state) {
        if (state is UninitializedProfile) {
          return SplashPage();
        }
        if (state is NoProfile) {
          return ProfileFormPage();
        }
        if (state is HasProfile) {
          _fetchUserProfile(); // fetch current user profile

          return BlocProvider(
            builder: (context) => PostBloc()..onFetchPosts(),
            child: TabPage(),
          );
        }

        return SplashPage();
      },
    );
  }
}
