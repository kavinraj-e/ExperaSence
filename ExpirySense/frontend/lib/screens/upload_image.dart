import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UploadImage extends StatefulWidget {
  @override
  _UploadImageState createState() => _UploadImageState();
}

class _UploadImageState extends State<UploadImage> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future uploadImage() async {
    if (_image == null) return;

    List<int> imageBytes = _image!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse('http://localhost:5000/api/upload'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'image': 'data:image/png;base64,$base64Image'}),
    );

    if (response.statusCode == 200) {
      print('Upload Successful');
    } else {
      print('Upload Failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Medicine Image')),
      body: Column(
        children: [
          _image == null ? Text('No image selected.') : Image.file(_image!),
          ElevatedButton(onPressed: getImage, child: Text('Pick Image')),
          ElevatedButton(onPressed: uploadImage, child: Text('Upload Image')),
        ],
      ),
    );
  }
}
