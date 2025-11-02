import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/event_model.dart';
import '../services/storage_service.dart';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  String _category = 'Seminar';
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  String? _imagePath;
  final StorageService _storage = StorageService();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(source: ImageSource.camera, maxWidth: 1024);
    if (picked != null) setState(() => _imagePath = picked.path);
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _selectedTime);
    if (t != null) setState(() => _selectedTime = t);
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    final newEvent = EventModel(
      id: const Uuid().v4(),
      title: _titleController.text.trim(),
      category: _category,
      date: _selectedDate,
      time: _selectedTime.format(context),
      imagePath: _imagePath,
    );

    final current = await _storage.readEvents();
    current.add(newEvent);
    await _storage.saveEvents(current);

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Event saved')));
    _titleController.clear();
    setState(() {
      _category = 'Seminar';
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
      _imagePath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Event Title'),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Title required' : null,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _category,
              items: ['Seminar', 'Ulang Tahun', 'Kampus', 'Lainnya']
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (v) => setState(() => _category = v ?? 'Seminar'),
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: Text('Date: ${_selectedDate.toLocal().toString().split(' ')[0]}')),
                TextButton(onPressed: _pickDate, child: const Text('Pick Date')),
              ],
            ),
            Row(
              children: [
                Expanded(child: Text('Time: ${_selectedTime.format(context)}')),
                TextButton(onPressed: _pickTime, child: const Text('Pick Time')),
              ],
            ),
            const SizedBox(height: 12),
            if (_imagePath != null) Image.file(File(_imagePath!)),
            const SizedBox(height: 6),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: const Icon(Icons.camera_alt),
              label: const Text('Take Photo'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveEvent,
              child: const Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }
}
