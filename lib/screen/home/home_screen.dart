import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/contact_list_view.dart';
import '../add_contact/add_contact.dart';
import '../../model/contact.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/to_home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static String uid;
  CollectionReference _collectionReference;

  Future<void> _getUid() async {
    final sharedPref = await SharedPreferences.getInstance();
    setState(() {
      uid = sharedPref.get('uid');
      print('uid value ' + uid);
      _collectionReference = Firestore.instance
          .collection('contacts')
          .document(uid)
          .collection('contact');
    });
  }

  void _editContactValues(Contact contact) {
    Navigator.pushNamed(context, AddContactScreen.routeName,
        arguments: contact);
  }

  @override
  void initState() {
    super.initState();
    _getUid();
  }

  @override
  Widget build(BuildContext context) {
    return _collectionReference == null
        ? Scaffold(
            body: Center(
              child: Text('Currently no contacts added'),
            ),
          )
        : StreamBuilder<QuerySnapshot>(
            stream: _collectionReference.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              print("collection Reference " + _collectionReference.path);
              return Scaffold(
                appBar: AppBar(
                  title: Text('Saved Contacts'),
                  actions: <Widget>[
                    FlatButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                      },
                      icon: Icon(Icons.settings, color: Colors.white,),
                      label: Text('', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
                body: snapshot.hasError
                    ? Center(
                        child: Text(
                          'Something has gone wrong!',
                          textAlign: TextAlign.center,
                        ),
                      )
                    : (snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : (snapshot.data.documents.length <= 0
                            ? Center(
                                child: Text(
                                  'No, contact has been added, add some by clicking + button.',
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ContactListView(
                                snapshot: snapshot.data,
                                itemClickFunction: _editContactValues,
                              ))),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AddContactScreen.routeName,
                        arguments: null);
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: Colors.blue,
                ),
              );
            },
          );
  }
}
