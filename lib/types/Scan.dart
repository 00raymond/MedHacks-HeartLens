class Scan {

  /// Required list of doubles: filtered values of the scan
  final List<double> filteredValues;

  /// Required string: date and time of the scan
  final String dateTime;

  /// Required integer: pulse of the scan
  final int pulse;

  Scan({required this.pulse, required this.filteredValues, required this.dateTime});

  /// Converts scan to JSON, ready to be saved to file
  Map<String, dynamic> toJson() {
    return {
      'pulse': pulse,
      'filteredValues': filteredValues,
      'dateTime': dateTime,
    };
  }

  /// Converts JSON to scan object
  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      pulse: json['pulse'],
      filteredValues: (json['filteredValues'] as List).map((e) => e.toDouble() as double).toList(),
      dateTime: json['dateTime'],
    );
  }

  /// Returns scan pulse
  int getPulse() {
    return pulse;
  }

  /// Returns filtered values saved to scan
  List<double> getFilteredValues() {
    return filteredValues;
  }

  /// Returns date and time of scan
  String getDateTime() {
    return dateTime;
  }
}
