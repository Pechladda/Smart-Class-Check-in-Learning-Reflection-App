import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'local_storage_service.dart';

class CheckinScreen extends StatefulWidget {
  const CheckinScreen({super.key});

  @override
  State<CheckinScreen> createState() => _CheckinScreenState();
}

class _CheckinScreenState extends State<CheckinScreen> {
  final _previousTopicController = TextEditingController();
  final _expectedTopicController = TextEditingController();
  final _storageService = LocalStorageService();

  double? _latitude;
  double? _longitude;
  String? _qrCode;
  int _mood = 3;
  bool _isSaving = false;

  @override
  void dispose() {
    _previousTopicController.dispose();
    _expectedTopicController.dispose();
    super.dispose();
  }

  Future<void> _getLocation() async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      _showMessage('Location services are disabled.');
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _showMessage('Location permission denied.');
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

  Future<void> _submitCheckin() async {
    if (_latitude == null || _longitude == null) {
      _showMessage('Please get GPS location first.');
      return;
    }
    if ((_qrCode ?? '').isEmpty) {
      _showMessage('Please scan QR code first.');
      return;
    }
    if (_previousTopicController.text.trim().isEmpty ||
        _expectedTopicController.text.trim().isEmpty) {
      _showMessage('Please fill in all text fields.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final record = CheckinRecord(
      timestamp: DateTime.now(),
      latitude: _latitude!,
      longitude: _longitude!,
      previousTopic: _previousTopicController.text.trim(),
      expectedTopic: _expectedTopicController.text.trim(),
      mood: _mood,
    );

    await _storageService.saveCheckinRecord(record);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    _showMessage('Check-in saved successfully.');
    Navigator.pop(context);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _sectionCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F4F4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: const Color(0xFF222222), size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    final theme = Theme.of(context);
    final moodOptions = <({int score, String emoji, String label})>[
      (score: 1, emoji: '😡', label: 'Very negative'),
      (score: 2, emoji: '🙁', label: 'Negative'),
      (score: 3, emoji: '😐', label: 'Neutral'),
      (score: 4, emoji: '🙂', label: 'Positive'),
      (score: 5, emoji: '😄', label: 'Very positive'),
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: moodOptions.map((option) {
        final isSelected = _mood == option.score;
        return ChoiceChip(
          label: Text('${option.emoji} ${option.score}'),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: Colors.black,
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? Colors.black : const Color(0xFFE5E5E5),
          ),
          labelStyle: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : const Color(0xFF1F1F1F),
            fontWeight: FontWeight.w600,
          ),
          onSelected: (_) {
            setState(() {
              _mood = option.score;
            });
          },
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Check-in'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Before Class',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Share your expectation and mood before class starts.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            _sectionCard(
              context: context,
              icon: Icons.location_on_outlined,
              title: 'Class Location',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  OutlinedButton.icon(
                    onPressed: _getLocation,
                    icon: const Icon(Icons.my_location_rounded),
                    label: const Text('Get GPS Location'),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Text(
                      _latitude == null
                          ? 'Latitude: -, Longitude: -'
                          : 'Latitude: ${_latitude!.toStringAsFixed(6)}, '
                                'Longitude: ${_longitude!.toStringAsFixed(6)}',
                      style: const TextStyle(color: Color(0xFF454545)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _sectionCard(
              context: context,
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scan classroom QR code',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 220,
                      child: MobileScanner(
                        onDetect: (capture) {
                          final code = capture.barcodes.first.rawValue;
                          if (code != null && code.isNotEmpty) {
                            setState(() {
                              _qrCode = code;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE8E8E8)),
                    ),
                    child: Text(
                      'Scanned result: ${_qrCode ?? '-'}',
                      style: const TextStyle(color: Color(0xFF454545)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _sectionCard(
              context: context,
              icon: Icons.edit_note_rounded,
              title: 'Class Details',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _previousTopicController,
                    decoration: const InputDecoration(
                      labelText:
                          'What topic was covered in the previous class?',
                      prefixIcon: Icon(Icons.history_edu_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _expectedTopicController,
                    decoration: const InputDecoration(
                      labelText: 'What topic do you expect to learn today?',
                      prefixIcon: Icon(Icons.lightbulb_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Mood (1-5)',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tap one option that best represents your mood.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF7A7A7A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildMoodSelector(),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _isSaving ? null : _submitCheckin,
              child: Text(_isSaving ? 'Saving...' : 'Submit Check-in'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
