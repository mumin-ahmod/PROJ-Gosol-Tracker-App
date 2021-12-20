import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:get/get.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/Model/gosol_model.dart';
import 'package:geolocator/geolocator.dart';

class GosolController extends GetxController {
  final gosolList = <GosolModel>[].obs;

  final unDay = 0.obs;
  final diff = 0.obs;
  final contDay = 0.obs;

  final currentCity = "".obs;

  @override
  void onInit() {
    gosolList.bindStream(DatabaseHelper.getAllGosols());

    super.onInit();

    getCity();
  }

// getAllGosolStream() {
//   DatabaseHelper.getAllGosols().then((item) => item.forEach((element) =>
//       gosolList.value.add(GosolModel(
//           id: element.id,
//           datetime: element.datetime,
//           temperature: element.temperature ?? 0))));
//
//   print(gosolList.value);
// }

  getCity() async {
    GeoCode geoCode = GeoCode();

    try {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();

      LocationPermission permission = await Geolocator.checkPermission();

      if (!isLocationEnabled) {
        const SnackBar(
          content: Text("Enable Location"),
        );
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      // final coordinates = Coordinates(latitude: position.latitude, longitude: position.longitude);

      var address = await geoCode.reverseGeocoding(
          latitude: position.latitude, longitude: position.longitude);

      print("LOCATION CITY: ${address.city}");

      currentCity.value = address.city!;
    } catch (e) {
      print(e);
    }
  }
}
