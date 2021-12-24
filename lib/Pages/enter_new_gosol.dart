import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/Model/gosol_model.dart';
import 'package:gosol_tracker_app/my_theme.dart';
import 'package:intl/intl.dart';

class EnterNewGosol extends StatelessWidget {
  EnterNewGosol({Key? key}) : super(key: key);

  final _dropDownValue = Rxn<String>();
  final timePicked = false.obs;
  final theme = MyTheme.light();

  DateTime dateNow = DateTime.now();
  DateTime pickedDate = DateTime.now();
  Rx<TimeOfDay> timeOfDay = TimeOfDay.now().obs;

  DateFormat f = DateFormat("h:mm a");

  GosolController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                SizedBox(
                  height: 70,
                  width: 80,
                  child: Image.asset("asset/water.png"),
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Add New Gosol",
                  style: theme.textTheme.headline3,
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 500,
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Select Date:",
                            style: theme.textTheme.bodyText1,
                          ),
                          Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 0.5,
                                ),
                              ),
                              child: SizedBox(
                                height: 38,
                                    width: 188,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          hint: _dropDownValue.value == null
                                              ? const Text("Choose Date")
                                              : Text(_dropDownValue.value!),
                                          items: [
                                            "Day Before Yesterday",
                                            "Yesterday",
                                            "Today",
                                      ]
                                              .map((value) =>
                                              DropdownMenuItem<String>(
                                                child: Text(value),
                                                value: value,
                                              ))
                                              .toList(),
                                          onChanged: (value) {
                                            _dropDownValue.value = value as String?;

                                            if (value == "Yesterday") {
                                              pickedDate = DateTime(dateNow.year,
                                                  dateNow.month, dateNow.day - 1);
                                            } else if (value == "Today") {
                                          pickedDate = dateNow;
                                        } else {
                                          pickedDate = DateTime(dateNow.year,
                                              dateNow.month, dateNow.day - 2);
                                        }

                                        print("PICKED DATE: $pickedDate");
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Enter Time:",
                            style: theme.textTheme.bodyText1,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 38,
                            width: 188,
                            child: Obx(
                              () => OutlinedButton(
                                onPressed: () async {
                                  timeOfDay.value = (await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now()))!;

                                  timePicked.value = true;

                                  print("PICKED TIME: $timeOfDay");
                                },
                                child: timePicked.value
                                    ? Text(
                                        f.format(
                                          DateTime(
                                              pickedDate.year,
                                              pickedDate.month,
                                              pickedDate.day,
                                              timeOfDay.value.hour,
                                              timeOfDay.value.minute),
                                        ),
                                      )
                                    : const Text("Select Time"),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        height: 30,
                        width: 100,
                        child: ElevatedButton(
                          onPressed: () {
                            int gosolTime = DateTime(
                                    pickedDate.year,
                                    pickedDate.month,
                                    pickedDate.day,
                                    timeOfDay.value.hour,
                                    timeOfDay.value.minute)
                                .microsecondsSinceEpoch;
                            DatabaseHelper.insertGosol(
                                GosolModel(datetime: gosolTime).toMap());

                            Get.back();
                          },
                          child: const Text("Save"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            primary: const Color(0xff62ddfc),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
