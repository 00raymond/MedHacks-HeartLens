import 'package:flutter/material.dart';
import 'package:medhacks/pages/camera.dart';
import 'package:medhacks/pages/saves.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple).copyWith(background: Colors.black),

      ),
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black38,
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(child:Image.asset('lib/assets/logo.png', width: 400, height: 75)),
            Container(child: const Text('Please remember to allow camera access when prompted to.', textAlign: TextAlign.center, style: TextStyle(fontSize: 20, color: Colors.grey))),
            Container(height:10,),
            SizedBox(
              width: 200,
              height: 50,
              child: TextButton(
                
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CameraPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, disabledForegroundColor: Colors.grey.withOpacity(0.38),
                ),

                child: const Text('Capture 📷', style: TextStyle(fontSize: 24.0)),
              ),
              
            ),
            const SizedBox(height:10),
            Container(
              width: 200,
              height: 50,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SavesPage()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.white, disabledForegroundColor: Colors.grey.withOpacity(0.38),
                ),
                child: const Text('Saved Scans', style: TextStyle(fontSize: 24.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
