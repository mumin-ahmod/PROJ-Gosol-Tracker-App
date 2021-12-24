import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Pages/about_page.dart';
import 'package:gosol_tracker_app/Pages/edit_profile_page.dart';
import 'package:gosol_tracker_app/Pages/empty_page.dart';
import 'package:gosol_tracker_app/Pages/enter_new_gosol.dart';
import 'package:gosol_tracker_app/Pages/gosol_list_page.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';

import '../my_theme.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({Key? key}) : super(key: key);

  final theme = MyTheme.light();

  final loadedNum = 7.obs;

  GosolController controller = Get.find();

  DateFormat f = DateFormat("EEE d-MMM \nh:mm a");

  DateFormat fD = DateFormat("EEE d-MMM");
  DateFormat fT = DateFormat("h:mm a");

  int getUnday() {
    if (controller.gosolList.isNotEmpty) {
      DateTime dateLast = DateTime.fromMicrosecondsSinceEpoch(controller
          .gosolList.value[controller.gosolList.value.length - 1].datetime!);

      return controller.unDay.value = DateTime.now().day - dateLast.day;
    } else {
      return 0;
    }
  }

  int getContDay() {
    int cont = 1;

    if (controller.gosolList.isNotEmpty) {
      int length = controller.gosolList.value.length;

      for (int i = 1; i < length; i++) {
        if ((DateTime.fromMicrosecondsSinceEpoch(
            controller.gosolList.value[i].datetime!)
            .day -
            DateTime.fromMicrosecondsSinceEpoch(
                controller.gosolList.value[i - 1].datetime!)
                .day) ==
            1) {
          cont++;
        } else if ((DateTime.fromMicrosecondsSinceEpoch(
            controller.gosolList.value[i].datetime!)
            .day ==
            DateTime.fromMicrosecondsSinceEpoch(
                controller.gosolList.value[i - 1].datetime!)
                .day)) {
          cont = cont;
        } else if (i + 1 < length) {
          if ((DateTime.fromMicrosecondsSinceEpoch(
              controller.gosolList.value[i].datetime!)
              .day ==
              DateTime.fromMicrosecondsSinceEpoch(
                  controller.gosolList.value[i + 1].datetime!)
                  .day)) {
            cont = cont;
          }
        } else {
          cont = 1;
        }
      }

      print("CONT : $cont " "LENGHTH: $length");
    }
    return cont;
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
                  color: Color(0xff64dd17),
                )),
          )
        ],
      ),
      drawer: buildDrawer(),
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
                    child: Obx(
                          () => ClipRRect(
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
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Icon(Icons.date_range),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Gosol Korechen: ${getUnday() == 0 ? 'Ajkei!' : getUnday().toString() + ' Days Ago.'} ",
                                    style: theme.textTheme.headline3,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  const Icon(Icons.repeat),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Text(
                                    "Ektana Gosol: ${getContDay() == 1 ? 0 : getContDay()} Days! ",
                                    style: theme.textTheme.headline3,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      //
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
          const SizedBox(
            height: 10,
          ),
          Flexible(
            child: Obx(
                  () => ListView(shrinkWrap: true, children: [
                Timeline.tileBuilder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
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
                    contentsBuilder: (context, index) {
                      int dateToday = DateTime.fromMicrosecondsSinceEpoch(
                          controller.gosolList.value[index].datetime!)
                          .day;

                      int datePrev = DateTime.fromMicrosecondsSinceEpoch(
                          controller.gosolList
                              .value[index == 0 ? 0 : index - 1].datetime!)
                          .day;

                      return SizedBox(
                        height: 100,
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 40, 0, 0),
                          child: Text(
                              "UnGosoled For: \n${dateToday - datePrev} Days"),
                        ),
                      );
                    },
                    oppositeContentsBuilder: (context, index) {
                      final gosol = controller.gosolList.value[index];

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  fD.format(DateTime.fromMicrosecondsSinceEpoch(
                                      gosol.datetime!)),
                                  style: theme.textTheme.headline2,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  fT.format(DateTime.fromMicrosecondsSinceEpoch(
                                      gosol.datetime!)),
                                  style: theme.textTheme.headline5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },

                    connectorBuilder: (_, index, __) =>
                    const SolidLineConnector(
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
                SizedBox(
                    height: 30,
                    width: 40,
                    child: TextButton(
                        onPressed: () {},
                        child: const Text("end of the list",
                            style: TextStyle(
                                fontSize: 14, color: Color(0xff64dd17))))),
              ]),

              //
            ),
          ),
        ],
      ),
    );
  }

  Drawer buildDrawer() {
    return Drawer(
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 200,
            ),
            _buildProfile(),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.to(() => EditProfile());
              },
              child: const ListTile(
                leading: Icon(Icons.person_outline),
                title: Text("Edit Profile"),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => GosolList());
              },
              child: const ListTile(
                leading: Icon(Icons.list_alt),
                title: Text("Gosol List"),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => EnterNewGosol());
              },
              child: const ListTile(
                leading: Icon(Icons.add_box_outlined),
                title: Text("Add Gosol"),
              ),
            ),
            InkWell(
              onTap: () {},
              child: const ListTile(
                leading: Icon(Icons.access_time_outlined),
                title: Text("Set Gosol Remainder"),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => EmptyPage());
              },
              child: const ListTile(
                leading: Icon(Icons.note_rounded),
                title: Text("Blog"),
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AboutPage());
              },
              child: const ListTile(
                leading: Icon(Icons.info_outline),
                title: Text("About"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.only(left: 6.0),
      child: Obx(
            () => Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundImage: controller.profileList.isNotEmpty
                  ? Image.memory(const Base64Decoder()
                          .convert(controller.profileList.value[0].image64bit!))
                      .image
                  : AssetImage("asset/male.png"),
              radius: 35,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.profileList.isNotEmpty
                      ? controller.profileList[0].name!
                      : "Your Name",
                  style: theme.textTheme.headline1,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: controller.currentCity.value.isNotEmpty
                      ? Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 18,
                            ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        controller.currentCity.value,
                        style: theme.textTheme.headline2,
                      ),
                    ],
                  )
                      : Container(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
