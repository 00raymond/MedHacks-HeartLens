import 'package:flutter/material.dart';
import 'package:medhacks/data/DataManager.dart';
import 'package:medhacks/types/Scan.dart';

class ResultsPage extends StatelessWidget {

  final List<double> filteredValues;
  final String dateTime;

  ResultsPage({super.key, required this.filteredValues, required this.dateTime});

  void initState() {
    _calculatePulse();
  }
  
  int _calculatePulse() {

    if (filteredValues.length < 5) {
      return 0;
    }
    int peakCount = 0;
    int seconds = 15;
    double factor = 60 / seconds;
    const int fingerThreshold = 100;

    for (int i = 2; i < filteredValues.length - 2; i++) {
      if (filteredValues[i] < fingerThreshold) {
        // threshold means the brightness value is low enough to be considered finger covering the camera
        // check if the next value is less than the current value and the value after that is lower than the current value
        if (filteredValues[i + 1] < filteredValues[i] && filteredValues[i] > filteredValues[i-1]) {
          if (filteredValues[i + 2] < filteredValues[i] && filteredValues[i] > filteredValues[i-2]) {
              // peak detected
              peakCount++;
          }
        }
      }
    }

    // The pulse should be calculated from these values
    double pulsePerMinute = peakCount * factor;
    return pulsePerMinute.toInt();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const LineChart(
                  

                // ),
                const Text('Results:', style: TextStyle(fontSize: 24)),
                const SizedBox(height: 20),
                Text('Average brightness: ${filteredValues.reduce((a, b) => a + b) / filteredValues.length}', style: TextStyle(fontSize: 18, color:Colors.white)),
                const SizedBox(height: 20),
                Text('Max brightness: ${filteredValues.reduce((a, b) => a > b ? a : b)}', style: TextStyle(fontSize: 18, color:Colors.white)),
                const SizedBox(height: 20),
                Text('Min brightness: ${filteredValues.reduce((a, b) => a < b ? a : b)}', style: TextStyle(fontSize: 18, color:Colors.white)),
                const SizedBox(height: 20),
                Text('Pulse: ${_calculatePulse()} BPM', style: TextStyle(fontSize: 18, color:Colors.white)),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                  ),
                  onPressed: () {
                    // save this stuff locally. when user accesses their past records, itll show a stream of their past results: time saved, pulse
                    Scan scan = Scan(pulse: _calculatePulse(), filteredValues: filteredValues, dateTime: dateTime);
                    DataManager().storeLocalScan(scan);
                    // create popup modal saying "Successfully saved! 🎉" with "Home" and "View All Results" buttons beneath that text. also X to close the modal
                  },
                  child: Text('💾 Save Results', style:TextStyle(color:Colors.white, fontSize: 30)),
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('🔄 Redo Scan', style:TextStyle(color:Colors.black, fontSize: 24)),
                  ),
                ),

            ],)
            
          ),
        ],
      ),
    );
  }
}