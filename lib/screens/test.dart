import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

class Test extends StatefulWidget {
  const Test({Key key}) : super(key: key);

  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool isLoading = false;

  String imageUrl;
  PickedFile image;
  uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    //Check Permissions

    //Select Image
    image = await _imagePicker.getImage(
        source: ImageSource.gallery, imageQuality: 50);
    var file = File(image.path);

    if (image != null) {
      setState(() {
        isLoading = true;
      });
      //Upload to Firebase
      var snapshot =
          await _firebaseStorage.ref().child('imagess/imageName').putFile(file);
      var downloadUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        imageUrl = downloadUrl;
        isLoading = false;
      });
    } else {
      print('No Image Path Received');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Selected Image'),
            TextButton(
              child: const Text('Upload File'),
              onPressed: uploadImage,
            ),
            const Text('Uploaded Image'),
            imageUrl != null
                ? Image.network(imageUrl)
                : Image.network('https://i.imgur.com/sUFH1Aq.png')
          ],
        ),
      ),
    );
  }
}
