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