import 'package:flutter/material.dart';
import 'package:medhacks/authentication_service.dart';
import 'package:medhacks/main.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    // final String _errorMessage = 'Invalid email or password.';
    final TextEditingController loginEmailController = TextEditingController();
    final TextEditingController loginPassController = TextEditingController();
    
    Future<void> _loginUser() async {
    final authService = Provider.of<AuthenticationService>(context, listen: false);
    print("asdf");
    var result = await authService.signIn(
        email: loginEmailController.text,
        password: loginPassController.text
      );
    if (result != null) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Login Failed', style: TextStyle(color:Colors.red)),
          content:  Text(result, style: TextStyle(fontSize: 18, color:Colors.white)),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: const Text('Okay', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color:Colors.white),),
            )
          ]
        )
      );
    } else {
      // send to home
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')),
      );
    }
  }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // send to home
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage(title: 'Home')),
            );
          },
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Logo
            Image.asset('lib/assets/logo.png', width: 400, height: 75),
            SizedBox(height:16.0),
            // Email TextField
            TextField(
              controller: loginEmailController,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16.0),
            // Password TextField
            TextField(
              controller: loginPassController,
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: const TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
              ),
              obscureText: true,
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 20.0),
            // Sign In Button
            ElevatedButton(
              onPressed: () {
                // Handle sign-in logic
                print("hello");
                _loginUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20.0),
            // Information Text
            const Center(
              child: Text(
                'Use credentials given by healthcare provider.',
                style: TextStyle(color: Colors.grey, fontSize: 15.0),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
