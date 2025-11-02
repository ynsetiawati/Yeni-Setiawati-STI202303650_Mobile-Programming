import 'package:flutter/material.dart';
import '../models/event_model.dart';
import '../services/storage_service.dart';
import 'event_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storage = StorageService();
  List<EventModel> _events = [];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final data = await _storage.readEvents();
    setState(() => _events = data);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadEvents,
      child: ListView.builder(
        itemCount: _events.length,
        itemBuilder: (context, index) {
          final e = _events[index];
          return ListTile(
            leading: const Icon(Icons.event),
            title: Text(e.title),
            subtitle: Text('${e.category} • ${e.date.toLocal().toString().split(' ')[0]}'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => EventDetailScreen(event: e)),
            ),
          );
        },
      ),
    );
  }
}
