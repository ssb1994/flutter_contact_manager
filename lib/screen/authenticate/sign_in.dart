import 'package:flutter/material.dart';

import './register.dart';
import '../home/home_screen.dart';
import '../../widget/text_form_widget.dart';
import '../authenticate/auth_provider.dart';

enum FORM_TYPE { EMAIL, PASSWORD }

class SignIn extends StatefulWidget {
  static const routeName = '/toSignInPage';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final Map<String, String> _loginParams = {
    'email': '',
    'password': '',
  };
  BuildContext _scaffoldContext;
  bool _isLoading = false;

  Future<void> _submitButtonClick() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    final result =
        await AuthProvider().signInUserWithEmailAndPassword(_loginParams);
    setState(() {
      _isLoading = false;
    });
    if (result) {
      Navigator.pushNamedAndRemoveUntil(_scaffoldContext, HomeScreen.routeName,
          (Route<dynamic> route) => false);
    } else {
      Scaffold.of(_scaffoldContext).showSnackBar(SnackBar(
        content: Text('Invalid Email or Password!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    String validatorFunction(String value, FORM_TYPE form_type) {
      if (value.isEmpty) {
        return 'This Field can\'t be empty';
      } else {
        if (form_type == FORM_TYPE.EMAIL) {
          if (!value.contains('@') || !value.contains('.')) {
            return 'Enter a valid E-Mail Id';
          }
        } else {
          if (value.length < 5) {
            return 'Password must have a minimum of 5';
          }
        }
      }
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Builder(builder: (ctx) {
        _scaffoldContext = ctx;
        return Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextformFieldWidget(
                          inputType: TextInputType.emailAddress,
                          maxLength: null,
                          saveFunction: (value) {
                            _loginParams['email'] = value;
                          },
                          validatorFunction: (value) {
                            return validatorFunction(value, FORM_TYPE.EMAIL);
                          },
                          hint: 'Enter your Email Id',
                          label: 'Email',
                          obscureText: false,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextformFieldWidget(
                          inputType: TextInputType.emailAddress,
                          maxLength: null,
                          saveFunction: (value) {
                            _loginParams['password'] = value;
                          },
                          validatorFunction: (value) {
                            return validatorFunction(
                              value,
                              FORM_TYPE.PASSWORD,
                            );
                          },
                          hint: 'Enter your Password',
                          label: 'Password',
                          obscureText: true,
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
                            onPressed: _isLoading ? null : _submitButtonClick,
                            child: Text(
                              'Sign in',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RegisterScreen.routeName);
                          },
                          child: Text(
                            'New user SignUp here',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              child: Center(
                child: CircularProgressIndicator(),
              ),
              visible: _isLoading,
            ),
          ],
        );
      }),
    );
  }
}
