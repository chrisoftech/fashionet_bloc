import 'package:fashionet_bloc/consts/consts.dart';
import 'package:fashionet_bloc/pages/pages.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:country_code_picker/country_code_picker.dart';

enum AuthMode { Login, SignUp }

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  TapGestureRecognizer _tapGestureRecognizer;

  AuthMode _authMode = AuthMode.Login;

  CountryCode _selectedCountryCode;

  @override
  void initState() {
    super.initState();

    _tapGestureRecognizer = TapGestureRecognizer()..onTap = _handleTap;
  }

  @override
  void dispose() {
    _tapGestureRecognizer.dispose();
    super.dispose();
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

  Widget _buildPhoneNumberTextField() {
    return Row(
      children: <Widget>[
        CountryCodePicker(
          onChanged: (CountryCode countryCode) {
            _selectedCountryCode = countryCode;
          },
          initialSelection: '+233',
          favorite: ['+233'],
          showCountryOnly: false,
          // padding: EdgeInsets.only(top: 15.0),
          padding: EdgeInsets.only(top: 3.0, right: 2.0),
          textStyle: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 17.0,
              fontWeight: FontWeight.bold),
        ),
        Flexible(
          child: TextField(
            keyboardType: TextInputType.phone,
            style: TextStyles.textFieldTextStyle,
            decoration: InputDecoration(hintText: 'Enter Phone number'),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTextField() {
    return TextField(
      obscureText: true,
      style: TextStyles.textFieldTextStyle,
      decoration: InputDecoration(labelText: 'Password'),
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return _authMode == AuthMode.Login
        ? Container()
        : TextField(
            obscureText: true,
            style: TextStyles.textFieldTextStyle,
            decoration: InputDecoration(labelText: 'Confirm Password'),
          );
  }

  void submitForm() {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => ProfileFormPage()));
  }

  Widget _buildActionButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: RaisedButton(
        onPressed: () => submitForm(),
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
              Icon(Icons.arrow_forward_ios,
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

  Widget _buildForm() {
    return Column(
      children: <Widget>[
        _buildFormTitle(),
        SizedBox(height: 30.0),
        _buildPhoneNumberTextField(),
        SizedBox(height: 10.0),
        _buildPasswordTextField(),
        SizedBox(height: 10.0),
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
        body: SafeArea(
          child: Container(
            alignment: Alignment(0.0, 0.0),
            padding: EdgeInsets.only(
                top: 30.0, right: _contentPadding, left: _contentPadding),
            child: SingleChildScrollView(child: _buildForm()),
          ),
        ),
      ),
    );
  }
}
