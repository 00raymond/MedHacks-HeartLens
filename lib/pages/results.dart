import 'package:flutter/material.dart';

class ResultsPage extends StatelessWidget {

  final List<double> brightnessValues;

  ResultsPage({required this.brightnessValues});

  @override
  void initState() {
    _calculatePulse();
  }

  int _calculatePulse() {

    // Implement pulse calculation here
    // 15 seconds of brightnessValues are stored in the brightnessValues list

    // count how many peaks in the brightnessValues list = pulses in 15 seconds.
    if (brightnessValues.length < 3) {
      return 0;
    }
    int peakCount = 0;
    int seconds = 15;
    double factor = 60 / seconds;
    const int fingerThreshold = 50;

    for (int i = 2; i < brightnessValues.length - 2; i++) {
      if (brightnessValues[i] < fingerThreshold) {
        // threshold means the brightness value is low enough to be considered finger covering the camera
        // check if the next value is less than the current value and the value after that is lower than the current value
        if (brightnessValues[i + 1] < brightnessValues[i] && brightnessValues[i] > brightnessValues[i-1]) {
          if (brightnessValues[i + 2] < brightnessValues[i] && brightnessValues[i] > brightnessValues[i-2]) {
              // peak detected
              peakCount++;
          }
        }
      }
    }

    // The pulse should be calculated from these values
    double pulsePerMinute = peakCount * factor;



    // The pulse should be returned as a double



    return pulsePerMinute.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Results:', style: TextStyle(fontSize: 24)),
                SizedBox(height: 20),
                Text('Average brightness: ${brightnessValues.reduce((a, b) => a + b) / brightnessValues.length}', style: TextStyle(fontSize: 18, color:Colors.white)),
                SizedBox(height: 20),
                Text('Max brightness: ${brightnessValues.reduce((a, b) => a > b ? a : b)}', style: TextStyle(fontSize: 18, color:Colors.white)),
                SizedBox(height: 20),
                Text('Min brightness: ${brightnessValues.reduce((a, b) => a < b ? a : b)}', style: TextStyle(fontSize: 18, color:Colors.white)),
                SizedBox(height: 20),
                Text('Pulse: ${_calculatePulse()} BPM', style: TextStyle(fontSize: 18, color:Colors.white)),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Redo Scan'),
            ),
          ),
        ],
      ),
    );
  }
}