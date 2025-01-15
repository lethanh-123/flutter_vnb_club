import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile.dart';

class ProfileNotifier extends StateNotifier<Profile?> {
  ProfileNotifier() : super(null);

  void setProfile(Profile profile) {
    state = profile;
  }
}

final profileProvider = StateNotifierProvider<ProfileNotifier, Profile?>((ref) {
  return ProfileNotifier();
});