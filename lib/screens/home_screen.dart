import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  bool _isNavBarVisible = false;

  void _toggleNavBar() {
    setState(() {
      _isNavBarVisible = !_isNavBarVisible;
    });
  }

  void _navigateTo(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
    _toggleNavBar();
  }

  Widget _buildCloseButton() {
    return Positioned(
      top: 40,
      right: 10,
      child: AnimatedOpacity(
        opacity: _isNavBarVisible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: _toggleNavBar,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onDoubleTap: _toggleNavBar,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  _buildSection('Upload Photo', Icons.add_a_photo),
                  _buildSection('My Wardrobe', Icons.checkroom),
                  _buildSection('Recommendations', Icons.style),
                ],
              ),
            ),
            _buildNavBar(context),
            _buildCloseButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.blue,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            'AI Fashion Assistant',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Revolutionize your wardrobe',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.blue),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      left: _isNavBarVisible ? 0 : -MediaQuery.of(context).size.width,
      top: 0,
      bottom: 0,
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        color: Colors.blue,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildNavBarItem(context, 'Logout', Icons.logout, () async {
                await _auth.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              }),
              _buildNavBarItem(context, 'Upload Photo', Icons.add_a_photo, () => _navigateTo(context, '/upload')),
              _buildNavBarItem(context, 'My Wardrobe', Icons.checkroom, () => _navigateTo(context, '/wardrobe')),
              _buildNavBarItem(context, 'Recommendations', Icons.style, () => _navigateTo(context, '/recommendations')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavBarItem(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(label, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

