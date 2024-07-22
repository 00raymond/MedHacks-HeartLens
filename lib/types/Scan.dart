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
      filteredValues: json['filteredValues'],
      dateTime: json['dateTime'],
    );
  }

  getPulse() {
    return pulse;
  }

  getFilteredValues() {
    return filteredValues;
  }

  getDateTime() {
    return dateTime;
  }

}