import 'package:flutter/material.dart';
import 'package:gosol_tracker_app/my_theme.dart';

class AboutPage extends StatelessWidget {
  AboutPage({Key? key}) : super(key: key);

  final theme = MyTheme.light();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            CircleAvatar(
              radius: 50,
            ),
            const SizedBox(
              height: 50,
            ),
            Text(
              "Shower Tracker App",
              style: theme.textTheme.headline1,
            ),
            const SizedBox(
              height: 60,
            ),
            Text(
              "Add Your Showers📅 \nand\nShare Shower Records to Social Media💪",
              style: theme.textTheme.headline2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 100,
            ),
            Text(
              "Author\n Mumin Ahmod \nmumin.ahmod@northsouth.edu",
              style: theme.textTheme.bodyText1,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
