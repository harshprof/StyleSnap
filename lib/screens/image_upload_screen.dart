import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? _selectedCategory;
  bool _isUploading = false;

  final List<String> _categories = ["T-Shirt", "Shirt", "Jeans", "Trousers", "Jacket"];

  // 📌 Pick Image from Gallery or Camera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  // 📌 Save Image Path Locally using SharedPreferences
  Future<void> _saveImageLocally() async {
    if (_image == null || _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select an image and category.")));
      return;
    }

    setState(() => _isUploading = true);

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> savedImages = prefs.getStringList(_selectedCategory!) ?? [];
      savedImages.add(_image!.path); // Store file path instead of base64

      await prefs.setStringList(_selectedCategory!, savedImages);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Successful!")));

      setState(() {
        _image = null;
        _selectedCategory = null;
        _isUploading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Upload Failed: $e")));
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Outfit')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null) Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(Icons.camera_alt), onPressed: () => _pickImage(ImageSource.camera)),
                IconButton(icon: Icon(Icons.image), onPressed: () => _pickImage(ImageSource.gallery)),
              ],
            ),
            DropdownButton<String>(
              hint: Text("Select Category"),
              value: _selectedCategory,
              onChanged: (value) => setState(() => _selectedCategory = value),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
            ),
            SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _saveImageLocally, child: Text("Save Image")),
          ],
        ),
      ),
    );
  }
}
