import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'local_storage_service.dart';

class FinishClassScreen extends StatefulWidget {
  const FinishClassScreen({super.key});

  @override
  State<FinishClassScreen> createState() => _FinishClassScreenState();
}

class _FinishClassScreenState extends State<FinishClassScreen> {
  final _learnedTodayController = TextEditingController();
  final _feedbackController = TextEditingController();
  final _storageService = LocalStorageService();
  final MobileScannerController _scannerController = MobileScannerController();

  double? _latitude;
  double? _longitude;
  String? _qrCode;
  bool _isSaving = false;
  bool _hasScanned = false;

  @override
  void dispose() {
    _learnedTodayController.dispose();
    _feedbackController.dispose();
    _scannerController.dispose();
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

  Future<void> _finishClass() async {
    if (_latitude == null || _longitude == null) {
      _showMessage('Please get GPS location first.');
      return;
    }
    if ((_qrCode ?? '').isEmpty) {
      _showMessage('Please scan QR code first.');
      return;
    }
    if (_learnedTodayController.text.trim().isEmpty ||
        _feedbackController.text.trim().isEmpty) {
      _showMessage('Please fill in all text fields.');
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final record = CheckoutRecord(
      timestamp: DateTime.now(),
      latitude: _latitude!,
      longitude: _longitude!,
      learnedToday: _learnedTodayController.text.trim(),
      feedback: _feedbackController.text.trim(),
    );

    await _storageService.saveCheckoutRecord(record);

    if (!mounted) {
      return;
    }

    setState(() {
      _isSaving = false;
    });

    _showMessage('Finish class data saved successfully.');
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finish Class'),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'After Class',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Capture your learning and class feedback.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
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
                        controller: _scannerController,
                        onDetect: (capture) async {
                          if (_hasScanned) {
                            return;
                          }
                          final code = capture.barcodes.first.rawValue;
                          if (code != null && code.isNotEmpty) {
                            setState(() {
                              _qrCode = code;
                              _hasScanned = true;
                            });
                            await _scannerController.stop();
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
                      'Scan status: ${_hasScanned ? 'Complete' : 'Waiting for scan'}\n'
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
              icon: Icons.rate_review_outlined,
              title: 'Reflection',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _learnedTodayController,
                    decoration: const InputDecoration(
                      labelText: 'What did you learn today?',
                      prefixIcon: Icon(Icons.menu_book_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Feedback about the class or instructor',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.feedback_outlined),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              onPressed: _isSaving ? null : _finishClass,
              child: Text(_isSaving ? 'Saving...' : 'Finish Class'),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}
