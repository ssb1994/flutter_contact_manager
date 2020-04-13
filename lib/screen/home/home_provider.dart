import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/contact.dart';

class HomeProvider with ChangeNotifier {
  Future<List<Contact>> getContactListfromFirebase(String uid) async {
    CollectionReference collectionReference = Firestore.instance
        .collection("contacts")
        .document(uid)
        .collection("contact");
    collectionReference.snapshots().listen((querySnapshot) {

    });
  }
}
