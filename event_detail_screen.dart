import 'dart:io';
import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.imagePath != null)
              Image.file(File(event.imagePath!), height: 200, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text('Category: ${event.category}'),
            Text('Date: ${event.date.toLocal().toString().split(' ')[0]}'),
            Text('Time: ${event.time}'),
          ],
        ),
      ),
    );
  }
}
