import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  LoginScreen({super.key});

  void login(BuildContext context) async {
    final response = await http.post(
      Uri.parse('http://localhost:5000/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email": emailController.text,
        "password": passwordController.text,
      }),
    );

    final data = jsonDecode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data['message'] ?? 'Login error')),
    );

    if (response.statusCode == 200) {
      // Save token and user info in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setString('username', data['user']['name']);
      await prefs.setString('userId', data['user']['id']);

      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 24),
            elevation: 8,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Welcome Back", style: Theme.of(context).textTheme.titleLarge),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => login(context),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Login"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text("Don't have an account? Sign up"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
