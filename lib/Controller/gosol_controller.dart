import 'package:get/get.dart';
import 'package:gosol_tracker_app/Database/database_helper.dart';
import 'package:gosol_tracker_app/Model/gosol_model.dart';

class GosolController extends GetxController {
  final Rx<List<GosolModel>> gosolList = Rx<List<GosolModel>>([]);

  @override
  void onInit() {
    getAllGosolStream();

    super.onInit();
  }

  getAllGosolStream() {
    DatabaseHelper.getAllGosols().then((item) => item.forEach((element) =>
        gosolList.value.add(GosolModel(
            id: element.id,
            datetime: element.datetime,
            temperature: element.temperature ?? 0))));

    print(gosolList.value);
  }
}
