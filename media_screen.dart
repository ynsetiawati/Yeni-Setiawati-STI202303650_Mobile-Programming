import 'dart:io';
import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/storage_service.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({super.key});

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  final StorageService _storage = StorageService();
  List<EventModel> _events = [];

  @override
  void initState() {
    super.initState();
    _loadMedia();
  }

  Future<void> _loadMedia() async {
    final data = await _storage.readEvents();
    setState(() => _events = data.where((e) => e.imagePath != null).toList());
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: _events.length,
      itemBuilder: (context, index) {
        final e = _events[index];
        return Card(
          child: Column(
            children: [
              Expanded(
                child: e.imagePath != null
                    ? Image.file(File(e.imagePath!), fit: BoxFit.cover)
                    : const Icon(Icons.event),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(e.title, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        );
      },
    );
  }
}
