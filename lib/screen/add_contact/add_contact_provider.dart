import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AddContactProvider {
  final firestoreInstance = Firestore.instance;

  Future<bool> addcontactToFirestore(
      File file, Map<String, String> params, String uid) async {
    try {
      String docName = DateTime.now().millisecondsSinceEpoch.toString();
      params['create_date_time'] = docName;
      params['last_update_on'] = '';
      if (file != null) {
        String fileName = await _uploadFile(file, uid, docName);
        params['image_url'] = fileName;
      } else {
        params['image_url'] = '';
      }
      await firestoreInstance
          .collection("contacts")
          .document(uid)
          .collection("contact")
          .document(docName)
          .setData(params);

      return true;
    } catch (error) {
      return false;
    }
  }

  Future<String> _uploadFile(File file, String uid, String fileName) async {
    final storageRef = FirebaseStorage.instance.ref();
    StorageUploadTask uploadTask = storageRef
        .child("contact_image")
        .child(uid)
        .child(fileName + '.jpg')
        .putFile(file);

    final taskSnapshot = await uploadTask.onComplete;
    final imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl.toString();
  }

  Future<bool> updateContactToFirestore(
      File file, Map<String, String> params, String uid) async {
    String docName = DateTime.now().millisecondsSinceEpoch.toString();
    params['last_update_on'] = docName;
    try {
      if (file != null) {
        String fileName = await _uploadFile(file, uid, params['create_date_time']);
        params['image_url'] = fileName;
      } else {
        params['image_url'] = '';
      }
      await firestoreInstance
          .collection('contacts')
          .document(uid)
          .collection('contact')
          .document(params['create_date_time'])
          .updateData(params);

      return true;
    } catch (error) {
      return false;
    }
  }
}
