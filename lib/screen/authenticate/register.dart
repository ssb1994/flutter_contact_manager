import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../home/home_screen.dart';
import '../../widget/text_form_widget.dart';
import '../authenticate/auth_provider.dart';
import '../../places_provider.dart';

enum FORM_TYPE { NAME, EMAIL, PASSWORD, MOBILE }

class RegisterScreen extends StatefulWidget {
  static const routeName = '/to_register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final auth_provider = AuthProvider();
  File imageFile;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _regParms = {
    'name': '',
    'email': '',
    'password': '',
    'mobile': '',
  };
  BuildContext _scaffoldContext;
  bool _isLoading = false;

  Future<void> submitButtonClick() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });

//    final result = auth.registerNewUser(_regParms);
    bool result =
        await auth_provider.createUserWithEmailPassword(imageFile, _regParms);
    setState(() {
      _isLoading = false;
    });
    print(result.toString());
    if (result) {
      Navigator.pushNamedAndRemoveUntil(_scaffoldContext, HomeScreen.routeName,   (Route<dynamic> route) => false);
    } else {
      Scaffold.of(_scaffoldContext).showSnackBar(
        SnackBar(
          content: Text('Enter a valid Email'),
        ),
      );
    }
  }

  String _validateTextFormFunction(String value, FORM_TYPE formType) {
    if (value.isEmpty) {
      return 'This Feild can\'t be empty';
    } else {
      if (formType == FORM_TYPE.EMAIL) {
        if (!value.contains('@') || !value.contains('.')) {
          return 'Enter a valid E-Mail Id';
        }
      } else if (formType == FORM_TYPE.PASSWORD) {
        if (value.length < 6) {
          return 'Password must have a minimum of 6';
        }
      } else if (formType == FORM_TYPE.MOBILE) {
        if (value.length < 10) {
          return 'Mobile number should have a minimum of 10';
        }
      }
    }
  }

  Future<void> _pickImage() async {
    File selectedImage =
        await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      imageFile = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'User Registration',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
      body: Builder(builder: (ctx) {
        _scaffoldContext = ctx;
        return Stack(
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
                      GestureDetector(
                        onTap: () {
                          _pickImage();
                        },
                        child: ClipOval(
                          child: SizedBox(
                            width: 100,
                            height: 100,
                            child: imageFile == null
                                ? Container(
                                    color: Colors.brown,
                                  )
                                : Image.file(
                                    imageFile,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextformFieldWidget(
                        inputType: TextInputType.text,
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
                          _regParms['name'] = value;
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
                        obscureText: false,
                        validatorFunction: (value) {
                          return _validateTextFormFunction(
                            value,
                            FORM_TYPE.MOBILE,
                          );
                        },
                        saveFunction: (value) {
                          _regParms['mobile'] = value;
                        },
                        maxLength: 10,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      TextformFieldWidget(
                        inputType: TextInputType.emailAddress,
                        hint: 'Enter your Email Id',
                        label: 'Email',
                        obscureText: false,
                        validatorFunction: (value) {
                          return _validateTextFormFunction(
                            value,
                            FORM_TYPE.EMAIL,
                          );
                        },
                        saveFunction: (value) {
                          _regParms['email'] = value;
                        },
                        maxLength: null,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextformFieldWidget(
                        inputType: TextInputType.visiblePassword,
                        hint: 'Enter your Password',
                        label: 'Password',
                        obscureText: true,
                        validatorFunction: (value) {
                          return _validateTextFormFunction(
                            value,
                            FORM_TYPE.PASSWORD,
                          );
                        },
                        saveFunction: (value) {
                          _regParms['password'] = value;
                        },
                        maxLength: null,
                      ),
                      SizedBox(
                        height: 30,
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
                            'REGISTER',
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
                child: Center(
              child: CircularProgressIndicator(),
            ))
          ],
        );
      }),
    );
  }
}
