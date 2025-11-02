import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/event_model.dart';

class StorageService {
  Future<String> get _localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/events.json');
  }

  Future<List<EventModel>> readEvents() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) return [];
      final contents = await file.readAsString();
      final List data = jsonDecode(contents);
      return data.map((e) => EventModel.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveEvents(List<EventModel> events) async {
    final file = await _localFile;
    final jsonData = jsonEncode(events.map((e) => e.toJson()).toList());
    await file.writeAsString(jsonData);
  }
}
