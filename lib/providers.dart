import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dupr_client.dart';
import 'package:logger/logger.dart';

final logger = Logger();

// Provider cho SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Provider cho DuprClient
final duprClientProvider = Provider<DuprClient>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DuprClient(prefs);
});

// Provider cho trạng thái đăng nhập
final isLoggedInProvider = StateProvider<bool>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    final token = prefs.getString('token');
    return token != null;
  } catch (e) {
    return false;
  }
});

// Provider cho DUPR ratings
final duprRatingsProvider = StateProvider<Map<String, dynamic>?>((ref) {
  try {
    final prefs = ref.watch(sharedPreferencesProvider);
    final userId = prefs.getString('userId');
    final token = prefs.getString('token');

    if (userId != null && token != null) {
      return {
        'singles': prefs.getString('singles_rating') ?? 'NR',
        'doubles': prefs.getString('doubles_rating') ?? 'NR',
        'confidence': prefs.getDouble('confidence_rating') ?? 0.0,
      };
    }
    return null;
  } catch (e) {
    return null;
  }
});

// Provider cho việc lưu ratings
final saveRatingsProvider =
    Provider<Future<void> Function(Map<String, dynamic>)>((ref) {
  return (Map<String, dynamic> ratings) async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);

      await prefs.setString(
          'singles_rating', ratings['singles']?.toString() ?? 'NR');
      await prefs.setString(
          'doubles_rating', ratings['doubles']?.toString() ?? 'NR');
      await prefs.setDouble(
          'confidence_rating', ratings['confidence']?.toDouble() ?? 0.0);

      // Cập nhật state của duprRatingsProvider
      ref.read(duprRatingsProvider.notifier).state = ratings;

    } catch (e) {
      throw Exception('Không thể lưu ratings: $e');
    }
  };
});

// Provider cho việc đăng xuất
final logoutProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);

      // Xóa tất cả thông tin đăng nhập
      await prefs.remove('userId');
      await prefs.remove('token');
      await prefs.remove('singles_rating');
      await prefs.remove('doubles_rating');
      await prefs.remove('confidence_rating');

      // Reset các providers
      ref.read(isLoggedInProvider.notifier).state = false;
      ref.read(duprRatingsProvider.notifier).state = null;

    } catch (e) {
      throw Exception('Không thể đăng xuất: $e');
    }
  };
});

// Provider cho việc refresh token
final refreshTokenProvider = Provider<Future<bool> Function()>((ref) {
  return () async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final client = ref.read(duprClientProvider);
      final userId = prefs.getString('userId');
      final token = prefs.getString('token');

      if (userId == null || token == null) {
        return false;
      }

      // Thực hiện refresh token (cần implement trong DuprClient)
      final response = await client.refreshToken(userId, token);

      if (response != null && response['result'] != null) {
        final newToken = response['result']['accessToken'];
        await prefs.setString('token', newToken);
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  };
});

// Provider cho việc kiểm tra token hết hạn
final tokenValidityProvider = Provider<Future<bool> Function()>((ref) {
  return () async {
    try {
      final prefs = ref.read(sharedPreferencesProvider);
      final token = prefs.getString('token');

      if (token == null) {
        return false;
      }

      // Implement logic kiểm tra token validity
      // Có thể gọi một API endpoint để verify token

      return true;
    } catch (e) {
      return false;
    }
  };
});
