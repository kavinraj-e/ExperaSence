import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:frontend/models/product.dart';

class ApiService {
  static Future<bool> submitData(Product product) async {
    final url = Uri.parse('http://localhost:5000/api/predict');
    final headers = {'Content-Type': 'application/json'};

    final response = await http.post(
      url,
      headers: headers,
      body: json.encode({
        'userId': product.userId,
        'name': product.name,
        'ingredients': product.ingredients,
        'expiryDate': product.expiryDate,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
