import 'package:flutter/material.dart';

import '../model/contact.dart';

class ContactListTile extends StatelessWidget {
  final Contact contact;
  final Function itemClickFunction;

  ContactListTile({this.contact, this.itemClickFunction});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: contact.imageUrl == ''
            ? CircleAvatar(
                radius: 30,
                child: Text(
                  contact.name[0].toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Colors.blue,
              )
            : CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(contact.imageUrl),
                backgroundColor: Colors.transparent,
              ),
        title: Text(contact.name),
        subtitle: Text(contact.mobile),
        onTap: () => itemClickFunction(contact),
      ),
    );
  }
}
