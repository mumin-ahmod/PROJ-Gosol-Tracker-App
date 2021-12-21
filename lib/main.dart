import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/instance_binding.dart';
import 'package:gosol_tracker_app/Pages/dashboard_page.dart';
import 'package:gosol_tracker_app/my_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  InstanceBinding().dependencies();
  runApp(const GosolTrackerApp());
}

class GosolTrackerApp extends StatelessWidget {
  const GosolTrackerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = MyTheme.light();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: DashboardPage(),
    );
  }
}
