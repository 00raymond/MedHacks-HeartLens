import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medhacks/authentication_service.dart';
import 'package:medhacks/pages/signin.dart';
import 'authentication_service.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final AuthenticationService _authService = AuthenticationService(FirebaseAuth.instance);

  HomeAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? user = _authService.getCurrentUser();

    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Container(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(),
          if (user != null) ...[
            const Text(
              "",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () async {
                await _authService.signOut();
                // refresh the app
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.exit_to_app, color: Colors.red),
                  SizedBox(width: 5),
                  Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ] else ...[
                // Align everything to the right
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignInPage()),
                        );
                      },
                      child: const Text(
                      "Sign In",
                      style: TextStyle(fontSize:22, color: Colors.white),
                      ),
                    ),
                  ),
                ) 
          ]
        ],
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
