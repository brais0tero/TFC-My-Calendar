import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:my_calendar/helper/helper_functions.dart';
import 'package:my_calendar/main.dart';
import 'package:my_calendar/services/auth_service.dart';

/// My Drawer Slider
class MySlider extends StatelessWidget {
  MySlider({
    Key ? key, required int page
  }): super(key: key);
  final int page = 0;
  // call auth service
  final AuthService _auth = AuthService();

  /// Icons
  List < IconData > icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    Icons.logout,
  ];

   /// Texts
  List < String > texts = [
    "Home",
    "Profile",
    "Logout",
  ];

// set functionality on icon preesed
  void _onIconPressed(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        // Navigator.of(context).pushReplacementNamed('/profile');
        break;
      case 2:
               _auth.signOut();
               Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => MyApp()));
        break;
    }
  }

   /// Build

  @override
  Widget build(BuildContext context) {
    // get user data from shared preferences as variables
    final Future < String ? > name = HelperFunctions.getUserNameSharedPreference();
    final Future < String ? > email = HelperFunctions.getUserEmailSharedPreference();
    final Future < String ? > photpUrl = HelperFunctions.getUserPhotoSharedPreference();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 90),
        decoration: const BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
              ),
            ],
          ),
          child: FutureBuilder < String ? > (
            future: photpUrl,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 20),
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(snapshot.data!),
                          ),
                          const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder < String ? > (
                                  future: name,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
                                       
                                      );
                                    } else {
                                      return const Text("Loading...");
                                    }
                                  }),
                                FutureBuilder < String ? > (
                                  future: email,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        snapshot.data!,
                                      
                                      );
                                    } else {
                                      return const Text("Loading...");
                                    }
                                  }),
                              ],
                            ),
                      ],
                    ),
                    const SizedBox(height: 40),
                      Expanded(
                        child: ListView.builder(
                          itemCount: icons.length,
                          physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, i) {
                              return InkWell(
                                // ignore: avoid_print
                                onTap: () => _onIconPressed(i,ctx),
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                    child: ListTile(
                                      leading: Icon(
                                        icons[i],
                                        color: i == page ? Colors.greenAccent :Colors.white,
                                        size: 30,
                                      ),
                                      title: Text(
                                        texts[i],
                                        style: const  TextStyle(
                                          color:  Colors.white,
                                        ),
                                      )),
                                ),
                              );
                            }),
                      ),
                  ],
                );
              } else {
                return const Text("Loading...");
              }
            }),
    );
  }
}