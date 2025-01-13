import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class DuprClient {
  static const String _baseUrl = 'https://api.dupr.gg';
  static const String _version = 'v1.0';

  final SharedPreferences _prefs;
  String? _accessToken;

  DuprClient(this._prefs) {
    _loadToken();
  }

  void _loadToken() {
    _accessToken = _prefs.getString('token');
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/$_version/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(
            {'email': email, 'password': password, 'provider': 'DUPR'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['result']['accessToken'];
        return data;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> refreshToken(
      String userId, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/$_version/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'userId': userId,
          'token': token,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['result']['accessToken'];
        return data;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPlayerRatings(
      String userId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/player/$_version/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> verifyToken(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/auth/$_version/verify'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      _accessToken = null;
      await _prefs.remove('token');
      await _prefs.remove('userId');
      return true;
    } catch (e) {
      return false;
    }
  }
}
