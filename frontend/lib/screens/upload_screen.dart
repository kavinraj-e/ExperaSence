import 'package:flutter/material.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/models/product.dart';

class UploadScreen extends StatefulWidget {
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  
  bool _isLoading = false;

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final product = Product(
      userId: '123',
      name: _nameController.text,
      ingredients: _ingredientsController.text.split(','),
      expiryDate: _expiryDateController.text,
    );

    final success = await ApiService.submitData(product);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      _showSuccessScreen();
    } else {
      _showErrorScreen();
    }
  }

  void _showSuccessScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Success'),
        content: Text('Data uploaded successfully!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorScreen() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text('Failed to upload data. Please try again later.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredients (comma separated)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ingredients';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date (yyyy-mm-dd)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an expiry date';
                  }
                  final dateRegex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
                  if (!dateRegex.hasMatch(value)) {
                    return 'Invalid date format. Use yyyy-mm-dd';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitData,
                      child: Text('Submit Data'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
