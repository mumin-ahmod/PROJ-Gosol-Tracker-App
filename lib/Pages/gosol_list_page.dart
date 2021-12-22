import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/my_theme.dart';
import 'package:intl/intl.dart';

class GosolList extends StatelessWidget {
  GosolList({Key? key}) : super(key: key);

  final theme = MyTheme.light();

  GosolController controller = Get.find();

  DateFormat f = DateFormat("EEE d-MMM - h:mm a");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Gosol List",
          style: theme.textTheme.headline4,
        ),
        centerTitle: true,
      ),
      body: Obx(
        () => ListView.separated(
          itemBuilder: (context, index) {
            final gosol = controller.gosolList.value[index];

            return ListTile(
              title: Text(
                f.format(DateTime.fromMicrosecondsSinceEpoch(gosol.datetime!)),
                style: theme.textTheme.bodyText1,
              ),
              trailing: IconButton(
                onPressed: () async {
                  await DatabaseHelper.delete(gosol.id!);
                },
                icon: Icon(Icons.delete_forever),
              ),
            );
          },
          separatorBuilder: (context, index) => const Divider(),
          itemCount: controller.gosolList.value.length,
        ),
      ),
    );
  }
}
