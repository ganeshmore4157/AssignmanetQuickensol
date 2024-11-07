import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';


class AuthService with ChangeNotifier {
  final String baseURL = "fakerestapi.azurewebsites.net";

  Future<List<dynamic>> getUserList() async {
    final String url = Uri.https(baseURL, '/api/v1/Users').toString();
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error: $error');
      return [];
    }
  }

  Future<bool> updateUser(int id, Map<String, dynamic> updatedData) async {
    final String url = Uri.https(baseURL, '/api/v1/Users/$id').toString();
    try {
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedData),
      );
      return response.statusCode == 200;
    } catch (error) {
      print('Error updating user: $error');
      return false;
    }
  }

  Future<bool> deleteUser(int id) async {
    final String url = Uri.https(baseURL, '/api/v1/Users/$id').toString();
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      return response.statusCode == 200;
    } catch (error) {
      print('Error deleting user: $error');
      return false;
    }
  }
}