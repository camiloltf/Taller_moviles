import 'package:flutter/material.dart';
import '../services/notification_service.dart';
import '../widgets/step_counter_widget.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  double _currentDistance = 0.0;
  TimeOfDay _selectedTime = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _pickTimeAndSchedule() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });

      await NotificationService.scheduleDailySummary(
        hour: picked.hour,
        minute: picked.minute,
        totalMeters: _currentDistance,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reporte diario programado a las ${picked.format(context)}',
          ),
          backgroundColor: const Color(0xFF2E7D32),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monitor de Caminata')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StepCounterWidget(
              onDistanceUpdated: (newDistance) {
                _currentDistance = newDistance;
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _pickTimeAndSchedule,
              icon: const Icon(Icons.alarm),
              label: Text(
                'Programar reporte diario (${_selectedTime.format(context)})',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
