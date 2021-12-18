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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Text("Enter Date:"),
              const SizedBox(
                height: 20,
              ),
              Obx(
                    () => DropdownButton(
                  hint: _dropDownValue.value == null
                      ? const Text("Choose Date")
                      : Text(_dropDownValue.value!),
                  items: [
                    "Day Before Yesterday",
                    "Yesterday",
                    "Today",
                  ]
                      .map((value) => DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  ))
                      .toList(),
                  onChanged: (value) {
                    _dropDownValue.value = value as String?;

                    if (value == "Yesterday") {
                      pickedDate = DateTime(
                          dateNow.year, dateNow.month, dateNow.day - 1);
                    } else if (value == "Today") {
                      pickedDate = dateNow;
                    } else {
                      pickedDate = DateTime(
                          dateNow.year, dateNow.month, dateNow.day - 2);
                    }

                    print("PICKED DATE: $pickedDate");
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text("Enter Time:"),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () async {
                  timeOfDay = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());

                  print("PICKED TIME: $timeOfDay");
                },
                child: const Text("Select Time"),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  int gosolTime = DateTime(pickedDate.year, pickedDate.month,
                          pickedDate.day, timeOfDay!.hour, timeOfDay!.minute)
                      .microsecondsSinceEpoch;
                  DatabaseHelper.insertGosol(
                      GosolModel(datetime: gosolTime).toMap());

                  controller.getAllGosolStream();

                  Get.back();
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
