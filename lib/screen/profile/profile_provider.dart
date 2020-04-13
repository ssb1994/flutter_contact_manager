import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import './update_enum.dart';

class ProfileProvider with ChangeNotifier {
  CollectionReference _collectionReference =
      Firestore.instance.collection('users');

  Future<Map<String, dynamic>> getProfileDetails(String uid) async {
    try {
      print('Api ' + _collectionReference.document(uid).path);
      final result = await _collectionReference.document(uid).get();
      print('name ' + result.data.toString());
      return result.data;
      notifyListeners();
    } catch (error) {
      print("result value " + error.toString());
      return null;
    }
  }

  Future<bool> updateUserData(String uid, Map param) async {
    try {
      print(_collectionReference.path);
      print(param.toString());
      await _collectionReference.document(uid).updateData(param);

      return true;
    } catch (error) {
      print("Update value error " + error.toString());
      return false;
    }
  }

  Future<String> uploadFile(File file, String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      StorageUploadTask uploadTask = storageRef
          .child("user_profile_img")
          .child(uid + '.jpg')
          .putFile(file);

      final taskSnapshot = await uploadTask.onComplete;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl.toString();
    } catch (error) {
      return null;
    }
  }
}
