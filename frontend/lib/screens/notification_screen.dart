import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final List<String> notifications = [
    "Reminder: Paracetamol expires in 2 days!",
    "New medicine added successfully",
    "Check your medicine history for recent updates",
    "System update available for ExpiraSense",
    "Vitamin C has expired!"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: Icon(Icons.notifications_active, color: Colors.red),
              title: Text(notifications[index]),
              subtitle: Text("Time: 10:00 AM"),
            ),
          );
        },
      ),
    );
  }
}
