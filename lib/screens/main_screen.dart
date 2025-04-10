import 'package:stylesnap/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:stylesnap/screens/settings_screen.dart';
import 'image_upload_screen.dart'; // Replace with your own screen
import 'wardrobe_screen.dart'; // Replace with your own screen
import 'recommendation_screen.dart'; // Replace with your own screen

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    RecommendationsScreen(),
    ImageUploadScreen(), 
    WardrobeScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white, // Solid background color
        elevation: 10, // Gives a floating effect
        selectedItemColor: Colors.purple, // Highlight selected tab
        unselectedItemColor: Colors.grey, // Keep others gray
        showUnselectedLabels: true, // Show labels for all tabs
        type: BottomNavigationBarType.fixed, // Prevents shifting effect
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_travel), label: "Reccomendations"),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: "upload"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Wardrobe"),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
