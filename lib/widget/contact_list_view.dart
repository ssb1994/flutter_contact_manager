import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/model/contact.dart';

import './contact_list_tile.dart';

class ContactListView extends StatelessWidget {
  final QuerySnapshot snapshot;
  final Function itemClickFunction;

  ContactListView({this.snapshot, this.itemClickFunction});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.documents.length,
      itemBuilder: (context, index) {
        final docValue = snapshot.documents[index];
        print('imageUrl value' + docValue['image_url']);
        Contact contact = Contact(
          name: docValue['name'],
          email: docValue['email'],
          imageUrl: docValue['image_url'],
          location: docValue['location'],
          mobile: docValue['mobile'],
          createDate: docValue['create_date_time'],
        );
        return ContactListTile(
          contact: contact,
          itemClickFunction: itemClickFunction,
        );
      },
    );
  }
}
