import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  void logout(BuildContext context) async {
    await _authService.logout();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => logout(context),
          child: Text('Logout'),
        ),
      ),
    );
  }
}
