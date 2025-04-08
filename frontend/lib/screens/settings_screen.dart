import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored user data

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (route) => false,
    ); // Remove all previous routes and navigate to login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.notifications, color: Colors.green),
            title: Text('Enable Notifications'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
          ListTile(
            leading: Icon(Icons.cloud, color: Colors.orange),
            title: Text('Auto Sync Data'),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blue),
            title: Text('About App'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('About'),
                  content: Text('ExpiraSense - Medicine Expiry Tracker v1.0'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout'),
            onTap: () => logout(context), // Call the logout method
          ),
        ],
      ),
    );
  }
}
