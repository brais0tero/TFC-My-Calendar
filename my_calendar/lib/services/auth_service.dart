// ignore_for_file: unnecessary_null_comparison

import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_calendar/helper/helper_functions.dart';
import 'package:my_calendar/models/user.dart' as localUser;
import 'package:my_calendar/services/database_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  localUser.User? _userFromFirebaseUser(User user) {
    return (user != null) ? localUser.User(uid: user.uid) : null;
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print(result);
      User? user = result.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String fullName, String email, String password) async {
    try {
      // create user in firebase auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        User? user = result.user;
        user!.updateDisplayName(fullName);
        user.reload();
        var usu = _userFromFirebaseUser(user);
        // Add user to database
        await DatabaseService().createUserDocument(user.uid, email, fullName);
        return usu;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      await HelperFunctions.saveUserLoggedInSharedPreference(false);
      await HelperFunctions.saveUserEmailSharedPreference('');
      await HelperFunctions.saveUserNameSharedPreference('');
      // Sign out with firebase
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // remove user
  Future removeUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await DatabaseService().removeUserData(user.uid);
        await user.delete();
        return await _auth.signOut();
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> getLoggedUser() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  getCurrentUserMail() {
    return _auth.currentUser!.email;
  }
}
