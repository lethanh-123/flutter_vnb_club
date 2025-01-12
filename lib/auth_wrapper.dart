import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dupr_provider.dart';
import 'dupr_rating_screen.dart';
import 'dupr_login_screen.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return isLoggedIn ? const DuprRatingScreen() : const DuprLoginScreen();
  }
}