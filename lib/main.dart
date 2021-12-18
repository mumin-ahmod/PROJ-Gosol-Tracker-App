import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Pages/dashboard_page.dart';
import 'package:gosol_tracker_app/Pages/enter_new_gosol.dart';

void main() {
  runApp(const GosolTrackerApp());
}

class GosolTrackerApp extends StatelessWidget {
  const GosolTrackerApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: DashboardPage(),
    );
  }
}
