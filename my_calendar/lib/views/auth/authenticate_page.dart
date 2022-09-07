import 'package:flutter/material.dart';
import 'package:my_calendar/views/auth/register_page.dart';
import 'package:my_calendar/views/auth/signin_page.dart';

class AuthenticatePage extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {

  bool _showSignIn = true;
  
  void _toggleView() {
    setState(() {
      _showSignIn = !_showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_showSignIn) {
      return SignInPage(toggleView: _toggleView);
    }
    else {
      return RegisterPage(toggleView: _toggleView);
    }
  }
}