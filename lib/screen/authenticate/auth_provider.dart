import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;

  Future<bool> createUserWithEmailPassword(
      File file, Map<String, String> params) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: params['email'], password: params['password']);
      FirebaseUser user = result.user;
      if (result != null) {
        params['uid'] = user.uid;
        if (file != null) {
          final imageUrl = await _uploadProfilePicture(user.uid, file);
          params['image_url'] = imageUrl;
        } else {
          params['image_url'] = '';
        }
        await _registerUserWithEmailPassword(params);
        final sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("uid", result.user.uid);
      } else {
        return false;
      }
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<String> _uploadProfilePicture(String uid, File file) async {
    final storageRef = FirebaseStorage.instance.ref();
    StorageUploadTask uploadTask =
        storageRef.child("user_profile_img").child(uid + '.jpg').putFile(file);

    final taskSnapshot = await uploadTask.onComplete;
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl.toString();
  }

  Future _registerUserWithEmailPassword(Map<String, String> params) async {
    final firestoreInstance = Firestore.instance;
    await firestoreInstance
        .collection('users')
        .document(params['uid'])
        .setData(params);
  }

  Future<bool> signInUserWithEmailAndPassword(
      Map<String, String> params) async {
    try {
      final authResult = await _auth.signInWithEmailAndPassword(
          email: params['email'], password: params['password']);
      if (authResult != null) {
        final sharedPref = await SharedPreferences.getInstance();
        sharedPref.setString("uid", authResult.user.uid);
      } else {
        return false;
      }
      return true;
    } catch (error) {
      return false;
    }
  }

  Future<bool> signOutUser() async {
    try {
      await _auth.signOut();
      return true;
    } catch (error) {
      return false;
    }
  }
}
