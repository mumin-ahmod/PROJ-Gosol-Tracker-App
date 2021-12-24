import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class ProfileModel {
  int? id;
  String? name;
  String? image64bit;

  static Future<String> pickImage() async {
    ByteData bytes = await rootBundle.load('asset/male.png');

    var buffer = bytes.buffer;

    var base64Image = base64.encode(Uint8List.view(buffer));

    print("IMAGE INPUTTED");

    // String base64Image = base64Encode(imageBytes);

    return base64Image;
  }

  ProfileModel({this.id, this.name, this.image64bit});

  ProfileModel._create({this.name = "Default Name", this.image64bit}) {
    print("private contructor");
  }

  static Future<ProfileModel> create() async {
    var component = ProfileModel._create();

    component.image64bit = await pickImage();

    return component;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {"name": name, "image64bit": image64bit};

    if (id != null) {
      map["id"] = id;
    }

    return map;
  }

  factory ProfileModel.fromMap(Map<String, dynamic> map) => ProfileModel(
      id: map["id"], name: map["name"], image64bit: map["image64bit"]);
}
