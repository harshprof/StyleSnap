import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class MyWardrobeScreen extends StatefulWidget {
  const MyWardrobeScreen({Key? key}) : super(key: key);

  @override
  _MyWardrobeScreenState createState() => _MyWardrobeScreenState();
}

class _MyWardrobeScreenState extends State<MyWardrobeScreen> {
  List<File> _savedImages = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final directory = await getApplicationDocumentsDirectory();
    final imageDirectory = Directory(directory.path);
    final List<FileSystemEntity> files = imageDirectory.listSync();

    setState(() {
      _savedImages = files
          .whereType<File>()
          .where((file) => file.path.endsWith('.png') || file.path.endsWith('.jpg'))
          .toList();
    });
  }

  Future<void> _removeImage(int index) async {
    try {
      await _savedImages[index].delete();
      setState(() {
        _savedImages.removeAt(index);
      });
    } catch (e) {
      print('Error deleting image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Wardrobe')),
      body: _savedImages.isEmpty
          ? const Center(child: Text('No images in wardrobe.'))
          : GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _savedImages.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'image_$index',
                      child: Image.file(
                        _savedImages[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmation(index),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _removeImage(index);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
