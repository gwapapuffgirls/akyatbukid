import 'dart:io';
import 'package:akyatbukid/Models/StatusModel.dart';
import 'package:akyatbukid/Services/dataServices.dart';
import 'package:akyatbukid/Services/storageServices.dart';
import 'package:akyatbukid/newsfeed/dropdownButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class AddStatus extends StatefulWidget {
  final String currentUserId;

  const AddStatus ({Key key, this.currentUserId}) : super(key: key);
  @override
  AddStatusState createState() => AddStatusState();
}

class AddStatusState extends State<AddStatus> {
  // TextEditingController writingTextController = TextEditingController();
  final FocusNode _nodeText1 = FocusNode();
  FocusNode writingTextFocus = FocusNode();
  bool _isLoading = false;
  //File _postImageFile;

  String _statusText;
  File _pickedImage;

  handleImageFromGallery() async {
    try {
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if (imageFile != null) {
        setState(() {
          _pickedImage = imageFile;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
        keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
        keyboardBarColor: Colors.white,
        nextFocus: true,
        actions: [
          KeyboardActionsItem(
            displayArrows: false,
            focusNode: _nodeText1,
          ),
          KeyboardActionsItem(focusNode: writingTextFocus, toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () {
                  handleImageFromGallery();
                  print('Select Image');
                  //_getImageandCrop();
                },
                child: Container(
                    color: Colors.grey,
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add_photo_alternate_rounded, size: 28),
                        Text(
                          "Add Image",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    )),
              );
            }
          ])
        ]);
  }

  int _value = 1;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Stack(children: <Widget>[
          KeyboardActions(
            config: _buildConfig(context),
            child: Column(
              children: <Widget>[
                Container(
                  width: size.width,
                  
                  
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14.0, left: 10.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    child:
                                        Image.asset('assets/images/Logo2.png'),
                                  )),
                              Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(5)),
                                  width: 270,
                                  height: 100,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: TextFormField(
                                            autofocus: true,
                                            focusNode: writingTextFocus,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Input your status here',
                                                hintMaxLines: 4),
                                            onChanged: (value) {
                                              _statusText = value;
                                            },
                                            keyboardType:
                                                TextInputType.multiline,
                                            maxLines: null,
                                          ),
                                        ),
                                      ])),
                            ],
                          ),

                          // _postImageFile != null ? Image.file(_postImageFile,fit: Box.fill);

                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(50, 15, 15, 14),
                              child: Container(
                                  padding: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: DropdownMenu()))
                        ]),
                  ),
                ),
              SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: _pickedImage == null
                      ? SizedBox.shrink()
                      : Container(
                          height: 200,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(_pickedImage),
                              )),
                        ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isLoading = true;
                    });
                    if (_statusText != null && _statusText.isNotEmpty) {
                      String image;
                      if (_pickedImage == null) {
                        image = '';
                      } else {
                        image = await StorageService.uploadStatusPicture(
                            _pickedImage);
                      }
                      StatusModel status = StatusModel(
                        text: _statusText,
                        image: image,
                        authorId: widget.currentUserId,
                        likes: 0,
                        comments: 0,
                        timestamp: Timestamp.fromDate(
                          DateTime.now(),
                        ),
                      );
                      DatabaseServices.createStatus(status);
                      Navigator.pop(context);
                    }
                    setState(() {
                      _isLoading = false;
                    });
                  },
                  child: Text('Post'),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green[800],
                      onPrimary: Colors.white,
                      padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      textStyle: TextStyle(
                        fontSize: 16,
                      )),
                ),
                SizedBox(height: 20),
                _isLoading ? CircularProgressIndicator() : SizedBox.shrink()
              ],
            ),
          ),

          //Utils.loadingCircle(_isLoading),
        ]));
  }

  // Future<void> _getImageAndCrop() async {
  //   File imageFileFromGallery = await ImagePicker.pickImage(source: ImageSource.gallery);
  //   if (imageFileFromGallery != null) {
  //     File cropImageFile = await Utils.cropImageFile(imageFileFromGallery);
  //     if (cropImageFile != null) {
  //       setState(() {
  //         _postImageFile = cropImageFile;
  //       });
  //     }
  //   }
  // }
}
