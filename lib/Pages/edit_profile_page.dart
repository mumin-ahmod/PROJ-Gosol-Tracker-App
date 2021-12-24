import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Model/profile_model.dart';
import 'package:gosol_tracker_app/my_theme.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  final theme = MyTheme.light();

  GosolController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Obx(
        () => Center(
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    backgroundImage: controller.profileList.value.isNotEmpty
                        ? Image.memory(Base64Decoder().convert(
                                controller.profileList.value[0].image64bit!))
                            .image
                        : AssetImage("asset/male.png"),
                    radius: 80,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    controller.profileList.value.isNotEmpty
                        ? controller.profileList.value[0].name!
                        : "Your Name",
                    style: theme.textTheme.headline1,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit_outlined)),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  print("NAME::: ${controller.profileList.value[0].name}");
                },
                child: Text("Save"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  primary: const Color(0xff62ddfc),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
