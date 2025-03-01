import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
class AppUpdateChecker {
  // Kiểm tra version mới
  Future<bool> checkForUpdate() async {
    try {
      // Lấy thông tin version hiện tại
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Gọi API để lấy version mới nhất từ App Store
      final response = await http.get(
        Uri.parse(
            'http://itunes.apple.com/lookup?bundleId=${packageInfo.packageName}'),
      );

      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        if (jsonResult['resultCount'] > 0) {
          final String newVersion = jsonResult['results'][0]['version'];

          // So sánh version
          if (_compareVersions(newVersion, currentVersion) > 0) {
            return true; // Có bản cập nhật mới
          }
        }
      }
      return false; // Không có bản cập nhật mới
    } catch (e) {
      print('Error checking for update: $e');
      return false;
    }
  }

  // So sánh version
  int _compareVersions(String v1, String v2) {
    List<int> v1Parts = v1.split('.').map(int.parse).toList();
    List<int> v2Parts = v2.split('.').map(int.parse).toList();

    for (int i = 0; i < v1Parts.length && i < v2Parts.length; i++) {
      if (v1Parts[i] > v2Parts[i]) return 1;
      if (v1Parts[i] < v2Parts[i]) return -1;
    }
    return v1Parts.length.compareTo(v2Parts.length);
  }

  // Mở App Store để cập nhật
  Future<void> openAppStore() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final appId = packageInfo.packageName;
    final url = 'https://apps.apple.com/app/id$appId';

    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Hiển thị dialog cập nhật
  void showUpdateDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Có bản cập nhật mới'),
        content: Text('Vui lòng cập nhật ứng dụng để có trải nghiệm tốt nhất'),
        actions: [
          TextButton(
            child: Text('Cập nhật ngay'),
            onPressed: () {
              openAppStore();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
