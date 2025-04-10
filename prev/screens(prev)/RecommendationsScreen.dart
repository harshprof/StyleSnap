import 'package:flutter/material.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({Key? key}) : super(key: key);

  @override
  _RecommendationScreenState createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  List<Map<String, String>> outfits = [
    {"image": "assets/outfit1.jpg", "description": "Casual summer outfit"},
    {"image": "assets/outfit2.jpg", "description": "Formal evening wear"},
    // Add more outfits here
  ];
  int currentIndex = 0;

  void _handleLike() {
    _showFeedback("Liked");
  }

  void _handleDislike() {
    _showFeedback("Disliked");
  }

  void _showFeedback(String feedback) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You $feedback this outfit.')),
    );
    setState(() {
      if (currentIndex < outfits.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0; // Restart the list
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Recommendations')),
        body: const Center(child: Text('No outfits to recommend.')),
      );
    }

    final outfit = outfits[currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Card(
              margin: const EdgeInsets.all(16.0),
              elevation: 8.0,
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(
                      outfit["image"]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      outfit["description"]!,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_down, color: Colors.red, size: 40),
                onPressed: _handleDislike,
              ),
              IconButton(
                icon: const Icon(Icons.thumb_up, color: Colors.green, size: 40),
                onPressed: _handleLike,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
