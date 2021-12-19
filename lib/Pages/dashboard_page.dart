import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Pages/enter_new_gosol.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  GosolController controller = Get.put(GosolController());

  DateFormat f = DateFormat("dd-MMM \nh:mm a");

  int getUnday() {
    if (controller.gosolList.isNotEmpty) {
      DateTime dateLast = DateTime.fromMicrosecondsSinceEpoch(controller
          .gosolList.value[controller.gosolList.value.length - 1].datetime!);

      return controller.unDay.value = DateTime.now().day - dateLast.day;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black54),
        title: const Text(
          "Shower Tracker",
          style: TextStyle(color: Colors.black54),
        ),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton(
                onPressed: () {
                  Get.to(() => EnterNewGosol());
                },
                icon: const Icon(
                  Icons.add,
                  size: 30,
                )),
          )
        ],
      ),
      drawer: Drawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: 250,
              width: 400,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 35,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Column(
                          children: [
                            Text(
                              "Mumin Ahmod",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "🗺️ Mymensingh",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Obx(
                      () => Text(
                        "Today \nYou are UnGosoled For: \n${getUnday()} Days",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            child: Obx(
              () => SizedBox(
                width: 300,
                child: ListView(children: [
                  FixedTimeline.tileBuilder(
                    builder: TimelineTileBuilder.connectedFromStyle(
                      itemCount: controller.gosolList.value.length,
                      contentsBuilder: (context, index) => SizedBox(
                        height: 100,
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                              "UnGosoled For: \n${DateTime.fromMicrosecondsSinceEpoch(controller.gosolList.value[index].datetime!).day - DateTime.fromMicrosecondsSinceEpoch(controller.gosolList.value[index == 0 ? 0 : index - 1].datetime!).day} Days"),
                        ),
                      ),
                      oppositeContentsBuilder: (context, index) {
                        final gosol = controller.gosolList.value[index];

                        return Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Text(f.format(
                                  DateTime.fromMicrosecondsSinceEpoch(
                                      gosol.datetime!))),
                            ),
                          ),
                        );
                      },
                      connectorStyleBuilder: (context, index) {
                        return ConnectorStyle.solidLine;
                      },
                      indicatorStyleBuilder: (context, index) =>
                          IndicatorStyle.dot,
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
