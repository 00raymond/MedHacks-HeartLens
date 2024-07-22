import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:medhacks/types/Scan.dart';

class DataManager {
  // apply singleton pattern
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();



  Future<void> storeLocalScan(Scan data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // save scan object to array in shared preferences
    List<String> existingScans = prefs.getStringList('scans') ?? [];
    existingScans.add(jsonEncode(data.toJson()));
    await prefs.setStringList('scans', existingScans);

    print("Saved data!");

  }

  Future<List<Scan>> loadLocalScans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // load scan objects from shared preferences
    List<String> scansJson = prefs.getStringList('scans') ?? [];
    List<Scan> scans = scansJson.map((scan) => Scan.fromJson(jsonDecode(scan))).toList();

    return scans;
  }

  void updateScans(List<Scan> scans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // save scan objects to shared preferences
    List<String> scansJson = scans.map((scan) => jsonEncode(scan.toJson())).toList();
    await prefs.setStringList('scans', scansJson);
  }

  Future<List<Scan>> deleteLocalScans(Set<Scan> deleted) async {
    // convert set to list
    List<Scan> deletedList = deleted.toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    // load scan objects from shared preferences
    List<String> scansJson = prefs.getStringList('scans') ?? [];
    List<Scan> scans = scansJson.map((scan) => Scan.fromJson(jsonDecode(scan))).toList();

    List<Scan> updatedScans = scans.where((scan) {
      return !deletedList.any((deletedScan) => deletedScan.dateTime == scan.dateTime);
    }).toList();

    // save scan objects to shared preferences
    List<String> updatedScansJson = updatedScans.map((scan) => jsonEncode(scan.toJson())).toList();
    await prefs.setStringList('scans', updatedScansJson);

    return updatedScans;
  }

}