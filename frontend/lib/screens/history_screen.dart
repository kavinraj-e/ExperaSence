import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> historyItems = [
    "Checked Paracetamol expiry date",
    "Uploaded a new medicine photo",
    "Viewed medicine details",
    "Checked Vitamin C expiry date",
    "Deleted expired medicine entry"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('History')),
      body: ListView.builder(
        itemCount: historyItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.history, color: Colors.blue),
            title: Text(historyItems[index]),
            subtitle: Text("Date: 2025-04-01"),
          );
        },
      ),
    );
  }
}
