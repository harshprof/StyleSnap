import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyWardrobeScreen extends StatefulWidget {
  const MyWardrobeScreen({Key? key}) : super(key: key);

  @override
  _MyWardrobeScreenState createState() => _MyWardrobeScreenState();
}

class _MyWardrobeScreenState extends State<MyWardrobeScreen> {
  List<String> _savedImages = [];

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedImages = prefs.getStringList('saved_images') ?? [];
    });
  }

  Future<void> _removeImage(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedImages.removeAt(index);
    });
    await prefs.setStringList('saved_images', _savedImages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wardrobe'),
      ),
      body: GridView.builder(
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
                child: Image.memory(
                  base64Decode(_savedImages[index]),
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteConfirmation(context, index),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to remove this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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

