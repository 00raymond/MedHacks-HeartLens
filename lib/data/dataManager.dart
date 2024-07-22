import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:medhacks/types/Scan.dart';

class DataManager {
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

}