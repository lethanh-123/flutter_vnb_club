import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dupr_client.dart';

// Provider cho SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

// Provider cho DuprClient
final duprClientProvider = Provider<DuprClient>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DuprClient(prefs);
});

// Provider lưu trữ thông tin người dùng đã đăng nhập
final userDataProvider = StateProvider<Map<String, dynamic>?>((ref) => null);

// Provider kiểm tra trạng thái đăng nhập
final isLoggedInProvider = Provider<bool>((ref) {
  final userData = ref.watch(userDataProvider);
  return userData != null;
});