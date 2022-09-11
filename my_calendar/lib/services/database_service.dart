import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/event.dart';

class DatabaseService {
  // Collection reference
  static CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  static CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

// create a new user document
  Future<void> createUserDocument(
      String UID, String email, String fullName) async {
    return await userCollection.doc(UID).set({
      'UID': UID,
      'email': email,
      'fullName': fullName,
      'profilePic':
          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
    });
  }

  // update userdata
  Future updateUserData(String UID, String fullName, String email) async {
    FirebaseAuth.instance.currentUser!.updateDisplayName(fullName);
    return await userCollection
        .doc(UID)
        .set({'fullName': fullName, 'email': email, 'profilePic': ''});
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
  static Future createEvent(Event event) async {
    DocumentReference eventDocRef = await eventCollection.add(event.toJson());
    return eventDocRef.set({"id": eventDocRef.id}, SetOptions(merge: true));
  }

  // Get events
  static Future<List<Event>> getAllUserEvents(String UID) async {
    // Get all user events
    QuerySnapshot snapshot =
        await eventCollection.where('idHost', isEqualTo: UID).get();
       print("Size : ${snapshot.size}");  
    List<Event> events = [];
    snapshot.docs.forEach((doc) {
      // acces to the doc data
      // get doc id
    // object? to Map<String, dynamic>
    Event event = Event.fromJson(doc.data() as Map<String, dynamic>);
      events.add(Event.fromJson(doc.data() as Map<String, dynamic>));
    });
    return events;
  }
  static Future<List<Event>> getlUserEventsForDay(String UID, DateTime day) async {
    // Get all user events
    QuerySnapshot snapshot =
        await eventCollection.where('idHost', isEqualTo: UID).where('startDate', isEqualTo: day).get();
    List<Event> events = [];
    snapshot.docs.forEach((doc) {
    // object? to Map<String, dynamic>
      // events.add(Event.fromJson(doc.data() as Map<String, dynamic>));
    });
    return events;
  }

  static Future<void> updateEvent(Event event) async {
    // Update event
    await eventCollection.doc(event.getId).set(event.toJson());
  }

  static void deleteEvent(Event event) {
    // Delete event
    eventCollection.doc(event.getId).delete();
  }
}
