import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';

final logger = Logger('DuprClient');

class DuprClient {
  static const String _baseUrl = 'https://api.dupr.gg';
  static const String _authUrl = 'https://dashboard.dupr.gg';
  static const String _version = 'v1.0';

  final SharedPreferences _prefs;
  String? _accessToken;

  DuprClient(this._prefs) {
    _loadToken();
  }

  // Token Management
  Future<void> _loadToken() async {
    _accessToken = _prefs.getString('dupr_access_token');
    logger.info('Loaded token: ${_accessToken?.substring(0, 10)}...');
  }

  Future<void> _saveToken(String token) async {
    _accessToken = token;
    await _prefs.setString('dupr_access_token', token);
    logger.info('Saved new token: ${token.substring(0, 10)}...');
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  // Authentication
  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      logger.info('Bắt đầu đăng nhập với email: $email');
      
      final loginUrl = '$_authUrl/api/auth/login';
      logger.info('URL đăng nhập: $loginUrl');

      // In ra payload để debug
      final payload = {
        'email': email,
        'password': password,
        'returnSecureToken': true
      };
      logger.info('Payload đăng nhập: ${jsonEncode(payload)}');

      final loginResponse = await http.post(
        Uri.parse(loginUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Origin': 'https://dashboard.dupr.gg',
          'Referer': 'https://dashboard.dupr.gg/',
        },
        body: jsonEncode(payload),
      );

      logger.info('Status code: ${loginResponse.statusCode}');
      logger.info('Response headers: ${loginResponse.headers}');
      logger.info('Response body: ${loginResponse.body}');

      if (loginResponse.statusCode == 200) {
        final loginData = jsonDecode(loginResponse.body);
        final token = loginData['accessToken'];
        
        if (token == null) {
          logger.warning('Token không tồn tại trong response');
          return null;
        }

        await _saveToken(token);
        logger.info('Đã lưu token thành công');

        // Lấy thông tin user
        final userResponse = await http.get(
          Uri.parse('$_authUrl/api/users/me'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        );

        logger.info('User API Status code: ${userResponse.statusCode}');
        logger.info('User API Response: ${userResponse.body}');

        if (userResponse.statusCode == 200) {
          final userData = jsonDecode(userResponse.body);
          logger.info('Đăng nhập thành công với user ID: ${userData['id']}');
          
          return {
            'result': {
              'user': {
                'id': userData['id'],
              },
              'accessToken': token,
            }
          };
        } else {
          logger.warning('Không thể lấy thông tin user: ${userResponse.statusCode}');
        }
      } else {
        logger.warning('Đăng nhập thất bại với status: ${loginResponse.statusCode}');
        logger.warning('Error response: ${loginResponse.body}');
      }
      
      return null;
    } catch (e, stackTrace) {
      logger.severe('Lỗi đăng nhập', e, stackTrace);
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await _prefs.remove('dupr_access_token');
      _accessToken = null;
      logger.info('Logout successful');
      return true;
    } catch (e) {
      return false;
    }
  }

  // Player Information
  Future<Map<String, dynamic>?> getPlayerRatings(String userId, String token) async {
    try {
      logger.info('Đang lấy thông tin rating cho user: $userId');
      final url = '$_baseUrl/player/$_version/$userId';
      logger.info('URL get ratings: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      logger.info('Rating API Status code: ${response.statusCode}');
      logger.info('Rating API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.info('Lấy thông tin rating thành công');
        return data;
      } else {
        logger.warning('Lấy thông tin rating thất bại: ${response.statusCode}');
        logger.warning('Error response: ${response.body}');
        return null;
      }
    } catch (e, stackTrace) {
      logger.severe('Lỗi khi lấy thông tin rating', e, stackTrace);
      return null;
    }
  }

  Future<Map<String, dynamic>?> getPlayerByDuprId(String duprId) async {
    try {
      logger.info('Fetching player info for DUPR ID: $duprId');
      final response = await http.get(
        Uri.parse('$_baseUrl/player/$_version/$duprId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.info('Successfully retrieved player info');
        return data;
      } else {
        logger.warning(
            'Failed to get player info with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Match History
  Future<List<Map<String, dynamic>>> getPlayerMatchHistory(String playerId,
      {int limit = 10}) async {
    try {
      logger.info('Fetching match history for player: $playerId');
      final response = await http.post(
        Uri.parse('$_baseUrl/player/$_version/$playerId/history'),
        headers: _headers,
        body: jsonEncode({
          "filters": {},
          "sort": {
            "order": "DESC",
            "parameter": "MATCH_DATE",
          },
          "limit": limit,
          "offset": 0
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final matches = data['result']['hits'] as List;
        logger.info('Retrieved ${matches.length} matches');
        return matches.cast<Map<String, dynamic>>();
      } else {
        logger.warning(
            'Failed to get match history with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Club Information
  Future<Map<String, dynamic>?> getClubInfo(String clubId) async {
    try {
      logger.info('Fetching club info for: $clubId');
      final response = await http.get(
        Uri.parse('$_baseUrl/club/$_version/$clubId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        logger.info('Successfully retrieved club info');
        return data;
      } else {
        logger.warning(
            'Failed to get club info with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getClubMembers(String clubId) async {
    try {
      logger.info('Fetching members for club: $clubId');
      final List<Map<String, dynamic>> allMembers = [];
      int offset = 0;
      bool hasMore = true;

      while (hasMore) {
        final response = await http.post(
          Uri.parse('$_baseUrl/club/$clubId/members/$_version/all'),
          headers: _headers,
          body: jsonEncode(
              {"exclude": [], "limit": 20, "offset": offset, "query": "*"}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final result = data['result'];
          final hits = result['hits'] as List;
          allMembers.addAll(hits.cast<Map<String, dynamic>>());

          final total = result['total'] as int;
          offset += result['limit'] as int;
          hasMore = offset < total;

          logger.info('Retrieved ${hits.length} members. Total: $total');
        } else {
          logger.warning(
              'Failed to get club members with status: ${response.statusCode}');
          hasMore = false;
        }
      }

      return allMembers;
    } catch (e) {
      return [];
    }
  }

  // Search Players
  Future<List<Map<String, dynamic>>> searchPlayers(String query) async {
    try {
      logger.info('Searching players with query: $query');
      final response = await http.post(
        Uri.parse('$_baseUrl/player/$_version/search'),
        headers: _headers,
        body: jsonEncode({
          "filters": {},
          "sort": {"order": "DESC", "parameter": "RATING"},
          "limit": 20,
          "offset": 0,
          "query": query
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hits = data['result']['hits'] as List;
        logger.info('Found ${hits.length} players');
        return hits.cast<Map<String, dynamic>>();
      } else {
        logger.warning('Search failed with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({
    String gender = 'ALL',
    String ageGroup = 'ALL',
    String gameType = 'DOUBLES',
  }) async {
    try {
      logger.info('Fetching leaderboard for $gameType');
      final response = await http.post(
        Uri.parse('$_baseUrl/player/$_version/leaderboard'),
        headers: _headers,
        body: jsonEncode({
          "filters": {
            "gender": gender,
            "ageGroup": ageGroup,
            "gameType": gameType
          },
          "sort": {"order": "DESC", "parameter": "RATING"},
          "limit": 20,
          "offset": 0
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hits = data['result']['hits'] as List;
        logger.info('Retrieved ${hits.length} leaderboard entries');
        return hits.cast<Map<String, dynamic>>();
      } else {
        logger.warning(
            'Failed to get leaderboard with status: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
