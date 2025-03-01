import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_screen.dart';
import 'providers.dart' as providers;
import 'update_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'welcome_screen.dart';
import 'auth_sreen.dart';
// import 'ton_kho.dart';
// import 'banhang.dart';
import 'invoice_list.dart';
// import 'settings_screen.dart';
import 'community_search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        providers.sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Kiểm tra update sau khi widget được khởi tạo
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    // Đợi một chút để đảm bảo context đã sẵn sàng
    await Future.delayed(const Duration(seconds: 1));

    final updateChecker = AppUpdateChecker();
    final hasUpdate = await updateChecker.checkForUpdate();
    if (hasUpdate && mounted) {
      updateChecker.showUpdateDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VNB App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/auth': (context) => const AuthScreen(),
        // '/tonkho': (context) => const TonKhoScreen(),
        // '/banhang': (context) => const BanHangScreen(),
        '/invoices': (context) => InvoiceListScreen(),
        // '/cai_dat': (context) => SettingsScreen(),
        '/communitySearch': (context) => const CommunitySearchScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
