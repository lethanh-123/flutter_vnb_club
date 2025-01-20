import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user.dart';
import 'dart:convert';

class AuthService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userKey = 'current_user';
  static const String _tokenExpiryKey = 'token_expiry';
  static const String _tokenTypeKey = 'token_type';

  // Lưu thông tin đăng nhập
  static Future<void> saveLoginInfo(Map<String, dynamic> loginData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = loginData['data'];
      
      // Lưu access token
      await prefs.setString(_tokenKey, data['access_token']);
      
      // Lưu refresh token
      await prefs.setString(_refreshTokenKey, data['refresh_token']);
      
      // Lưu token type
      await prefs.setString(_tokenTypeKey, data['token_type']);
      
      // Lưu thời gian hết hạn
      final expiryTime = DateTime.now().add(
        Duration(seconds: data['expires_in'])
      ).millisecondsSinceEpoch;
      await prefs.setInt(_tokenExpiryKey, expiryTime);
      
      // Lưu thông tin user
      await prefs.setString(_userKey, json.encode(data['user']));
    } catch (e) {
      print('Error saving login info: $e');
      throw Exception('Failed to save login information');
    }
  }

  // Lấy access token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final expiryTime = prefs.getInt(_tokenExpiryKey);

      if (token == null || expiryTime == null) return null;

      final now = DateTime.now().millisecondsSinceEpoch;
      if (now < expiryTime) {
        return token;
      }
      
      // Token hết hạn, dùng refresh token
      return await refreshToken();
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Lấy refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      print('Error getting refresh token: $e');
      return null;
    }
  }

  // Refresh token
  static Future<String?> refreshToken() async {
    try {
      final refreshToken = await getRefreshToken();
      if (refreshToken == null) return null;

      // Gọi API refresh token
      // TODO: Implement refresh token API call
      // final response = await http.post(
      //   Uri.parse('your_refresh_token_endpoint'),
      //   headers: {'Authorization': 'Bearer $refreshToken'},
      // );
      
      // if (response.statusCode == 200) {
      //   final newTokenData = json.decode(response.body);
      //   await saveLoginInfo(newTokenData);
      //   return newTokenData['data']['access_token'];
      // }

      return null;
    } catch (e) {
      print('Error refreshing token: $e');
      return null;
    }
  }

  // Lấy thông tin user hiện tại
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    
    final userData = json.decode(userJson);
    return User.fromJson(userData);
  }

  // Kiểm tra đã đăng nhập chưa
  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  // Đăng xuất
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_refreshTokenKey);
    await prefs.remove(_userKey);
    await prefs.remove(_tokenExpiryKey);
  }

  // Kiểm tra và lấy token type
  static Future<String> getTokenType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token_type') ?? 'Bearer';
  }

  // Lấy full authorization header
  static Future<String?> getAuthorizationHeader() async {
    final token = await getToken();
    final tokenType = await getTokenType();
    if (token == null) return null;
    return '$tokenType $token';
  }

  // Kiểm tra token có hết hạn chưa
  static Future<bool> isTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    final expiryTime = prefs.getInt(_tokenExpiryKey);
    if (expiryTime == null) return true;
    
    final now = DateTime.now().millisecondsSinceEpoch;
    return now >= expiryTime;
  }
}
