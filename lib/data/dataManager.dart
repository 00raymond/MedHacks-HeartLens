import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:medhacks/types/Scan.dart';

class DataManager {
  // apply singleton pattern
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  /// Save scan object to array in shared preferences
  Future<void> storeLocalScan(Scan data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> existingScans = prefs.getStringList('scans') ?? [];
    existingScans.add(jsonEncode(data.toJson()));
    await prefs.setStringList('scans', existingScans);

  }

  /// Load scan objects from device shared preferences
  Future<List<Scan>> loadLocalScans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> scansJson = prefs.getStringList('scans') ?? [];
    List<Scan> scans = scansJson.map((scan) => Scan.fromJson(jsonDecode(scan))).toList();

    return scans;
  }

  /// Update scan objects in device shared preferences
  void updateScans(List<Scan> scans) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save scan objects to shared preferences
    List<String> scansJson = scans.map((scan) => jsonEncode(scan.toJson())).toList();
    await prefs.setStringList('scans', scansJson);
  }

  /// Load scan objects from device shared preferences. Remove selected input set of scans.
  Future<List<Scan>> deleteLocalScans(Set<Scan> deleted) async {
    // Convert set to list
    List<Scan> deletedList = deleted.toList();

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> scansJson = prefs.getStringList('scans') ?? [];
    List<Scan> scans = scansJson.map((scan) => Scan.fromJson(jsonDecode(scan))).toList();

    List<Scan> updatedScans = scans.where((scan) {
      return !deletedList.any((deletedScan) => deletedScan.dateTime == scan.dateTime);
    }).toList();

    // Save scan objects to device shared preferences.
    List<String> updatedScansJson = updatedScans.map((scan) => jsonEncode(scan.toJson())).toList();
    await prefs.setStringList('scans', updatedScansJson);

    return updatedScans;
  }

}