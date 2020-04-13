import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import './udate_profile_screen.dart';
import './update_enum.dart';
import './profile_provider.dart';
import '../../constants.dart';
import '../authenticate/auth_provider.dart';
import '../authenticate/sign_in.dart';
import './update_profile_picture.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/to_profielScreen';

  @override
  State<StatefulWidget> createState() {
    return _ProfileScreenState();
  }
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = false;
  bool _isFirstTime = true;
  String uid;
  Map<String, String> profileValue = {
    'name': '',
    'email': '',
    'mobile': '',
    'image_url': '',
  };

  Future<void> _getSharedValue() async {
    final sharedPref = await SharedPreferences.getInstance();
    uid = await sharedPref.get('uid');

    _profileApiCall();
  }

  Future<void> _profileApiCall() async {
    setState(() {
      _isLoading = true;
    });
    final result =
        await Provider.of<ProfileProvider>(context).getProfileDetails(uid);
    setState(() {
      _isLoading = false;
      profileValue['name'] = result['name'];
      profileValue['email'] = result['email'];
      profileValue['mobile'] = result['mobile'];
      profileValue['image_url'] = result['image_url'];
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    if (_isFirstTime) {
    _getSharedValue();
//    }
//    _isFirstTime = false;
  }

  void _listTileClickFunction(UPDATE_TYPE_ENUM formType, String oldValue) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UpdateProfileScreen(
          formType,
          oldValue,
          uid,
        ),
      ),
    );
  }

  void _popMenuChoiceAction(String choice) async {
    if (choice == Constants.change_password) {
      _listTileClickFunction(UPDATE_TYPE_ENUM.EMAIL, profileValue['email']);
    }
    if (choice == Constants.sign_out) {
      setState(() {
        _isLoading = true;
      });
      bool result = await AuthProvider().signOutUser();
      setState(() {
        _isLoading = false;
      });
      if (result) {
        FirebaseUser user = await FirebaseAuth.instance.currentUser();
        if (user == null) {
          Navigator.pushNamedAndRemoveUntil(
              context, SignIn.routeName, (Route<dynamic> route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.amber,
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black,
            ),
            onSelected: _popMenuChoiceAction,
            itemBuilder: (BuildContext context) {
              return Constants.profile_constant_list.map((value) {
                return PopupMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.amber,
                  height: 250,
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _circleAvatarWidget(),
                      SizedBox(
                        height: 10,
                      ),
                      _userNameWidget()
                    ],
                  ),
                ),
                _profileItemListTile(
                  'Email',
                  profileValue['email'],
                  null,
                ),
                _profileItemListTile(
                  'Mobile',
                  profileValue['mobile'],
                  () {
                    _listTileClickFunction(
                        UPDATE_TYPE_ENUM.MOBILE, profileValue['mobile']);
                  },
                ),
              ],
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

  Widget _profileItemListTile(
      String title, String subTitle, Function onListItemClick) {
    return Card(
      margin: EdgeInsets.all(10),
      color: Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        subtitle: Text(
          subTitle,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        trailing: title == 'Email'
            ? null
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.edit,
                    color: Colors.grey,
                  )
                ],
              ),
        onTap: onListItemClick,
      ),
    );
  }

  Widget _circleAvatarWidget() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                UpdateProfilePicture(profileValue['image_url'], uid),
          ),
        );
      },
      child: CircleAvatar(
        radius: 50,
        backgroundImage: profileValue['image_url'] != null
            ? NetworkImage(profileValue['image_url'])
            : null,
        child: profileValue['image_url'] != null
            ? null
            : Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _userNameWidget() {
    return GestureDetector(
      onTap: () {
        _listTileClickFunction(UPDATE_TYPE_ENUM.NAME, profileValue['name']);
      },
      child: Row(
        children: <Widget>[
          Text(
            profileValue['name'],
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Icon(
            Icons.edit,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
