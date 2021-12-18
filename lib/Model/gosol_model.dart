import 'package:gosol_tracker_app/Database/database_helper.dart';

class GosolModel {
  int? id;
  int? datetime;
  double? temperature;

  GosolModel({this.id, this.datetime, this.temperature = 0});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      DatabaseHelper.datetimeColumn: datetime,
      DatabaseHelper.temperatureColumn: temperature,
    };

    if (id != null) {
      map["id"] = id; // if object GIVES AN "ID" THEN ... take the id.

    }

    return map;
  }

  // factory method : who is like a constructor but can return something
  factory GosolModel.fromMap(Map<String, dynamic> map) => GosolModel(
      id: map[DatabaseHelper.idColumn],
      datetime: map[DatabaseHelper.datetimeColumn],
      temperature: map[DatabaseHelper.temperatureColumn]);
}
