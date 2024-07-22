import 'package:shared_preferences/shared_preferences.dart';
import 'package:medhacks/types/Scan.dart';

class DataManager {
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;
  DataManager._internal();

  List<String> _data = [];

  Future<void> storeLocalScan(Scan data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // save 

  }

  List<String> getData() {
    return _data;
  }
}