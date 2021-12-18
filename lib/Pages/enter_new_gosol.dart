import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/Model/gosol_model.dart';

class EnterNewGosol extends StatelessWidget {
  EnterNewGosol({Key? key}) : super(key: key);

  final _dropDownValue = Rxn<String>();

  DateTime dateNow = DateTime.now();
  DateTime pickedDate = DateTime.now();
  TimeOfDay? timeOfDay;

  GosolController controller = Get.put(GosolController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 250,
                ),
                SizedBox(
                  height: 70,
                  width: 80,
                  child: Image.asset("asset/water.png"),
                ),
                SizedBox(
                  height: 500,
                  width: 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 100,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Select Date:"),
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
                          const Text("Enter Time:"),
                          const SizedBox(
                            width: 20,
                          ),
                          SizedBox(
                            height: 38,
                            width: 188,
                            child: OutlinedButton(
                              onPressed: () async {
                                timeOfDay = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now());

                                print("PICKED TIME: $timeOfDay");
                              },
                              child: const Text("Select Time"),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
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
                                    timeOfDay!.hour,
                                    timeOfDay!.minute)
                                .microsecondsSinceEpoch;
                            DatabaseHelper.insertGosol(
                                GosolModel(datetime: gosolTime).toMap());

                            Get.back();
                          },
                          child: const Text("Save"),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
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
