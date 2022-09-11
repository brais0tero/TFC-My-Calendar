import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/event.dart';

class DatabaseService {

  // Collection reference
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('test');


// create a new user document
  Future<void> createUserDocument(String UID, String email, String fullName) async {
    return await userCollection.doc(UID).set({
      'UID': UID,
      'email': email,
      'fullName': fullName,
      'profilePic': ''
    });
  }

  // update userdata
  Future updateUserData(String UID, String fullName, String email) async {
    FirebaseAuth.instance.currentUser!.updateDisplayName(fullName);
    return await userCollection.doc(UID).set({
      'fullName': fullName,
      'email': email,
      'profilePic': ''
    });
  }


  // get user data
  Future getUserData(String email) async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        print(user.uid);
      }
    });
    print("user: $User");
    QuerySnapshot snapshot = await userCollection.get();
    var size = snapshot.size;
    print("test: $size");
    return snapshot;
  }

  // remove user data
  Future removeUserData(String UID) async {
    return await userCollection.doc(UID).delete();
  }

  // create Event
  Future createEvent(String userName, Event event) async {
    DocumentReference eventDocRef = await eventCollection.add(event.toJson());
  }

  // Get events
  static Future getUserEvents(String UID) async {
    // Get all user events
    QuerySnapshot snapshot = await eventCollection.get();
    var size = snapshot.size;
    print("test: $size");
    return snapshot;
  }
}
