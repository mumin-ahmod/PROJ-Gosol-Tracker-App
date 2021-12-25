import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/Model/profile_model.dart';
import 'package:gosol_tracker_app/my_theme.dart';
import 'package:image_picker/image_picker.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);

  final theme = MyTheme.light();
  final _formKey = GlobalKey<FormState>();

  final isEditing = false.obs;

  GosolController controller = Get.find();

  Rxn<String> image64 = Rxn<String>();

  final nameController = TextEditingController();

  Future<String> pickImage() async {
    var image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);

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
                  image64.value != null
                      ? CircleAvatar(
                          backgroundImage: Image.memory(
                                  const Base64Decoder().convert(image64.value!))
                              .image,
                          radius: 80,
                        )
                      : CircleAvatar(
                          backgroundImage:
                              controller.profileList.value.isNotEmpty
                                  ? Image.memory(const Base64Decoder().convert(
                                          controller.profileList.value[0]
                                              .image64bit!))
                                      .image
                                  : const AssetImage("asset/male.png"),
                          radius: 80,
                        ),
                  IconButton(
                      onPressed: () async {
                        image64.value = await pickImage();
                      },
                      icon: const Icon(Icons.edit_outlined)),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Obx(
              () => Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    isEditing.value
                        ? SizedBox(
                            width: 200,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                    hintText: "Nick Name"),
                                validator: (text) {
                                  if (text!.isEmpty || text.length > 20) {
                                    return "Name Must be Less then 20 Characters";
                                  }
                                },
                              ),
                            ),
                          )
                        : SizedBox(
                            width: 200,
                            child: Text(
                              controller.profileList.value.isNotEmpty
                                  ? controller.profileList.value[0].name!
                                  : "Your Name",
                              style: theme.textTheme.headline1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                    IconButton(
                        onPressed: () {
                          isEditing.value = true;
                        },
                        icon: const Icon(Icons.edit_outlined)),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
              onPressed: () async {
                if (image64.value != null) {
                  await DatabaseHelper.updateProfile(ProfileModel(
                    id: controller.profileList[0].id,
                    name: controller.profileList[0].name,
                    image64bit: image64.value,
                  ));

                  Fluttertoast.showToast(msg: "Saved!");
                  image64.value = null;
                }

                if (nameController.text.isNotEmpty) {
                  if (_formKey.currentState!.validate()) {
                    DatabaseHelper.updateProfile(ProfileModel(
                      id: controller.profileList[0].id,
                      name: nameController.text,
                      image64bit: controller.profileList[0].image64bit,
                    ));
                    Fluttertoast.showToast(msg: "Saved!");
                  } else {
                    Fluttertoast.showToast(
                        msg: "Name must be Less then 20 Characters long");
                  }

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
