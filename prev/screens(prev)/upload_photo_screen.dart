import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({Key? key}) : super(key: key);

  @override
  _UploadPhotoScreenState createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _showConfirmationDialog();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Upload'),
          content: const Text('Do you want to upload this image?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Upload'),
              onPressed: () {
                Navigator.of(context).pop();
                _saveImageLocally();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveImageLocally() async {
    if (_image == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final directory = await getApplicationDocumentsDirectory();
      final uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}${path.extension(_image!.path)}';
      final savedImage = await _image!.copy('${directory.path}/$uniqueFileName');

      setState(() {
        _isUploading = false;
        _image = null; // ✅ Reset image so user can add another one immediately
      });

      _showSuccessSnackBar('Image saved successfully!');
    } catch (e) {
      setState(() {
        _isUploading = false;
      });
      _showErrorSnackBar('Error saving image: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Photo')),
      body: Center(
        child: _isUploading
            ? const CircularProgressIndicator()
            : SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_image != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Image.file(_image!, height: 300),
                      ),
                    if (_image == null)
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text('No image selected.'),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Select from Gallery'),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Take a Photo'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
