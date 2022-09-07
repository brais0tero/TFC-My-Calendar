import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event.dart';

class DatabaseService {
  final String uid;
  DatabaseService({
    required this.uid
  });

  // Collection reference
  final CollectionReference userCollection =
    FirebaseFirestore.instance.collection('users');
  final CollectionReference eventCollection =
    FirebaseFirestore.instance.collection('events');

  // update userdata
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.doc(uid).set({
      'fullName': fullName,
      'email': email,
      'password': password,
      'profilePic': ''
    });
  }

  // create group
  Future createEvent(String userName, Event event) async {
    DocumentReference eventDocRef = await eventCollection.add(event.toJson());
  }

  // get user data
  Future getUserData(String email) async {

    FirebaseAuth.instance
      .authStateChanges()
      .listen((User ? user) {
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
}