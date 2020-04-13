import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import './profile_provider.dart';

class UpdateProfilePicture extends StatefulWidget {
   String imageUrl;
  final String uid;

  UpdateProfilePicture(this.imageUrl, this.uid);

  @override
  _UpdateProfilePictureState createState() => _UpdateProfilePictureState();
}

class _UpdateProfilePictureState extends State<UpdateProfilePicture> {
  File imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    File selectedImage =
        await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      widget.imageUrl = '';
      imageFile = selectedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change your Profile Picture',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _pickImage();
                  },
                  child: ClipOval(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: widget.imageUrl.isEmpty
                          ? imageFile == null
                              ? Container(
                                  color: Colors.brown,
                                )
                              : Image.file(
                                  imageFile,
                                  fit: BoxFit.fill,
                                )
                          : CircleAvatar(
                              radius: 100,
                              backgroundImage: NetworkImage(widget.imageUrl),
                              backgroundColor: Colors.transparent,
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Visibility(
                  visible: imageFile != null ? true : false,
                  child: Container(
                    width: 150,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });
                        String imageString = await ProfileProvider()
                            .uploadFile(imageFile, widget.uid);
                        if (imageString != null) {
                          Map<String, String> params = {
                            'image_url': imageString
                          };
                          setState(() {
                            _isLoading = false;
                          });
                          final result = await ProfileProvider()
                              .updateUserData(widget.uid, params);
                          if (result) {
                            Navigator.of(context).pop();
                          }
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: Text(
                        'Upload',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Visibility(
            child: Center(
              child: CircularProgressIndicator(),
            ),
            visible: _isLoading,
          )
        ],
      ),
    );
  }
}
