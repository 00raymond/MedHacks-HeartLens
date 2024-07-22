class Scan {

  final List<double> filteredValues;
  final String dateTime;
  final int pulse;

  Scan({required this.pulse, required this.filteredValues, required this.dateTime});

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