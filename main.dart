import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/add_event_screen.dart';
import 'screens/media_screen.dart';

void main() {
  runApp(const MyEventPlannerApp());
}

class MyEventPlannerApp extends StatelessWidget {
  const MyEventPlannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Event Planner',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainTabController(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainTabController extends StatefulWidget {
  const MainTabController({super.key});

  @override
  State<MainTabController> createState() => _MainTabControllerState();
}

class _MainTabControllerState extends State<MainTabController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Event Planner'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.list), text: 'Daftar Event'),
            Tab(icon: Icon(Icons.add), text: 'Tambah Event'),
            Tab(icon: Icon(Icons.photo_library), text: 'Media'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          HomeScreen(),
          AddEventScreen(),
          MediaScreen(),
        ],
      ),
    );
  }
}
