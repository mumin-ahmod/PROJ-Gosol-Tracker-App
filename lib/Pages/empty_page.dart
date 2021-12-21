import 'package:flutter/material.dart';
import 'package:gosol_tracker_app/my_theme.dart';

class EmptyPage extends StatelessWidget {
  EmptyPage({Key? key}) : super(key: key);

  final theme = MyTheme.light();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
          child: Text(
        "This Page \n is Not Available Right Now.",
        textAlign: TextAlign.center,
        style: theme.textTheme.headline3,
      )),
    );
  }
}
