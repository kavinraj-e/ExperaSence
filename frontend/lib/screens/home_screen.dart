import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import additional screens
import 'package:frontend/screens/history_screen.dart';
import 'package:frontend/screens/settings_screen.dart';
import 'package:frontend/screens/upload_screen.dart';
import 'package:frontend/screens/notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _username;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onSearchTapped() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Search functionality coming soon!')),
    );
  }

  final List<Widget> _pages = [
    MedicineListScreen(),
    HistoryScreen(),
    UploadScreen(),
    NotificationScreen(),
    SettingsScreen(),
  ];

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 💥 Hides the back arrow
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('ExpiraSense'),
                if (_username != null)
                  Text('Hi, $_username!', style: const TextStyle(fontSize: 12)),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _onSearchTapped,
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_upload), label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}

// ✅ Medicine List Screen
class MedicineListScreen extends StatefulWidget {
  @override
  _MedicineListScreenState createState() => _MedicineListScreenState();
}

class _MedicineListScreenState extends State<MedicineListScreen> {
  bool _isLoading = true;
  List<dynamic> _medicines = [];

  @override
  void initState() {
    super.initState();
    _fetchMedicines();
  }

  Future<void> _fetchMedicines() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:5000/api/predict/get'));

      if (response.statusCode == 200) {
        setState(() {
          _medicines = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        _showError();
      }
    } catch (_) {
      _showError();
    }
  }

  void _showError() {
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to load medicines')),
    );
  }

  Color _getExpiryColor(String status, DateTime expiryDate) {
    return status == 'expired'
        ? Colors.red
        : expiryDate.isBefore(DateTime.now().add(const Duration(days: 3)))
            ? Colors.orange
            : Colors.green;
  }

  String _getExpiryInfo(DateTime expiryDate, String status) {
    if (status == 'expired') return 'Expired';
    final now = DateTime.now();
    final remainingDays = expiryDate.difference(now).inDays;
    return 'Expires in $remainingDays days';
  }

  void _showSideEffectsDialog(BuildContext context, List<dynamic> sideEffects) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Side Effects"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: sideEffects.isNotEmpty
              ? sideEffects.map((effect) => Text("- $effect")).toList()
              : [const Text("No side effects listed")],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _medicines.isEmpty
            ? const Center(child: Text('No medicines found'))
            : ListView.builder(
                itemCount: _medicines.length,
                itemBuilder: (ctx, index) {
                  final medicine = _medicines[index];
                  final expiryDate = DateTime.parse(medicine['expiryDate']);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: Icon(
                          Icons.medical_services,
                          color: _getExpiryColor(medicine['status'], expiryDate),
                        ),
                        title: Text(
                          medicine['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: _getExpiryColor(medicine['status'], expiryDate),
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ingredients: ${medicine['ingredients'].join(', ')}'),
                            Text('Expiry Date: ${expiryDate.toLocal().toString().split(' ')[0]}'),
                            Text(
                              _getExpiryInfo(expiryDate, medicine['status']),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _getExpiryColor(medicine['status'], expiryDate),
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () =>
                              _showSideEffectsDialog(context, medicine['sideEffects']),
                        ),
                      ),
                    ),
                  );
                },
              );
  }
}
