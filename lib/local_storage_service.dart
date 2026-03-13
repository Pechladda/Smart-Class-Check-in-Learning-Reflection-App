import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CheckinRecord {
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String previousTopic;
  final String expectedTopic;
  final int mood;

  CheckinRecord({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.previousTopic,
    required this.expectedTopic,
    required this.mood,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'previous_topic': previousTopic,
      'expected_topic': expectedTopic,
      'mood_score': mood,
    };
  }
}

class CheckoutRecord {
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String learnedToday;
  final String feedback;

  CheckoutRecord({
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    required this.learnedToday,
    required this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'learned_today': learnedToday,
      'feedback': feedback,
    };
  }
}

class LocalStorageService {
  static const _checkinKey = 'checkin_records';
  static const _checkoutKey = 'checkout_records';

  Future<void> saveCheckinRecord(CheckinRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = prefs.getStringList(_checkinKey) ?? [];
    records.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_checkinKey, records);
  }

  Future<void> saveCheckoutRecord(CheckoutRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final records = prefs.getStringList(_checkoutKey) ?? [];
    records.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_checkoutKey, records);
  }
}
