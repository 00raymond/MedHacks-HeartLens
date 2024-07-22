class Scan {
  final List<double> filteredValues;
  final String dateTime;
  final int pulse;

  Scan({required this.pulse, required this.filteredValues, required this.dateTime});

  Map<String, dynamic> toJson() {
    return {
      'pulse': pulse,
      'filteredValues': filteredValues,
      'dateTime': dateTime,
    };
  }

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
      pulse: json['pulse'],
      filteredValues: (json['filteredValues'] as List).map((e) => e.toDouble() as double).toList(),
      dateTime: json['dateTime'],
    );
  }

  int getPulse() {
    return pulse;
  }

  List<double> getFilteredValues() {
    return filteredValues;
  }

  String getDateTime() {
    return dateTime;
  }
}
