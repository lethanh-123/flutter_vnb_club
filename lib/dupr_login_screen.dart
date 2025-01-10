import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dupr_client.dart';
import 'package:logging/logging.dart';
import 'dupr_provider.dart';
import 'dupr_client.dart';

final logger = Logger('DuprLoginScreen');

class DuprLoginScreen extends ConsumerStatefulWidget {
  const DuprLoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DuprLoginScreen> createState() => _DuprLoginScreenState();
}

class _DuprLoginScreenState extends ConsumerState<DuprLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final client = ref.read(duprClientProvider);
      final loginResponse = await client.login(
        _emailController.text,
        _passwordController.text,
      );
      print(_passwordController.text);
      if (!mounted) return;
      print(loginResponse);
      if (loginResponse != null) {
        final userId = loginResponse['result']['user']['id'];
        final token = loginResponse['result']['accessToken'];

        logger.info('Đăng nhập thành công. UserID: $userId');

        final playerResponse = await client.getPlayerRatings(userId, token);

        if (playerResponse != null) {
          final doubles = playerResponse['result']['ratings']['doubles'];
          final singles = playerResponse['result']['ratings']['singles'];

          if (mounted) {
            Navigator.pop(context, {
              'singles': singles ?? 'NR',
              'doubles': doubles ?? 'NR',
              'confidence':
                  playerResponse['result']['ratings']['doublesConfidence'] ?? 0,
            });
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đăng nhập thất bại')),
          );
        }
      }
    } catch (e) {
      // logger.error('Lỗi đăng nhập: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Có lỗi xảy ra')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng nhập DUPR'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://profluence.com/wp-content/uploads/2024/01/Untitled-design-7.jpg',
              height: 60,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Đăng nhập'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
