import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../../widget/text_form_widget.dart';
import './add_contact_provider.dart';
import '../../model/contact.dart';
import '../../widget/place_search_field.dart';

enum FORM_TYPE { NAME, EMAIL, MOBILE, LOCATION }

class AddContactScreen extends StatefulWidget {
  static const routeName = '/addContactScreen';

  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  File imageFile;
  String imageUrl;
  bool _isLoading = false;
  String placeValue = '';
  GlobalKey<FormState> _formKey = GlobalKey();
  Map<String, String> _addContactParams = {
    'name': '',
    'email': '',
    'mobile': '',
    'location': '',
  };
  String userId;

  Future<void> getUid() async {
    final sharedPref = await SharedPreferences.getInstance();
    userId = sharedPref.get("uid");
  }

  Future<void> _pickImage() async {
    File selectedImage =
        await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageFile = selectedImage;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUid();
  }

  @override
  Widget build(BuildContext context) {
    final Contact contact = ModalRoute.of(context).settings.arguments;
    if (contact != null) {
      _addContactParams['name'] = contact.name;
      _addContactParams['email'] = contact.email;
      _addContactParams['mobile'] = contact.mobile;
      _addContactParams['location'] = contact.location;
      _addContactParams['image_url'] = contact.imageUrl;
      _addContactParams['create_date_time'] = contact.createDate;
      imageUrl = contact.imageUrl;
    }

    Future<void> submitButtonClick() async {
      if (!_formKey.currentState.validate()) {
        return;
      }
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      bool result;
      if (contact == null) {
        result = await AddContactProvider()
            .addcontactToFirestore(imageFile, _addContactParams, userId);
      } else {
        result = await AddContactProvider()
            .updateContactToFirestore(imageFile, _addContactParams, userId);
      }

      setState(() {
        _isLoading = false;
      });
      if (result) {
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Contact'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.all(
                  10,
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pickImage();
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 20,
                        ),
                        child: ClipOval(
                          child: SizedBox(
                              width: 100,
                              height: 100,
                              child: contact != null
                                  ? (imageFile == null
                                      ? (imageUrl == null || imageUrl.isEmpty
                                          ? Container(
                                              color: Colors.brown,
                                            )
                                          : Image.network(
                                              imageUrl,
                                              fit: BoxFit.fill,
                                            ))
                                      : Image.file(
                                          imageFile,
                                          fit: BoxFit.fill,
                                        ))
                                  : (imageFile == null
                                      ? Container(
                                          color: Colors.brown,
                                        )
                                      : Image.file(
                                          imageFile,
                                          fit: BoxFit.fill,
                                        ))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextformFieldWidget(
                      inputType: TextInputType.text,
                      initialValue: contact != null ? contact.name : null,
                      hint: 'Enter your Name',
                      label: 'Name',
                      obscureText: false,
                      validatorFunction: (value) {
                        return _validateTextFormFunction(
                          value,
                          FORM_TYPE.NAME,
                        );
                      },
                      saveFunction: (value) {
                        _addContactParams['name'] = value;
                      },
                      maxLength: null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextformFieldWidget(
                      inputType: TextInputType.emailAddress,
                      hint: 'Enter your Email',
                      initialValue: contact != null ? contact.email : null,
                      label: 'Email',
                      obscureText: false,
                      validatorFunction: (value) {
                        return _validateTextFormFunction(
                          value,
                          FORM_TYPE.EMAIL,
                        );
                      },
                      saveFunction: (value) {
                        _addContactParams['email'] = value;
                      },
                      maxLength: null,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextformFieldWidget(
                      inputType: TextInputType.phone,
                      hint: 'Enter your Mobile',
                      label: 'Mobile',
                      initialValue: contact != null ? contact.mobile : null,
                      obscureText: false,
                      validatorFunction: (value) {
                        return _validateTextFormFunction(
                          value,
                          FORM_TYPE.MOBILE,
                        );
                      },
                      saveFunction: (value) {
                        _addContactParams['mobile'] = value;
                      },
                      maxLength: 10,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    PlaceSearchWidget(
                      location: contact==null?null:contact.location,
                      saveFunction: (value) {
                        _addContactParams['location'] = value;
                      },
                      validatorFunction: (value) {
                        return _validateTextFormFunction(
                          value,
                          FORM_TYPE.LOCATION,
                        );
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 200,
                      height: 45,
                      margin: EdgeInsets.all(10),
                      child: RaisedButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: _isLoading ? null : submitButtonClick,
                        child: Text(
                          'SAVE CONTACT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Visibility(
              visible: _isLoading,
              child: Center(
                child: CircularProgressIndicator(),
              ))
        ],
      ),
    );
  }

  String _validateTextFormFunction(String value, FORM_TYPE formType) {
    if (formType == FORM_TYPE.NAME || formType == FORM_TYPE.MOBILE) {
      if (value.isEmpty) {
        return 'This field can\'t be empty';
      }
    }
    if (formType == FORM_TYPE.MOBILE) {
      if (value.length < 10) {
        return 'Mobile number should have a minimum of 10';
      }
    }
  }
}
