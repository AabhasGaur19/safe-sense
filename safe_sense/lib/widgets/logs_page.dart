import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/session.dart';

class LogsPage extends StatelessWidget {
  final List<Session> sessionLogs;
  const LogsPage({super.key, required this.sessionLogs});

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    if (sessionLogs.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No Session Logs',
              style: TextStyle(fontSize: 24, color: Colors.grey),
            ),
            Text(
              'Start and stop a session to see it here.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: sessionLogs.length,
      itemBuilder: (context, index) {
        final session = sessionLogs[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.indigo),
                const SizedBox(height: 4),
                Text(
                  _formatDuration(session.duration),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
            title: Text(
              DateFormat('MMMM dd, yyyy').format(session.startTime),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  "From: ${session.startLocation}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                Text(
                  "To:      ${session.endLocation}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 4),
                Text(
                  "Time: ${DateFormat.jm().format(session.startTime)} - ${DateFormat.jm().format(session.endTime)}",
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}