import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/Model/profile_model.dart';
import 'package:gosol_tracker_app/my_theme.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  final theme = MyTheme.light();

  final isEditing = false.obs;

  GosolController controller = Get.find();

  String? image64;

  final nameController = TextEditingController();

  Future<String> pickImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 30);

    var imageBytes = await image!.readAsBytes();

    print("IMAGE PICKED: ${image.path}");

    String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Obx(
              () => Row(
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
                  IconButton(
                      onPressed: () async {
                        image64 = await pickImage();
                      },
                      icon: Icon(Icons.edit_outlined)),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isEditing.value
                      ? SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: "Enter Name"),
                          ),
                        )
                      : Text(
                          controller.profileList.value.isNotEmpty
                              ? controller.profileList.value[0].name!
                              : "Your Name",
                          style: theme.textTheme.headline1,
                        ),
                  IconButton(
                      onPressed: () {
                        isEditing.value = true;
                      },
                      icon: const Icon(Icons.edit_outlined)),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () {
                if (image64 != null) {
                  DatabaseHelper.updateProfile(ProfileModel(
                    id: controller.profileList[0].id,
                    name: controller.profileList[0].name,
                    image64bit: image64,
                    ));
                  }

                  if (nameController.text.isNotEmpty) {
                  DatabaseHelper.updateProfile(ProfileModel(
                    id: controller.profileList[0].id,
                    name: nameController.text,
                    image64bit: controller.profileList[0].image64bit,
                  ));

                  print("CONTROLLER TEXT: ${nameController.text}");
                }

                isEditing.value = false;
                nameController.clear();
                print("NAME::: ${controller.profileList.value[0].name}");
                print("ID::: ${controller.profileList.value[0].id}");
              },
                child: const Text("Save"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                primary: Colors.black54,
              ),
              ),
            ],
          ),
        ),
    );
  }
}
