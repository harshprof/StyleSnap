import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _image;
  final picker = ImagePicker();

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Selection'),
          content: const Text('Do you want to upload this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _image = null;
                });
              },
            ),
            TextButton(
              child: const Text('Upload'),
              onPressed: () {
                Navigator.of(context).pop();
                _uploadImage();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      final prefs = await SharedPreferences.getInstance();
      List<String> savedImages = prefs.getStringList('saved_images') ?? [];

      final bytes = await _image!.readAsBytes();
      final base64Image = base64Encode(bytes);
      savedImages.add(base64Image);

      await prefs.setStringList('saved_images', savedImages);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image uploaded successfully!')),
      );

      setState(() {
        _image = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Photo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _image == null
                  ? const Text('No image selected.')
                  : Image.file(_image!, key: UniqueKey()),
            ),
            const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _image == null ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: () => _getImage(ImageSource.gallery),
                child: const Text('Select from Gallery'),
              ),
            ),
            const SizedBox(height: 10),
            AnimatedOpacity(
              opacity: _image == null ? 1.0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: ElevatedButton(
                onPressed: () => _getImage(ImageSource.camera),
                child: const Text('Take a Photo'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

