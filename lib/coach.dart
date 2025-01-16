import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// lib/models/coach.dart
class Coach {
  final String id;
  final String fullName;
  final String sportName;
  final String? avatarUrl;
  final String? bio;
  final double averageRating;
  final int totalReviews;
  final List<dynamic> certifications;
  final bool isVerified;

  Coach({
    required this.id,
    required this.fullName,
    required this.sportName,
    this.avatarUrl,
    this.bio,
    required this.averageRating,
    required this.totalReviews,
    required this.certifications,
    required this.isVerified,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      // Convert id to String if it's an int
      id: json['id'].toString(),
      fullName: json['full_name'] ?? '',
      sportName: json['sport_name'] ?? 'Unknown Sport',
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      // Handle potential integer values for average_rating
      averageRating: (json['average_rating'] is int)
          ? (json['average_rating'] as int).toDouble()
          : (json['average_rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      certifications: json['certifications'] ?? [],
      isVerified: json['is_verified'] ?? false,
    );
  }
}
