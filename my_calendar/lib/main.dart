import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_calendar/views/auth/authenticate_page.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'helper/helper_functions.dart';
import 'firebase_options.dart';
import 'utils/utils.dart';
import 'views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {
    // Check if auth firebase user is logged in

    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if (value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home:
          _isLoggedIn ? const MyHomePage(title: 'Inicio') : AuthenticatePage(),
    );
  }
}
