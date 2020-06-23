import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

import 'providers/user.dart';

class AddServiceScreen extends StatefulWidget {
  static const String id = 'add_service';
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  // Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
      sourcePath: _imageFile.path,
    );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController locController = TextEditingController();
  int _radioValue;
  String _role = '';
  double rating_ = 1;

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          _role = 'owner';
          break;
        case 1:
          _role = 'employee';
          break;
        case 2:
          _role = 'former employee';
          break;
        case 3:
          _role = 'customer';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<User>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new service'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(32),
              child: _imageFile != null
                  ? Image.file(_imageFile)
                  : Text('No image chosen, please choose one.'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (_imageFile != null) ...[
                  FlatButton(
                    color: Colors.deepOrangeAccent,
                    child: Icon(
                      Icons.crop,
                      color: Colors.white,
                    ),
                    onPressed: _cropImage,
                  ),
                  FlatButton(
                    color: Colors.deepOrangeAccent,
                    child: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    onPressed: _clear,
                  ),
                ]
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                  child: Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                      ),
                      onPressed: () => _pickImage(ImageSource.camera),
                      color: Colors.blue,
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.photo_library,
                      ),
                      onPressed: () => _pickImage(ImageSource.gallery),
                      color: Colors.pink,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              width: 250,
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Name of service'),
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: descController,
                decoration:
                    InputDecoration(hintText: 'Description about service'),
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(hintText: 'Category'),
              ),
            ),
            Container(
              width: 250,
              child: TextField(
                controller: locController,
                decoration: InputDecoration(hintText: 'Location'),
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: Column(
                children: [
                  Text('What\'s your role?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        value: 0,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text('Owner'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 1,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text('Employee'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 2,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text('Former employee'),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 3,
                        groupValue: _radioValue,
                        onChanged: _handleRadioValueChange,
                      ),
                      Text('Customer'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              width: 250,
              child: Column(
                children: [
                  Text('Rating'),
                  SmoothStarRating(
                    allowHalfRating: false,
                    onRated: (v) {
                      setState(() {
                        rating_ = v;
                        print(rating_);
                      });
                    },
                    starCount: 5,
                    rating: rating_,
                    size: 40.0,
                    isReadOnly: false,
                    color: Colors.pink,
                    borderColor: Colors.pink,
                    spacing: 0.0,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(32),
              child: Uploader(
                file: _imageFile,
                user: userData,
                name: nameController.text,
                desc: descController.text,
                category: categoryController.text,
                location: locController.text,
                role: _role,
                rating: rating_,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  final File file;
  final FirebaseUser user;
  final String name;
  final String desc;
  final String category;
  final String location;
  final String role;
  final double rating;

  Uploader({
    Key key,
    this.file,
    this.user,
    this.name,
    this.desc,
    this.category,
    this.location,
    this.role,
    this.rating,
  }) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage =
      FirebaseStorage(storageBucket: 'gs://opin1on8-d41d8.appspot.com');

  StorageUploadTask _uploadTask;

  _startUpload() {
    String filePath = 'services/${widget.name} ${DateTime.now()}.png';

    setState(() {
      _uploadTask = _storage.ref().child(filePath).putFile(widget.file);
    });
  }

  void addService(FirebaseUser userData) async {
    final StorageTaskSnapshot downloadUrl = (await _uploadTask.onComplete);
    final String url = await downloadUrl.ref.getDownloadURL() as String;

    print('URL Is $url');

    Map _rating = {};
    if (widget.rating == 1) {
      _rating['1'] = 1;
      _rating['2'] = 0;
      _rating['3'] = 0;
      _rating['4'] = 0;
      _rating['5'] = 0;
    } else if (widget.rating == 2) {
      _rating['1'] = 0;
      _rating['2'] = 1;
      _rating['3'] = 0;
      _rating['4'] = 0;
      _rating['5'] = 0;
    } else if (widget.rating == 3) {
      _rating['1'] = 0;
      _rating['2'] = 0;
      _rating['3'] = 1;
      _rating['4'] = 0;
      _rating['5'] = 0;
    } else if (widget.rating == 4) {
      _rating['1'] = 0;
      _rating['2'] = 0;
      _rating['3'] = 0;
      _rating['4'] = 1;
      _rating['5'] = 0;
    } else if (widget.rating == 5) {
      _rating['1'] = 0;
      _rating['2'] = 0;
      _rating['3'] = 0;
      _rating['4'] = 0;
      _rating['5'] = 1;
    }

    Map ratedBy = {};
    ratedBy[userData.uid] = widget.rating;

    DocumentReference ref =
        await Firestore.instance.collection("services").add({
      'name': widget.name,
      'description': widget.desc,
      'category': widget.category,
      'location': widget.location,
      'owner': widget.role == 'owner' ? userData.displayName : '',
      'imageUrl': url,
      'added_by': userData.uid,
      'rating': _rating,
      'rated_by': ratedBy,
    });

    print(ref.documentID);
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;
            if (_uploadTask.isComplete) {
              addService(widget.user);
            }
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_uploadTask.isComplete)
                    Text(
                      '🎉Service added🎉',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        height: 2,
                        fontSize: 25,
                      ),
                    ),
                  LinearProgressIndicator(value: progressPercent),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(0)} % ',
                    style: TextStyle(fontSize: 30),
                  ),
                ]);
          });
    } else {
      return FlatButton.icon(
          color: Colors.deepPurpleAccent,
          label: Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.white,
          ),
          onPressed: _startUpload);
    }
  }
}
