import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './update_enum.dart';
import '../../widget/text_form_widget.dart';
import './profile_provider.dart';

class UpdateProfileScreen extends StatefulWidget {
  final UPDATE_TYPE_ENUM update_type_enum;
  final String oldValue;
  final String uid;

  UpdateProfileScreen(this.update_type_enum, this.oldValue, this.uid);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  bool _isObscrureType;
  String _updateType;
  bool _isFirstTime = true;
  Map<String, String> updatedParam = {};
  final _formKey = GlobalKey<FormState>();

  Future<void> _updateButtonClick() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    final result = await ProfileProvider().updateUserData(widget.uid, updatedParam);
    if (result) {
      Navigator.of(context).pop();
    }
  }

  String _validateFunction(String value) {
    if (value.isEmpty) {
      return 'This Feild can\'t be empty';
    } else {
      if (widget.update_type_enum == UPDATE_TYPE_ENUM.EMAIL) {
        if (!value.contains('@') || !value.contains('.')) {
          return 'Enter a valid E-Mail Id';
        }
      } else if (widget.update_type_enum == UPDATE_TYPE_ENUM.PASSWORD) {
        if (value.length < 6) {
          return 'Password must have a minimum of 6';
        }
      } else if (widget.update_type_enum == UPDATE_TYPE_ENUM.MOBILE) {
        if (value.length < 10) {
          return 'Mobile number should have a minimum of 10';
        }
      }
    }
  }

  void _onSavedFunction(String value) {
    switch (widget.update_type_enum) {
      case UPDATE_TYPE_ENUM.EMAIL:
        {
          updatedParam = {'email': value};
        }
        break;
      case UPDATE_TYPE_ENUM.NAME:
        {
          updatedParam = {'name': value};
        }
        break;
      case UPDATE_TYPE_ENUM.MOBILE:
        {
          updatedParam = {'mobile': value};
        }
        break;

      default:
        {}
        break;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (_isFirstTime) {
      switch (widget.update_type_enum) {
        case UPDATE_TYPE_ENUM.PASSWORD:
          {
            setState(() {
              _isObscrureType = true;
              _updateType = 'Password';
            });
          }
          break;

        case UPDATE_TYPE_ENUM.EMAIL:
          {
            setState(() {
              _isObscrureType = false;
              _updateType = 'Email';
            });
          }
          break;

        case UPDATE_TYPE_ENUM.MOBILE:
          {
            setState(() {
              _isObscrureType = false;
              _updateType = 'Mobile';
            });
          }
          break;

        case UPDATE_TYPE_ENUM.NAME:
          {
            setState(() {
              _isObscrureType = false;
              _updateType = 'Name';
            });
          }
          break;

        default:
          {}
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Change your $_updateType',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              widget.oldValue,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextformFieldWidget(
                        hint: 'Enter your new $_updateType',
                        label: 'New $_updateType',
                        obscureText: false,
                        saveFunction: _onSavedFunction,
                        validatorFunction: _validateFunction,
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      Container(
                        width: 150,
                        height: 40,
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: _updateButtonClick,
                          child: Text(
                            'UPDATE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
