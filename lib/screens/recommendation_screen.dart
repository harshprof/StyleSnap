import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationsScreen extends StatefulWidget {
  @override
  _RecommendationsScreenState createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  List<File> tops = [];     // Stores images of T-Shirts/Shirts
  List<File> bottoms = [];  // Stores images of Jeans/Trousers
  List<List<File>> outfitCombinations = [];  // Stores outfit pairs
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadStoredImages();
  }

  // 📌 Load stored image paths from SharedPreferences
  Future<void> _loadStoredImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> topCategories = ["T-Shirt", "Shirt"];
    List<String> bottomCategories = ["Jeans", "Trousers"];

    tops = _getImagesFromPrefs(prefs, topCategories);
    bottoms = _getImagesFromPrefs(prefs, bottomCategories);

    _generateOutfitCombinations();
  }

  // 📌 Retrieve image file paths from SharedPreferences
  List<File> _getImagesFromPrefs(SharedPreferences prefs, List<String> categories) {
    List<File> images = [];
    for (String category in categories) {
      List<String>? paths = prefs.getStringList(category);
      if (paths != null) {
        images.addAll(paths.map((path) => File(path)).toList());
      }
    }
    return images;
  }

  // 📌 Generate all possible outfit combinations
  void _generateOutfitCombinations() {
    outfitCombinations.clear();
    if (tops.isNotEmpty && bottoms.isNotEmpty) {
      for (var top in tops) {
        for (var bottom in bottoms) {
          outfitCombinations.add([top, bottom]);
        }
      }
    }
    setState(() {});
  }

  // 📌 Like Outfit (Store Likes Locally)
  void _likeOutfit() {
    // Store liked outfits in SharedPreferences if needed
    _nextOutfit();
  }

  // 📌 Show Next Outfit
  void _nextOutfit() {
    setState(() {
      if (currentIndex < outfitCombinations.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // Restart when end is reached
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (outfitCombinations.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Outfit Recommendations")),
        body: Center(child: Text("No outfits available. Upload more items!")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Outfit Recommendations")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 📌 Display Top & Bottom Images Side by Side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(outfitCombinations[currentIndex][0], height: 200, width: 150, fit: BoxFit.cover),
              SizedBox(width: 20),
              Image.file(outfitCombinations[currentIndex][1], height: 200, width: 150, fit: BoxFit.cover),
            ],
          ),
          SizedBox(height: 20),
          // 📌 Like/Dislike Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: Icon(Icons.thumb_down, size: 40, color: Colors.red), onPressed: _nextOutfit),
              SizedBox(width: 50),
              IconButton(icon: Icon(Icons.thumb_up, size: 40, color: Colors.green), onPressed: _likeOutfit),
            ],
          ),
        ],
      ),
    );
  }
}
