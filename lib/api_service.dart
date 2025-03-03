import 'dart:convert';
import 'package:http/http.dart' as http;
import 'profile.dart';
import 'tournament.dart';
import 'match.dart';
import 'sport.dart';
import 'club.dart';
import 'coach.dart';
import 'posts.dart';
import 'dupr_ranking.dart';
import 'street_scred.dart';
import 'court.dart';
import 'user.dart';

class ApiService {
  static const String baseUrl = "https://cosports.appvnb.com";

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

      if (response.statusCode == 200 || response.statusCode == 201) {
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
        Uri.parse('$baseUrl/matches_tournaments'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);

        if (data['success'] == true) {
          final matchesJson = data['data']['matches'] as List;
          final tournamentsJson = data['data']['tournaments'] as List;

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

  static Future<List<DuprRanking>> fetchDuprRankings() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_dupr_rankings.php'),
        headers: {'Content-Type': 'application/json'},
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((ranking) => DuprRanking.fromJson(ranking))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load DUPR rankings');
      }
    } catch (e) {
      print('Error fetching DUPR rankings: $e');
      throw Exception('Error fetching DUPR rankings: $e');
    }
  }

  static Future<List<StreetCred>> fetchStreetCred(String period) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_street_cred.php?period=$period'),
        headers: {'Content-Type': 'application/json'},
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data'] as List)
              .map((cred) => StreetCred.fromJson(cred))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load Street Cred');
      }
    } catch (e) {
      print('Error fetching Street Cred: $e');
      throw Exception('Error fetching Street Cred: $e');
    }
  }

  static Future<List<Court>> fetchCourts() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_courts'),
        headers: {'Content-Type': 'application/json'},
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data']['courts'] as List)
              .map((court) => Court.fromJson(court))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load courts');
      }
    } catch (e) {
      print('Error fetching courts: $e');
      throw Exception('Error fetching courts: $e');
    }
  }

  static Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.15.1/flutter_vnb_club_be/get_users.php'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("responsefsdf" + data.toString());
        if (data['success'] == true) {
          final users = (data['data']['users'] as List)
              .map((user) => User.fromJson(user))
              .toList();
          return users;
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  static Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      final data = json.decode(response.body);
      return data['success'] == true;
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  static Future<bool> updateUser(
      String userId, Map<String, dynamic> userData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/update_user.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'id': userId,
          ...userData,
        }),
      );

      final data = json.decode(response.body);
      return data['success'] == true;
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  static Future<bool> deleteUser(String userId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/delete_user.php?id=$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      final data = json.decode(response.body);
      return data['success'] == true;
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  static Future<List<Court>> fetchLocations() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_courts.php'),
        headers: {'Content-Type': 'application/json'},
      );

      final decodedResponse = utf8.decode(response.bodyBytes);

      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success'] == true) {
          return (data['data']['courts'] as List)
              .map((court) => Court.fromJson(court))
              .toList();
        } else {
          throw Exception(data['error'] ?? 'Unknown error');
        }
      } else {
        throw Exception('Failed to load locations');
      }
    } catch (e) {
      print('Error fetching locations: $e');
      throw Exception('Error fetching locations: $e');
    }
  }

  static Future<Map<String, dynamic>> getCourtStats() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_court_stats.php'),
        headers: {'Content-Type': 'application/json'},
      );
      final decodedResponse = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success']) {
          return data['data'];
        } else {
          throw Exception(data['error'] ?? 'Lỗi không xác định');
        }
      } else {
        throw Exception('Lỗi kết nối: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi tải dữ liệu: ${e.toString()}');
    }
  }

  static Future<Court> getCourtDetail(int courtId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/get_court_detail.php?id=$courtId'),
        headers: {'Content-Type': 'application/json'},
      );
      final decodedResponse = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        final data = json.decode(decodedResponse);
        if (data['success']) {
          return Court.fromJson(data['data']);
        } else {
          throw Exception(data['error'] ?? 'Lỗi không xác định');
        }
      } else {
        throw Exception('Lỗi kết nối: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Lỗi khi tải thông tin sân: ${e.toString()}');
    }
  }
}
