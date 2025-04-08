import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/login_page.dart';
import 'package:frontend/screens/signup_page.dart';
import 'package:frontend/screens/upload_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ExpiraSense',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupPage(),
        '/home': (context) => HomeScreen(),
        '/upload': (context) => UploadScreen(),
      },
      builder: (context, child) {
        FlutterError.onError = (FlutterErrorDetails details) {
          FlutterError.dumpErrorToConsole(details);
        };
        return child!;
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final username = prefs.getString('username');

    // Navigate based on token or username
    if (token != null && username != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
