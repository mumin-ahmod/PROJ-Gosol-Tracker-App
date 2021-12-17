import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EnterNewGosol extends StatelessWidget {
  EnterNewGosol({Key? key}) : super(key: key);

  final _dropDownValue = Rxn<String>();

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
                    "Yesterday",
                    "Today",
                    "Tommorrow",
                  ]
                      .map((value) => DropdownMenuItem<String>(
                            child: Text(value),
                            value: value,
                          ))
                      .toList(),
                  onChanged: (value) {
                    _dropDownValue.value = value as String?;
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
                  final timeOfDay = await showTimePicker(
                      context: context, initialTime: TimeOfDay.now());
                },
                child: const Text("Select Time"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
