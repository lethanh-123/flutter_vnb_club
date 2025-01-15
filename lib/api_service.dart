import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart';
import 'tournament.dart';
import 'match.dart';

class ApiService {
  static const String baseUrl = "http://192.168.1.251/vnb_club_back_end";

  static Future<Map<String, dynamic>?> callApi(
      String endpoint, Map<String, dynamic> body) async {
    try {
      final url = Uri.parse('$baseUrl/$endpoint');
      print('Calling API: $url with body: $body'); // Debug log

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(body),
      );

      print('API Response Status: ${response.statusCode}'); // Debug log
      print('API Response Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        print('Decoded Response: $decodedResponse'); // Debug log
        return decodedResponse;
      } else {
        print(
            'API Error: ${response.statusCode} - ${response.body}'); // Debug log
        return null;
      }
    } catch (e) {
      print('API Call Error: $e'); // Debug log
      return null;
    }
  }

  Future<Profile> getProfile(int userId) async {
    try {
      print('Calling getProfile for userId: $userId'); // Debug log

      final response = await http.get(
        Uri.parse('$baseUrl/get_profile.php?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print(
          'API Response: ${response.statusCode} - ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return Profile.fromJson(data['data']);
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e'); // Debug log
      throw Exception('Error getting profile: $e');
    }
  }

  static Future<Map<String, dynamic>> getMatchesAndTournaments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/matches_tournaments.php'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      print('API Response Status: ${response.statusCode}'); // Debug log
      print('API Response Body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse['success'] == true) {
          return {
            'matches': (decodedResponse['data']['matches'] as List)
                .map((m) => Match.fromJson(m))
                .toList(),
            'tournaments': (decodedResponse['data']['tournaments'] as List)
                .map((t) => Tournament.fromJson(t))
                .toList(),
          };
        } else {
          throw Exception(decodedResponse['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('API Call Error: $e'); // Debug log
      throw Exception('Error getting matches and tournaments: $e');
    }
  }
}
