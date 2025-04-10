import 'package:flutter/material.dart';

import 'image_upload_screen.dart';
import 'recommendation_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade700, Colors.pinkAccent.shade200],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Title with Fade-in Effect
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(seconds: 1),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: Text(
                  "Outfit Generator",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 10),

              // Tagline with Fade-in Effect
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: Duration(seconds: 1),
                builder: (context, value, child) => Opacity(
                  opacity: value,
                  child: child,
                ),
                child: Text(
                  "AI-powered outfit suggestions for effortless styling!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
              ),

              SizedBox(height: 40),

              // Upload Outfit Button
              // _buildButton(
              //   text: "Upload Your Outfit",
              //   color: Colors.pinkAccent,
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (_) => ImageUploadScreen()));
              //   },
              // ),

              SizedBox(height: 20),

              // View Recommendations Button
              // _buildButton(
              //   text: "View Outfit Suggestions",
              //   color: Colors.deepPurpleAccent,
              //   onPressed: () {
              //     Navigator.push(context, MaterialPageRoute(builder: (_) => RecommendationsScreen()));
              //   },
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({required String text, required Color color, required VoidCallback onPressed}) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 800),
      builder: (context, value, child) => Transform.scale(
        scale: value,
        child: child,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5,
        ),
        child: Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }
}
