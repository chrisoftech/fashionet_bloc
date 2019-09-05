import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/consts/consts.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthMode { Login, SignUp }

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  TapGestureRecognizer _tapGestureRecognizer;

  AuthMode _authMode = AuthMode.Login;
  // CountryCode _selectedCountryCode;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  AuthBloc _authBloc;
  LoginBloc _loginBloc;

  @override
  void initState() {
    super.initState();

    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handleTap;

    _loginBloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = AuthProvider.of(context);
  }

  void _hideKeypad() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _handleTap() {
    HapticFeedback.vibrate();
    setState(() {
      _authMode == AuthMode.Login
          ? _authMode = AuthMode.SignUp
          : _authMode = AuthMode.Login;
    });
  }

  bool _isLoginButtonEnabled({@required LoginState state}) {
    return !state.isSubmitting;
  }

  Widget _buildFormTitle() {
    return Column(
      children: <Widget>[
        Align(
            alignment: Alignment.topLeft,
            child: Text('FASHIONet', style: TextStyles.headerTextStyle)),
        Align(
            alignment: Alignment.topLeft,
            child: Text(
                'Please, enter credentials to ${_authMode == AuthMode.Login ? 'sign-in' : 'sign-up'} ',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildEmailTextField() {
    return StreamBuilder<String>(
        stream: _authBloc.email,
        builder: (context, snapshot) {
          return Row(
            children: <Widget>[
              Flexible(
                child: TextField(
                  onChanged: _authBloc.onEmailChanged,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyles.textFieldTextStyle,
                  decoration: InputDecoration(
                      labelText: 'Email', errorText: snapshot.error),
                ),
              ),
            ],
          );
        });
  }

  Widget _buildPasswordTextField() {
    return StreamBuilder<String>(
        stream: _authBloc.password,
        builder: (context, snapshot) {
          return TextField(
            obscureText: true,
            onChanged: _authBloc.onPasswordChanged,
            controller: _passwordController,
            style: TextStyles.textFieldTextStyle,
            decoration: InputDecoration(
                labelText: 'Password', errorText: snapshot.error),
          );
        });
  }

  Widget _buildPasswordConfirmTextField() {
    return _authMode == AuthMode.Login
        ? Container()
        : StreamBuilder<String>(
            // stream: _authBloc.confirmPassword,
            builder: (context, snapshot) {
            return TextField(
              obscureText: true,
              // onChanged: _authBloc.onPasswordConfirmChanged,
              style: TextStyles.textFieldTextStyle,
              decoration: InputDecoration(
                  labelText: 'Confirm Password', errorText: snapshot.error),
            );
          });
  }

  // void _showSnackbar({@required String message}) {
  //   final snackbar = SnackBar(
  //       content: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: <Widget>[
  //           Flexible(child: Text(message)),
  //           Icon(Icons.info_outline, color: Theme.of(context).accentColor)
  //         ],
  //       ),
  //       duration: new Duration(seconds: 2));
  //   _scaffoldKey.currentState
  //     ..hideCurrentSnackBar()
  //     ..showSnackBar(snackbar);
  // }

  void _showSnackbar(
      {@required Icon icon, @required String title, @required String message}) {
    if (!mounted) return;

    Flushbar(
      icon: icon,
      title: title,
      message: message,
      flushbarStyle: FlushbarStyle.FLOATING,
      duration: Duration(seconds: 3),
    )..show(context);
  }

  void submitForm() async {
    _hideKeypad();

    _authMode == AuthMode.Login
        ? _loginBloc.dispatch(
            LoginWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text),
          )
        : _loginBloc.dispatch(
            SignUpWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text),
          );

    // final _icon = Icon(Icons.warning, color: Colors.amber);
    // _showSnackbar(
    //     icon: _icon,
    //     title: 'Validation',
    //     message: 'Please select post image(s) to continue!');
    // final ReturnType _isAuthenticated = _authMode == AuthMode.Login
    //     ? await _authBloc.signInUser()
    //     : await _authBloc.signUpUser();

    // if (!_isAuthenticated.returnType) {
    //   _showSnackbar(message: _isAuthenticated.messagTag);
    // }
  }

  Widget _buildActionButton({@required LoginState state}) {
    return Align(
      alignment: Alignment.bottomRight,
      child: RaisedButton(
        onPressed:
            !_isLoginButtonEnabled(state: state) ? null : () => submitForm(),
        color: Theme.of(context).accentColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(_authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold)),
              SizedBox(width: 20.0),
              state.isSubmitting
                  ? SizedBox(
                      height: 20.0,
                      width: 20.0,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    )
                  : Icon(Icons.arrow_forward_ios,
                      size: 18.0, color: Theme.of(context).primaryColor)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthModeSwitcher() {
    return RichText(
      text: TextSpan(
        text: _authMode == AuthMode.Login
            ? 'Don\'t have an account yet?'
            : 'Aready have an account?',
        style: TextStyles.labelTextStyle,
        children: <TextSpan>[
          TextSpan(
              text: _authMode == AuthMode.Login ? ' Sign Up' : ' Login',
              recognizer: _tapGestureRecognizer,
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildForm({@required LoginState state}) {
    return Column(
      children: <Widget>[
        SizedBox(height: 30.0),
        _buildFormTitle(),
        SizedBox(height: 30.0),
        _buildEmailTextField(),
        SizedBox(height: 5.0),
        _buildPasswordTextField(),
        SizedBox(height: 5.0),
        _buildPasswordConfirmTextField(),
        SizedBox(height: 20.0),
        _buildActionButton(state: state),
        SizedBox(height: 60.0),
        _buildAuthModeSwitcher()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.isFailure) {
          final _icon = Icon(Icons.error, color: Colors.red);
          _showSnackbar(icon: _icon, title: 'Error', message: 'Login failure');
        }
        if (state.isSubmitting) {
          final _icon = Icon(Icons.info_outline, color: Colors.green);
          _showSnackbar(
              icon: _icon,
              title: 'Authenticating',
              message: 'Verifying authentication credentials');
        }
        if (state.isSuccess) {
          BlocProvider.of<AuthVerificationBloc>(context)..dispatch(LoggedIn());
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
            alignment: Alignment(0.0, 0.0),
            padding: EdgeInsets.symmetric(horizontal: _contentPadding),
            child: SingleChildScrollView(child: _buildForm(state: state)),
          );
        },
      ),
    );
  }
}
