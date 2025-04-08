import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRScanner extends StatefulWidget {
  @override
  _OCRScannerState createState() => _OCRScannerState();
}

class _OCRScannerState extends State<OCRScanner> {
  File? _frontImage, _backImage;
  String _medicineName = "Not detected";
  String _expiryDate = "Not detected";
  String _ingredients = "Not detected";
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(bool isFront) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isFront) {
          _frontImage = File(pickedFile.path);
        } else {
          _backImage = File(pickedFile.path);
        }
      });
      _performOCR(File(pickedFile.path), isFront);
    }
  }

  Future<void> _performOCR(File image, bool isFront) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    final inputImage = InputImage.fromFile(image);
    final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);
    
    String extractedText = recognizedText.text;
    
    if (isFront) {
      _extractMedicineName(extractedText);
    } else {
      _extractExpiryAndIngredients(extractedText);
    }

    textRecognizer.close();
  }

  void _extractMedicineName(String text) {
    setState(() {
      _medicineName = text.split("\n").first; // Assume first line is medicine name
    });
  }

  void _extractExpiryAndIngredients(String text) {
    RegExp expiryRegex = RegExp(r'EXP:? (\d{2}/\d{4}|\d{2}-\d{2}-\d{4})'); 
    RegExpMatch? expiryMatch = expiryRegex.firstMatch(text);

    setState(() {
      _expiryDate = expiryMatch != null ? expiryMatch.group(0)! : "Not found";
      _ingredients = text.replaceAll(expiryRegex, "").trim();
    });
  }

  Widget _displayImage(File? imageFile) {
    if (imageFile == null) return Container();
    if (kIsWeb) {
      return Text("Image preview not available on Web");
    }
    return Image.file(imageFile, height: 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Medicine")),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  if (_frontImage != null) _displayImage(_frontImage),
                  ElevatedButton(onPressed: () => _pickImage(true), child: Text("Pick Front Image")),
                ],
              ),
              Column(
                children: [
                  if (_backImage != null) _displayImage(_backImage),
                  ElevatedButton(onPressed: () => _pickImage(false), child: Text("Pick Back Image")),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text("Medicine Name: $_medicineName", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Expiry Date: $_expiryDate", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Ingredients: $_ingredients"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
