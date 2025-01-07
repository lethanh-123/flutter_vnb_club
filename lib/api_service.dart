import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://192.168.1.251";

  static Future<Map<String, dynamic>?> callApi(
      String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    print('Calling API: $url');
    final headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(body),
      );
      print(
          'API Response [${response.statusCode}]: ${response.body}'); // Log response
      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        print(
            'API Error [$endpoint]: ${response.statusCode} - ${response.body}');
        return {
          'error': 'Có lỗi xảy ra',
          'status': response.statusCode,
          'details': response.body
        };
      }
    } catch (e) {
      print('API Call Error [$endpoint]: $e');
      return {'error': 'Không thể kết nối đến máy chủ'};
    }
  }
}
