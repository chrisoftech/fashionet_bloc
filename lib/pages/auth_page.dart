import 'package:fashionet_bloc/blocs/blocs.dart';
import 'package:fashionet_bloc/consts/consts.dart';
import 'package:fashionet_bloc/models/models.dart';
import 'package:fashionet_bloc/providers/providers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AuthMode { Login, SignUp }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TapGestureRecognizer _tapGestureRecognizer;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  AuthMode _authMode = AuthMode.Login;
  // CountryCode _selectedCountryCode;

  AuthBloc _authBloc;

  @override
  void initState() {
    super.initState();

    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handleTap;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc = AuthProvider.of(context);
  }

  void _handleTap() {
    HapticFeedback.vibrate();
    setState(() {
      _authMode == AuthMode.Login
          ? _authMode = AuthMode.SignUp
          : _authMode = AuthMode.Login;
    });
  }

  void _hideKeypad() {
    FocusScope.of(context).requestFocus(FocusNode());
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
              // CountryCodePicker(
              //   onChanged: (CountryCode countryCode) {
              //     _selectedCountryCode = countryCode;
              //   },
              //   initialSelection: '+233',
              //   favorite: ['+233'],
              //   showCountryOnly: false,
              //   padding: EdgeInsets.only(
              //       top: snapshot.error == null ? 3.0 : 0.0,
              //       bottom: snapshot.error == null ? 0.0 : 15.0,
              //       right: 2.0),
              //   textStyle: TextStyle(
              //       color: Theme.of(context).primaryColor,
              //       fontSize: 17.0,
              //       fontWeight: FontWeight.bold),
              // ),
              Flexible(
                child: TextField(
                  onChanged: _authBloc.onEmailChanged,
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
            stream: _authBloc.confirmPassword,
            builder: (context, snapshot) {
              return TextField(
                obscureText: true,
                onChanged: _authBloc.onPasswordConfirmChanged,
                style: TextStyles.textFieldTextStyle,
                decoration: InputDecoration(
                    labelText: 'Confirm Password', errorText: snapshot.error),
              );
            });
  }

  void _showSnackbar({@required String message}) {
    final snackbar = SnackBar(
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(child: Text(message)),
            Icon(Icons.info_outline, color: Theme.of(context).accentColor)
          ],
        ),
        duration: new Duration(seconds: 2));
    _scaffoldKey.currentState
      ..hideCurrentSnackBar()
      ..showSnackBar(snackbar);
  }

  void submitForm() async {
    _hideKeypad();
    final ReturnType _isAuthenticated = _authMode == AuthMode.Login
        ? await _authBloc.signInUser()
        : await _authBloc.signUpUser();

    if (!_isAuthenticated.returnType) {
      _showSnackbar(message: _isAuthenticated.messagTag);
    }
  }

  Widget _buildActionButton() {
    return StreamBuilder<bool>(
        stream: _authMode == AuthMode.Login
            ? _authBloc.validateSignIn
            : _authBloc.validateSignUp,
        builder: (context, AsyncSnapshot<bool> validatorSnapshot) {
          return StreamBuilder<LoginState>(
              stream: _authBloc.loginState,
              builder: (context, snapshot) {
                return Align(
                  alignment: Alignment.bottomRight,
                  child: RaisedButton(
                    onPressed: (validatorSnapshot.hasData &&
                            validatorSnapshot.data &&
                            snapshot.data != LoginState.Loading)
                        ? () => submitForm()
                        : null,
                    color: Theme.of(context).accentColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                              _authMode == AuthMode.Login ? 'Login' : 'Sign Up',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(width: 20.0),
                          snapshot.data == LoginState.Loading
                              ? SizedBox(
                                  height: 20.0,
                                  width: 20.0,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.0),
                                )
                              : Icon(Icons.arrow_forward_ios,
                                  size: 18.0,
                                  color: Theme.of(context).primaryColor)
                        ],
                      ),
                    ),
                  ),
                );
              });
        });
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

  Widget _buildForm() {
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
        _buildActionButton(),
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

    return GestureDetector(
      onTap: _hideKeypad,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            alignment: Alignment(0.0, 0.0),
            padding: EdgeInsets.symmetric(horizontal: _contentPadding),
            child: SingleChildScrollView(child: _buildForm()),
          ),
        ),
      ),
    );
  }
}
