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
  File _image;
  final picker = ImagePicker();
  String _uploadedFileURL;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  bool isLoading = false;
  Future uploadFile() async {
    setState(() {
      isLoading = true;
    });
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference storageReference =
        storage.ref().child('imagess/${Path.basename(_image.path)}}');

    UploadTask uploadTask = storageReference.putFile(_image);
    Future.delayed(Duration(seconds: 2), () {
      storageReference =
          storage.ref().child('imagess/${Path.basename(_image.path)}}');
      uploadTask = storageReference.putFile(_image);
      uploadTask.then((res) {
        uploadTask.snapshot.ref.getDownloadURL();
      });
      storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL = fileURL;
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                children: <Widget>[
                  Text('Selected Image'),
                  _image != null
                      ? Image.file(
                          File(_image.path),
                          height: 150,
                        )
                      : Container(height: 150),
                  _image == null
                      ? TextButton(
                          child: Text('Choose File'),
                          onPressed: getImage,
                        )
                      : Container(),
                  _image != null
                      ? TextButton(
                          child: Text('Upload File'),
                          onPressed: uploadFile,
                        )
                      : Container(),
                  Text('Uploaded Image'),
                  _uploadedFileURL != null
                      ? Image.network(
                          _uploadedFileURL,
                          height: 150,
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }
}
