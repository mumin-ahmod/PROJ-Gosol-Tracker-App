import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/Model/gosol_model.dart';
import 'package:gosol_tracker_app/Pages/enter_new_gosol.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  GosolController controller = Get.put(GosolController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Shower Tracker App",
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => EnterNewGosol());
              },
              icon: Icon(Icons.playlist_add_outlined))
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.gosolList.value.length,
          itemBuilder: (context, index) {
            final gosol = controller.gosolList.value[index];

            return ListTile(
              title: Text(DateTime.fromMicrosecondsSinceEpoch(gosol.datetime!)
                  .toString()),
            );
          },
        ),
      ),
    );
  }
}
