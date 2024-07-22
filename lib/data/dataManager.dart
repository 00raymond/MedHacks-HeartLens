import 'package:shared_preferences/shared_preferences.dart';
import 'package:medhacks/types/Scan.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  Future<void> storeLocalScan(Scan data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // save scan object to array in shared preferences


  }

  Future<List<Scan>> loadLocalScans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Scan> _localScans = [];

    // load scan objects from shared preferences

    return _localScans;
  }

}