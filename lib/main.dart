import 'package:flutter/material.dart';
import 'package:flutter_firebase_demo/screen/authenticate/sign_in.dart';
import 'package:provider/provider.dart';

import './screen/authenticate/register.dart';
import './screen/home/home_screen.dart';
import './screen/add_contact/add_contact.dart';
import './places_provider.dart';
import './screen/profile/profile_screen.dart';
import './screen/profile/profile_provider.dart';
import './screen/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PlacesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ProfileProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        routes: {
          RegisterScreen.routeName: (ctx) => RegisterScreen(),
          HomeScreen.routeName: (ctx) => HomeScreen(),
          AddContactScreen.routeName: (context) => AddContactScreen(),
          SignIn.routeName: (ctx) => SignIn(),
          ProfileScreen.routeName: (context) => ProfileScreen(),
        },
      ),
    );
  }
}
