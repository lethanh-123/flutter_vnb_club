import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart';
import 'tournament.dart';
import 'match.dart';
import 'sport.dart';
import 'club.dart';
import 'coach.dart';
import 'posts.dart';

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

  static Future<Map<String, List>> getMatchesAndTournaments() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/matches_tournaments.php'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );
      print(
          'API Response: ${response.statusCode} - ${response.body}'); // Debug log
      // Decode response với UTF-8
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);

        if (data['success'] == true) {
          final matchesJson = data['data']['matches'] as List;
          final tournamentsJson = data['data']['tournaments'] as List;

          // if (DebugMode) {
          //   print('Matches JSON: $matchesJson');
          //   print('Tournaments JSON: $tournamentsJson');
          // }

          final matches = matchesJson.map((json) {
            try {
              return Match.fromJson(json);
            } catch (e) {
              print('Error parsing match: $e');
              print('Match data: $json');
              rethrow;
            }
          }).toList();

          final tournaments = tournamentsJson.map((json) {
            try {
              return Tournament.fromJson(json);
            } catch (e) {
              print('Error parsing tournament: $e');
              print('Tournament data: $json');
              rethrow;
            }
          }).toList();

          return {
            'matches': matches,
            'tournaments': tournaments,
          };
        } else {
          throw Exception('API returned error: ${data['error']}');
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('API Error: $e');
      throw Exception('Error getting matches and tournaments: $e');
    }
  }

  static Future<List<Sport>> fetchSports() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sports.php'),
        headers: {'Content-Type': 'application/json'},
      );
// Decode response với UTF-8
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data']['sports'] as List)
              .map((sport) => Sport.fromJson(sport))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load sports');
      }
    } catch (e) {
      print('Error fetching sports: $e');
      throw Exception('Error fetching sports: $e');
    }
  }

  static Future<List<Club>> fetchClubs(
      {String? sportId, String searchQuery = ''}) async {
    try {
      String url = '$baseUrl/clubs.php';
      if (sportId != null) {
        url += '?sport_id=$sportId';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data']['clubs'] as List)
              .map((club) => Club.fromJson(club))
              .where((club) =>
                  searchQuery.isEmpty ||
                  club.name.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load clubs');
      }
    } catch (e) {
      print('Error fetching clubs: $e');
      throw Exception('Error fetching clubs: $e');
    }
  }

  static Future<List<Coach>> fetchCoaches() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/coaches.php'),
        headers: {'Content-Type': 'application/json'},
      );

      // Decode response với UTF-8
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data']['coaches'] as List)
              .map((coach) => Coach.fromJson(coach))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load coaches');
      }
    } catch (e) {
      print('Error fetching coaches: $e');
      throw Exception('Error fetching coaches: $e');
    }
  }

  static Future<List<Post>> fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts.php'),
        headers: {'Content-Type': 'application/json'},
      );

      // Decode response với UTF-8
      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data']['posts'] as List)
              .map((post) => Post.fromJson(post))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
      throw Exception('Error fetching posts: $e');
    }
  }
}
