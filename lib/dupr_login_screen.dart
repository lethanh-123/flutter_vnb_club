import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'providers.dart' as providers;
import 'pickleball_profile_screen.dart';

final logger = Logger();

class DuprLoginScreen extends ConsumerStatefulWidget {
  const DuprLoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DuprLoginScreen> createState() => _DuprLoginScreenState();
}

class _DuprLoginScreenState extends ConsumerState<DuprLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Trong _login()
  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập email và mật khẩu';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final client = ref.read(providers.duprClientProvider);

      final loginResponse = await client.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (loginResponse != null) {
        final userId = loginResponse['result']['user']['id'].toString();
        final token = loginResponse['result']['accessToken'];

        final prefs = ref.read(providers.sharedPreferencesProvider);
        await prefs.setString('userId', userId);
        await prefs.setString('token', token);

        ref.read(providers.isLoggedInProvider.notifier).state = true;

        try {
          final playerResponse = await client.getPlayerRatings(userId, token);

          if (!mounted) return;

          if (playerResponse != null) {
            final ratings = {
              'singles': playerResponse['result']['ratings']['singles'],
              'doubles': playerResponse['result']['ratings']['doubles'],
              'confidence': playerResponse['result']['ratings']['doublesConfidence'],
            };

            ref.read(providers.duprRatingsProvider.notifier).state = ratings;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PickleballProfileScreen(
                  playerData: playerResponse,
                  onBackPressed: (ratings) {
                    ref.read(providers.duprRatingsProvider.notifier).state = ratings;
                    Navigator.pop(context, ratings);
                  },
                ),
              ),
            );
          } else {
            setState(() {
              _errorMessage = 'Không thể lấy thông tin điểm số';
            });
          }
        } catch (ratingError) {
          if (mounted) {
            setState(() {
              _errorMessage = 'Không thể lấy thông tin điểm số: $ratingError';
            });
          }
        }
      } else {
        setState(() {
          _errorMessage = 'Đăng nhập thất bại: Không nhận được response';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Lỗi: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
            Image.asset(
              'assets/dupr.jpg',
              height: 100,
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
              decoration: InputDecoration(
                labelText: 'Mật khẩu',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Đăng nhập'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}