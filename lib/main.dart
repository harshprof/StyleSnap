import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/upload_photo_screen.dart';
import 'screens/my_wardrobe_screen.dart';
import 'services/auth_service.dart';
import 'utils/custom_page_route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Fashion Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
          buttonColor: Colors.blue,
        ),
      ),
      home: StreamBuilder<User?>(
        stream: _auth.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              return FutureBuilder(
                future: Future.delayed(Duration(seconds: 2)),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return LoginScreen();
                  }
                  return SplashScreen();
                },
              );
            }
            return HomeScreen();
          }
          return SplashScreen();
        },
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return CustomPageRoute(child: LoginScreen());
          case '/signup':
            return CustomPageRoute(child: SignupScreen());
          case '/home':
            return CustomPageRoute(child: HomeScreen());
          case '/upload':
            return CustomPageRoute(child: UploadPhotoScreen());
          case '/wardrobe':
            return CustomPageRoute(child: MyWardrobeScreen());
          case '/recommendations':
            return CustomPageRoute(
              child: Scaffold(
                appBar: AppBar(title: Text('Recommendations')),
                body: Center(child: Text('Recommendations coming soon!')),
              ),
            );
          default:
            return null;
        }
      },
    );
  }
}

