import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WardrobeScreen extends StatefulWidget {
  @override
  _WardrobeScreenState createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends State<WardrobeScreen> {
  Map<String, List<String>> wardrobe = {};

  @override
  void initState() {
    super.initState();
    _loadWardrobe();
  }

  // 📌 Load images from SharedPreferences
  Future<void> _loadWardrobe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, List<String>> tempWardrobe = {};

    List<String> categories = ["T-Shirt", "Shirt", "Jeans", "Trousers", "Jacket"];
    for (String category in categories) {
      List<String> images = prefs.getStringList(category) ?? [];
      if (images.isNotEmpty) {
        tempWardrobe[category] = images;
      }
    }

    setState(() => wardrobe = tempWardrobe);
  }

  // 📌 Delete Image Function
  Future<void> _deleteImage(String category, String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if (wardrobe.containsKey(category)) {
      List<String> updatedList = List.from(wardrobe[category]!);
      updatedList.remove(imagePath);

      // Update SharedPreferences
      await prefs.setStringList(category, updatedList);

      // Delete File from Storage (Optional)
      File imageFile = File(imagePath);
      if (imageFile.existsSync()) {
        imageFile.delete();
      }

      // Update UI
      setState(() {
        if (updatedList.isEmpty) {
          wardrobe.remove(category);
        } else {
          wardrobe[category] = updatedList;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Image deleted!")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Wardrobe")),
      body: wardrobe.isEmpty
          ? Center(child: Text("No items in wardrobe."))
          : ListView(
              children: wardrobe.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Text(entry.key, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: entry.value.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {
                              _deleteImage(entry.key, entry.value[index]);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Image.file(File(entry.value[index]), width: 100, height: 100, fit: BoxFit.cover),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
    );
  }
}
