import 'package:flutter/material.dart';
import 'package:trust_estate_app/pages/login_signup_page.dart';
import 'package:trust_estate_app/services/authentication.dart';
import 'package:trust_estate_app/pages/home_page.dart';

class RootPage extends StatefulWidget {
  RootPage({this.params, this.auth});

  final BaseAuth auth;
  final Map params;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
AuthStatus authStatus = AuthStatus.AuthStatus.NOT_DETERMINED;
String _userId = "";

@override
void initState() {
  super.initState();
  widget.auth.getCurrentUser().then((user) {
    setState(() {
      if (user != null) {
        _userId = user?.uid;
      }
      authStatus =
      user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
    });
  });
}
void _onLoggedIn() {
  widget.auth.getCurrentUser().then((user){
    setState(() {
      _userId = user.uid.toString();
    });
  });
  setState(() {
    authStatus = AuthStatus.LOGGED_IN;

  });
}
void _onSignedOut() {
  setState(() {
    authStatus = AuthStatus.NOT_LOGGED_IN;
    _userId = "";
  });
}

  Widget _waitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO show login or home page depending on user login state

    switch (authStatus){
      case AuthStatus.LOGGED_IN:
        return new LoginSignUpPage(
          auth: widget.auth,
          onSignedIn: _onLoggedIn,
          params: widget.params,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.lenth > 0 && _userId != null){
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            onSignedOut: _onSignedOut,
            params: widget.params,
          );
        }else return _waitingScreen();
        break;
        default:
        return _waitingScreen();
    }
  }
