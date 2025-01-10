import 'package:flutter/material.dart';
import 'package:flutter_vnb_ios/cai_dat.dart';
import 'ton_kho.dart';
import 'banhang.dart';
import 'invoice_list.dart';
import 'package:flutter_vnb_ios/api_service.dart';
import 'preferences.dart';
import 'functions.dart';
import 'auth_sreen.dart';
import 'welcome_screen.dart';
import 'package:logging/logging.dart';
import 'community_search_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dupr_client.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dupr_provider.dart';
final Logger logger = Logger('MyApp'); // Logger declaration

void configureLogging() {
  Logger.root.level = Level.ALL; // Log all levels

  logger.onRecord.listen((record) {
    final logMessage =
        '${record.level.name}: ${record.time}: ${record.loggerName}: ${record.message}';

    // Chunk the log messages to avoid truncation
    const chunkSize = 3000;
    for (int i = 0; i < logMessage.length; i += chunkSize) {
      debugPrint(
        logMessage.substring(
            i,
            i + chunkSize > logMessage.length
                ? logMessage.length
                : i + chunkSize),
        wrapWidth: 3000, // Prevent log wrapping
      );
    }
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  configureLogging();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    logger.info('Ứng dụng MyApp đã khởi chạy');
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      initialRoute: '/welcome', // Start with the Welcome screen
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/tonkho': (context) => const TonKhoScreen(),
        '/banhang': (context) => const BanHangScreen(),
        '/invoices': (context) => InvoiceListScreen(),
        '/cai_dat': (context) => SettingsScreen(),
        '/communitySearch': (context) => const CommunitySearchScreen(),
      },
    );
  }
}
