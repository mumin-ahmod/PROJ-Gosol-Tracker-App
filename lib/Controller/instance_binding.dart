import 'package:get/get.dart';
import 'package:gosol_tracker_app/Controller/gosol_controller.dart';

class InstanceBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<GosolController>(GosolController());
  }
}
