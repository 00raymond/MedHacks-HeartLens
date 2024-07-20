import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medhacks/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

List<CameraDescription> _cameras = [];

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  bool _isCountingDown = false;
  String _countdownText = 'Press start and hold your fingertip still over the front camera for accurate results.';
  int _countdown = 3;
  final List<double> _brightnessValues = [];
  final List<double> _redChannelValues = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  void _initCamera() async {
    final status = await _checkCameraPermission();
    if (status == PermissionStatus.denied) {
      _showDialog();
    } else {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
      _controller = CameraController(_cameras.first, ResolutionPreset.high); //uses first camera get available cameras list
      _controller!.initialize().then((_) {
        if(!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      });
    }
    }
  }

  Future<PermissionStatus> _checkCameraPermission() async {
    final status = await Permission.camera.request();
    return status;
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Camera Permission'),
          content: const Text('Please allow camera permission to use this feature.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home',)),
                  );
                },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _startEvaluation() {

    _brightnessValues.clear();
    _redChannelValues.clear();

    setState(() {
      _countdownText = "Scanning...\nPlease hold still.";
    });

    _controller?.startImageStream((CameraImage image) {

      double brightness = calculateBrightness(image);
      double redChannel = calculateRedChannel(image);

      setState(() {
        _brightnessValues.add(brightness);
        _redChannelValues.add(redChannel);
      });
    });

    int timeRemaining = 20;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining == 0) {
        _controller?.stopImageStream();
        // _controller?.dispose();

        setState(() {
          _countdownText = "Scan complete. \nNavigating to results...";
        });

        print('Brightness values: $_brightnessValues');
        print('Red channel values: $_redChannelValues');

        timer.cancel();
      } else {
        setState(() {
          _countdownText = "Scanning...\n$timeRemaining seconds remaining.";
          timeRemaining--;
        });
      }
    });
  }

// Function to calculate brightness from a CameraImage
double calculateBrightness(CameraImage image) {
  int totalBrightness = 0;
  int pixelCount = image.planes[0].bytes.length;

  for (int i = 0; i < pixelCount; i++) {
    totalBrightness += image.planes[0].bytes[i];
  }

  return totalBrightness / pixelCount;
}

// Function to calculate red channel value from a CameraImage
double calculateRedChannel(CameraImage image) {
  int totalRedChannel = 0;
  int pixelCount = image.planes[0].bytes.length;

  for (int i = 0; i < pixelCount; i += 3) {
    totalRedChannel += image.planes[0].bytes[i]; // Assuming the red channel is in the first plane
  }

  return totalRedChannel / (pixelCount ~/ 3);
}


  void _startCountdown() {
    _countdownText="Starting Countdown...";
    setState(() {
      _isCountingDown = true;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
        _startEvaluation();
        return;
      }
      setState(() {
        _countdownText = _countdown.toString();
        _countdown--;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: Stack(
        children: [
          _isCameraInitialized
              ? CameraPreview(_controller!)
              : const Center(child: CircularProgressIndicator()),
          if (!_isCountingDown)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _countdownText,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startCountdown,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.deepPurple),
                      padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0)),
                    ),
                    child: const Text(
                      'Start',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          if (_isCountingDown)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _countdownText,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          Positioned(
            bottom: 40.0,
            left: 10.0,
            child: FloatingActionButton(
              backgroundColor: Colors.deepPurple,
              onPressed: () {
                _controller?.dispose();
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
