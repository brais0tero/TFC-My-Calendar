// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors_in_immutables, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:my_calendar/helper/helper_functions.dart';
import 'package:my_calendar/views/home_view.dart';
import 'package:my_calendar/services/auth_service.dart';
import 'package:my_calendar/services/database_service.dart';
import 'package:my_calendar/shared/constants.dart';
import 'package:my_calendar/shared/loading.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState!.validate()) {
      print(email);
      print(password);
      setState(() {
        _isLoading = true;
      });

      await _auth
          .signInWithEmailAndPassword(email, password)
          .then((result) async {
        if (result != null) {
          print(result.uid);
          QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(email);
          var name = userInfoSnapshot.docs[0].get('fullName');
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(name);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const MyHomePage(title: 'My calendar')));
        } else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            body: Form(
            key: _formKey,
            child: Container(
              color: Colors.black,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Set events",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 30.0),
                      Text("Sign In",
                          style:
                              TextStyle(color: Colors.white, fontSize: 25.0)),
                      SizedBox(height: 20.0),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Email'),
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val!)
                              ? null
                              : "Please enter a valid email";
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Password'),
                        validator: (val) => val!.runes.length < 6
                            ? 'Password not strong enough'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0)),
                            ),
                            child: const Text('Sign In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0)),
                            onPressed: () {
                              _onSignIn();
                            }),
                      ),
                      SizedBox(height: 10.0),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Register here',
                              style: const TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
            ),
          ));
  }
}
