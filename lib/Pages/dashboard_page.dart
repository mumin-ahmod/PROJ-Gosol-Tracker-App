import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Pages/enter_new_gosol.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../my_theme.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final theme = MyTheme.light();

  GosolController controller = Get.put(GosolController());

  DateFormat f = DateFormat("EEE d-MMM \nh:mm a");

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
        titleSpacing: 0,
        leadingWidth: 70,
        // SPACE BEFORE LEADING ICON / MENU ICON
        toolbarHeight: 70,

        iconTheme: const IconThemeData(color: Colors.black54),
        title: Text(
          "Shower Tracker",
          style: theme.textTheme.headline4,
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
      drawer: const Drawer(),
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
                  _buildProfile(),
                  const SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Obx(() => ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Container(
                                width: double.infinity,
                                height: 100,
                                color: const Color(0xFFdcedc8),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(Icons.date_range),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Gosol Korechen: ${getUnday() == 0 ? 'Ajkei!' : getUnday().toString() + ' Days Ago.'} ",
                                          style: theme.textTheme.headline4,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Icon(Icons.date_range),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          "Ektana Gosol: 0 Days! ",
                                          style: theme.textTheme.headline4,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )

                        //     Text(
                        //   "Apni Gosol Korechen: ${getUnday() == 0 ? 'Ajkei!' : getUnday().toString() + ' Days Ago.'} ",
                        //   style: theme.textTheme.headline3,
                        //   textAlign: TextAlign.center,
                        // ),
                        ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "TIMELINE",
              style: GoogleFonts.encodeSans(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 5),
            ),
          ),
          Flexible(
            child: Obx(
              () => Timeline.tileBuilder(
                theme: TimelineThemeData(
                  connectorTheme: const ConnectorThemeData(
                    thickness: 3.0,
                  ),
                  indicatorTheme: const IndicatorThemeData(
                    size: 15.0,
                  ),
                ),
                builder: TimelineTileBuilder.connected(
                  itemCount: controller.gosolList.value.length,
                  contentsAlign: ContentsAlign.basic,
                  contentsBuilder: (context, index) => SizedBox(
                    height: 100,
                    width: 400,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 40, 0, 0),
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

                  connectorBuilder: (_, index, __) => const SolidLineConnector(
                    color: Color(0xff64dd17),
                  ),

                  indicatorBuilder: (_, index) => const DotIndicator(
                    color: Color(0xff64dd17),
                  ),

                  itemExtentBuilder: (_, __) {
                    return 100.0;
                  },
                  // indicatorStyle: IndicatorStyle.container,
                  // connectorStyle: ConnectorStyle.solidLine,

                  // connectorStyleBuilder: (context, index) {
                  //   return ConnectorStyle.solidLine;
                  // },
                  // indicatorStyleBuilder: (context, index) =>
                  // IndicatorStyle.dot,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
                "https://png.pngtree.com/png-vector/20190120/ourlarge/pngtree-man-vector-icon-png-image_470295.jpg"),
            radius: 35,
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Mumin Ahmod",
                style: theme.textTheme.headline1,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  "🗺️ Mymensingh",
                  style: theme.textTheme.headline2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
