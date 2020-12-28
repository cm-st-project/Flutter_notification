import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Server {
  FirebaseFirestore _db;
  final databaseReference = FirebaseDatabase().reference();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  FirebaseAuth _firebaseAuth;

  Server() {
    _init();
  }
  _init() async {
    await Firebase.initializeApp().then((value) {
      _db = FirebaseFirestore.instance;
      _firebaseAuth = FirebaseAuth.instance;
    });
  }

  Future<String> signIn(String email, String password) async {
    var user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password)).user;
    return user.uid;
  }

  Future<String> signUpWithProfile(String email, String password, String name) async {
    var user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password)).user;
    databaseReference.reference().child("/users/" + user.uid + "/name").set(name);
    return user.uid;
  }

  Future<String> updateName(String name) async {
    print('reset name:' + name);
    var user =  _firebaseAuth.currentUser;
    databaseReference.reference().child("/users/" + user.uid + "/name").set(name);
    return user.toString();
  }

  Future<String> resetPassword(String email, String newPassword) async {
    print('reset password: ' + email);
    var user =  _firebaseAuth.currentUser;
    print('email' +user.email);
    if (user.email == email) {
      user.updatePassword(newPassword);
      return user.uid;
    }
    return null;
  }

  Future<String> saveDeviceToken() async {
    await Future.delayed(Duration(seconds: 2));
    var user =   _firebaseAuth.currentUser;
    String fcmToken = await _firebaseMessaging.getToken();

    if (fcmToken != null) {
      var tokenRef =
      _db.collection('user')
          .doc(user.uid)
          .collection('tokens')
          .doc(fcmToken);
      await tokenRef.set({
        'token': fcmToken,
        'createAt': FieldValue.serverTimestamp(),
        'platform': Platform.operatingSystem
      });
    }
    return fcmToken;
  }
}